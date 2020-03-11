.include "macros.s

.global main

main: 							// main()
	// Lire mots w0 et w1 		// {
	// à déchiffrer 			//
	adr x0, fmtEntree 			//
	adr x1, temp 				//
	bl scanf 					// scanf("%X", &temp)
	ldr w19, temp 				// w0 = temp
								//
	adr x0, fmtEntree 			//
	adr x1, temp 				//
	bl scanf 					// scanf("%X", &temp)
	ldr w20, temp 				// w1 = temp
								//
	// Déchiffrer w0 et w1 		//
	mov w0, w19 				//
	mov w1, w20 				//
	ldr w2, k0 					//
	ldr w3, k1 					//
	ldr w4, k2 					//
	ldr w5, k3 					//
	bl dechiffrer 				// w0, w1 = dechiffrer(w0, w1, w2, w3, w4, w5)
								//
	// Afficher message secret 	//
	mov w19, w0 				//
	mov w20, w1 				//
								//
	adr x0, fmtSortie 			//
	mov w1, w19 				//
	mov w2, w20 				//
	bl printf 					// printf("%c %c\n", w0, w1)
								//
	// Quitter programme 		//
	mov x0, 0 					//
	bl exit 					// return 0
								// }
/*******************************************************************************
Procédure de déchiffrement de l'algorithme TEA
Entrées: - mots w0 et w1 à déchiffrer (32 bits chacun)
- clés w2, w3, w4 et w5 (32 bits chacune)
Sortie: mots w0 et w1 déchiffrés
*******************************************************************************/
dechiffrer:
	// w19 et w20 contiennent mots decryptees
	SAVE						//
	mov w21, 0					// i = 0
	cmp w21, 32					// if(i==32)
	b.ne dechiffrerSingle		// dechiffrer(w0, w1, w2, w3, w4, w5)
	RESTORE						//
	ret							//

dechiffreSingle:
	lsl w22, w0, 4				// w22 = w0 4 bits gauche TODO
	add w22, w22, w0			// w22 = w22 + w4

	add w23, w21, 33			// w23 = i + 33
	mul w23, w23, delta			// w23 = w23*delta

	add w24, w23, w0			// w24 = w23+w0

	lsr w25, w0, 5				// w25 = w0 5 bits a droit


	add w21, w21, 1				// i+=1
	b dechiffrer				// branch dechiffrer

.section ".rodata"

k0: 		.word 		0xABCDEF01
k1: 		.word 		0x11111111
k2: 		.word 		0x12345678
k3: 		.word 		0x90000000

delta: 		.word 		0x9E3779B9

fmtEntree: 	.asciz 		"%X"
fmtSortie: 	.asciz 		"%c %c\n"

.section ".data"
			.align 4
temp: 		.skip 4
