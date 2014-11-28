#####################################################################
#  Gabriel Naves da Silva - 03/11/2014                              #
#  Modulo com uma funcao para printar uma imagem na tela.           #
#  Parametros:                                                      #
#  $a0 -> Posicao X da imagem (Posicao do ponto superior esquerdo)  #
#  $a1 -> Posicao Y da imagem (Posicao do ponto superior esquerdo)  #
#  $a2 -> Endereco da imagem                                        #
#  Byte de transparencia: 0x28                                      #
#####################################################################
    .text

printImg:
    addi $sp, $sp, -32
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $s6, 24($sp)
    sw $s7, 28($sp)

    lw $s1, 0($a2)               # Carrega a largura da imagem
    lw $s2, 4($a2)               # Carrega a altura da imagem
    addi $a2, $a2, 8
    move $s0, $a2                # Endereco da imagem vai para $s0
    add $s1, $s1, $a0            # A posicao x eh somada a largura
    add $s2, $s2, $a1            # A posicao y eh somada a altura
    move $s3, $a1                # i comeca na posicao y
    move $s7, $a0                # Posicao x passa para $s7
printImgHeightLoop:
    beq $s3, $s2, printImgHeightExit    # Se i for igual a Altura, termina
    li $s5, 1                           # Contador para os pixels
    lw $s6, 0($s0)                      # Carrega o set de pixels atual
    move $s4, $s7                       # j comeca na posicao x (que esta salva em $s7)
printImgWidthLoop:
    beq $s4, $s1, printImgWidthExit      # Se j for igual a Largura, termina esse loop
    ## Descobre em qual posicao da word esta o pixel a ser printado
    li $t0, 1
    beq $s5, $t0, printImgFirstPixel
    li $t0, 2
    beq $s5, $t0, printImgSecondPixel
    li $t0, 3
    beq $s5, $t0, printImgThirdPixel
    li $t0, 4
    beq $s5, $t0, printImgFourthPixel
printImgFirstPixel:
    srl $t0, $s6, 24
    li $t1, 0                           # Flag para avisar que a word nao acabou
    j printImgWidthEnd
printImgSecondPixel:
    sll $t0, $s6, 8
    srl $t0, $t0, 24
    li $t1, 0                           # Flag para avisar que a word nao acabou
    j printImgWidthEnd
printImgThirdPixel:
    sll $t0, $s6, 16
    srl $t0, $t0, 24
    li $t1, 0                           # Flag para avisar que a word nao acabou
    j printImgWidthEnd
printImgFourthPixel:
    sll $t0, $s6, 24
    srl $t0, $t0, 24
    li $s5, 0
    li $t1, 1                           # Flag para avisar que a word acabou
printImgWidthEnd:
    li $t9, 0x0028                      ### 0x0028: cor tida como invisivel. ###
    beq $t0, $t9, printImgWidthEnd_JumpPixel
    li $v0, 45                          # Codigo do syscall plot
    move $a0, $s4                       # Posicao x do pixel
    move $a1, $s3                       # Posicao y do pixel
    move $a2, $t0                       # Cor para printar
    syscall                             # Plota o pixel
printImgWidthEnd_JumpPixel:
    addi $s5, $s5, 1                    # contador de pixel++
    addi $s4, $s4, 1                    # j++
    beq $s4, $s1, printImgWidthExit     # Se j for igual a Largura, termina esse loop
    bne $t1, $zero, printImgHeightExitOfWord
    j printImgWidthLoop
printImgHeightExitOfWord:
    addi $s0, $s0, 4
    lw $s6, 0($s0)                      # Carrega o set de pixels atual
    j printImgWidthLoop
printImgWidthExit:
    addi $s3, $s3, 1                    # i++
    addi $s0, $s0, 4                    # Proxima word
    j printImgHeightLoop

printImgHeightExit:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    lw $s6, 24($sp)
    lw $s7, 28($sp)
    addi $sp, $sp, 32
    jr $ra
