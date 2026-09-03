/* Canonical text I/O for Russell interface files. */

#ifndef RI_IO_H
#define RI_IO_H

#include <stdio.h>

extern int ri_write_word();
extern int ri_read_word();
extern int ri_write_string();
extern int ri_read_string();
extern int ri_write_header();
extern int ri_read_header();

#endif
