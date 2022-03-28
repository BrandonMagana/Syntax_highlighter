%{
    #include <stdio.h>
    #include <stdlib.h>
%}
%option outfile="helpers/scanner.c" 

%%

\n {fprintf(yyout, "<br>", "");}
[\t] {fprintf(yyout, "&emsp;", "");}
" " {fprintf(yyout, "&nbsp;", "");}

%%

int yywrap(){}
int main(int argc, char **argv) {

    yyin = fopen("./inputs/data.txt", "r");
    yyout = fopen("./helpers/highlighted_syntax.html", "w");
    yylex();
    fclose(yyin);
    fclose(yyout);
    return 0;

}