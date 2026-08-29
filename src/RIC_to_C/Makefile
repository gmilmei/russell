RROOT = <path to grandparent directory, normally defined by top level Makefile>
RR_TEMPLATE= \"$(RROOT)\\0XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\"
CFLAGS= $(PORT_CFLAGS) -DRROOT=$(RR_TEMPLATE)
OBJS= main.o loc_tab.o tmp_tab.o args.o strings.o

to_C: $(OBJS)
	$(CC) $(CFLAGS) -o to_C $(OBJS) $(GC_LIBS)

$(OBJS): tables.h strings.h
