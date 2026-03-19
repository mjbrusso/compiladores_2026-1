%{
#include <stdio.h>
#include <stdlib.h>

void print_token(const char *token_name) {
    printf("(%s, \"%s\")\n", token_name, yytext);
}
%}

%option yylineno

%%
"//".*\n                   ; /* Ignora comentários de linha */ 
[ \t\n]                    ; /* Ignora espaços em branco e tabulações */
[0-9]+                     { print_token("INTLITERAL"); }
"var"                      { print_token("VARDEF"); }
"if"                       { print_token("IF"); }
"else"                     { print_token("ELSE"); }
"while"                    { print_token("WHILE"); }
"break"                    { print_token("BREAK"); }
"and"                      { print_token("AND"); }
"or"                       { print_token("OR"); }
"not"                      { print_token("NOT"); }
"print"                    { print_token("PRINT"); }
"read"                     { print_token("READ"); }
[A-Za-z][A-Za-z0-9_]*      { print_token("IDENT"); }
"="                        { print_token("ATTRIB"); }
"=="                       { print_token("EQUAL"); }
"!="                       { print_token("NOTEQ"); }
"<="                       { print_token("LE"); }
">="                       { print_token("GE"); }
"<"                        { print_token("LT"); }
">"                        { print_token("GT"); }
"+"                        { print_token("PLUS"); }
"-"                        { print_token("MINUS"); }
"*"                        { print_token("TIMES"); }
"/"                        { print_token("DIVIDE"); }
"("                        { print_token("LPAREN"); }
")"                        { print_token("RPAREN"); }
"{"                        { print_token("LBRACE"); }
"}"                        { print_token("RBRACE"); }
";"                        { print_token("SEMICOLON"); }
","                        { print_token("COMMA"); }

.                          {
                              fprintf(stderr, "Error: '%s' is not recognized (line %d)\n",  yytext, yylineno);
                              exit(1);
                           }
%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}
