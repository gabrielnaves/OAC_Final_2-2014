    .data
####################################
# inputManagerFlags:               #
# Bit 0: A        Bit 6: Right     #
# Bit 1: B        Bit 7: Up        #
# Bit 2: X        Bit 8: Left      #
# Bit 3: Y        Bit 9: Down      #
# Bit 4: Start    Bit 10: R        #
# Bit 5: Select   Bit 11: L        #
####################################
inputManagerFlags:           .word    0x00000000

    .text
inputManagerUpdate:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)

    la $t0, 0xFFFF0104 # Endereco do buffer 1 do teclado
    lw $a0, 0($t0)
    la $t0, 0xFFFF0100 # Endereco do buffer 0 do teclado
    lw $a1, 0($t0)
    jal inputManagerProcessBuffer

    lw $ra, 0($sp)
    lw $a0, 4($sp)
    addi $sp, $sp, 8
    jr $ra

## Processa o buffer do teclado. $a0 contem o buffer 1 e $a1 contem o buffer 0.
inputManagerProcessBuffer:
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $a0, 16($sp)
    sw $a1, 20($sp)

    move $s0, $a0           # Buffer 1 para $s0
    move $s1, $a1           # Buffer 0 para $s1
    li $s2, 0x00F0          # $s2 contem o codigo para remocao de botao

    srl $t0, $s0, 24        # Byte mais significativo do buffer 1 vai pra $t0
    bne $t0, $s2, inputManagerProcessBuffer_ignoreFirstByte # Se $t0 nao for 0x00F0, ignora esse byte
    li $a1, 0               # Se $t0 for 0x00F0, seta o proximo byte para false, se for um botao
    sll $a0, $s0, 8
    srl $a0, $a0, 24

    jal inputManagerSetButton   # Seta o segundo byte pra false
    j inputManagerProcessBuffer_thirdByte # Vai para o terceiro byte
inputManagerProcessBuffer_ignoreFirstByte:
    sll $a0, $s0, 8
    srl $a0, $a0, 24
    beq $a0, $s2, inputManagerProcessBuffer_thirdByteToFalse # Se for 0x00F0, seta o proximo byte para false
    li $a1, 1
    jal inputManagerSetButton     # Seta o segundo byte pra true
    j inputManagerProcessBuffer_thirdByte # Vai para o terceiro byte
inputManagerProcessBuffer_thirdByteToFalse:
    sll $a0, $s0, 16
    srl $a0, $a0, 24
    li $a1, 0
    jal inputManagerSetButton    # Seta o terceiro byte pra false
    j inputManagerProcessBuffer_fourthByte # vai pro quarto byte
inputManagerProcessBuffer_thirdByte:
    sll $a0, $s0, 16
    srl $a0, $a0, 24
    beq $a0, $s2, inputManagerProcessBuffer_fourthByteToFalse
    li $a1, 1
    jal inputManagerSetButton    # Seta o terceiro byte pra true
    j inputManagerProcessBuffer_fourthByte # vai pro quarto byte
inputManagerProcessBuffer_fourthByteToFalse:
    sll $a0, $s0, 24
    srl $a0, $a0, 24
    li $a1, 0
    jal inputManagerSetButton   # Seta o quarto byte pra false
    j inputManagerProcessBuffer_fifthByte # Vai pro quinto byte
inputManagerProcessBuffer_fourthByte:
    sll $a0, $s0, 24
    srl $a0, $a0, 24
    beq $a0, $s2, inputManagerProcessBuffer_fifthByteToFalse
    li $a1, 1
    jal inputManagerSetButton    # Seta o quarto byte pra true
    j inputManagerProcessBuffer_fifthByte # Vai pro quinto byte
inputManagerProcessBuffer_fifthByteToFalse:
    srl $a0, $s1, 24
    li $a1, 0
    jal inputManagerSetButton   # Seta o quinto byte pra false
    j inputManagerProcessBuffer_sixthByte # Vai pro sexto byte
inputManagerProcessBuffer_fifthByte:
    srl $a0, $s1, 24
    beq $a0, $s2, inputManagerProcessBuffer_sixthByteToFalse
    li $a1, 1
    jal inputManagerSetButton #seta o quinto byte pra true
    j inputManagerProcessBuffer_sixthByte # Vai pro sexto byte
inputManagerProcessBuffer_sixthByteToFalse:
    sll $a0, $s1, 8
    srl $a0, $a0, 24
    li $a1, 0
    jal inputManagerSetButton   # Seta o sexto byte pra false
    j inputManagerProcessBuffer_seventhByte # Vai pro setimo byte
inputManagerProcessBuffer_sixthByte:
    sll $a0, $s1, 8
    srl $a0, $a0, 24
    beq $a0, $s2, inputManagerProcessBuffer_seventhByteToFalse
    li $a1, 1
    jal inputManagerSetButton #seta o sexto byte pra true
    j inputManagerProcessBuffer_seventhByte # Vai pro setimo byte
inputManagerProcessBuffer_seventhByteToFalse:
    sll $a0, $s1, 16
    srl $a0, $a0, 24
    li $a1, 0
    jal inputManagerSetButton   # Seta o setimo byte pra false
    j inputManagerProcessBuffer_eighthByte # Vai pro oitavo byte
inputManagerProcessBuffer_seventhByte:
    sll $a0, $s1, 16
    srl $a0, $a0, 24
    beq $a0, $s2, inputManagerProcessBuffer_eighthByteToFalse
    li $a1, 1
    jal inputManagerSetButton #seta o setimo byte pra true
    j inputManagerProcessBuffer_eighthByte # Vai pro oitavo byte
inputManagerProcessBuffer_eighthByteToFalse:
    sll $a0, $s1, 24
    srl $a0, $a0, 24
    li $a1, 0
    jal inputManagerSetButton   # Seta o oitavo byte pra false
    j inputManagerProcessBuffer_end # termina
inputManagerProcessBuffer_eighthByte:
    sll $a0, $s1, 24
    srl $a0, $a0, 24
    li $a1, 1
    jal inputManagerSetButton #seta o oitavo byte pra true
inputManagerProcessBuffer_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $a0, 16($sp)
    lw $a1, 20($sp)
    addi $sp, $sp, 24
    jr $ra

## Dado um byte no registrador $a0, descobre se eh um botao e seta a flag correspondente.
## Se o valor em $a1 for 0, seta para falso. Se for 1, seta para verdadeiro.
inputManagerSetButton:
    lw $t1, inputManagerFlags
    li $t0, 0x00000022 ### Botao A
    bne $t0, $a0, inputManagerSetButton_B
    li $t0, 0x0001
    j inputManagerSetButtonFoundButton
inputManagerSetButton_B:
    li $t0, 0x0000001A ### Botao B
    bne $t0, $a0, inputManagerSetButton_X
    li $t0, 0x0002
    j inputManagerSetButtonFoundButton
inputManagerSetButton_X:
    li $t0, 0x0000001B ### Botao X
    bne $t0, $a0, inputManagerSetButton_Y
    li $t0, 0x0004
    j inputManagerSetButtonFoundButton
inputManagerSetButton_Y:
    li $t0, 0x0000001C ### Botao Y
    bne $t0, $a0, inputManagerSetButton_Start
    li $t0, 0x0008
    j inputManagerSetButtonFoundButton
inputManagerSetButton_Start:
    li $t0, 0x0000005A ### Botao Start
    bne $t0, $a0, inputManagerSetButton_Select
    li $t0, 0x0010
    j inputManagerSetButtonFoundButton
inputManagerSetButton_Select:
    li $t0, 0x00000059 ### Botao Select
    bne $t0, $a0, inputManagerSetButton_Right
    li $t0, 0x0020
    j inputManagerSetButtonFoundButton
inputManagerSetButton_Right:
    li $t0, 0x0000004B ### Botao Right
    bne $t0, $a0, inputManagerSetButton_Up
    li $t0, 0x0040
    j inputManagerSetButtonFoundButton
inputManagerSetButton_Up:
    li $t0, 0x00000043 ### Botao Up
    bne $t0, $a0, inputManagerSetButton_Left
    li $t0, 0x0080
    j inputManagerSetButtonFoundButton
inputManagerSetButton_Left:
    li $t0, 0x0000003B ### Botao Left
    bne $t0, $a0, inputManagerSetButton_Down
    li $t0, 0x0100
    j inputManagerSetButtonFoundButton
inputManagerSetButton_Down:
    li $t0, 0x00000042 ### Botao Down
    bne $t0, $a0, inputManagerSetButton_R
    li $t0, 0x0200
    j inputManagerSetButtonFoundButton
inputManagerSetButton_R:
    li $t0, 0x00000021 ### Botao R
    bne $t0, $a0, inputManagerSetButton_L
    li $t0, 0x0400
    j inputManagerSetButtonFoundButton
inputManagerSetButton_L:
    li $t2, 0x00000023 ### Botao L
    li $t0, 0x0800
    beq $t2, $a0, inputManagerSetButtonFoundButton
    jr $ra
inputManagerSetButtonFoundButton:
    beq $a1, $zero, inputManagerSetButtonSetToFalse
    or $t1, $t0, $t1
    sw $t1, inputManagerFlags
    jr $ra
inputManagerSetButtonSetToFalse:
    not $t0, $t0
    and $t1, $t0, $t1
    sw $t1, inputManagerFlags
    jr $ra



isButtonDown_A:
    lw $v0, inputManagerFlags
    andi $v0, $v0, 0x0001
    jr $ra
    
isButtonDown_B:
    lw $v0, inputManagerFlags
    andi $v0, $v0, 0x0002
    srl $v0, $v0, 1
    jr $ra

isButtonDown_X:
    lw $v0, inputManagerFlags
    andi $v0, $v0, 0x0004
    srl $v0, $v0, 2
    jr $ra

isButtonDown_Y:
    lw $v0, inputManagerFlags
    andi $v0, $v0, 0x0008
    srl $v0, $v0, 3
    jr $ra

isButtonDown_Start:
    lw $v0, inputManagerFlags
    andi $v0, $v0, 0x0010
    srl $v0, $v0, 4
    jr $ra

isButtonDown_Select:
    lw $v0, inputManagerFlags
    andi $v0, $v0, 0x0020
    srl $v0, $v0, 5
    jr $ra

isButtonDown_Right:
    lw $v0, inputManagerFlags
    andi $v0, $v0, 0x0040
    srl $v0, $v0, 6
    jr $ra

isButtonDown_Up:
    lw $v0, inputManagerFlags
    andi $v0, $v0, 0x0080
    srl $v0, $v0, 7
    jr $ra

isButtonDown_Left:
    lw $v0, inputManagerFlags
    andi $v0, $v0, 0x0100
    srl $v0, $v0, 8
    jr $ra

isButtonDown_Down:
    lw $v0, inputManagerFlags
    andi $v0, $v0, 0x0200
    srl $v0, $v0, 9
    jr $ra

isButtonDown_R:
    lw $v0, inputManagerFlags
    andi $v0, $v0, 0x0400
    srl $v0, $v0, 10
    jr $ra

isButtonDown_L:
    lw $v0, inputManagerFlags
    andi $v0, $v0, 0x0800
    srl $v0, $v0, 11
    jr $ra
