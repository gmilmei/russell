extern end;

# ifdef USE_SYSTEM_GC
#   define is_ptr(x) ( ((x) == 0) || (GC_base((void *)(x)) != 0) )
# elif defined(RT)
#   define is_ptr(x) ( ((unsigned) (x)) == 0 || (((unsigned) (x)) >= 0x10000000 \
						 && ((unsigned) (x)) <= 0x20000000\
						 && (((unsigned)(x)) & 1) == 0 ) )
# else
#   define is_ptr(x) ( ((unsigned) (x)) == 0 || (((unsigned) (x)) >= ((unsigned) &end) \
						 && ((unsigned) (x)) <= 0x10000000\
						 && (((unsigned)(x)) & 1) == 0 ) )
# endif

