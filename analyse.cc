#include "analyse.h"


void addParentheses(char*,char*,int);
bool isOperator(char);

bool opOrder(char,char);
int opPriority(char);
int convertOperator(char);
char makeOperator(int);
bool isNumber(char);


void printTree(Noeud*);


Noeud* makeTree(char* expr)
{
 int i=0;
  
 stack<Noeud*> operandStack;
 stack<int> numberStack;
  	
 
 while (expr[i]!='\0')
 {
 	if (isOperator(expr[i]))
	{
		Noeud* current;
		
		if (!numberStack.empty())
		{
			
			int operand=0;
			int power=1;
			while (!numberStack.empty())
			{
			 	operand += numberStack.top()*power;
			 	numberStack.pop();
				power*=10;
			}
		
			current = new Noeud();
			current->type=TYPE_NOMBRE;
			current->valeur = operand;
			current->gauche=NULL;
			current->droite=NULL;		
			operandStack.push(current);
			
		}
		
		current= new Noeud();
	 	current->type = TYPE_OPERATEUR;
		current->valeur = convertOperator(expr[i]);		
		
		
		current->droite=operandStack.top();
		operandStack.pop();		
		current->gauche=operandStack.top();
		
		operandStack.pop();
		operandStack.push(current);
	}
	
	else if(isNumber(expr[i]))
	{
		
		numberStack.push((int)(expr[i]-'0'));	
	}
	
	else if(expr[i]==' ' && !numberStack.empty())
	{
		
		int operand=0;
		int power=1;
		while (!numberStack.empty())
		{
		 	operand += numberStack.top()*power;
		 	numberStack.pop();
			power*=10;
		}
		
		Noeud* current = new Noeud();
		current->type=TYPE_NOMBRE;
		current->valeur = operand;
		current->gauche=NULL;
		current->droite=NULL;		
		operandStack.push(current);
		
		
	}	
	
  	i++;
 }
 
 return operandStack.top();

}

void printTree(Noeud* racine)
{
 
 
 if (racine->type == TYPE_NOMBRE)
 {
  	printf("%d",racine->valeur);
  
 }
 else if (racine->type == TYPE_OPERATEUR)
 {
 	
 
 	if (racine->gauche !=NULL)
	{
 		printf("(");
		printTree(racine->gauche);
	 }
	 
	 printf("%c",makeOperator(racine->valeur));
  
 
	 if (racine->droite !=NULL)
	 {
	 	printTree(racine->droite);
		printf(")");
	 }
 
 }
}

void deleteTree(Noeud* noeud)
{
 if(noeud->gauche != NULL)
 {
  	deleteTree(noeud->gauche);
	noeud->gauche=NULL;
 }
	
 if(noeud->droite != NULL)
 {
  	deleteTree(noeud->droite);
	noeud->droite=NULL;
 }
 
 delete noeud;


}

void shuntingYard(char * expr,char *output, int len)
{
 
 stack<char> opStack;
 int nextOutput=0;
 

 for(int i=0;i<len;i++)
 {
 	if (isOperator(expr[i]))
	{
		output[nextOutput++]=' ';			
	  	while(!opStack.empty() && opOrder(expr[i],opStack.top()) && isOperator(opStack.top()))
		{				 	
			output[nextOutput++]=opStack.top();	
			opStack.pop();		
		}
		
		opStack.push(expr[i]); 
 	}
	else if (expr[i]=='(')
	{
		opStack.push(expr[i]);
	}
	else if (expr[i]==')')
	{
		
		while(!opStack.empty() && isOperator(opStack.top()))
		{
			output[nextOutput++]=opStack.top();
			opStack.pop();
		}
		if(!opStack.empty() )
		{
			
			opStack.pop();			
		}
	}	
	
	else if(expr[i]=='\0')
	{
	 	break;
	}
	else 
	{
		output[nextOutput++]=expr[i];
	}
}


 while (!opStack.empty())
 { 
 	if (isOperator(opStack.top()))
	{
		output[nextOutput++]=opStack.top();
	}
	opStack.pop();
 }
 output[nextOutput]='\0';
 
 //printf("RPN: %s\n",output);
	
}
	
int opPriority(char op)
{
 if(op=='*') return 2;
 if(op=='/') return 2;
 return 1;
}
 
char makeOperator(int v)
{
 if(v==0) return '+';
 if(v==1) return '-';
 if(v==2) return '*';
 if(v==3) return '/';
 
 else return '\0';
}


bool isNumber(char c)
{
 return c>='0' && c<='9';
}

bool opOrder (char op1,char op2)
{
  return opPriority(op1) <= opPriority(op2);
}

bool isOperator(char c)
{
 return (c=='+'||c=='-'||c=='*'||c=='/');
}

int convertOperator(char op)
{
 if(op=='+') return 0;
 if(op=='-') return 1;
 if(op=='*') return 2;
 if(op=='/') return 3;
 
 else return -1;
}
 
 
