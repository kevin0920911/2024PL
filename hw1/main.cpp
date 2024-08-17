#include <iostream>
#include <stack>
using namespace std;
int main(int argc ,char **argv){
    if (argc!=2){
        cerr<<"Use one Argument\n";
        return 1;
    }
    // get argument
    string express(argv[1]);
    stack<int> st ;
    int tmp = 0;
    bool flag = false;
    for (int i=0;i<express.size();){
        if (!isdigit(express[i]) && express[i]!='+' 
             && express[i] != '-' && express[i] != '*' 
             &&express[i] != '/' && express[i]!=' '
           ){
            cerr<<" Invalid Argument!\n";
            return 1;
        }
        // space
        if (express[i]==' '){
            if (flag)
                st.push(tmp);
            i++;
            flag = false;
            tmp = 0;
            continue;
        }

        
        if (isdigit(express[i])){
            flag = true;
            tmp = tmp*10 + express[i] - '0';
            i++;
            continue;
        }
    
        if (express[i] == '+'){
            if (st.size()<2){
                cerr<<" Invalid Argument!\n";
                return 1;
            }

            int n1 = st.top(); st.pop();
            int n2 = st.top(); st.pop();
            st.push(n2 + n1);
            i++;
            continue;
        }

        if (express[i] == '-'){
            if (st.size()<2){
                cerr<<" Invalid Argument!\n";
                return 1;
            }

            int n1 = st.top(); st.pop();
            int n2 = st.top(); st.pop();
            st.push(n2 - n1);
            i++;
            continue;
        }
        if (express[i] == '*'){
            if (st.size()<2){
                cerr<<" Invalid Argument!\n";
                return 1;
            }

            int n1 = st.top(); st.pop();
            int n2 = st.top(); st.pop();
            st.push(n2 * n1);
            i++;
            continue;
        }
        if (express[i] == '/'){
            if (st.size()<2){
                cerr<<" Invalid Argument!\n";
                return 1;
            }

            int n1 = st.top(); st.pop();
            int n2 = st.top(); st.pop();
            if (n1 == 0){
                cerr<<"Divide by zero\n";
                return 1;
            }
            st.push(n2 / n1);
            i++;
            continue;
        }
    }
    if (st.size()!=1){
        cerr<<"Ivalid Argument!\n";
        return 1;
    }   
    cout<<st.top()<<endl;
    st.pop();
    return 0;
}
