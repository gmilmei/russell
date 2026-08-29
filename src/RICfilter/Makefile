filter: filter.o
	$(CC) $(PORT_CFLAGS) -o filter filter.o $(GC_LIBS)

filter.o: filter.c RIC.h ../pass5d/op_codes.h
	$(CC) $(PORT_CFLAGS) -c filter.c
