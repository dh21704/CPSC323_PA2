%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;
void yyerror(const char *s);
%}

%union {
    int val;
}

%token <val> INT
%token PLUS MINUS MUL DIV LPAREN RPAREN

%type <val> E T F

%left PLUS MINUS
%left MUL DIV
%right NEG

%%

input:
      /* empty */
    | input line
    ;

line:
      E '\n'     { printf("Result = %d\n", $1); }
    | error '\n' { printf("Invalid expression\n"); yyerrok; }
    ;

E:
      E PLUS T   { $$ = $1 + $3; }
    | E MINUS T  { $$ = $1 - $3; }
    | T          { $$ = $1; }
    ;

T:
      T MUL F    { $$ = $1 * $3; }
    | T DIV F    {
                    if ($3 == 0) {
                        yyerror("Division by zero");
                        YYERROR;
                    }
                    $$ = $1 / $3;
                 }
    | F          { $$ = $1; }
    ;

F:
      INT                { $$ = $1; }
    | LPAREN E RPAREN    { $$ = $2; }
    | MINUS F %prec NEG  { $$ = -$2; }
    ;

%%

void yyerror(const char *s) {
    // Only print runtime errors; suppress default syntax error
    if (strcmp(s, "syntax error") != 0) {
        fprintf(stderr, "Error: %s at line %d\n", s, yylineno);
    }
}

int main() {
    yyparse();
    return 0;
}
