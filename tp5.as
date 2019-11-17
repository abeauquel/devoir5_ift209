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
*			Alexandre Beauquel
*			Joel Lemaire																	*
																*
********************************************************************************/


Compile:
	SAVE

	mov 	x19,x0
	mov 	x20,x1

	ldr		w20, [x19]	//type du noeud
	add		x19, x19, 4
	ldr 	w21, [x19]	// valeur du noeud

	cmp 	x20, 0
	b.ne	Compile10	// si ce n'est pas un nombre
	adr 	x0,fmtPush
	mov 	x1,x21
	bl 		printf
	bl 		CompileFin

Compile10:

	add		x19, x19, 4
	ldr		x0, [x19]	// address du noeud de gauche
	mov		x1, x20
	bl		Compile

	add		x19, x19, 8
	ldr		x0, [x19]		// +8 pour etre au noeud de droite
	mov		x1, x20
	bl		Compile


CompileFin:
	mov x0, 0
	mov x1, 0
	RESTORE
	ret

.section ".rodata"
fmtPush:		.asciz	"push : %d \n"
fmtAddress:		.asciz	"Add : %x \n"
fmtOp:		.asciz	"Op :"

.section ".bss"
temp:			.skip 4
