%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex(void);  // Declare the lexer function
extern FILE *yyin;  // Declare yyin as an external variable
void yyerror(const char *s);  // Declare the error reporting function
%}

%union {
    int val;  // Declare the value type for the symbols (here, integers)
}

%token <val> INT
%token PLUS MINUS MUL DIV LPAREN RPAREN NEG

%type <val> E T F E_prime T_prime

%left PLUS MINUS  // Addition and subtraction have the same precedence (left-associative)
%left MUL DIV     // Multiplication and division have higher precedence (left-associative)
%right NEG        // Unary minus has the highest precedence (right-associative)
%left '(' ')'

%%

E: T E_prime {
    $$ = $1 + $2;  // Evaluate the expression after T
}

E_prime:
    PLUS T E_prime {
        $$ = $2 + $3;  // Handle addition
    }
    | MINUS T E_prime {
        $$ = $2 - $3;  // Handle subtraction
    }
    | /* empty */ {
        $$ = 0;  // Base case: no more operations, so just return 0
    }
    ;

T: F T_prime {
    $$ = $1 * $2;  // Handle multiplication and division
}

T_prime:
    MUL F T_prime {
        $$ = $2 * $3;  // Handle multiplication
    }
    | DIV F T_prime {
        if ($3 == 0) {
            yyerror("Division by zero");
            exit(1);
        }
        $$ = $2 / $3;  // Handle division
    }
    | /* empty */ {
        $$ = 1;  // Base case: no more multiplication or division, return 1
    }
    ;

F: INT {
    $$ = $1;  // Integer value is just the token
}
 | LPAREN E RPAREN {
    $$ = $2;  // Parentheses, evaluate the expression inside the parentheses
}
 | MINUS F %prec NEG {
    $$ = -$2;  // Handle unary minus, negate the value
}
 ;

%%

int main() {
    // Open the file "pa2_test_cases.txt" for reading.
    FILE *file = fopen("pa2_test_cases.txt", "r");
    if (!file) {
        fprintf(stderr, "Error opening file.\n");
        return 1;
    }

    // Redirect input to the file.
    yyin = file;

    // Start parsing.
    yyparse();

    // Close the file after processing.
    fclose(file);

    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
