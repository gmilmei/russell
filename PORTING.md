# Russell 3.3 Linux port

This document records the scope, decisions, and progress of the Linux port.
The historical source is preserved by the Git tag `original-3.3`.

## Initial target

- Linux on 32-bit x86 (i386/i686 ABI)
- GCC in GNU89 mode for the historical C sources
- ELF executables generated through the C compiler driver
- Portable C32 implementation of the BigNum package
- Existing Russell examples used as regression tests

A native 64-bit port is explicitly deferred until the 32-bit reference port
works.  The original implementation assumes 32-bit pointers, `int`, `long`,
and runtime words in several places.

## Baseline

- Upstream version: Russell compiler 3.3
- Baseline Git tag: `original-3.3`
- Baseline commit: `bc51ba9`
- Tracked files: 429
- Source dates: mostly 1989--1993

The baseline is the authoritative machine-checkable inventory.  Use
`git diff original-3.3` to inspect every porting change.

## Architecture

The build consists of the following major parts:

1. C bootstrap compiler and compiler passes under `src/`.
2. Russell initial environments in `src/initenv.r` and `src/Ginitenv.r`.
3. Russell intermediate-code-to-C converter in `src/RIC_to_C/`.
4. Runtime and continuation implementation under `runtime/`.
5. A bundled conservative garbage collector under `src/gc/`.
6. The DEC/INRIA BigNum package under `runtime/BigNum/`.
7. The `rc` driver in `src/root/rc.c`.

The historical bootstrap creates `rc.x`/`Grc.x` by serializing initialized
compiler state into an a.out executable.  The driver and signature utilities
also inspect a.out structures directly.  Replacing this mechanism is the
largest part of the Linux port; merely changing compiler flags will not be
sufficient on an ELF system.

## Porting stages

- [x] Preserve and identify the original source baseline.
- [x] Establish a reproducible Linux i386 toolchain and ABI checks.
- [ ] Make the C bootstrap components compile in GNU89 mode.
- [x] Replace obsolete direct linker and startup-object invocations.
- [ ] Replace a.out compiler-image and signature storage.
- [ ] Port and test the runtime, garbage collector, and call/cc.
- [x] Build the BigNum C32 backend and verify arithmetic.
- [ ] Complete the compiler bootstrap.
- [ ] Run and automate the example-program regression suite.
- [ ] Enable optimization, tighten diagnostics, and document installation.

## Compatibility policy

The first working port should preserve language and runtime behaviour rather
than modernize the implementation wholesale.  K&R C is accepted temporarily
through `-std=gnu89`.  Compatibility fixes should be narrow and reviewable.
Obsolete assembly backends, profiling startup objects, demand loading, and the
static-GC optimizer are outside the initial milestone.

## Acceptance criteria for the first milestone

The first complete milestone is reached when a clean Linux i386 environment
can build the compiler without historical binary artifacts, compile
`examples/fact.r` to an ELF32 executable, and run it successfully.  The wider
example suite is the acceptance criterion for the completed port.

## Known high-risk areas

- a.out parsing and executable-image mutation in `src/main.c`,
  `src/root/rc.c`, `src/sigio/sig_in.c`, and `src/extract_sig.c`
- stack copying and `setjmp`/`longjmp` assumptions in `runtime/callcc.c`
- obsolete OS and memory-layout assumptions in the bundled collector
- pointer/integer conversions hidden by the original 32-bit ABI
- absolute paths embedded through `RROOT`
- non-commercial license language and separate BigNum restrictions

## Change log

### Phase 0

- Imported the unmodified distribution and tagged it `original-3.3`.
- Recorded the initial target, architecture, exclusions, and acceptance tests.

### Phase 1

- Added the reference GCC flags in `config/linux-i386.mk`.
- Added `make check-abi` to reject incompatible data models early.
- Verified that the host toolchain can compile and link ELF32/i386 programs.
- Disabled the host's read-only ccache for deterministic local builds.
- Run target programs natively on the Linux/i386 host.

### Phase 2

- Replaced hard-coded C compiler invocations with `$(CC)`.
- Replaced final links through `ld`, `crt0.o`, and static `libc.a` with GCC
  driver links.  Relocatable aggregation still uses `$(LD) -r`.
- Routed the historical build through the Linux i386 configuration.
- Classified the remaining blockers as removed `varargs.h`, conflicting
  historical declarations, and direct a.out structure access.
- Ported the syntax-tree variadic constructors to `stdarg.h`.
- Made the parser grammar compatible with the current Berkeley Yacc output.
- Built the C driver, parser, most compiler passes, and bundled collector as
  ELF32 objects; runtime and BigNum compatibility work remains.
- Switched the Linux reference build to the system Boehm GC (`gc-devel.i686`)
  through `USE_SYSTEM_GC`; the bundled collector remains in the source tree
  but is no longer part of the default dependency graph.
- Ported the BigNum C32 declarations for current GCC and preserved i386 flags
  in its recursive build.
- Built the complete runtime into an ELF32 relocatable `runtime/rrt0.o`.
- Made `BigNumProduct` explicitly 64-bit so 32-by-32-bit arithmetic does not
  rely on undefined full-width shifts on the i386 ABI.

### Phase 3: ELF cold start

- Replaced the compiler's dependency on a serialized a.out process image with
  an ELF cold-start path: a fresh `Rc` parses the standard environment and the
  user program consecutively in the same process.
- Retained the old image writer behind a compile-time guard for historical
  reference; it is not compiled in the Linux configuration.
- Mapped `realloc` to `GC_realloc`; the current yacc skeleton grows a parser
  stack originally allocated through `GC_malloc`, and mixing it with libc
  `realloc` corrupted the syntax tree while parsing `Ginitenv.r`.
- Replaced the historical heap-address heuristic in `is_ptr` with `GC_base`
  for the system collector, whose i386 heap may be below the executable.
- Made the string-expansion template writable instead of modifying a string
  literal in read-only storage.
- Verified under native i386 GDB that `Rc -G` exits normally and translates
  `examples/fact.r` into a 2384-byte RIC file.
