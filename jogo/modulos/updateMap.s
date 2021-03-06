.data
BG_ATUAL: .word 0x00000000
.text

updateMap:

	lw $a1, maxPositionX
	lw $a2, maxPositionY
	lw $a0, MATUAL

	addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal getTileInfo
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    li $t0, 0x3d
    beq $v0, $t0, mudaMapa
    jr $ra
	

	mudaMapa:
		lw $a1, maxPositionX
		lw $a2, maxPositionY

		lw $t0, BG_ATUAL

		lw $t1, BG_0
		beq $t0, $t1, mapa0
		lw $t1, BG_1
		beq $t0, $t1, mapa1
		lw $t1, BG_2
		beq $t0, $t1, mapa2
		lw $t1, BG_3
		beq $t0, $t1, mapa3
		lw $t1, BG_4
		beq $t0, $t1, mapa4
		lw $t1, BG_5
		beq $t0, $t1, mapa5
		lw $t1, BG_6
		beq $t0, $t1, mapa6
		lw $t1, BG_7
		beq $t0, $t1, mapa7
		lw $t1, BG_8
		beq $t0, $t1, mapa8
		lw $t1, BG_9
		beq $t0, $t1, mapa9
		lw $t1, BG_10
		beq $t0, $t1, mapa10
		lw $t1, BG_11
		beq $t0, $t1, mapa11
		lw $t1, BG_12
		beq $t0, $t1, mapa12
		lw $t1, BG_13
		beq $t0, $t1, mapa13
		lw $t1, BG_14
		beq $t0, $t1, mapa14	




jr $ra
#######################
##$a0->MBG_X
##$a2->BG_X
#######################
atualizaMapaInfo:
	lw $a1, MATUAL
    addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a2, 4($sp)
	jal copiaMatriz
	lw $ra, 0($sp)
	lw $a2, 4($sp)
	addi $sp, $sp, 8
	sw $a2, BG_ATUAL
	j imprimeRestante

vaipra0:
    lw $a0, MBG_0
    lw $a2, BG_0
    j atualizaMapaInfo
vaipra1:
    lw $a0, MBG_1
    lw $a2, BG_1
    j atualizaMapaInfo
vaipra2:
    lw $a0, MBG_2
    lw $a2, BG_2
    j atualizaMapaInfo
vaipra3:
    lw $a0, MBG_3
    lw $a2, BG_3
    j atualizaMapaInfo
vaipra4:
    lw $a0, MBG_4
    lw $a2, BG_4
    j atualizaMapaInfo
vaipra5:
    lw $a0, MBG_5
    lw $a2, BG_5
    j atualizaMapaInfo
vaipra6:
    lw $a0, MBG_6
    lw $a2, BG_6
    j atualizaMapaInfo
vaipra7:
    lw $a0, MBG_7
    lw $a2, BG_7
    j atualizaMapaInfo
vaipra8:
    lw $a0, MBG_8
    lw $a2, BG_8
    j atualizaMapaInfo
vaipra9:
    lw $a0, MBG_9
    lw $a2, BG_9
    j atualizaMapaInfo
vaipra10:
    lw $a0, MBG_10
    lw $a2, BG_10
    j atualizaMapaInfo
vaipra11:
    lw $a0, MBG_11
    lw $a2, BG_11
    j atualizaMapaInfo
vaipra12:
    lw $a0, MBG_12
    lw $a2, BG_12
    j atualizaMapaInfo
vaipra13:
    lw $a0, MBG_13
    lw $a2, BG_13
    j atualizaMapaInfo
vaipra14:
	#CODIGO PARA TROCAR A MUSICA
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	lw $a0,BEGIN_MUS_1
    jal trocaMus
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	#CODIGO PARA TROCAR A MUSICA

    lw $a0, MBG_14
    lw $a2, BG_14
    j atualizaMapaInfo
vaipra15:

	#CODIGO PARA TROCAR A MUSICA
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	lw $a0,BEGIN_MUS_2
    jal trocaMus
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	#CODIGO PARA TROCAR A MUSICA
	
    lw $a0, MBG_15
    lw $a2, BG_15
    j atualizaMapaInfo


mapa0:
	j vaipra1
mapa1:
	lw $t0, maxPositionY
	beq $t0, $zero, vaipra2
	j vaipra0
mapa2:
	lw $t0, maxPositionY
	beq $t0, $zero, vaipra3
	j vaipra1
mapa3:
	lw $t0, maxPositionY
	beq $t0, $zero, vaipra5
	lw $t0, maxPositionX
	beq $t0, $zero, vaipra4
	j vaipra2
mapa4:
	lw $t0, maxPositionY
	beq $t0, $zero, vaipra6
	j vaipra3
mapa5:
	j vaipra3
mapa6:
	lw $t0, maxPositionY
	beq $t0, $zero, vaipra7
	j vaipra4
mapa7:
	li $t0, 13
	lw $t1, maxPositionY
	beq $t0, $t1, vaipra6
	j vaipra8
mapa8:
	lw $t0, maxPositionY
	beq $t0, $zero, vaipra9
	j vaipra7
mapa9:
	li $t0, 13
	lw $t1, maxPositionY
	beq $t0, $t1, vaipra8
	j vaipra10
mapa10:
	lw $t0, maxPositionY
	beq $t0, $zero, vaipra12
	lw $t0, maxPositionX
	beq $t0, $zero, vaipra9
	j vaipra11
mapa11:
	j vaipra10
mapa12:
	li $t0, 13
	lw $t1, maxPositionY
	beq $t0, $t1, vaipra10
	j vaipra13
mapa13:
	lw $t0, maxPositionY
	beq $t0, $zero, vaipra14
	j vaipra12
mapa14:
	lw $t0, maxPositionY
	beq $t0, $zero, vaipra15
	j vaipra13
	
imprimeRestante:
li $a0, 0
li $a1, 0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal printImg
lw $ra, 0($sp)
addi $sp, $sp, 4

addi $sp, $sp, -4
sw, $ra, 0($sp)
jal printaObjetosInicio
lw $ra, 0($sp)
addi $sp, $sp, 4

addi $sp, $sp, -4
sw, $ra, 0($sp)
jal iniciaMaxPosicao
lw $ra, 0($sp)
addi $sp, $sp, 4


addi $sp, $sp, -4
sw $ra, 0($sp)
jal printMax
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra


###########################
# copia a matriz base     #
# para a matriz destino   #
# exclusivamente para mbg #
# $a0 -> endereco origem  #
# $a1 -> endereco destino #
###########################

copiaMatriz:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)


	move $s0, $a0
	move $s1, $a1
	li $t0, 56

	loopCopiaMatriz:
	    beq $t0, $zero, fimCopiaMatriz
	    lw $t1, 0($s0)
	    sw $t1, 0($s1)
	    addi $s0, $s0, 4
	    addi $s1, $s1, 4
	    addi $t0, $t0, -1

	    j loopCopiaMatriz

fimCopiaMatriz:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	jr $ra



#coloca o max no local certo no proximo mapa
iniciaMaxPosicao:
	lw $t0, maxPositionX
	lw $t1, maxPositionY


	beq $t1, $zero, porCima
	beq $t0, $zero, porEsquerda
	li $t3, 15
	beq $t3, $t0, porDireita
	li $t3, 13
	beq $t3, $t1, porBaixo

	porCima:
		li $t2, 12
		sw $t2, maxPositionY
		jr $ra

	porEsquerda:
		li $t2, 14
		sw $t2, maxPositionX
		jr $ra

	porDireita:
		li $t2, 1
		sw $t2, maxPositionX
		jr $ra

	porBaixo:
		li $t2, 1
		sw $t2, maxPositionY
		jr $ra

#Printa todos os objetos a partir do MAPA ATUAL
#FAVOR EXECUTAR ISSO AQUI ANTES DO LOOP DO JOGO, DEPOIS DE TER POPULADO A MATRIZ ATUAL
printaObjetosInicio:
		
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)

	li $s0, 14
	li $s1, 16

	move $t0, $zero
	objetosMATUALi:

		move $t1, $zero
		beq $t0, $s0, objetosFim
		
		objetosMATUALj:
			beq $t1, $s1, fimMATUALj

			addi $sp, $sp, -16
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			sw $t0, 8($sp)
			sw $t1, 12($sp)

			add $a1, $zero, $t1
			add $a2, $zero, $t0
			lw $a0, MATUAL
			jal getTileInfo 

			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $t0, 8($sp)
			lw $t1, 12($sp)
			addi $sp, $sp, 16

			li $t2, 0x23 # parede
			beq $v0, $t2, proxMATUALj
			li $t2, 0x3D # limite
			beq $v0, $t2, proxMATUALj
			li $t2, 0x2A # caminho pisável
			beq $v0, $t2, proxMATUALj
			li $t2, 0x7C # porta
			beq $v0, $t2, proxMATUALj
			li $t2, 0x61 # botão pra caixa
			beq $v0, $t2, proxMATUALj
			li $t2, 0x62 # botão pra caixa com gancho
			beq $v0, $t2, proxMATUALj


			#inimigos
			li $t2, 0x41
			beq $v0, $t2, proxMATUALj
			li $t2, 0x42
			beq $v0, $t2, proxMATUALj
			li $t2, 0x43
			beq $v0, $t2, proxMATUALj
			li $t2, 0x44
			beq $v0, $t2, proxMATUALj
			li $t2, 0x45
			beq $v0, $t2, proxMATUALj
			li $t2, 0x46
			beq $v0, $t2, proxMATUALj
			li $t2, 0x47
			beq $v0, $t2, proxMATUALj
			li $t2, 0x48
			beq $v0, $t2, proxMATUALj
			li $t2, 0x49
			beq $v0, $t2, proxMATUALj
			li $t2, 0x4A
			beq $v0, $t2, proxMATUALj
			li $t2, 0x4B
			beq $v0, $t2, proxMATUALj
			li $t2, 0x4C
			beq $v0, $t2, proxMATUALj
			li $t2, 0x4D
			beq $v0, $t2, proxMATUALj
			li $t2, 0x4E
			beq $v0, $t2, proxMATUALj
			li $t2, 0x4F
			beq $v0, $t2, proxMATUALj
			li $t2, 0x2e
			beq $v0, $t2, proxMATUALj

			#TRAP: j TRAP

			beq $v0, $zero, proxMATUALj


			addi $sp, $sp, -16
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			sw $t0, 8($sp)
			sw $t1, 12($sp)

			move $a0, $v0
			jal getObjAddr

			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $t0, 8($sp)
			lw $t1, 12($sp)
			addi $sp, $sp, 16

			addi $sp, $sp, -16
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			sw $t0, 8($sp)
			sw $t1, 12($sp)

			move $a0, $v0
			add $a1, $zero, $t1
			sll $a1, $a1, 16
			add $a1, $a1, $t0
			jal printInTile

			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $t0, 8($sp)
			lw $t1, 12($sp)
			addi $sp, $sp, 16

			proxMATUALj:		
				addi $t1, $t1, 1
				j objetosMATUALj
		fimMATUALj:
			addi $t0, $t0, 1
			j objetosMATUALi

	objetosFim:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		addi $sp, $sp, 8


	lw $ra, 0($sp)
	addi $sp, $sp, 4
jr $ra
