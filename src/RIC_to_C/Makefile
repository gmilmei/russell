RROOT = <path to grandparent directory, normally defined by top level Makefile>
ifneq ($(findstring -DUSE_ELF_COLD_START,$(PORT_CFLAGS)),)
RR_TEMPLATE= \"$(RROOT)\"
else
RR_TEMPLATE= \"$(RROOT)\\0XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\"
endif
CFLAGS= $(PORT_CFLAGS) -DRROOT=$(RR_TEMPLATE)
OBJS= main.o loc_tab.o tmp_tab.o args.o strings.o

to_C: $(OBJS)
	$(CC) $(CFLAGS) -o to_C $(OBJS) $(GC_LIBS)

$(OBJS): tables.h strings.h
