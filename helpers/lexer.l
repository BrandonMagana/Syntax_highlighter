%{
    #include <stdio.h>
    #include <stdlib.h>
%}
%option outfile="helpers/scanner.c" 

%%

"if"|"for"|"while"|"or"|"else"|"return"|"in"|"class"|"def"|"catch"|"public"|"return"|"continue"|"using"|"namespace" {fprintf(yyout, "<span class='color-1'>%s</span>", yytext);}
"("|")"|"{"|"}"|"["|"]" {fprintf(yyout, "<span class='color-2'>%s</span>", yytext);}
"true"|"false"|"True"|"False" {fprintf(yyout, "<span class='color-3'>%s</span>", yytext);}
"#".*|"%".*|"//".* {fprintf(yyout, "<span class='color-4'>%s</span>", yytext);}
[0-9]+ {fprintf(yyout, "<span class='color-5'>%s</span>", yytext);}
[0-9]+"."[0-9]+ {fprintf(yyout, "<span class='color-6'>%s</span>", yytext);}
[a-zA-Z_]+[a-zA-Z0-9_]* {fprintf(yyout, "<span class='color-7'>%s</span>", yytext);}
"<="|">="|"=="|"!="|"<"|">" {fprintf(yyout, "<span class='color-8'>%s</span>", yytext);}
"\."|","|";"|":" {fprintf(yyout, "<span class='color-9'>%s</span>", yytext);}
"'"."'" {fprintf(yyout, "<span class='color-10'>%s</span>", yytext);}
"!"|"%"|"^"|"+"|"="|"-"|"*"|"/" {fprintf(yyout, "<span class='color-11'>%s</span>", yytext);}
"\"".*"\"" {fprintf(yyout, "<span class='color-12'>%s</span>", yytext);}
\n {fprintf(yyout, "<br>", "");}
[\t] {fprintf(yyout, "&emsp;", "");}
" " {fprintf(yyout, "&nbsp;", "");}

%%

int yywrap(){}
int main(int argc, char **argv) {

    yyin = fopen("./inputs/text_input.txt", "r");
    yyout = fopen("./helpers/highlighted_syntax.html", "w");
    yylex();
    fclose(yyin);
    fclose(yyout);
    return 0;

}
