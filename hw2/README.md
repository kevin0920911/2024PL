# Program Language Homework2 - yacc & lex
## 環境建置
1. 本程式是在Ubuntu 18.04建置，為了避免環境不一致導致的錯誤，我有使用docker技術(dockerfile如檔案所示)
2. 執行步驟如下
    ```bash
    $ docker build -t yacc:v1 .
    $ docker run -it yacc:v1 
    ```
3. 若是不想使用docker，請確保以下指令是否可以使用
    - g++
    - bison
    - flex
    1. 若在 window/linux 下執行
        ```bash
        $ bison -d ./calc.y
        $ flex ./calc.l
        $ g++ -o calc -g ./calc.tab.c ./lex.yy.c
        $ ./calc
        ```
## 程式說明
- 此程式使用到yacc/lex技術，以下為它的運作過程
    ![img](https://th.bing.com/th/id/R.af51df362b7184bfdd5a15e1f8ed7c2d?rik=ddTgDq3FzWAS5g&pid=ImgRaw&r=0)
    - 以下程式說明將分成yacc與lex兩個部分

- yacc
    - 變數的儲存
        1. 我使用hash_table的方式使變數與數值綁定起來，並使用函數做到查詢與更新
            ```C++
            unordered_map<string,double> symbolTable;
            double symbolVal(string symbol);
            void updateSymbol(string symbol, double value);
            ```
            - 在symbolVal的部份考量到NOT FOUND的情況，因此當找不到會跳出錯誤訊息，並離開程式中
                ```C++
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
                ```
    - 操作子的例外情形
        - 除法無法/0，因此除零產生，會跳出錯誤訊息，並離開程式中
            ```C++
            expr DIV expr {
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
            ```
        - 取餘數無法%0，因此%0產生，會跳出錯誤訊息，並離開程式中
            ```C++
            expr MOD expr { 
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
            ```
        - log數值範圍在正數，因此當傳入數值<=產生，會跳出錯誤訊息，並離開程式中
            ```C++
            LOG '(' expr ')' { 
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
            ```
    - 文法
        ```yacc
        program: program stmt '\n'  
               | /* empty */        
       
        stmt : ID '=' expr        

        expr: NUM           
            | ID            
            | expr ADD expr 
            | expr SUB expr 
            | expr MUL expr 
            | expr DIV expr 
            | expr MOD expr 
            | COS '(' expr ')' 
            | SIN '(' expr ')'
            | NEG '(' expr ')' 
            | ABS '(' expr ')'
            | LOG '(' expr ')' 
            | expr POW expr 
            | INR ID 
            | DEC ID 
            | ID INR 
            | ID DEC 
            | '(' expr ')' 
        ```

    - lex 
        - token 的定義
            - 變數 ID: `[_A-Za-z][_A-Za-z0-9]*`
            - 數值 NUM: `[1-9][0-9]*|0` 、 `[0-9]*"."[0-9]+`
            - 操作子
                - ADD +
                - SUB -
                - MUL *
                - DIV /
                - MOD %
                - COS cos
                - SIN sin
                - NEG neg
                - LOG log
                - ABS abs
                - POW ^
                - INR ++
                - DEC --
                - '='
                - '('
                - ')'
                - '\n'
    - PS: 三角函數單位是弧度量