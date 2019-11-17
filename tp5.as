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
	bl 		printf		// C'EST UN NOMBRE
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

	cmp	x21,1
	b.eq	Compile12
	cmp	x21,2
	b.eq	Compile13
	b.gt	Compile14

Compile11: 		//0 = ADD
	adr 	x0,fmtADD
	bl 		printf
	bl 		Compile15

Compile12:		// 1 = SUB
	adr 	x0,fmtSUB
	bl 		printf
	bl 		Compile15

Compile13:		// 2 = MUL
	adr 	x0,fmtMUL
	bl 		printf
	bl 		Compile15

Compile14:		// 3 = DIV
	adr 	x0,fmtDIV
	bl 		printf
	bl 		Compile15

Compile15:

CompileFin:
	mov x0, 0
	mov x1, 0
	RESTORE
	ret

.section ".rodata"
fmtPush:		.asciz	"push : %d \n"
fmtAddress:		.asciz	"Add : %x \n"
fmtOp:			.asciz	"Op :"
fmtADD:			.asciz	"ADD \n"
fmtSUB:			.asciz	"SUB \n"
fmtMUL:			.asciz	"MUL \n"
fmtDIV:			.asciz	"DIV \n"

.section ".bss"
temp:			.skip 4
