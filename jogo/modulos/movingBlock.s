.data
    mvBlockPosX: .word 0x00000000
    mvBlockPosY: .word 0x00000000
    mvBlockDir:  .word 0x00000000

.text

updateBlock:
    addi $sp, $sp, -4
    sw $ra, 0($sp)


    lw $t0, mvBlockDir
    beq $t0, $zero, fimUpdateBlock
    # Frente = 1                                                    #
    # Tras = 2                                                      #
    # Direita = 3                                                   #
    # Esquerda = 4                                                  #
    li $t1, 2
    beq $t1, $t0, mvFrente
    li $t1, 1
    beq $t1, $t0, mvTras
    li $t1, 3
    beq $t1, $t0, mvDireita
    li $t1, 4
    beq $t1, $t0, mvEsquerda


fimUpdateBlock:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

mvFrente:
    lw $t0, mvBlockPosX
    lw $t1, mvBlockPosY
    addi $t1, $t1, -1

    lw $a0, MATUAL
    move $a1, $t0
    move $a2, $t1
    jal getTileInfo

    li $t0, 0x61
    beq $t0, $v0, mvFront
    li $t0, 0x2a
    beq $t0, $v0, mvFront
    li $t0, 0x00000000
    sw $t0, mvBlockDir
    j fimUpdateBlock

    mvFront:
        #escreve na matriz a proxima matriz
        lw $a0, MATUAL
        li $a3, 0x63
        jal setTileInfo
        #escreve na matriz no local deixando grama
        lw $a0, MATUAL
        lw $a1, mvBlockPosX
        lw $a2, mvBlockPosY
        li $a3, 0x2a
        jal setTileInfo

        #apaga o anterior
        lw $a0, BG_ATUAL
        lw $t0, mvBlockPosX
        sll $t0, $t0, 16
        lw $t1, mvBlockPosY
        or $a1, $t0, $t1
        jal printTile

        #escreve o proximo
        lw $a0, MVBLOCK
        lw $t0, mvBlockPosX
        sll $t0, $t0, 16
        lw $t1, mvBlockPosY
        addi $t1, $t1, -1
        or $a1, $t0, $t1
        jal printInTile

        #atualiza posicao
        lw $t0, mvBlockPosY
        addi $t0, $t0, -1
        sw $t0, mvBlockPosY


        j fimUpdateBlock


mvTras:
    lw $t0, mvBlockPosX
    lw $t1, mvBlockPosY
    addi $t1, $t1, 1

    lw $a0, MATUAL
    move $a1, $t0
    move $a2, $t1
    jal getTileInfo

    li $t0, 0x61
    beq $t0, $v0, mvBack
    li $t0, 0x2a
    beq $t0, $v0, mvBack
    li $t0, 0x00000000
    sw $t0, mvBlockDir
    j fimUpdateBlock

    mvBack: 
        #escreve na matriz a proxima matriz
        lw $a0, MATUAL
        li $a3, 0x63
        jal setTileInfo
        #escreve na matriz no local deixando grama
        lw $a0, MATUAL
        lw $a1, mvBlockPosX
        lw $a2, mvBlockPosY
        li $a3, 0x2a
        jal setTileInfo

        #apaga o anterior
        lw $a0, BG_ATUAL
        lw $t0, mvBlockPosX
        sll $t0, $t0, 16
        lw $t1, mvBlockPosY
        or $a1, $t0, $t1
        jal printTile

        #escreve o proximo
        lw $a0, MVBLOCK
        lw $t0, mvBlockPosX
        sll $t0, $t0, 16
        lw $t1, mvBlockPosY
        addi $t1, $t1, 1
        or $a1, $t0, $t1
        jal printInTile

        #atualiza posicao
        lw $t0, mvBlockPosY
        addi $t0, $t0, 1
        sw $t0, mvBlockPosY


        j fimUpdateBlock

mvDireita:
    lw $t0, mvBlockPosX
    lw $t1, mvBlockPosY
    addi $t0, $t0, 1

    lw $a0, MATUAL
    move $a1, $t0
    move $a2, $t1
    jal getTileInfo

    li $t0, 0x61
    beq $t0, $v0, mvRight
    li $t0, 0x2a
    beq $t0, $v0, mvRight
    li $t0, 0x00000000
    sw $t0, mvBlockDir
    j fimUpdateBlock

    mvRight:
        #escreve na matriz a proxima matriz
        lw $t0, mvBlockPosX
        lw $t1, mvBlockPosY
        addi $t0, $t0, 1
        lw $a0, MATUAL
        li $a3, 0x63
        jal setTileInfo
        #escreve na matriz no local deixando grama
        lw $a0, MATUAL
        lw $a1, mvBlockPosX
        lw $a2, mvBlockPosY
        li $a3, 0x2a
        jal setTileInfo

        #apaga o anterior
        lw $a0, BG_ATUAL
        lw $t0, mvBlockPosX
        sll $t0, $t0, 16
        lw $t1, mvBlockPosY
        or $a1, $t0, $t1
        jal printTile

        #escreve o proximo
        lw $a0, MVBLOCK
        lw $t0, mvBlockPosX
        addi $t0, $t0, 1
        sll $t0, $t0, 16
        lw $t1, mvBlockPosY
        or $a1, $t0, $t1
        jal printInTile

        #atualiza posicao
        lw $t0, mvBlockPosX
        addi $t0, $t0, 1
        sw $t0, mvBlockPosX

        j fimUpdateBlock

mvEsquerda:
    lw $t0, mvBlockPosX
    lw $t1, mvBlockPosY
    addi $t0, $t0, -1

    lw $a0, MATUAL
    move $a1, $t0
    move $a2, $t1
    jal getTileInfo

    li $t0, 0x61
    beq $t0, $v0, mvLeft
    li $t0, 0x2a
    beq $t0, $v0, mvLeft
    li $t0, 0x00000000
    sw $t0, mvBlockDir
    j fimUpdateBlock

    mvLeft:
        #escreve na matriz a proxima matriz
        lw $t0, mvBlockPosX
        lw $t1, mvBlockPosY
        addi $t0, $t0, -1
        lw $a0, MATUAL
        li $a3, 0x63 #caixa
        jal setTileInfo
        #escreve na matriz no local deixando grama
        lw $a0, MATUAL
        lw $a1, mvBlockPosX
        lw $a2, mvBlockPosY
        li $a3, 0x2a #caminho livre
        jal setTileInfo

        #apaga o anterior
        lw $a0, BG_ATUAL
        lw $t0, mvBlockPosX
        sll $t0, $t0, 16
        lw $t1, mvBlockPosY
        or $a1, $t0, $t1
        jal printTile

        #escreve o proximo
        lw $a0, MVBLOCK
        lw $t0, mvBlockPosX
        addi $t0, $t0, -1
        sll $t0, $t0, 16
        lw $t1, mvBlockPosY
        or $a1, $t0, $t1
        jal printInTile

        #atualiza posicao
        lw $t0, mvBlockPosX
        addi $t0, $t0, -1
        sw $t0, mvBlockPosX


        j fimUpdateBlock