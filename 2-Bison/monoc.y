%{  /* Declarações */
    #include <stdio.h> // printf, ...

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

%%

program:
    command
    ;

command:
    printStmt
    ;

printStmt:
    PRINT LPAREN RPAREN SEMICOLON
    ;

%%
    /* Código */

void yyerror(const char *s) {
    fprintf(stderr, "%s near '%s' (line %d)\n", s, yytext, yylineno);
}
