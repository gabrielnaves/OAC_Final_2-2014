#################################
# $a0: endereco da imagem
# $a1: half0: posicao da matriz i | half2: posicao da matriz j
# _________
# | i | j |
#
# Nota: eu nao me importo com temporarios
###############################
.text

printTile:
    li $t0, 20 #largura tile
    li $t1, 16 #altura tile

    srl $t2, $a1, 16 #i
    sll $t3, $a1, 16 #pré-j
    srl $t3, $t3, 16 #j

    mult $t2, $t0
    mflo $t2 #pixel x

    mult $t3, $t1
    mflo $t3 #pixel y

    add $a1, $t2, $zero
    sll $a1, $a1, 16 #x
    add $a1, $a1, $t3 #y

    addi $sp, $sp, -4
    sw $ra, 0($sp)

    jal printTilePixel

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    jr $ra

#################################
# $a0: endereco da imagem
# $a1: half0: posicao x | half2: posicao y
# _________
# | x | y |
###############################
printTilePixel:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    addi $sp, $sp, -32
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $s6, 24($sp)
    sw $s7, 28($sp)

    # BOSTA! NÃ£o funciona lh e lhu
    #lh $s0, 0($a1) #x
    #lh $s1, 2($a1) #y
    
    srl $s0, $a1, 16 #x
    sll $s1, $a1, 16 #pré-y
    srl $s1, $s1, 16 #y

    addi $a0, $a0, 8 #pula word de largura e altura da imagem
    add $a0, $a0, $s0 #posiciona em x

    li $t0, 320
    mult $t0, $s1 #multiplicando pixel y por quantidade de pixel em x que tenho que pular
    mflo $t0
    add $a0, $a0, $t0

    add $t4, $zero, $a0 #coloca em t4 o endereço de onde estão os pixels da imagem


    li $s2, 21 #largura tile + 1 (20 na verdade)
    li $s3, 18 #altura tile + 1 (17 na verdade)

    add $s6, $zero, $zero #contador de posicao y
    li $s4, 25 #numero 24

    printTileLoop:
        lw $s7, 0($t4)
        addi $t1, $zero, 0xFF000000 #mascara
        li $t2, 24  #contador de shift
        add $s5, $zero, $zero #contador de posicao x

        eixoX:
            beq $s5, $s2, pulaEixoY

            li $v0, 45                          # Codigo do syscall plot

            add $t0, $s0, $s5                   # posicao x do pixel + contador de pixel x
            move $a0, $t0                       # Posicao x do pixel

            add $t0, $s1, $s6                   # posicao y do pixel + contador de pixel y
            move $a1, $t0                       # Posicao y do pixel

            and $t8, $s7, $t1                   # pega pixel da imagem
            srlv $t8, $t8, $t2                  # shifta para pixel ocupar posicao menos significativa
            move $a2, $t8                       # Cor para printar

            addi $sp, $sp, -40
            sw $t0, 0($sp)
            sw $t1, 4($sp)
            sw $t2, 8($sp)
            sw $t3, 12($sp)
            sw $t4, 16($sp)
            sw $t5, 20($sp)
            sw $t6, 24($sp)
            sw $t7, 28($sp)
            sw $t8, 32($sp)
            sw $t9, 36($sp)

            syscall                             # Plota o pixel

            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $t3, 12($sp)
            lw $t4, 16($sp)
            lw $t5, 20($sp)
            lw $t6, 24($sp)
            lw $t7, 28($sp)
            lw $t8, 32($sp)
            lw $t9, 36($sp)
            addi $sp, $sp, 40

            addi $t2, $t2, -8
            srl $t1, $t1, 8

            addi $s5, $s5, 1

            li $t3, -1
            slt $t3, $t3, $t2
            beq $t3, $zero, proximaWord

            j eixoX

            proximaWord:

                addi $t4, $t4, 4
                lw $s7, 0($t4)
                addi $t1, $zero, 0xFF000000 #mascara
                li $t2, 24  #contador de shift
                j eixoX

        pulaEixoY:

            addi $s6, $s6, 1
            addi $t4, $t4, 300          #Andando mais 300 pixels porque andou 20 de x 
            bne $s3, $s6, printTileLoop


    fimPrintTile:

        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        lw $s6, 24($sp)
        lw $s7, 28($sp)
        addi $sp, $sp, 32

        lw $ra, 0($sp)
        addi $sp, $sp, 4

        jr $ra
