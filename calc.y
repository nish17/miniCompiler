%{
  void yyerror(char *s);
  #include <stdio.h>
  #include <stdlib.h>
  int sym[52];
  int symVal(char symbol);
  void updateSymVal(char symbol, int val);  
%}

%union {int num; char;}
$start line
%token print
%token exit_
%token <num> number
%token <id> identifier
%type <num> line exp term
%type <id> assignment

%%
line  : assignment ';' {;}
      | exit_ ';' {exit(EXIT_SUCCESS);}
      | print exp ';' {printf("Value is %d\n", $2);}
      | line assignment ';' {;}
      | line print exp ';' {printf("Value is %d\n", $3);}
      | line exit_ ';' {exit(EXIT_SUCCESS);}