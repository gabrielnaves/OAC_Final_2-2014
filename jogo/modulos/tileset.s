#################################
# Sinayra Pascoal Cotts Moreira - 04/12/2014
#  Modulos para lidar com tiles
###############################
.text

.eqv WIDTH_TILE 20 
.eqv HEIGHT_TILE 17 

#Dado um endereço de memória de uma matriz de movimentação, retornar o conteudo de uma posicao dessa matriz
#$v0 -> conteudo da posicao da matriz
#$a0 -> começo da matriz
#$a1 -> x
#$a2 -> y
getTileInfo:
    sll $t0, $a2, 4
    add $t0, $t0, $a1 #carrega 16*y + x em $t0

    li $t4, 4
    div $t0, $t4
    mflo $t1
    sll $t0, $t1, 2
    add $t0, $t0, $a0

    lw $t2, 0($t0)
    mfhi $t1
    sll $t1, $t1, 3
   
    sllv $t2, $t2, $t1 #coloca o byte desejado no fim da word 
    srl $v0, $t2, 24 #bota esse byte no inicio da word

    jr $ra

#################################
# $a0: half0: posicao do pixel x | half2: posicao do pixel y
# $v0: half0: posicao da matriz i | half2: posicao da matriz j
# Retorna, a partir da posicao (x,y) a posicao (i,j) da matriz de tile
#      _________
# Arg: | x | y |
#         _________
# Return: | i | j |
#
# Nota: eu nao me importo com temporarios
###############################
getTile:
    li $t0, WIDTH_TILE 
    li $t1, HEIGHT_TILE

    srl $t2, $a0, 16 #x
    sll $t3, $a0, 16 #pre-y
    srl $t3, $t3, 16 #y

    add $t4, $zero, $t0
    add $t9, $zero, $t1
    add $t5, $zero, $zero #i
    add $t7, $zero, $zero #j
    li $t6, 1
    
    procuraX:
        slt $t8, $t2, $t4 #pixel < tile ?
        beq $t8, $t6, procuraY # t8 == 1, entao tileX ok
        addi $t5, $t5, 1
        add $t4, $t4, $t0
        j procuraX

    procuraY:
        slt $t8, $t3, $t9 #pixel < tile ?
        beq $t8, $t6, setIJ # t8 == 1, entao tileX ok
        addi $t7, $t7, 1
        add $t9, $t9, $t1
        j procuraY

    setIJ:
        add $v0, $zero, $zero
        add $v0, $zero, $t5
        sll $v0, $v0, 16
        add $v0, $v0, $t7

    jr $ra

#################################
# $a0: endereco da imagem
# $a1: half0: posicao da matriz i | half2: posicao da matriz j
# Printa o imagem inteira na posicao i,j da matriz
# _________
# | i | j |
#
# Nota: eu nao me importo com temporarios
###############################
printInTile:
    li $t0, WIDTH_TILE 
    li $t1, HEIGHT_TILE

    srl $t2, $a1, 16 #i
    sll $t3, $a1, 16 #pre-j
    srl $t3, $t3, 16 #j

    mult $t2, $t0
    mflo $t2 #pixel x

    mult $t3, $t1
    mflo $t3 #pixel y

    add $a2, $zero, $a0 #endereco da imagem
    add $a0, $zero, $t2 #posicao x
    add $a1, $zero, $t3 #posicao y

    addi $sp, $sp, -4
    sw $ra, 0($sp)

    jal printImg

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra


#################################
# $a0: endereco da imagem
# $a1: half0: posicao da matriz i | half2: posicao da matriz j
# Printa o tile (i,j) do BG
# _________
# | i | j |
#
# Nota: eu nao me importo com temporarios
###############################

printTile:
    li $t0, 20 #largura tile
    li $t1, 17 #altura tile

    srl $t2, $a1, 16 #i
    sll $t3, $a1, 16 #prÃ©-j
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
# Função auxiliar para printar o tile
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

    # BOSTA! NÃƒÂ£o funciona lh e lhu
    #lh $s0, 0($a1) #x
    #lh $s1, 2($a1) #y
    
    srl $s0, $a1, 16 #x
    sll $s1, $a1, 16 #prÃ©-y
    srl $s1, $s1, 16 #y

    addi $a0, $a0, 8 #pula word de largura e altura da imagem
    add $a0, $a0, $s0 #posiciona em x

    li $t0, 320
    mult $t0, $s1 #multiplicando pixel y por quantidade de pixel em x que tenho que pular
    mflo $t0
    add $a0, $a0, $t0

    add $t4, $zero, $a0 #coloca em t4 o endereÃ§o de onde estÃ£o os pixels da imagem


    li $s2, 20 #largura tile + 1 (20 na verdade)
    li $s3, 17 #altura tile + 1 (17 na verdade)

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

            jal Plot                             # Plota o pixel

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


#ADICIONE ESTE INCLUDE CASO QUEIRA TESTAR O GETTILE SEPARADO
#.include "printImg.s"
