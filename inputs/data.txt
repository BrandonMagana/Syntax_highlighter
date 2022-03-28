#include <bits/stdc++.h>
using namespace std;

class RegularExpression{

    public:
        string regex;
        int color;
        
        RegularExpression(string regex, int color_index){
            this->regex = regex;
            this->color = color_index; 
        }
    
        string getRegexInstruction(){
            return this->regex + " {fprintf(yyout, \"<span class=\'color-" + to_string(this->color) + "\'>%s</span>\", yytext);}";
        }
};

void createLFile(vector<RegularExpression> reg_expressions){
    int lineNum = 0;
    
    ifstream template_file("./templates/template.l");
    ofstream targetFile("./helpers/lexer.l");
    string line;
   
    while(getline(template_file, line)){
        
        targetFile << line << "\n";

        if(lineNum == 7){
            for(int i = 0; i < reg_expressions.size(); i++){
                targetFile << reg_expressions[i].getRegexInstruction() << "\n"; 
            } 
        }
        
        lineNum++;
    }
}

vector<RegularExpression> readRegExpressions(string file_path) {
    
    vector<RegularExpression> regularExpressions; 
    
    ifstream file(file_path);
    string line, regex;
    int color_index = 1;
    while(getline(file, line)){
        if(line.size() > 0) {
            RegularExpression current_regex(line, color_index);
            regularExpressions.push_back(current_regex); 
            color_index++;
        }
    
    }
    file.close();
    return regularExpressions;
}

void createIndexHtml(){
    ofstream index("index.html");
    ifstream html_template("./templates/template.html");
    ifstream highlighted_syntax_file("./helpers/highlighted_syntax.html");
    string template_line, highlighted_syntax;
    
    //Getting content from highlighted_syntax_file
    getline(highlighted_syntax_file, highlighted_syntax);

    while(getline(html_template, template_line)){
        index << template_line << "\n";
        if(template_line.find("id=\"code\"") != string::npos){
            index << highlighted_syntax; 
        }
    }
}

int main(){

    string regex_file = "inputs/regular_expressions.txt"; 
    
    vector<RegularExpression> regularExpressions = readRegExpressions(regex_file);
    createLFile(regularExpressions);
    
    system("flex helpers/lexer.l");
    system("gcc helpers/scanner.c -o scanner");
    system("scanner");
    // Build index.html
    createIndexHtml();

    return 0;
}
