#ifndef ANALYSE_H
#define ANALYSE_H

#include <stdio.h>
#include <string.h>
#include <stack>

#define TYPE_NOMBRE 0
#define TYPE_OPERATEUR 1
#define TYPE_VARIABLE 2



using namespace std;

/*
Noeud de l'arbre syntaxique.
Chaque represente soit une operation, soit un operande.
Le champ "type" sert a les distinguer. Les noeuds de type
operateur ont toujours des enfants, une branche de gauche
et une branche de droite, chaque operande.  Un operande seul (nombre) n'a jamais d'enfants, 
les pointeurs gauche et droite sont donc toujours a NULL dans ce cas.

Le champ "valeur" est un numero d'operation (0 = +, 1 = -, 2 = *, 3 = /) pour les noeuds
de type operation, ou la valeur du nombre pour les champs de type operande.

*/

struct Noeud
{
 int type;
 int valeur;
 Noeud* gauche;
 Noeud* droite; 
};



/* 
Fonction qui convertit une chaine de caracteres qui contient une expression en notation infixee
en une expression en notation polonaise inverse, qui est plus facile a convertir a son tour en
un arbre syntaxique.

Entrees: 1-chaine de caractere originale (infixee)
         2-chaine de caractere resultante (polonaise inverse)
	 3-longueur des chaines (la chaine resultante doit pouvoir accommoder 2x plus de caracteres)
*/	 

void shuntingYard(char *,char*, int);


/*
Fabrique l'abre syntaxique a partir de d'une expression en notation polonaise inverse
Retourne un pointeur sur le noeud racine.
*/

Noeud* makeTree(char *);


/*
Detruit recursivement une structure d'arbre. Appelez cette fonction a la fin de votre code, pour eviter
de polluer la memoire.
*/

void deleteTree(Noeud*);

#endif
