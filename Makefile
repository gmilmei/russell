prefix ?= /usr/local
exec_prefix ?= $(prefix)
bindir ?= $(exec_prefix)/bin
libdir ?= $(exec_prefix)/lib
russelldir ?= $(libdir)/russell
DESTDIR ?=

.PHONY: all compiler-core check-abi clean clean-port install

include config/linux-i386.mk

all: check-abi compiler-core

compiler-core:
	env CCACHE_DISABLE=1 $(MAKE) -C src -f Makefile.main all \
		PORT_CORE_ONLY=1 \
		RROOT=$(CURDIR) CC=gcc LD=ld AR=ar \
		PORT_CFLAGS="$(CPPFLAGS) $(CFLAGS)" REL_LDFLAGS="-m elf_i386" \
		GC_LIBS="$(GC_LIBS)"

check-abi: build/linux-i386/abi-check
	build/linux-i386/abi-check

build/linux-i386/abi-check: tools/abi_check.c config/linux-i386.mk
	mkdir -p build/linux-i386
	$(CC) $(CPPFLAGS) $(CFLAGS) $< -o $@ $(LDFLAGS)

install: all
	install -d $(DESTDIR)$(bindir) $(DESTDIR)$(russelldir)/bin
	install -d $(DESTDIR)$(russelldir)/src/RICfilter
	install -d $(DESTDIR)$(russelldir)/src/RIC_to_C
	install -d $(DESTDIR)$(russelldir)/src/delab
	install -d $(DESTDIR)$(russelldir)/runtime
	install -m 755 rc $(DESTDIR)$(russelldir)/bin/rc
	install -m 755 rhelp $(DESTDIR)$(russelldir)/bin/rhelp
	install -m 755 src/Rc $(DESTDIR)$(russelldir)/src/Rc
	install -m 644 src/Ginitenv.r src/initenv.r $(DESTDIR)$(russelldir)/src/
	install -m 755 src/RICfilter/filter $(DESTDIR)$(russelldir)/src/RICfilter/filter
	install -m 755 src/RIC_to_C/to_C $(DESTDIR)$(russelldir)/src/RIC_to_C/to_C
	install -m 755 src/delab/delab $(DESTDIR)$(russelldir)/src/delab/delab
	install -m 644 runtime/rrt0.o $(DESTDIR)$(russelldir)/runtime/rrt0.o
	cp -a src/help $(DESTDIR)$(russelldir)/src/
	printf '%s\n' '#!/bin/sh' 'RUSSELL_ROOT="$(russelldir)"' \
		'export RUSSELL_ROOT' 'exec "$(russelldir)/bin/rc" "$$@"' \
		> $(DESTDIR)$(bindir)/rc
	printf '%s\n' '#!/bin/sh' 'RUSSELL_BASE="$(russelldir)/src"' \
		'export RUSSELL_BASE' 'exec "$(russelldir)/bin/rhelp" "$$@"' \
		> $(DESTDIR)$(bindir)/rhelp
	chmod 755 $(DESTDIR)$(bindir)/rc $(DESTDIR)$(bindir)/rhelp

clean-port:
	rm -rf build/linux-i386

clean: clean-port
	$(MAKE) -C src -f Makefile.main clean RROOT=$(CURDIR)
	$(MAKE) -C runtime clean
	rm -f rc rhelp fixmacros fixstrings a.out
