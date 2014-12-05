.data #0x10010000
    BG_1: .word 0x00000000
    MBG_1: .word 0x00000000
    MAX_FRONT: .word 0x00000000

.text

main:
    li $a0, 3 # Numero de elementos no jogo
    jal loadGame
##############################################################################################################
    li $v0,48   #syscall para limpar a tela
    li $a0,0xFF  #fundo branco
    syscall

    li $a0, 0
    li $a1, 0
    la $a2, BG_1
    lw $a2, 0($a2)
    jal printImg

    li $s0, 140 #pos inicial x
    li $s1, 85  #pos inicial y
    add $a0, $s0, $zero
    add $a1, $s1, $zero
    la $a2, MAX_FRONT           #endereço da imagem na sram
    lw $a2, 0($a2)
    jal printImg
    j LOOP

LOOP:
    jal inputManagerUpdate
    jal isButtonDown_Up
    bne $v0, $zero, CIMA
    jal isButtonDown_Down
    bne $v0, $zero, BAIXO
    jal isButtonDown_Right
    bne $v0, $zero, DIREITA
    jal isButtonDown_Left
    bne $v0, $zero, ESQUERDA
    j LOOP

    CIMA:
        ##olha o tile para o qual ele esta tentando movimentar
        la $a0, MBG_1
        lw $a0, 0($a0)
        
        #addi $t0, $zero, 20
        #div $a1, $s0, $t0
        #addi $a2, $s1, 17
        #addi $t0, $zero, 17
        #div $a2, $a2, $t0
        
        #jal getTileInfo
        #addi $t0, $zero, 0x2A #$t0 = *
        bne $v0, $t0, LOOP #se nao for valido, nem anda
        
        la $a0, BG_1
        lw $a0, 0($a0)
        move $a1, $zero
        add $a1, $s0, $zero
            sll $a1, $a1, 16 #x
        add $a1, $a1, $s1 #y
        jal printTilePixel
        la $a0, BG_1
        lw $a0, 0($a0)
        move $a1, $zero
        add $a1, $s0, $zero
            sll $a1, $a1, 16 #x
        add $a1, $a1, $s1
        addi $a1, $a1, 17
        jal printTilePixel
                
        addi $s1, $s1, -17
        add $a0, $s0, $zero
        add $a1, $s1, $zero
        la $a2, MAX_FRONT           #endereço da imagem na sram
        lw $a2, 0($a2)
        jal printImg
        j LOOP
    BAIXO:
        ##olha o tile para o qual ele esta tentando movimentar
        la $a0, MBG_1
        lw $a0, 0($a0)
        
        #add $a1, $s0, $zero
        #addi $t0, $zero, 20
        #div $a1, $a1, $t0
        #add $a2, $s1, $zero
        #addi $t0, $zero, 17
        #div $a2, $a2, $t0
        
        #jal getTileInfo
        #addi $t0, $zero, 0x2A #$t0 = *
        bne $v0, $t0, LOOP #se nao for valido, nem anda

        la $a0, BG_1
        lw $a0, 0($a0)
        move $a1, $zero
        add $a1, $s0, $zero
            sll $a1, $a1, 16 #x
        add $a1, $a1, $s1 #y
        jal printTilePixel
        la $a0, BG_1
        lw $a0, 0($a0)
        move $a1, $zero
        add $a1, $s0, $zero
            sll $a1, $a1, 16 #x
        add $a1, $a1, $s1
        addi $a1, $a1, 17
        jal printTilePixel

        addi $s1, $s1, 17
        add $a0, $s0, $zero
        add $a1, $s1, $zero
        la $a2, MAX_FRONT           #endereço da imagem na sram
        lw $a2, 0($a2)
        jal printImg
        j LOOP
    DIREITA:
        #olha o tile para o qual ele esta tentando movimentar
        la $a0, MBG_1
        lw $a0, 0($a0)
        
        addi $a1, $s0, 20
        addi $t0, $zero, 20
        div $a1, $a1, $t0
        add $a2, $s1, $zero
        addi $t0, $zero, 17
        div $a2, $a2, $t0
        
        jal getTileInfo
        addi $t0, $zero, 0x2A #$t0 = *
        bne $v0, $t0, LOOP #se nao for valido, nem anda
        
        la $a0, BG_1
        lw $a0, 0($a0)
        move $a1, $zero
        add $a1, $s0, $zero
            sll $a1, $a1, 16 #x
        add $a1, $a1, $s1 #y
        jal printTilePixel
        la $a0, BG_1
        lw $a0, 0($a0)
        move $a1, $zero
        add $a1, $s0, $zero
            sll $a1, $a1, 16 #x
        add $a1, $a1, $s1
        addi $a1, $a1, 17
        jal printTilePixel

        addi $s0, $s0, 20
        add $a0, $s0, $zero
        add $a1, $s1, $zero
        la $a2, MAX_FRONT           #endereço da imagem na sram
        lw $a2, 0($a2)
        jal printImg
        j LOOP
    ESQUERDA:
        ##olha o tile para o qual ele esta tentando movimentar
        la $a0, MBG_1
        lw $a0, 0($a0)

        addi $a1, $s0, -20
        addi $t0, $zero, 20
        div $a1, $a1, $t0
        add $a2, $s1, $zero
        addi $t0, $zero, 17
        div $a2, $a2, $t0
        
        jal getTileInfo
        addi $t0, $zero, 0x2A #$t0 = *
        bne $v0, $t0, LOOP #se nao for valido, nem anda
        
        la $a0, BG_1
        lw $a0, 0($a0)
        move $a1, $zero
        add $a1, $s0, $zero
            sll $a1, $a1, 16 #x
        add $a1, $a1, $s1 #y
        jal printTilePixel
        la $a0, BG_1
        lw $a0, 0($a0)
        move $a1, $zero
        add $a1, $s0, $zero
            sll $a1, $a1, 16 #x
        add $a1, $a1, $s1
        addi $a1, $a1, 17
        jal printTilePixel

        addi $s0, $s0, -20
        add $a0, $s0, $zero
        add $a1, $s1, $zero
        la $a2, MAX_FRONT           #endereço da imagem na sram
        lw $a2, 0($a2)
        jal printImg
        j LOOP
    
EXIT:
    j EXIT

##############################################################################################################
.include "include.s"