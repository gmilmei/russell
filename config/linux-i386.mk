# Reference configuration for the initial Linux port.
# Keep ABI-changing flags centralized here.

CC := env CCACHE_DISABLE=1 gcc
LD := ld
AR := ar
I386_RUNNER ?= qemu-i386

CPPFLAGS := -D_GNU_SOURCE -DUSE_SYSTEM_GC
CFLAGS := -m32 -std=gnu89 -O0 -g -fcommon -fno-pie \
	-fno-strict-aliasing -fno-builtin -Wno-error=implicit-int \
	-Wno-error=implicit-function-declaration
LDFLAGS := -m32 -no-pie
GC_LIBS := -lgc -lpthread -ldl
