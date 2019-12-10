%{

    #include<stdio.h>

    int error=0;

   

%}

%token num



%left '+' '-'

%left '*' '/' '%'

%left '(' ')'

%%

ArithmeticExpression: S{

         printf("%d\n",$$);

        };
S:T'$' {$$=$1;}
;
T:T'+'T {$$=$1+$3;}

 |T'-'T {$$=$1-$3;}

 |T'*'T {$$=$1*$3;}

 |T'/'T {$$=$1/$3;}

 |'('T')' {$$=$2;}

 | num {$$=$1;}

;

%%



void main()

{

   printf("Please Enter some mathematical expressions to validate :) please add $ at the end!\n");
 
   yyparse(); 

  if(error==0){printf("Congratulations! Parsing is completed and your expression is valid! :D\n");}

 

}

void yyerror()

{

   printf("Your expression doesn't seem to be valid! sorry :(\n");

   error=1;

}
