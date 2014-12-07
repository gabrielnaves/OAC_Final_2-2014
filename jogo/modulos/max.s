.data
maxPositionX: .word 0x00000000
maxPositionY: .word 0x00000000
#################################################################
# maxSide contem a informacao de pra que lado o max esta virado #
# Frente = 0                                                    #
# Tras = 1                                                      #
# Direita = 2                                                   #
# Esquerda = 3                                                  #
# Esse dado vai ser controlado pelo updateMax, junto com o      #
# max_ChangeSprite.                                             #
#################################################################
maxSide: .word 0x00000000
## maxCurrentImage contem o endereco da imagem atual.
## Esse endereco sera atualizado pelo max_ChangeSprite.
maxCurrentImage: .word 0x00000000
#################################################################
# Contem a informacao do estado atual do max.
# Os estados sao:
# 0 => estado normal
# 1 => maos levantadas sem segurar nada
# 2 => maos levantadas segurando algo
#################################################################
maxCurrentState: .word 0x00000000
#####
# Serve para dizer quando ha mudanca de estado do max, pois deve apagar o max antigo e printar o max novamente
#####
maxCurrentStateControl: .word 0x00000000
.text

############
# Funcao principal do update do max, deve rodar a cada frame do jogo.
############
updateMax:
    addi $sp, $sp, -12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $ra, 8($sp)
    jal max_GetMovementInput
    move $s0, $v0
    move $s1, $v1
    jal max_GetInteractionInput
    lw $t0, maxCurrentState
    beq $t0, $zero, updateMax_SetNormalSprite
    la $t0, MAX_2_FRONT
    lw $a2, 0($t0) # max front
    lw $a3, 4($t0) # max back
    lw $t1, 8($t0)
    lw $t2, 12($t0)
    addi $sp, $sp, -8
    sw $t1, 0($sp) # max right
    sw $t2, 4($sp) # max left
    j updateMax_changeSprite
updateMax_SetNormalSprite:
    la $t0, MAX_FRONT
    lw $a2, 0($t0) # max front
    lw $a3, 4($t0) # max back
    lw $t1, 8($t0)
    lw $t2, 12($t0)
    addi $sp, $sp, -8
    sw $t1, 0($sp) # max right
    sw $t2, 4($sp) # max left
updateMax_changeSprite:
    move $a0, $s0
    move $a1, $s1
    jal max_ChangeSprite
    addi $sp, $sp, 8
    move $a0, $s0
    move $a1, $s1
    jal moveMax
    
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12
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

    lw $s0, BG_ATUAL

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
    lw $a0, MATUAL
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
    lw $a0, MATUAL
    move $a1, $s0
    move $a2, $s1
    jal getTileInfo
    li $t0, 0x23
    beq $v0, $t0, verificaMoveMax_diagonalInvalido
verificaMoveMax_diagonalValido:
    ## Se o movimento diagonal for valido, precisa verificar as laterais,
    ## eh possivel que o destino seja valido mas o movimento seja invalido
    lw $a0, MATUAL
    lw $a1, maxPositionX
    move $a2, $s1
    jal getTileInfo
    li $t0, 0x23
    bne $v0, $t0, verificaMoveMax_valid # Se essa lateral for valida, o movimento eh valido
    lw $a0, MATUAL
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
    lw $a0, MATUAL
    lw $a1, maxPositionX
    move $a2, $s1
    jal getTileInfo
    li $t0, 0x23
    bne $v0, $t0, verificaMoveMax_validForX # Se essa lateral for valida, o movimento preserva o X
    lw $a0, MATUAL
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

##############################################################################
# A partir do maxPosition e da direcao do movimento, atualiza a posicao      #
# do max (verifica se pode atualizar a posicao antes de efetivamente mover). #
# $a0 = movimento horizontal (-1, 0, 1)                                      #
# $a1 = movimento vertical (-1, 0, 1)                                        #
##############################################################################
moveMax:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    beq $a0, $zero, moveMax_delayOrtogonal
    beq $a1, $zero, moveMax_delayOrtogonal
moveMax_delayDiagonal:
    li $a2, 1
    lw $t0, FRAME_COUNTER
    li $t1, 424
    div $t0, $t1
    mfhi $t0
    bne $t0, $zero, moveMax_End
    j moveMax_checkIfHasMovement
moveMax_delayOrtogonal:
    li $a2, 0
    lw $t0, FRAME_COUNTER
    li $t1, 300
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

################################################################################
# A partir do maxPosition, printa o max.                                       #
# Observacao: a posicao do max se refere aos seus pes. Ao printar, essa funcao #
# printa o max um tile acima                                                   #
################################################################################
printMax:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    lw $a0, maxCurrentImage
    lw $t0, maxPositionX
    sll $t0, $t0, 16
    lw $t1, maxPositionY
    addi $t1, $t1, -1
    # Verifica se o max esta um tile fora da tela
    li $t4, -1
    beq $t1, $t4, printMaxHardCoded
    or $a1, $t0, $t1
    jal printInTile
    j printMax_end
printMaxHardCoded:
    move $a2, $a0
    li $t5, 20
    lw $t0, maxPositionX
    mult $t0, $t5
    mflo $a0
    li $a1, -17
    jal printImg
printMax_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

################################################################################################
# A partir do lado antigo do max e do movimento (horizontal e vertical),                       #
# define se deve alterar o sprite. Os sprites vem em $a2 e $a3, e de duas posicoes da pilha.   #
# $a0 = movimento horizontal                                                                   #
# $a1 = movimento vertical                                                                     #
# $a2 = sprite front                                                                           #
# $a3 = sprite back                                                                            #
# Topo da pilha = sprite right                                                                 #
# Topo da pilha menos um = sprite left                                                         #
# Convencao do maxSide:                                                                        #
# Frente = 0                                                                                   #
# Tras = 1                                                                                     #
# Direita = 2                                                                                  #
# Esquerda = 3                                                                                 #
################################################################################################
max_ChangeSprite:
    addi $sp, $sp, -28
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $s0, 12($sp)
    sw $s1, 16($sp)
    sw $s2, 20($sp)
    sw $s3, 24($sp)
    ## move os argumentos pros registradores salvos
    move $s0, $a2 # front
    move $s1, $a3 # back
    lw $s2, 28($sp) # right
    lw $s3, 32($sp) # left
    ## Verifica se o movimento eh diagonal. Se for, nao altera o lado
    beq $a0, $zero, max_ChangeSprite_CheckVertical
    beq $a1, $zero, max_ChangeSprite_CheckHorizontal
    j max_ChangeSprite_checkStateControl
max_ChangeSprite_CheckVertical:
    beq $a1, $zero, max_ChangeSprite_checkStateControl # Se $a1 for zero nao tem movimento
    # Aqui tem movimento vertical apenas
    li $t0, -1
    beq $t0, $a1, max_ChangeSprite_CheckVertical_negative
    # Aqui o movimento eh pra baixo
    lw $t0, maxSide
    beq $t0, $zero, max_ChangeSprite_checkStateControl # Se o lado anterior for igual ao atual, nao precisa fazer nada
    sw $zero, maxSide
    sw $s0, maxCurrentImage
    j max_ChangeSprite_reprintMax
max_ChangeSprite_CheckVertical_negative:
    # Aqui o movimento eh pra cima
    li $t0, 1
    lw $t1, maxSide
    beq $t0, $t1, max_ChangeSprite_checkStateControl # Se o lado anterior for igual ao atual, nao precisa fazer nada
    sw $t0, maxSide
    sw $s1, maxCurrentImage
    j max_ChangeSprite_reprintMax
max_ChangeSprite_CheckHorizontal:
    beq $a0, $zero, max_ChangeSprite_checkStateControl # Se $a0 for zero nao tem movimento
    # Aqui tem movimento horizontal apenas
    li $t0, -1
    beq $t0, $a0, max_ChangeSprite_CheckHorizontal_negative
    # Aqui o movimento eh pra direita
    li $t0, 2
    lw $t1, maxSide
    beq $t0, $t1, max_ChangeSprite_checkStateControl # Se o lado anterior for igual ao atual, nao precisa fazer nada
    sw $t0, maxSide
    sw $s2, maxCurrentImage
    j max_ChangeSprite_reprintMax
max_ChangeSprite_CheckHorizontal_negative:
    # Aqui o movimento eh pra esquerda
    li $t0, 3
    lw $t1, maxSide
    beq $t0, $t1, max_ChangeSprite_checkStateControl # Se o lado anterior for igual ao atual, nao precisa fazer nada
    sw $t0, maxSide
    sw $s3, maxCurrentImage
    j max_ChangeSprite_reprintMax
max_ChangeSprite_checkStateControl:
    lw $t9, maxCurrentStateControl
    beq $t9, $zero, max_ChangeSprite_end
max_ChangeSprite_reprintMax:
    jal apagaMax
    jal printMax
    sw $zero, maxCurrentStateControl
max_ChangeSprite_end:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $s0, 12($sp)
    lw $s1, 16($sp)
    lw $s2, 20($sp)
    lw $s3, 24($sp)
    addi $sp, $sp, 28

###########################################################################################################
# Essa funcao decide se o estado do max ira variar, dependendo dos botoes A, B, X, Y                      #
# Essa funcao tem um trecho no .data proprio, para saber se um botao esteve pressionado no frame anterior #
###########################################################################################################
.data
    max_GetInteractionInput_A: .word 0x00
    max_GetInteractionInput_B: .word 0x00
    max_GetInteractionInput_X: .word 0x00
    max_GetInteractionInput_Y: .word 0x00
.text
max_GetInteractionInput:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    ## Verifica se esta tentando segurar algo (ou chutar um bloco)
    jal isButtonDown_B
    beq $v0, $zero, max_GetInteractionInput_end # Se o botao B nao estiver pressionado pode terminar
    # Se o botao B estiver pressionado, verifica se esteve pressionado antes
    la $t0, max_GetInteractionInput_B
    lw $t1, 0($t0)
    li $t2, 1
    beq $t2, $t1, max_GetInteractionInput_end # Se esta pressionado e esteve pressionado, pode terminar
    # Aqui o botao B nao estava pressionado e foi pressionado
    lw $t0, maxCurrentState
    not $t0, $t0
    andi $t0, $t0, 0x0001
    sw $t0, maxCurrentState
    sw $t2, maxCurrentStateControl
    beq $t0, $zero, max_GetInteractionInput_changeToNormal
    lw $t0, maxSide
    li $t1, 4
    mult $t0, $t1
    mflo $t0
    la $t1, MAX_2_FRONT
    add $t1, $t0, $t1
    lw $t0, 0($t1)
    sw $t0, maxCurrentImage
    j max_GetInteractionInput_end
max_GetInteractionInput_changeToNormal:
    lw $t0, maxSide
    li $t1, 4
    mult $t0, $t1
    mflo $t0
    la $t1, MAX_FRONT
    add $t1, $t0, $t1
    lw $t0, 0($t1)
    sw $t0, maxCurrentImage
max_GetInteractionInput_end:
    sw $v0, max_GetInteractionInput_B
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra