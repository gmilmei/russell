#!/bin/sh
# Compile and (where possible) run the standalone Russell examples.
# This script deliberately runs binaries natively; it does not invoke QEMU.

set -u

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
LOGDIR=${1:-"$ROOT/build/example-tests"}
TIMEOUT=${RUSSELL_TEST_TIMEOUT:-20}

mkdir -p "$LOGDIR"
summary="$LOGDIR/summary.txt"
: >"$summary"

printf 'Russell example test\nroot: %s\ntimeout: %ss\n\n' "$ROOT" "$TIMEOUT" \
  | tee "$summary"

status=0
for source in "$ROOT"/examples/*.r; do
    name=$(basename "$source" .r)
    log="$LOGDIR/$name.log"
    work=$(mktemp -d "${TMPDIR:-/tmp}/russell-$name.XXXXXX") || exit 2
    trap 'rm -rf "$work"' INT TERM EXIT

    # Keep generated .o/.s/.G files out of the source tree.
    cp "$source" "$work/$name.r"
    printf '=== %s ===\n' "$name" >"$log"
    printf 'source: %s\n' "$source" >>"$log"

    if timeout "$TIMEOUT" "$ROOT/rc" -o "$work/$name" "$work/$name.r" \
         >>"$log" 2>&1; then
        printf '%-24s compiled\n' "$name" | tee -a "$summary"
        if [ -x "$work/$name" ]; then
            if timeout "$TIMEOUT" "$work/$name" >>"$log" 2>&1; then
                printf '%-24s ran\n' "$name" | tee -a "$summary"
            else
                rc=$?
                printf '%-24s run-failed (%s)\n' "$name" "$rc" | tee -a "$summary"
                status=1
            fi
        fi
    else
        rc=$?
        printf '%-24s compile-failed (%s)\n' "$name" "$rc" | tee -a "$summary"
        status=1
    fi

    rm -rf "$work"
    trap - INT TERM EXIT
done

printf '\nDetailed logs: %s\n' "$LOGDIR" | tee -a "$summary"
exit "$status"
