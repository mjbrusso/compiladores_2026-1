
%{
#include <stdio.h>
%}

LETRA   [a-zA-Z\x80-\xFF]
PALAVRA {LETRA}+

%%

{PALAVRA}   printf("%s\n", yytext);
\n|.  ;


%%

int main(){
    yylex();
}