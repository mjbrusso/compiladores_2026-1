%{  /* Declarações */
    #include <stdio.h>  // printf, ...
    #include <stdlib.h> // atoi

    int yylex();                    // Declara função do analizador léxico
    void yyerror(const char* s);    // Declara função para tratamento de erros
    extern int yylineno;            // Variável com o número da linha atual
    extern char *yytext;            // Variável com o texto atual sendo analizado
%}

 // Tokens, tipos, precedências, etc.

%token PRINT
%token RPAREN
%token LPAREN
%token SEMICOLON
%token INTLITERAL
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
%token COMMA
%token IDENT

%left PLUS MINUS
%left TIMES DIVIDE

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
        VARDEF IDENT SEMICOLON {}
    |   VARDEF IDENT ATTRIB expression SEMICOLON {}
    ;

assignment:
    IDENT ATTRIB expression SEMICOLON {}

expression:
      INTLITERAL      {  $$ = atoi(yytext); } 
    | arithmeticOp
    | enclosedExpr    
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

%%
    /* Código */

void yyerror(const char *s) {
    fprintf(stderr, "%s near '%s' (line %d)\n", s, yytext, yylineno);
}
