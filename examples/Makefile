# Build the standalone Russell examples.  The compiler driver is in the
# repository root after `make` has completed.

RC ?= ../rc
RCFLAGS ?= -pL

PROGRAMS = \
	callcc_test complex compose enum_test extend_test extern_test fact ffact \
	fib fixpoint fp_test gauss lazy_test lfib points primes print psexpr_test \
	rfib self_appl sep_test sexpr sig_test squares string_test sum tree_test \
	typearg

# These sources define parametrized values intended for `extern { ... }`.
# They are compiled to an object file and its portable Russell interface;
# they are not executable programs in their own right.
LIBRARIES = identity lazy_sexpr memo psexpr tree
LIBRARY_OBJECTS = $(LIBRARIES:%=%.o)
LIBRARY_INTERFACES = $(LIBRARIES:%=%.ri)
GENERATED = $(foreach ext,c s G o ri,$(PROGRAMS:%=%.$(ext)) $(LIBRARIES:%=%.$(ext)))

.PHONY: all programs libraries calc clean

all: programs libraries calc

programs: $(PROGRAMS)

libraries: $(LIBRARY_OBJECTS) $(LIBRARY_INTERFACES)

$(PROGRAMS): %: %.r
	$(RC) $(RCFLAGS) -o $@ $<

$(LIBRARY_OBJECTS): %.o: %.r
	$(RC) $(RCFLAGS) -c $<

# `rc -c name.r` emits both name.o and name.ri.  This dependency records the
# latter output explicitly, so a partial build is repaired when needed.
$(LIBRARY_INTERFACES): %.ri: %.o
	@:

lfib: memo.o memo.ri
psexpr_test: psexpr.o psexpr.ri
sep_test: identity.o identity.ri
squares: lazy_sexpr.o lazy_sexpr.ri
tree_test: tree.o tree.ri

# The constructive-real calculator has its own Makefile and C support sources.
calc:
	$(MAKE) -C calc RC="$(abspath $(RC))"

clean:
	rm -f $(PROGRAMS) $(GENERATED)
	$(MAKE) -C calc clean
