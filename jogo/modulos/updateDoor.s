
.data
	doorFlag: .word 0x00
.text



updateDoor:
    lw $t0, BG_2
    lw $t1, BG_ATUAL
    bne $t0, $t1, updateDoorEnd # Se o mapa atual nao for o mapa 2, nao tem update
    lw $t0, doorFlag
    bne $t0, $zero, updateDoorEnd
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    #$v0 -> conteudo da posicao da matriz
	#$a0 -> começo da matriz
	#$a1 -> x
	#$a2 -> y
	lw $a0, MATUAL
	li $a1, 3
	li $a2, 4
	jal getTileInfo
	li $t0, 0x63
	bne $t0, $v0, updateDoorLoad
	lw $a0, MATUAL
	li $a1, 6
	li $a2, 4
	jal getTileInfo
	li $t0, 0x63
	bne $t0, $v0, updateDoorLoad
	lw $a0, MATUAL
	li $a1, 9
	li $a2, 4
	jal getTileInfo
	li $t0, 0x63
	bne $t0, $v0, updateDoorLoad
	lw $a0, MATUAL
	li $a1, 12
	li $a2, 4
	jal getTileInfo
	li $t0, 0x63
	bne $t0, $v0, updateDoorLoad




    lw $a0, MBG_22
    lw $a1, MATUAL
    jal copiaMatriz


    lw $a0, MBG_22
    lw $a1, MBG_2
    jal copiaMatriz


    li $t0, 1
    sw $t0, doorFlag

updateDoorLoad:
lw $ra, 0($sp)
addi $sp, $sp, 4
updateDoorEnd:
	jr $ra