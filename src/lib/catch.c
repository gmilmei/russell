# include <signal.h>
# include <stdio.h>
# include <stdlib.h>
# include "mesg.h"

/*
 *  Catch signals and flush io buffers before aborting.
 */

int sig;           /* the signal caught */

/*
 * catchsigs()
 *
 * Setup signals to be caught
 */
catchsigs()
{   extern void catch();

    signal(SIGQUIT, catch);
    signal(SIGILL, catch);
#ifdef SIGEMT
    signal(SIGEMT, catch);
#endif
    signal(SIGFPE, catch);
    signal(SIGBUS, catch);
    signal(SIGSEGV, catch);
    signal(SIGSYS, catch);
    signal(SIGPIPE, catch);
    signal(SIGALRM, catch);
}

/*
 * catch()
 *
 * Catch a signal, put it in sig, print an error message, then abort().
 * (Note: abort() will flush all io buffers before executing an iot trap).
 */
void catch(i)
int i;
{
    sig = i;
	printf("Rc failed with signal: %s\n", mesg[i]);
    abort();
}
