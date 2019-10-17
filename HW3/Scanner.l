%{

#include<stdio.h>

#include "y.tab.h"

extern int yylval;

%}



%%

[0-9]+ {

          yylval=atoi(yytext);

          return num;

       }

[\t] ;

[\n] return 0;

.    return yytext[0];

%%

int yywrap()

{

return 1;

}

