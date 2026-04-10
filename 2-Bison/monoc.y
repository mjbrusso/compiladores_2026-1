%{  /* Declarações */
    #include <stdio.h>  // printf, ...
    #include <stdlib.h> // atoi
    #include "symtab.h"

    int yylex();                    // Declara função do analizador léxico
    void yyerror(const char* s);    // Declara função para tratamento de erros
    extern int yylineno;            // Variável com o número da linha atual
    extern char *yytext;            // Variável com o texto atual sendo analizado
%}

 // Tokens, tipos, precedências, etc.

%union{
    int valint;         // INTLITERAL
    symtab_entry *id;   // IDENT
}

%token PRINT
%token RPAREN
%token LPAREN
%token SEMICOLON
%token<valint> INTLITERAL
%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token VARDEF
%token READ
%token ATTRIB
%token IF
%token ELSE
%token WHILE
%token BREAK
%token AND
%token OR
%token NOT
%token EQUAL
%token NOTEQ
%token LE
%token GE
%token LT
%token GT
%token LBRACE
%token RBRACE
%token<id> IDENT

%left PLUS MINUS
%left TIMES DIVIDE

%type<valint> expression
%type<valint> arithmeticOp
%type<valint> enclosedExpr
%type<valint> identifier
%type<valint> readExpr

%%

program:
        command program
    |
    ;

command:
        printStmt
    |   declaration
    |   assignment
    ;

printStmt:
      PRINT LPAREN RPAREN SEMICOLON             { printf("\n"); }
    | PRINT LPAREN expression RPAREN SEMICOLON  { printf("%d\n", $3); }
    ;

declaration:
        VARDEF IDENT SEMICOLON { $2->defined = 1; }
    |   VARDEF IDENT ATTRIB expression SEMICOLON { 
                                    $2->defined = 1;
                                    $2->value = $4;
                                }
    ;

assignment:
    IDENT ATTRIB expression SEMICOLON {
        if(!$1->defined){
            printf("%d: '%s' undefined\n", yylineno, $1->key);
            exit(1);
        }
        $1->value = $3;
    }

expression:
      INTLITERAL      {  $$ = atoi(yytext); } 
    | arithmeticOp
    | enclosedExpr 
    | identifier 
    | readExpr  
    ;

readExpr:
    READ LPAREN RPAREN  { 
                            int aux;
                            scanf("%d", &aux);
                            $$ = aux;
                        }
    ;

arithmeticOp:
      expression PLUS expression  { $$ = $1 + $3; }
    | expression MINUS expression { $$ = $1 - $3; }
    | expression TIMES expression { $$ = $1 * $3; }
    | expression DIVIDE expression { $$ = $1 / $3; }
    ;

enclosedExpr:
    LPAREN expression RPAREN { $$ = $2; }
    ;

identifier:
    IDENT       {
                    if(!$1->defined){
                        printf("%d: '%s' undefined\n", yylineno, $1->key);
                        exit(1);
                    }
                    $$ = $1->value;
                }
%%
    /* Código */

void yyerror(const char *s) {
    fprintf(stderr, "%s near '%s' (line %d)\n", s, yytext, yylineno);
}
