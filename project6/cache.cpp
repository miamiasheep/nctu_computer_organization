#include<iostream>
#include<string.h>
#include<stdio.h>
#include<stdlib.h>
#define max 100
using namespace std;
int charToDigit(char c){
    if(c>='a')return (c-87);
    else return (c-'0');
}
unsigned int stringToHex(char *a){
    int ans=0;
    for(int i=2;a[i]!='\n';i++){
        ans=ans*16;
        ans=ans+charToDigit(a[i]);
    }
    return ans;
}
void print(char *a){
    for(int i=0;a[i]!=0;i++){
        cout<<a[i];
    }
}
void cache(char* file, int cacheSize,int lineSize,int ass,int method){
    FILE *data;
    char string1[max];
    int aa;
    char file2[99];
    int index;
    unsigned int tempVal;
    int miss=0,hit=0,total=0;

    index=cacheSize/(lineSize*ass);// calculate how many indices in the cache
    unsigned int myCache[index][ass];
    int count[index];
    for(int i=0;i<index;i++){count[i]=0;}//count is the counter for the
    //every entry , I will use in the FIFO alg.
    for(int i=0;i<index;i++){
        for(int j=0;j<ass;j++){
            myCache[i][j]=-1;
        }
    }
    ////thie is my cache
        //////////////////////
    int ii;
    for(ii=0;file[ii]!='\n';ii++){
        file2[ii]=file[ii];
    }
    file2[ii]=0;
    ////////////////////////erase"\n"
    data=fopen(file2,"r");//read the file in
    while(fgets(string1,sizeof(string1),data)){
        tempVal=stringToHex(string1);
        int nn;
         nn=((tempVal/lineSize)%index);// find which index should I put in.
         bool check;
         int current;
         check=false;
            for(int i=0;i<ass;i++){
                if((myCache[nn][i]/lineSize)==(tempVal/lineSize)){
                    check=true;
                    current=i;
                }
            }
            //check whether the address of data is in the cache
        if(method==0){//FIFO
            if(check){
                hit++;
                total++;// if hit, let hit +1
            }else{
                miss++;
                total++;
                myCache[nn][count[nn]]=tempVal;
                count[nn]=((count[nn]+1)%ass);
            // if miss choose the block which comes in first
            // and replace it
            }

        }//FIFO
        unsigned int temp;
        if(method==1){//LRU
            if(check){
                if (current!=0){
                temp=myCache[nn][current];
                for(int i=ass-1;i>=current;i--){
                    myCache[nn][i]=myCache[nn][i-1];
                }
                myCache[nn][0]=temp;
                }
                hit++;
                total++;
                // if hit , I let hit +1
                // and I put the block to the first and move the other to right
                // by one position. So , I am sure that the freshest data is in the
                //left end, the oldest data is in the right end
            }else{
                miss++;
                total++;
                for(int i=ass-1;i>0;i--){
                    myCache[nn][i]=myCache[nn][i-1];
                }
                myCache[nn][0]=tempVal;
                // if miss , I move out the oldest block which is in the right end
                // and put current accessed block to the left end, the other shift
                // right by one position.
            }
        }//LRU

    }//while
    //system("pause");
    cout<<"==========================="<<endl;
    cout<<"trace file: "<<file2<<endl;
    //system("pause");
    cout<<"cache size: "<<cacheSize<<endl;
    cout<<"line size: "<<lineSize<<endl;
    cout<<"associativity: "<<ass<<endl;
    cout<<"Replacement: ";
    if(method==0)cout<<"FIFO"<<endl;
    if(method==1)cout<<"LRU"<<endl;
    cout<<"cache hits "<<hit<<endl;
    cout<<"cache misses "<<miss<<endl;
    cout<<"miss rate: "<< 100*((double)miss/(double)total)<<"%"<<endl;
}
int main(){
    ///////////////////input
    char input[99];
    int cacheSize, lineSize,ass, method;
    cout<<"file name: ";
    fgets(input,sizeof(input),stdin);
    cout<<"cache size: ";
    cin>>cacheSize;
    cout<<"line size: ";
    cin>>lineSize;
    cout<<"ass: ";
    cin>>ass;
    cout<<"method: ";
    cin>>method;
    cache(input,cacheSize,lineSize,ass,method);
    return 0;
}
