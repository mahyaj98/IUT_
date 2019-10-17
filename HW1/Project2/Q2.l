%{ 
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>


FILE* write_file;

%} 
  
digit         [0-9]
letter        [a-zA-Z]

%% 
"//"[^\n]*                  /* skip comments*/
"+"[ ]                         { fprintf(write_file, "( operator , + )"); }
"-"[ ]                         { fprintf(write_file, "( operator , - )"); }
"*"[ ]                         { fprintf(write_file, "( operator , * )"); }
"/"[ ]                         { fprintf(write_file, "( operator , / )"); }
"("[ ]                         { fprintf(write_file, "( special , ( )"); }
")"[ ]                         { fprintf(write_file, "( special , ) )"); }
"+="[ ]                        { fprintf(write_file, "( operator , += )"); }
"="[ ]                         { fprintf(write_file, "( operator , = )"); }
"++"                        { fprintf(write_file, "( operator , ++ )"); }
"--"                        { fprintf(write_file, "( operator , -- )"); }
"/="[ ]                        { fprintf(write_file, "( operator , /= )"); }
"-="[ ]                        { fprintf(write_file, "( operator , -= )"); }
"*="[ ]                        { fprintf(write_file, "( operator , *= )"); }
"{"                         { fprintf(write_file, "( special , { )"); }
"}"                         { fprintf(write_file, "( special , } )"); }
"int"[ ]                       { fprintf(write_file, "( keyword , int )"); }
"main"[ ]                      { fprintf(write_file, "( keyword , main )"); }
"if"[ ]                        { fprintf(write_file, "( keyword , if)"); }
"char"[ ]                      { fprintf(write_file, "( keyword , char )"); }
"float"[ ]                     { fprintf(write_file, "( keyword , float )"); }
"return"[ ]                    { fprintf(write_file, "( keyword , return )"); }
"then"[ ]                      { fprintf(write_file, "( keyword , then )"); }
"var"[ ]                       { fprintf(write_file, "( keyword , var )"); }
"while"[ ]                     { fprintf(write_file, "( keyword , while )"); }
{letter}({letter}|{digit})*[ ] { fprintf(write_file, "( identifier , %s )", yytext); }
{digit}+[ ]                    { fprintf(write_file, "( integer , %s )", yytext);}
{digit}+\.{digit}*[ ]          { fprintf(write_file, "( float , %s )", yytext);}
[ \t\n\r]                   /* skip whitespace */
.                           { printf("Unknown Character =  %s \n", yytext);}

%% 
  
int yywrap(){} 
int main(int argc, char **argv) 
{ 
    FILE* read_file = fopen(argv[1],"r");
    write_file = fopen("output.txt","w");
    yyin = read_file;
  
    yylex(); 
    fclose(read_file);
    fclose(write_file);  
    return 0; 
} 
