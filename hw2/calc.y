%{
    /*
        * This is the header section of the file
        * It contains the C++ code that is copied verbatim to the generated file
        * It also contains the declarations of the functions that are used in the grammar


        * The following functions are declared in this section:
            * double symbolVal(string s)
                * Returns the value of the symbol s
                * If the symbol is not defined, it prints an error message and exits the program

            * void updateSymbol(string s, double val)
                * Updates the value of the symbol s to val

        * The priority of the operators is defined in this section
            * The operators are defined in the following order of precedence (Descending order):
                * ADD, SUB
                * MUL, DIV, MOD
                * COS, SIN, NEG, ABS, LOG, POW, INR, DEC

        **** IMPORTANT ****
        * Remember that THIS PROGRAM USE C++, SO YOU MUST COMPILE IT WITH G++ DO NOT USE GCC
            * The following is an example of how to compile the program:
                * $ flex ./calc.l
                * $ bison -dv ./calc.y
                * $ g++ -o calc calc.tab.c lex.yy.c -lfl -lm
    */
    
    /*
        * External functions and variables
            * yylex() - The lexer function
            * yyparse() - The parser function
            * yyerror(char *s) - The error function
            * line - The line number of the input file
    */
    extern int yylex();
    extern int yyparse();
    extern void yyerror(char *s);
    extern int line;

    /*
        * Include the necessary libraries
            * iostream - Input/Output stream
            * cstdlib - C Standard Library (for string conversion eg. cstring to double)
            * math.h - Math library (for mathematical functions eg. cos, sin, log10, pow)
            * unordered_map - Unordered map (implemented using hash) (for storing the symbol table)
            * string - String library (for string manipulation)
    */
    #include <iostream>
    #include <cstdlib>
    #include <math.h>
    #include <unordered_map>
    #include <string>
    using namespace std;

    /*
        * The symbol table is implemented using an unordered map
            * The key is a string (symbol)
            * The value is a double (value of the symbol)
    */
    unordered_map<string,double> symbolTable;
    double symbolVal(string symbol);
    void updateSymbol(string symbol, double value);
%}

%union {
    double num;
    char* id;
}
%start program


%left ADD SUB
%left MUL DIV MOD
%left COS SIN NEG ABS LOG POW INR DEC



%token <num> NUM
%token <id> ID


%token ADD SUB MUL DIV MOD COS SIN NEG ABS LOG POW INR DEC 
%type <num> expr
%type <id> stmt program


%%

program: program stmt '\n'  {;}
       | /* empty */        {;}
       ;

stmt : ID '=' expr        {
                            /*
                                * Updates the value of the symbol $1 to the value of the expression $3
                            */
                            $$ = $1;
                            updateSymbol(string($1),$3);
                            cout<<$3<<endl;  
                          }
     ;

expr: NUM           { 
                        /*
                            * Returns the value of the number
                        */
                        $$ = $1; 
                    }
    | ID            {
                        /*
                            * Returns the value of the symbol
                        */ 
                        $$ = symbolVal(string($1));
                    }
    | expr ADD expr {
                        /*
                            * Returns the sum of the two expressions
                        */ 
                        $$ = $1 + $3; 
                    }
    | expr SUB expr {
                        /*
                            * Returns the difference of the two expressions
                        */ 
                        $$ = $1 - $3; 
                    }
    | expr MUL expr {
                        /*
                            * Returns the product of the two expressions
                        */
                         $$ = $1 * $3; 
                    }
    | expr DIV expr {
                        /*
                            * Checks if the divisor is zero
                            * If it is, it prints an error message and exits the program
                        */
                        if($3 == 0){
                            fprintf(stderr,"line %i: Division by zero.\n",line);
                            exit(EXIT_FAILURE);
                        } 
                        $$ = $1 / $3; 
                    }
    | expr MOD expr { 
                        /*
                            * Checks if the divisor is zero
                            * If it is, it prints an error message and exits the program
                        */
                        if($3 == 0){
                            fprintf(stderr,"line %i: Division by zero.\n",line);
                            exit(EXIT_FAILURE);
                        }
                        $$ = fmod($1,$3); 
                    }
    | COS '(' expr ')' { 
                            /*
                                * Returns the cosine of the expression
                                * The expression is in radians
                            */
                            $$ = cos($3); 
                       }
    | SIN '(' expr ')' { 
                            /*
                                * Returns the sine of the expression
                                * The expression is in radians
                            */
                            $$ = sin($3); 
                       }
    | NEG '(' expr ')' { 
                            /*
                                * Returns the negative of the expression
                            */
                            $$ = -$3; 
                       }
    | ABS '(' expr ')' {    
                            /*
                                * Returns the absolute value of the expression
                            */
                            $$ = fabs($3); 
                       }
    | LOG '(' expr ')' { 
                            /*
                                * Checks if the argument of the logarithm is non-positive
                                * If it is, it prints an error message and exits the program
                            */
                            if($3 <= 0){
                                fprintf(stderr,"line %i: Logarithm of non-positive number.\n",line);
                                exit(EXIT_FAILURE);
                            }
                            $$ = log10($3); 
                        }
    | expr POW expr  {
                            /*
                                * Returns the value of the first expression raised to the power of the second expression
                            */ 
                            $$ = pow($1,$3);
                     }
    | INR ID {
                    /*
                        * Increments the value of the symbol
                    */
                    $$ = symbolVal($2)+1 ;
                    updateSymbol($2,symbolVal($2)+1);
               }
    | DEC ID {
                    /*
                        * Decrements the value of the symbol
                    */
                    $$ = symbolVal($2) -1;
                    updateSymbol($2,symbolVal($2)-1);
               }
    | ID INR {
                    /*
                        * Increments the value of the symbol
                    */
                    $$ = symbolVal($1);
                    updateSymbol($1,symbolVal($1)+1);
               }
    | ID DEC {    
                    /*
                        * Decrements the value of the symbol
                    */
                    $$ =  symbolVal($1);
                    updateSymbol($1,symbolVal($1)-1);
               }
    | '(' expr ')' {    
                        /*
                            * Returns the value of the expression
                        */ 
                        $$ = $2;
                   }
    ;
%%                     /* C code */
double symbolVal(string s){
    /*
        * Returns the value of the symbol s
        * If the symbol is not defined, it prints an error message and exits the program
    */
    auto find = symbolTable.find(s);
    if(find != symbolTable.end()){
        // Symbol is defined
        return find->second;
    }
    else{
        // Symbol is not defined
        fprintf(stderr,"line %i: %s is undefined.\n",line,s.c_str());
        exit(EXIT_FAILURE);
    }
}


void updateSymbol(string s, double val){
    /*
        * Updates the value of the symbol s to val
    */
    if (s.size()>16){
        fprintf(stderr,"line %i: Symbol %s: too long.\n",line,s.c_str());
        exit(EXIT_FAILURE);
    }
    symbolTable[string(s)] = val;
} 

int main(){
    
    return yyparse();

}

