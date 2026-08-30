#
/*
 * Russell
 *
 * tables of reserved words
 */

#include      "../parser/y.tab.h"

struct restab {
    char *rt_txt;
    int rt_val;
};

struct restab residtab[] = {
    {"cand", CAND}, {"characters", CHARACTERS}, {"constants", CONSTANTS},
    {"cor", COR}, {"do", DO}, {"else", ELSE}, {"elsif", ELSIF},
    {"enum", ENUM}, {"export", EXPORT}, {"extend", EXTEND},
    {"extern", EXTERN}, {"fi", FI}, {"field", FIELD}, {"func", FUNC},
    {"hide", HIDE}, {"if", IF}, {"in", IN}, {"let", LET}, {"ni", NI},
    {"od", OD}, {"prod", PROD}, {"readonly", READONLY}, {"record", RECORD},
    {"signature", SIGNATURE}, {"then", THEN}, {"type", TYPE},
    {"union", UNION}, {"use", USE}, {"val", VAL}, {"var", VAR},
    {"with", WITH},
};

int nresids = sizeof residtab / sizeof residtab[0];


struct restab resoptab[] = {
    {":", COLON}, {"<<", LEFT_ANGLE_BRACKET}, {"==", EQUALS_EQUALS},
    {"===", EQUALS_EQUALS_EQUALS}, {"==>", RIGHT_ARROW},
    {">>", RIGHT_ANGLE_BRACKET},
};

int nresops = sizeof resoptab / sizeof resoptab[0];
