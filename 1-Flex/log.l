%{
#include <stdio.h>
%}

DIGITO      [0-9]
MAIUSCULA   [A-Z]
MINUSCULA   [a-z]
DIA         {DIGITO}{2}
MES         {MAIUSCULA}{MINUSCULA}{2}
ANO         {DIGITO}{4}
DATA        {DIA}\/{MES}\/{ANO}

%option yylineno

%%


{DATA}  printf("%d: %s\n", yylineno, yytext);
\n      ;
.       ;

%%

int main(){
    yylex();
}
