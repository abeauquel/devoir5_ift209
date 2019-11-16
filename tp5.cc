#include <stdio.h>
#include <string>
#include "analyse.h"

using namespace std;

extern "C"{

int Compile (Noeud*,char*);

}


int main(){


char input[1000];
char polo[2000];
char res[2000];
Noeud * root;

scanf("%s",input);

int size = strlen(input);

shuntingYard(input,polo,size);

root = makeTree(polo);

size = Compile(root,res);

printf("%d\n",size);
for(int i=0;i<size;i++){

    printf("%x\n",(unsigned char)res[i]);

}

deleteTree(root);

return 0;
}



