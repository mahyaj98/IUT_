%{ 
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>


FILE* write_file;
int no_of_words = 0;
int no_of_lines = 0; 
int no_of_chars = 0; 

%} 
  

%% 

([a-zA-Z0-9])+  {if(strcmp(yytext,"user")==0){fprintf(write_file, "username");}
                else{fprintf(write_file,"%s",yytext);}
                ++no_of_words;no_of_chars+=strlen(yytext);}
                
\n              {fprintf(write_file,"\n");;
                ++no_of_lines;} 
                
[ ]             {fprintf(write_file, " ");
                ++no_of_chars;}                
                
.               {++no_of_chars;} 

%% 
  
int yywrap(){} 
int main(int argc, char **argv) 
{ 
    FILE* read_file = fopen(argv[1],"r");
    write_file = fopen("output.txt","w");
    yyin = read_file;
  
    yylex(); 
    printf("number of characters = %d\nnumber of words = %d\nnumber of lines = %d",no_of_chars,no_of_words,no_of_lines);
    fclose(read_file);
    fclose(write_file);  
    return 0; 
} 
