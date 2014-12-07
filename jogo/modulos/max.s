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

###########################################################
# A partir da posicao dada, verifica se eh valida ou nao. #
# Essa funcao ta grande bagarai!! D:                      #
# $a0 = posicao no eixo x do max                          #
# $a1 = posicao no eixo y do max                          #
# $a2 = flag para avisar que o movimento eh diagonal      #
# $v0 = 0 se a posicao for invalida                       #
# $v0 = 0 se o movimento deve preservar a posicao X ou Y  #
# $v0 = 1 se a posicao for valida                         #
# Quando o movimento eh diagonal e deve preservar a       #
# posicao x ou y, o proprio verificaMoveMax realiza o     #
# movimento.                                              #
###########################################################
verificaMoveMax:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    move $s0, $a0  # Nova posicao X vai para $s0
    move $s1, $a1  # Nova posicao Y vai para $s1
    bne $a2, $zero, verificaMoveMax_diagonal # Se o movimento for diagonal o tratamento eh diferente
    ## Verifica limites da matriz
    li $t0, -1
    beq $s0, $t0, verificaMoveMax_invalid
    beq $s1, $t0, verificaMoveMax_invalid
    li $t0, 16
    beq $s0, $t0, verificaMoveMax_invalid
    li $t0, 14
    beq $s1, $t0, verificaMoveMax_invalid
    ## Verifica o tile de chegada
    lw $a0, MBG_1
    move $a1, $s0
    move $a2, $s1
    jal getTileInfo
    li $t0, 0x23
    beq $v0, $t0, verificaMoveMax_invalid
    j verificaMoveMax_valid
verificaMoveMax_diagonal:
    ## Verifica limites da matriz
    li $t0, -1
    beq $s0, $t0, verificaMoveMax_invalid
    beq $s1, $t0, verificaMoveMax_invalid
    li $t0, 16
    beq $s0, $t0, verificaMoveMax_invalid
    li $t0, 14
    beq $s1, $t0, verificaMoveMax_invalid
    ## Verifica o tile de chegada
    lw $a0, MBG_1
    move $a1, $s0
    move $a2, $s1
    jal getTileInfo
    li $t0, 0x23
    beq $v0, $t0, verificaMoveMax_diagonalInvalido
verificaMoveMax_diagonalValido:
    ## Se o movimento diagonal for valido, precisa verificar as laterais,
    ## eh possivel que o destino seja valido mas o movimento seja invalido
    lw $a0, MBG_1
    lw $a1, maxPositionX
    move $a2, $s1
    jal getTileInfo
    li $t0, 0x23
    bne $v0, $t0, verificaMoveMax_valid # Se essa lateral for valida, o movimento eh valido
    lw $a0, MBG_1
    lw $a2, maxPositionY
    move $a1, $s0
    jal getTileInfo
    li $t0, 0x23
    bne $v0, $t0, verificaMoveMax_valid # Se essa lateral for valida, o movimento eh valido
    # Se chegar aqui o movimento eh invalido
    j verificaMoveMax_invalid
verificaMoveMax_diagonalInvalido:
    ## Se o movimento diagonal for invalido, ainda eh possivel que o movimento para
    ## algum dos lados seja valido. Nesse caso, se movimenta para o lado ao inves de para a diagonal
    lw $a0, MBG_1
    lw $a1, maxPositionX
    move $a2, $s1
    jal getTileInfo
    li $t0, 0x23
    bne $v0, $t0, verificaMoveMax_validForX # Se essa lateral for valida, o movimento preserva o X
    lw $a0, MBG_1
    move $a1, $s0
    lw $a2, maxPositionY
    jal getTileInfo
    li $t0, 0x23
    bne $v0, $t0, verificaMoveMax_validForY # Se essa lateral for valida, o movimento preserva o Y
    # Se nao for valido para nenhum lado, o movimento eh invalido
    j verificaMoveMax_invalid
verificaMoveMax_validForX: # Preserva o X
    jal apagaMax
    sw $s1, maxPositionY # Salva a nova posicao do Y
    jal printMax
    j verificaMoveMax_invalid
verificaMoveMax_validForY: # Preserva o Y
    jal apagaMax
    sw $s0, maxPositionX # Salva a nova posicao do X
    jal printMax
    j verificaMoveMax_invalid
verificaMoveMax_valid:
    li $v0, 1
    j verificaMoveMax_End
verificaMoveMax_invalid:
    li $v0, 0  # Movimento eh invalido
verificaMoveMax_End:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
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
    beq $a0, $zero, moveMax1450
    beq $a1, $zero, moveMax1450
moveMax2000:
    li $a2, 1
    lw $t0, FRAME_COUNTER
    li $t1, 2050
    div $t0, $t1
    mfhi $t0
    bne $t0, $zero, moveMax_End
    j moveMax_checkIfHasMovement
moveMax1450:
    li $a2, 0
    lw $t0, FRAME_COUNTER
    li $t1, 1450
    div $t0, $t1
    mfhi $t0
    bne $t0, $zero, moveMax_End
moveMax_checkIfHasMovement:
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