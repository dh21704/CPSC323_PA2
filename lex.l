%{
#include "yacc.tab.h"
#include <stdlib.h>
extern int yylineno;
%}

%%

[0-9]+        { yylval.val = atoi(yytext); return INT; }
"+"           { return PLUS; }
"-"           { return MINUS; }
"*"           { return MUL; }
"/"           { return DIV; }
"("           { return LPAREN; }
")"           { return RPAREN; }

[ \t]+        ;           // ignore spaces and tabs
\n            { yylineno++; return '\n'; }  // return newline to parser
.             { printf("Invalid character '%s' at line %d\n", yytext, yylineno); }

%%

int yywrap() { return 1; }
