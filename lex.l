%{
#include "yacc.tab.h"
#include <stdlib.h>
#include <stdio.h>

int yylex(void);  // Declare the lexer function
%}

%%

[0-9]+           { yylval.val = atoi(yytext); return INT; }  // Integer token

"+"              { return PLUS; }
"-"              { 
                    if (yytext[1] == ' ' || yytext[1] == '\t' || yytext[1] == '(' || yytext[1] == '\n') {
                        return MINUS; // Unary minus
                    }
                    return MINUS;  // Binary minus
                }

"*"              { return MUL; }
"/"              { return DIV; }
"("              { return LPAREN; }
")"              { return RPAREN; }

[ \t\n]          { /* Ignore whitespace */ }
.                { printf("Invalid character: %s\n", yytext); return 0; }  // Invalid character

%%

int yywrap() {
    return 1;
}
