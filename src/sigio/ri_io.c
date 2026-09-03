/* Canonical text I/O for Russell interface files.
 *
 * Numbers use decimal notation; byte strings use one line of lowercase hex.
 * Thus the representation has no host byte-order dependency.
 */

#include "parm.h"
#include "sigio/ri_io.h"
#include <errno.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>

#define RI_MAGIC "RUSSELL-INTERFACE 1\n"
#define RI_ABI   "ABI word32-v1\n"

int ri_write_word(file, value)
FILE *file;
long value;
{
    return fprintf(file, "%ld\n", value) < 0 ? -1 : 0;
}

int ri_read_word(file, result)
FILE *file;
long *result;
{
    char line[64];
    char *end;
    long value;

    if (fgets(line, sizeof line, file) == NULL) return -1;
    errno = 0;
    value = strtol(line, &end, 10);
    if (errno != 0 || end == line || *end != '\n' || value < INT_MIN
        || value > INT_MAX) return -1;
    *result = value;
    return 0;
}

int ri_write_string(file, string)
FILE *file;
char *string;
{
    static char hex[] = "0123456789abcdef";
    unsigned char *p;

    if (string == (char *)0) return fputs("-\n", file) == EOF ? -1 : 0;
    for (p = (unsigned char *)string; *p != '\0'; p++) {
        if (putc(hex[*p >> 4], file) == EOF || putc(hex[*p & 15], file) == EOF)
            return -1;
    }
    return putc('\n', file) == EOF ? -1 : 0;
}

int ri_read_string(file, string)
FILE *file;
char **string;
{
    char line[2002];
    char *result;
    char *p;
    int length;
    int hi, lo;

    *string = (char *)0;
    if (fgets(line, sizeof line, file) == NULL) return -1;
    length = strlen(line);
    if (length == 2 && line[0] == '-' && line[1] == '\n') return 0;
    if (length == 0 || line[length - 1] != '\n' || ((length - 1) & 1)) return -1;
    result = (char *)malloc((length - 1) / 2 + 1);
    if (result == (char *)0) return -1;
    for (p = line; p < line + length - 1; p += 2) {
        hi = (*p >= '0' && *p <= '9') ? *p - '0' :
             (*p >= 'a' && *p <= 'f') ? *p - 'a' + 10 : -1;
        lo = (p[1] >= '0' && p[1] <= '9') ? p[1] - '0' :
             (p[1] >= 'a' && p[1] <= 'f') ? p[1] - 'a' + 10 : -1;
        if (hi < 0 || lo < 0) {
            free(result);
            return -1;
        }
        result[(p - line) / 2] = (hi << 4) | lo;
    }
    result[(length - 1) / 2] = '\0';
    *string = result;
    return 0;
}

int ri_write_header(file)
FILE *file;
{
    return fputs(RI_MAGIC, file) == EOF || fputs(RI_ABI, file) == EOF ? -1 : 0;
}

int ri_read_header(file)
FILE *file;
{
    char line[64];

    return fgets(line, sizeof line, file) == NULL || strcmp(line, RI_MAGIC) != 0
        || fgets(line, sizeof line, file) == NULL || strcmp(line, RI_ABI) != 0
        ? -1 : 0;
}
