/*
 * Copyright (c) 1980, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#ifndef lint
static char copyright[] =
"@(#) Copyright (c) 1980, 1993\n\
	The Regents of the University of California.  All rights reserved.\n";
#endif /* not lint */

#ifndef lint
static char sccsid[] = "@(#)xstr.c	8.1 (Berkeley) 6/9/93";
#endif /* not lint */

#include <sys/types.h>
#include <signal.h>
#include <unistd.h> /* mktemp() */
#include <errno.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "pathnames.h"  /* seems overkill for just one define... */

#include "objpak.h"

/*
 * xstr - extract and hash strings in a C program
 *
 * Bill Joy, UCB
 * November, 1978
 */

/*
 * David Stes,
 * April, 1997
 * 
 * (a) Added -s option so that strings databases can be shared
 *     across directories.
 * 
 * (b) Fix for ANSI C string concatenation.
 *     "hello" "world" was being translated into 2 separate &xstr expressions.
 */

#define	ignore(a)	((void) a)

off_t	tellpt;
off_t	hashit();
void	onintr();
char	*savestr();
id		yankstr(); /* stes 4/21/1997 */
off_t	yankchain(); /* stes 4/21/1997 - replaces yankstr() */

off_t	mesgpt;
char	*strings =	"strings";

int	cflg;
int	vflg;
int	readstd;
int tmpflg;   /* flag temporary "strings" file for cleanup */

char *umsg = "usage: xstr [ -v ] [ -c ] [ -s strings ] [ - ] [ name ... ]\n";

usage()
{
	fprintf(stderr,umsg);exit(1);
}

void
mktempstrings()
{
	static char template[256];
	strcpy(template,_PATH_TMP);
	strings = mktemp(template);
	tmpflg=1;
}

isoption(s)
	char *s;
{
	return s != NULL && s[0] == '-';
}

main(argc, argv)
	int argc;
	char *argv[];
{

	argc--, argv++;
	while (argc > 0 && isoption(*argv)) {
		register char *cp = &(*argv++)[1];

		argc--;
		if (*cp == 0) {
			readstd++;
			continue;
		}
		do switch (*cp++) {

		case 'c':
			cflg++;
			continue;

		case 'v':
			vflg++;
			continue;
		
		/* stes 4/21/1997 -- use strings databases across directories */
		case 's':
			argc--;strings=*argv++;
			if (!strings || isoption(strings)) 	usage();
			continue;

		default:
			usage();

		} while (*cp);
	}
	
	if (signal(SIGINT, SIG_IGN) == SIG_DFL) signal(SIGINT, onintr);
	
	if (cflg || (argc == 0 && !readstd))
		readstrings();
	else
		mktempstrings();
	
	while (readstd || argc > 0) {
		if (freopen("x.c", "w", stdout) == NULL)
			perror("x.c"), exit(1);
		if (!readstd && freopen(argv[0], "r", stdin) == NULL)
			perror(argv[0]), exit(2);
		process("x.c");
		if (readstd == 0)
			argc--, argv++;
		else
			readstd = 0;
	};
	flushsh();
	if (cflg == 0)
		xsdotc();
	if (tmpflg) ignore(unlink(strings));
	exit(0);
}

char linebuf[BUFSIZ];

int
newlinebuf(char *msg)
{
	if (fgets(linebuf, sizeof linebuf, stdin) == NULL) {
		if (ferror(stdin)) { perror(msg);exit(3); } else return 1;
	}
	return 0;
}

/*
 * stes - 21/6/1997
 * Return String instance for preprocessor line.
 * Code copied out of process() and reused in whitespace scanning
 */

id
cppline()
{
	if (linebuf[0] == '#') {
		if (linebuf[1] == ' ' && isdigit(linebuf[2]))
			return [String sprintf:"#line%s", &linebuf[1]];
		else
			return [String sprintf:"%s", linebuf];
	}

	return nil;
}

process(name)
	char *name;
{
	char *cp;
	register int c;
	register int incomm = 0;
	int inchain = 0;
	int ret;

	printf("extern char\txstr[];\n");
	for (;;) {
		id str;

		if (newlinebuf(name)) break;
		if (str = cppline()) { [str print];[str free];continue; }
		
		for (cp = linebuf; c = *cp++;) switch (c) {

		case '"':
			if (incomm)
				goto def;
			if ((ret = (int) yankchain(&cp)) == -1)
				goto out;
			printf("(&xstr[%d])", ret);
			break;

		case '\'':
			if (incomm)
				goto def;
			putchar(c);
			if (*cp)
				putchar(*cp++);
			break;

		case '/':
			if (incomm || *cp != '*')
				goto def;
			incomm = 1;
			cp++;
			printf("/*");
			continue;

		case '*':
			if (incomm && *cp == '/') {
				incomm = 0;
				cp++;
				printf("*/");
				continue;
			}
			goto def;

def:
		default:
			putchar(c);
			break;
		}
	}
out:
	if (ferror(stdout))
		perror("x.c"), onintr();
}

/* stes - 4/21/1997
 * modified to return a String instance instead of an off_t.
 * yankchain() then concatenates string objects.
 */


id
yankstr(cpp)
	register char **cpp;
{
	register char *cp = *cpp;
	register int c, ch;
	char dbuf[BUFSIZ];
	register char *dp = dbuf;
	register char *tp;

	while (c = *cp++) {
		switch (c) {

		case '"':
			cp++;
			goto out;

		case '\\':
			c = *cp++;
			if (c == 0)
				break;
			if (c == '\n') {
				if (newlinebuf("x.c")) return nil;
				cp = linebuf;
				continue;
			}
			for (tp = "b\bt\tr\rn\nf\f\\\\\"\""; ch = *tp++; tp++)
				if (c == ch) {
					c = *tp;
					goto gotc;
				}
			if (!octdigit(c)) {
				*dp++ = '\\';
				break;
			}
			c -= '0';
			if (!octdigit(*cp))
				break;
			c <<= 3, c += *cp++ - '0';
			if (!octdigit(*cp))
				break;
			c <<= 3, c += *cp++ - '0';
			break;
		}
gotc:
		*dp++ = c;
	}
out:
	*cpp = --cp;
	*dp = 0;
	return [String str:dbuf]; /* return (hashit(dbuf, 1)); */
}

/* stes - 4/21/1997
 * skip white space, until a double quote follows
 * skip white space if yes, otherwise output whitespace.
 * (this is complicated by the use of linebuf)
 */

void
concatChar(id str,int c)
{
	char cStr[2];
	cStr[0] = c;cStr[1] = 0;
	[str concatSTR:cStr];
}

int
stringfollows(cpp)
	char **cpp;
{
	int c;
	id str; /* for stripping #line directives out of string */
	char *cp = *cpp;
	id whitespace = [String new];

	while ((c = *cp++)) switch(c) {
		case '\n' :
				concatChar(whitespace,c);
				do {
				if (newlinebuf("x.c")) break;else cp = linebuf;
				if ((str = cppline())) {
					[whitespace concatSTR:[str str]];
					[str free];
				}} while (str);
				continue;
		case ' '  :
		case '\t' :
				concatChar(whitespace,c);continue;
		case '"' :
				*cpp = cp;return 1;
		default   :
				*cpp = --cp;[whitespace print];return 0;
	}
}

/* stes - 4/21/1997
 * yankchain() is like the old yankstr() but deals with
 * ANSI C string concatenation.
 */

off_t
yankchain(cpp)
	char **cpp;
{
	id chain = [String new];
	
	do {
		id str = yankstr(cpp);
		if (str) [chain concatSTR:[str str]]; else return -1;
	} while (stringfollows(cpp));
	
	return (hashit([chain str], 1));
}

octdigit(c)
	char c;
{

	return (isdigit(c) && c != '8' && c != '9');
}

fgetNUL(obuf, rmdr, file)
	char *obuf;
	register int rmdr;
	FILE *file;
{
	register c;
	register char *buf = obuf;

	while (--rmdr > 0 && (c = xgetc(file)) != 0 && c != EOF)
		*buf++ = c;
	*buf++ = 0;
	return ((feof(file) || ferror(file)) ? 0 : 1);
}

readstrings()
{
	char buf[BUFSIZ];
	register FILE *mesgread = fopen(strings, "r");

	if (mesgread == NULL)
		return;
	for (;;) {
		mesgpt = tellpt;
		if (fgetNUL(buf, sizeof buf, mesgread) == NULL) break;
		ignore(hashit(buf, 0));
	}
	ignore(fclose(mesgread));
}

xgetc(file)
	FILE *file;
{

	tellpt++;
	return (getc(file));
}

#define	BUCKETS	128

struct	hash {
	off_t	hpt;
	char	*hstr;
	struct	hash *hnext;
	short	hnew;
} bucket[BUCKETS];

off_t
hashit(str, new)
	char *str;
	int new;
{
	int i;
	register struct hash *hp, *hp0;

	hp = hp0 = &bucket[lastchr(str) & 0177];
	while (hp->hnext) {
		hp = hp->hnext;
		i = istail(str, hp->hstr);
		if (i >= 0)
			return (hp->hpt + i);
	}
	if ((hp = (struct hash *) calloc(1, sizeof (*hp))) == NULL) {
		perror("xstr");
		exit(8);
	}
	hp->hpt = mesgpt;
	if (!(hp->hstr = strdup(str))) {
		(void)fprintf(stderr, "xstr: %s\n", strerror(errno));
		exit(1);
	}
	mesgpt += strlen(hp->hstr) + 1;
	hp->hnext = hp0->hnext;
	hp->hnew = new;
	hp0->hnext = hp;
	return (hp->hpt);
}

flushsh()
{
	register int i;
	register struct hash *hp;
	register FILE *mesgwrit;
	register int old = 0, new = 0;

	for (i = 0; i < BUCKETS; i++)
		for (hp = bucket[i].hnext; hp != NULL; hp = hp->hnext)
			if (hp->hnew)
				new++;
			else
				old++;
	if (new == 0 && old != 0)
		return;
	mesgwrit = fopen(strings, old ? "r+" : "w");
	if (mesgwrit == NULL)
		perror(strings), exit(4);
	for (i = 0; i < BUCKETS; i++)
		for (hp = bucket[i].hnext; hp != NULL; hp = hp->hnext) {
			found(hp->hnew, hp->hpt, hp->hstr);
			if (hp->hnew) {
				fseek(mesgwrit, hp->hpt, 0);
				ignore(fwrite(hp->hstr, strlen(hp->hstr) + 1, 1, mesgwrit));
				if (ferror(mesgwrit))
					perror(strings), exit(4);
			}
		}
	if (fclose(mesgwrit) == EOF)
		perror(strings), exit(4);
}

found(new, off, str)
	int new;
	off_t off;
	char *str;
{
	if (vflg == 0)
		return;
	if (!new)
		fprintf(stderr, "found at %d:", (int) off);
	else
		fprintf(stderr, "new at %d:", (int) off);
	prstr(str);
	fprintf(stderr, "\n");
}

prstr(cp)
	register char *cp;
{
	register int c;

	while (c = (*cp++ & 0377))
		if (c < ' ')
			fprintf(stderr, "^%c", c + '`');
		else if (c == 0177)
			fprintf(stderr, "^?");
		else if (c > 0200)
			fprintf(stderr, "\\%03o", c);
		else
			fprintf(stderr, "%c", c);
}

xsdotc()
{
	register FILE *strf = fopen(strings, "r");
	register FILE *xdotcf;

	if (strf == NULL)
		perror(strings), exit(5);
	xdotcf = fopen("xs.c", "w");
	if (xdotcf == NULL)
		perror("xs.c"), exit(6);
	fprintf(xdotcf, "char\txstr[] = {\n");
	for (;;) {
		register int i, c;

		for (i = 0; i < 8; i++) {
			c = getc(strf);
			if (ferror(strf)) {
				perror(strings);
				onintr();
			}
			if (feof(strf)) {
				fprintf(xdotcf, "\n");
				goto out;
			}
			fprintf(xdotcf, "0x%02x,", c);
		}
		fprintf(xdotcf, "\n");
	}
out:
	fprintf(xdotcf, "};\n");
	ignore(fclose(xdotcf));
	ignore(fclose(strf));
}

lastchr(cp)
	register char *cp;
{

	while (cp[0] && cp[1])
		cp++;
	return (*cp);
}

istail(str, of)
	register char *str, *of;
{
	register int d = strlen(of) - strlen(str);

	if (d < 0 || strcmp(&of[d], str) != 0)
		return (-1);
	return (d);
}

void
onintr()
{

	ignore(signal(SIGINT, SIG_IGN));
	if (tmpflg) ignore(unlink(strings));
	ignore(unlink("x.c"));
	ignore(unlink("xs.c"));
	exit(7);
}
