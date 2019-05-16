
/* 
 * cheating a little bit : define __NO_CTYPE
 * this is because GNU glibc2 ctype.h otherwise uses complicated macros
 * for isspace , which makes the job for VICI more difficult
 * #define __NO_CTYPE 1
 * cheating a bit : some headers expand stdin and stdout 
 * #undef stdin
 * #undef stdout
 */

#include "stdio.h"
#include "stdlib.h"
#include "objc.h"
#include "Graph.h"
#include "Node.h"


STR root;
id graph, lastNode;
char yytext[BUFSIZ];

doGraph() {
    id sequence, node;

    /* Build Graph by reading the input file */
    graph = [Graph new];
    yyparse();

    /* Mark all nodes reachable from root */
    [[graph addNode:root] mark];

    /* Print reachable nodes */
    sequence = [graph eachElement];
    printf("Reachable from %s:\n",root);
    while ( (node=[sequence next]) ) 
	if ([node isMarked]) printf("%s ",[node str]);
    printf("\n\n");

    /* Print unreachable nodes */
    sequence = [graph eachElement];
    printf("Not reachable from %s:\n",root);
    while ( (node=[sequence next]) )
	if (![node isMarked]) printf("%s ",[node str]);
    printf("\n\n");

    /* Print undefined nodes */
    sequence = [graph eachElement];
    printf("Undefined nodes:\n");
    while ( (node=[sequence next]) )
	if (![node isDefined]) printf("%s ",[node str]);
    printf("\n");
}

#define DefAction(x) lastNode = [graph defineNode:x]
#define RefAction(x) [lastNode addReference:[graph addNode:x]]

#include "Syntax.m"

main(int argc,char *argv[])
{
    if (argc>3||argc<2) {fprintf(stderr,"%s root [file]\n",argv[0]);exit(1);}
    if (argc==3) if (!freopen(argv[2],"r",stdin)) {perror("freopen");exit(1);}
    root = argv[1];
    doGraph();
}

