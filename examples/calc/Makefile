RC ?= ../../rc
RFLAGS ?= -O
CC := env CCACHE_DISABLE=1 gcc
CFLAGS ?= -m32 -std=gnu89 -fno-builtin
calc: calc.r cr/fusion.o primes/prime_test.o xlong.o window.o curses.o \
      term.o to_hex.o
	$(RC) -pL $(RFLAGS) calc.r term.o curses.o to_hex.o -lncurses -ltinfo -lm
	mv a.out calc

xlong.o: xlong.r
	$(RC) -cpN $(RFLAGS) xlong.r

window.o: window.r
	$(RC) -cpNL $(RFLAGS) window.r

cr/fusion.o: cr/fusion.r cr/rat.o cr/cr.o cr/exp.o xlong.o
	$(RC) -cpNL $(RFLAGS) cr/fusion.r

cr/cr.o: cr/cr.r cr/interval.o xlong.o
	$(RC) -cpNL $(RFLAGS) cr/cr.r

cr/interval.o: cr/interval.r
	$(RC) -cpN $(RFLAGS) cr/interval.r

cr/rat.o: cr/rat.r xlong.o
	$(RC) -cpN $(RFLAGS) cr/rat.r

cr/exp.o: cr/exp.r
	$(RC) -cpNL $(RFLAGS) cr/exp.r

primes/Zmod.o: primes/Zmod.r xlong.o
	$(RC) -cpN $(RFLAGS) primes/Zmod.r

primes/prime_test.o: primes/prime_test.r primes/Zmod.o xlong.o
	$(RC) -cpN $(RFLAGS) primes/prime_test.r

clean:
	rm -f *.o *.s *.G *.ri calc .objfilelist \
		calc.c calc.s calc.G \
		xlong.c xlong.s xlong.G xlong.ri window.c window.s window.G window.ri \
		cr/cr.c cr/cr.s cr/cr.G cr/cr.ri \
		cr/exp.c cr/exp.s cr/exp.G cr/exp.ri \
		cr/fusion.c cr/fusion.s cr/fusion.G cr/fusion.ri \
		cr/interval.c cr/interval.s cr/interval.G cr/interval.ri \
		cr/rat.c cr/rat.s cr/rat.G cr/rat.ri \
		primes/Zmod.c primes/Zmod.s primes/Zmod.G primes/Zmod.ri \
		primes/prime_test.c primes/prime_test.s primes/prime_test.G primes/prime_test.ri
