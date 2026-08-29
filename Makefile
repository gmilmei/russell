.PHONY: all compiler-core check-abi clean-port

include config/linux-i386.mk

all: check-abi compiler-core

compiler-core:
	env CCACHE_DISABLE=1 $(MAKE) -C src -f Makefile.main all \
		PORT_CORE_ONLY=1 \
		RROOT=$(CURDIR) CC=gcc LD=ld AR=ar \
		PORT_CFLAGS="$(CPPFLAGS) $(CFLAGS)" REL_LDFLAGS="-m elf_i386" \
		GC_LIBS="$(GC_LIBS)"

check-abi: build/linux-i386/abi-check
	$(I386_RUNNER) build/linux-i386/abi-check

build/linux-i386/abi-check: tools/abi_check.c config/linux-i386.mk
	mkdir -p build/linux-i386
	$(CC) $(CPPFLAGS) $(CFLAGS) $< -o $@ $(LDFLAGS)

clean-port:
	rm -rf build/linux-i386
