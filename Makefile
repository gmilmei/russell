.PHONY: all check-abi clean-port

include config/linux-i386.mk

all:
	$(MAKE) -C src all

check-abi: build/linux-i386/abi-check
	$(I386_RUNNER) build/linux-i386/abi-check

build/linux-i386/abi-check: tools/abi_check.c config/linux-i386.mk
	mkdir -p build/linux-i386
	$(CC) $(CPPFLAGS) $(CFLAGS) $< -o $@ $(LDFLAGS)

clean-port:
	rm -rf build/linux-i386
