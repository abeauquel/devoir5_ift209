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

	mov 	x19,x0	//adresse du noeud racine
	mov 	x27,x1	// adresse du tableau d'octets pour écrire le code compilé

	// On annule l'instruction HALT et WRITE pour le cote recursif
	adr		x21, nbOctet
	ldr		x20, [x21]
	cmp		x20, xzr

	b.eq	Compile3	// si nboctet > 0 on a rien à annuler

	// On retire 1 au compteur d'octet
	mov		x0, 2
	bl		DiminuerDeUnOctet

Compile3:

	ldr		w20, [x19]	//type du noeud
	add		x19, x19, 4
	ldr 	w21, [x19]	// valeur du noeud

	cmp 	x20, 0
	b.ne	Compile10	// si ce n'est pas un nombre
	adr 	x0,fmtPush
	mov 	x1,x21
	bl 		printf		// C'EST UN NOMBRE

	mov		x0, 3		// Pour un push il y a 3 octets
	bl 		AjouterOctet

	adr		x1,	instructionPUSH
	ldrb	w0, [x1]

	strb	w0,	[x27]

	mov		x0, 0
	strb	w0,	[x27, 1]

	strb 	w21,[x27, 2]

	add		x27, x27, 3	//Incremente l'addresse du tableau binaire
	bl 		CompileFin

Compile10:

	mov		x0, 1		// Simule l'ajout d'un octet pour déclencher l'annulation l'instruction HALT
	bl 		AjouterOctet

	add		x19, x19, 4
	ldr		x0, [x19]	// address du noeud de gauche
	mov		x1, x27		// addresse du tableau binaire
	bl		Compile

	add		x19, x19, 8
	ldr		x0, [x19]		// +8 pour etre au noeud de droite
	add		x1, x27, 3	// addresse du tableau binaire + 3 octets du push precedent
	bl		Compile

	mov		x0, 1
	bl 		DiminuerDeUnOctet

	cmp	x21,1
	b.eq	Compile12
	cmp	x21,2
	b.eq	Compile13
	b.gt	Compile14

Compile11: 		//0 = ADD
	adr 	x0,fmtADD
	bl 		printf

	mov		x0, 1		// Pour un ADD, il y a 1 octet
	bl		AjouterOctet

	adr		x1,	instructionADD
	ldrb	w0, [x1]
	add		x27, x27, 6	// addresse du tableau binaire + 6 octets des push precedent
	strb	w0,	[x27]
	add		x27, x27, 1
	bl 		CompileFin

Compile12:		// 1 = SUB
	adr 	x0,fmtSUB
	bl 		printf
	bl 		CompileFin

Compile13:		// 2 = MUL
	adr 	x0,fmtMUL
	bl 		printf
	bl 		CompileFin

Compile14:		// 3 = DIV
	//todo faire pop et push pour avoir le bon ordre dans la division
	adr 	x0,fmtDIV
	bl 		printf
	bl 		CompileFin


CompileFin:

	adr		x1,	instructionWRITE
	ldrb	w0, [x1]
	strb	w0,	[x27]	// addresse du tableau binaire
	adr		x1,	instructionHALT
	ldrb	w0, [x1]
	strb	w0,	[x27, 1]	// addresse du tableau binaire + 1
	mov 	x0, 2		// On ajoute 2 octets
	bl		AjouterOctet

	adr		x19, nbOctet
	ldr		x0, [x19]

	RESTORE
	ret

//x0 : nombre d'octet à ajouter
AjouterOctet:
	SAVE
	adr		x19, nbOctet
	ldr		x20, [x19]
	add		x20, x20, x0
	str 	x20, [x19]
	RESTORE
	ret

//x0 : nombre d'octet à diminuer
DiminuerDeUnOctet:
	SAVE
	adr		x19, nbOctet
	ldr		x20, [x19]
	sub		x20, x20, x0
	str 	x20, [x19]
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
instructionHALT:	.byte 0
instructionWRITE:	.byte 33
instructionPUSH:	.byte 64
instructionPOP:		.byte 68
instructionADD:		.byte 72
instructionSUB:		.byte 76
instructionMUL:		.byte 80
instructionDIV:		.byte 84

.section ".bss"
temp:			.skip 4
nbOctet:		.skip 4
addressDebutTableau: .xword 0
