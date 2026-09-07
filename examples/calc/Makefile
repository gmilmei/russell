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
	rm -f *.o *.s *.G *.ri cr/*.o cr/*.s cr/*.G cr/*.ri \
		primes/*.o primes/*.s primes/*.G primes/*.ri calc
