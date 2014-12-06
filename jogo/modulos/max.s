.data
maxPositionX: .word 0x00000000
maxPositionY: .word 0x00000000

.text

############
# Funcao principal do update do max, deve rodar a cada frame do jogo.
############
updateMax:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    jal max_GetMovementInput
    move $a0, $v0
    move $a1, $v1
    jal moveMax
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

############
# Retorna em $v0 o movimento horizontal e em $v1 o movimento vertical
# O movimento eh dado por (-1, 0, 1)
############
max_GetMovementInput:
    addi $sp, $sp, -12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $ra, 8($sp)
    li $s0, 0   # Movimento horizontal
    li $s1, 0   # Movimento vertical
max_GetMovementInput_CheckUp:
    jal isButtonDown_Up
    beq $v0, $zero, max_GetMovementInput_CheckDown
    addi $s1, $s1, -1 # Movimento vertical -= 1
max_GetMovementInput_CheckDown:
    jal isButtonDown_Down
    beq $v0, $zero, max_GetMovementInput_CheckLeft
    addi $s1, $s1, 1 # Movimento vertical += 1
max_GetMovementInput_CheckLeft:
    jal isButtonDown_Left
    beq $v0, $zero, max_GetMovementInput_CheckRight
    addi $s0, $s0, -1 # Movimento horizontal -= 1
max_GetMovementInput_CheckRight:
    jal isButtonDown_Right
    beq $v0, $zero, max_GetMovementInput_End
    addi $s0, $s0, 1 # Movimento horizontal += 1
max_GetMovementInput_End:
    move $v0, $s0
    move $v1, $s1
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12
    jr $ra

############
# Apaga o max, a partir do maxPosition
############
apagaMax:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    lw $s0, BG_1

    lw $t0, maxPositionX
    sll $t0, $t0, 16
    lw $t1, maxPositionY
    or $s1, $t0, $t1

    move $a0, $s0
    move $a1, $s1
    jal printTile
    
    move $a0, $s0
    addi $a1, $s1, -1
    jal printTile

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

############
# A partir da posicao dada, verifica se eh valida ou nao.
# $a0 = posicao no eixo x do max
# $a1 = posicao no eixo y do max
# $v0 = 0 se a posicao for invalida
# $v0 = 1 se a posicao for valida
############
verificaMoveMax:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    move $s0, $a0
    move $s1, $a1
    li $t0, -1
    beq $s0, $t0, verificaMoveMax_invalid
    beq $s1, $t0, verificaMoveMax_invalid
    li $t0, 16
    beq $s0, $t0, verificaMoveMax_invalid
    li $t0, 14
    beq $s1, $t0, verificaMoveMax_invalid
    #lw $a0, MBG_1
    #move $a1, $s0
    #move $a2, $s1
    #jal getTileInfo
    #li $t0, 0x23
    #beq $v0, $t0, verificaMoveMax_invalid
    li $v0, 1
    j verificaMoveMax_End
verificaMoveMax_invalid:
    li $v0, 0
verificaMoveMax_End:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

############
# A partir do maxPosition e da direcao do movimento, atualiza a posicao
# do max (verifica se pode atualizar a posicao antes de efetivamente mover).
# $a0 = movimento horizontal (-1, 0, 1)
# $a1 = movimento vertical (-1, 0, 1)
############
moveMax:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    bne $a0, $zero, moveMax_move
    bne $a1, $zero, moveMax_move
    j moveMax_End
moveMax_move:
    lw $t6, maxPositionX
    lw $t7, maxPositionY
    add $s0, $t6, $a0
    add $s1, $t7, $a1
    move $a0, $s0
    move $a1, $s1
    jal verificaMoveMax
    beq $v0, $zero, moveMax_End
    jal apagaMax
    sw $s0, maxPositionX
    sw $s1, maxPositionY
    jal printMax
moveMax_End:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

############
# A partir do maxPosition, printa o max.
# Observacao: a posicao do max se refere aos seus pes. Ao printar, essa funcao
# printa o max um tile acima
############
printMax:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    la $a0, MAX_FRONT
    lw $a0, 0($a0)
    lw $t0, maxPositionX
    sll $t0, $t0, 16
    lw $t1, maxPositionY
    addi $t1, $t1, -1
    or $a1, $t0, $t1
    jal printInTile
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra