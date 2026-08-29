#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

static int
check_size(const char *name, size_t actual, size_t expected)
{
    if (actual == expected)
        return 0;

    fprintf(stderr, "unsupported ABI: sizeof(%s) is %lu, expected %lu\n",
            name, (unsigned long)actual, (unsigned long)expected);
    return 1;
}

int
main(void)
{
    int failed = 0;

    failed |= check_size("char", sizeof(char), 1);
    failed |= check_size("short", sizeof(short), 2);
    failed |= check_size("int", sizeof(int), 4);
    failed |= check_size("long", sizeof(long), 4);
    failed |= check_size("void *", sizeof(void *), 4);
    failed |= check_size("uintptr_t", sizeof(uintptr_t), 4);

    if (CHAR_BIT != 8) {
        fprintf(stderr, "unsupported ABI: CHAR_BIT is %d, expected 8\n",
                CHAR_BIT);
        failed = 1;
    }

    if (failed)
        return EXIT_FAILURE;

    puts("Russell target ABI: Linux i386, 8-bit bytes, 32-bit words");
    return EXIT_SUCCESS;
}
