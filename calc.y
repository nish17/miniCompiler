%{
  void yyerror(char *s);
  #include <stdio.h>
  #include <stdlib.h>
  int sym[52];
  int symVal(char symbol);
  void updateSymVal(char symbol, int val);  
%}

%union {int num; char id;}
%start line
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

assignment  : identifier '=' exp {updateSymVal($1,$3);}
            ;
exp         : term {$$ = $1;}
            | exp '+' term {$$ = $1 + $3;}
            | exp '-' term {$$ = $1 - $3;}
            ;
term        : number {$$ = $1;}
            | identifier {$$ = symVal($1);}
%%

int computeSymInd(char token){
  int index = -1;
  if(islower(token)){
    index = token - 'a' + 26;
  }
  else if(isupper(token)){
    index = token - 'A';
  }
  return index;
}

int symVal(char symbol){
  int index = computeSymInd(symbol);
  return sym[index];
}

void updateSymVal(char symbol, int val){
  int index = computeSymInd(symbol);
  sym[index] = val;
}

int main(){
  for(int i = 0, i<52; i++) sym[i] = 0;
  return yyparse();
}

void yyerror(chat *s) fprintf(stderr,"%s\n",s);