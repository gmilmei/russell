# Reference configuration for the initial Linux port.
# Keep ABI-changing flags centralized here.

CC := env CCACHE_DISABLE=1 gcc
LD := ld
AR := ar
I386_RUNNER ?= qemu-i386

CPPFLAGS := -D_GNU_SOURCE
CFLAGS := -m32 -std=gnu89 -O0 -g -fcommon -fno-pie \
	-fno-strict-aliasing
LDFLAGS := -m32 -no-pie
