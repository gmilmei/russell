CFLAGS = $(PORT_CFLAGS)

.PHONY: all clean

all: rrt0.o

clean:
	find . -type f \( -name '*.o' -o -name '*.a' \) -delete
	rm -f BigNum/testKerN BigNum/bztest

OBJECTS= alias.o bool.o chstr.o long.o long_mult.o \
	 short.o void.o comb_float.o array.o call_russell.o \
	 type_constr.o misc.o ref.o list.o lazy_list.o file.o callcc.o \
	 startup.o BigNum/BigNum.a

rrt0.o: main.o russell_lib.o
	$(LD) -r $(REL_LDFLAGS) -o rrt0.o main.o russell_lib.o

russell_lib.o: $(OBJECTS)
	$(LD) -r $(REL_LDFLAGS) -o russell_lib.o $(OBJECTS)

comb_float.o: float.o sfloat.o
	$(LD) -r $(REL_LDFLAGS) -o comb_float.o float.o sfloat.o

BigNum/BigNum.a:
	cd BigNum; $(MAKE) C32 CC="$(CC)" \
		CFLAGS="$(PORT_CFLAGS) -c -I./h" \
		LKFLAGS="-m32 -no-pie"
	
$(OBJECTS): runtime.h ../src/gc/gc.h

chstr.o misc.o array.o alias.o bool.o short.o long.o void.o ref.o list.o lazy_list.o file.o alloc.o float.o call_russell.o: types.h

startup.o main.o: initenv.cpp types.h
