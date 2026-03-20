%{
#include <stdio.h>
#include <stdlib.h>
#include "monoc.tab.h"
%}

%option yylineno

%%

"//".*\n                   ; /* Ignora comentários de linha */ 
[ \t\n]                    ; /* Ignora espaços em branco, tabulações e quebras de linha */
";"                        { return SEMICOLON; }
"print"                    { return PRINT; }
"("                        { return LPAREN; }
")"                        { return RPAREN; }

 /*
[0-9]+                     { return INTLITERAL;  }
"+"                        { return PLUS; }
"-"                        { return MINUS; }
"*"                        { return TIMES; }
"/"                        { return DIVIDE; }
"var"                      { return VARDEF; }
"read"                     { return READ; }
"="                        { return ATTRIB; }
"if"                       { return IF; }
"else"                     { return ELSE; }
"while"                    { return WHILE; }
"break"                    { return BREAK; }
"and"                      { return AND; }
"or"                       { return OR; }
"not"                      { return NOT; }
"=="                       { return EQUAL; }
"!="                       { return NOTEQ; }
"<="                       { return LE; }
">="                       { return GE; }
"<"                        { return LT; }
">"                        { return GT; }
"{"                        { return LBRACE; }
"}"                        { return RBRACE; }
","                        { return COMMA; }
[A-Za-z][A-Za-z0-9_]*      { return IDENT; }
 */
.                          {
                              fprintf(stderr, "Error: '%s' is not recognized (line %d)\n", yytext, yylineno);
                              exit(1);
                           }
%%

int main(int argc, char **argv) {
    yyparse();
    return 0;
}

