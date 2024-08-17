%{
    /*
        * This is the lexer file for the calculator
        * It will return the token to the parser

        * The tokens are defined in the calc.tab.h file
        
        * The lexer will return the following tokens
            * ADD +
            * SUB -
            * MUL *
            * DIV /
            * MOD %
            * COS cos()
            * SIN sin()
            * NEG neg()
            * LOG log()
            * ABS abs()
            * POW ^
            * INR ++
            * DEC --
            * NUM floating point or integer number
            * ID identifier(use C style identifiers)
            * '='
            * '('
            * ')'
            * '\n'
        
        * The lexer will also return the line number

        * Look at the calc.y file for the grammar, and how to compile the program
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
    int line = 1;

    #include <cstring>
    #include "calc.tab.h"
%}


%%

"+"             { 
                    /*
                        return the ADD token
                    */
                    return ADD; 
                }
"-"             { 
                    /*
                        return the SUB token
                    */
                    return SUB; 
                }
"*"             { 
                    /*
                        return the MUL token
                    */
                    return MUL; 
                }
"/"             { 
                    /*
                        return the DIV token
                    */
                    return DIV; 
                }
"%"             { 
                    /*
                        return the MOD token
                    */
                    return MOD; 
                }
"cos"           { 
                    /*
                        return the COS token
                    */
                    return COS; 
                }
"sin"           { 
                    /*
                        return the SIN token
                    */
                    return SIN; 
                }
"neg"           { 
                    /*
                        return the NEG token
                    */
                    return NEG; 
                }
"log"           { 
                    /*
                        return the LOG token
                    */
                    return LOG; 
                }
"abs"           { 
                    /*
                        return the ABS token
                    */
                    return ABS; 
                }
"^"             { 
                    /*
                        return the POW token
                    */
                    return POW; 
                }
"++"            {   
                    /*
                        return the INR token
                    */
                    return INR; 
                }
"--"            { 
                    /*
                        return the DEC token
                    */
                    return DEC; 
                }
"="             { 
                    /*
                        return the '=' token
                    */
                    return '=';
                }
"("             {
                    /*
                        return the '(' token
                    */
                    return '(';
                }
")"             { 
                    /*
                        return the ')' token
                    */
                    return ')'; 
                }
[0-9]*"."[0-9]+ { 
                    /*
                        return the floating point number
                    */
                    yylval.num = atof(yytext); 
                    return NUM; 
                }
[1-9][0-9]*|0   { 
                    /*
                        return the integer number
                    */
                    yylval.num = atoi(yytext); 
                    return NUM; 
                }
[A-Za-z_][A-Za-z0-9_]* { 
                            /*
                                return the identifier
                            */
                            yylval.id = strdup(yytext); 
                            return ID; 
                     }
[ ]+                 {;/*ignore spaces*/}
[ \t]+               {;/*ignore tabs*/}
\n                   {
                        /*
                            * Increment the line number
                        */
                        line++;
                        return '\n';
                     }
.                    { 
                        /*
                            * Santax error
                        */  
                        yyterminate();  
                     }



%%

int yywrap() {
    return 1;
}
void yyerror(char *s) {
    fprintf(stderr,"line %d: %s with token \"%s\"\n", line, s, yytext);
}

    