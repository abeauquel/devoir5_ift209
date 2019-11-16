.include "/root/SOURCES/ift209/tools/ift209.as"

.global Compile


.section ".text"

/********************************************************************************
*																				*
*	Sous-programme qui compile un arbre syntaxique et produit le code binaire  	*
*	des instructions.															*
*																				*
*	Paramètres:																	*
*		x0: adresse du noeud racine												*
*		x1: adresse du tableau d'octets pour écrire le code compilé				*
*															                    *
*	Auteurs: 																	*
*																				*
********************************************************************************/


Compile:
	SAVE



	RESTORE
	ret
