    .data
stringBotao_A:           .asciiz   "Botao A pressionado"
stringBotao_B:           .asciiz   "Botao B pressionado"
stringBotao_X:           .asciiz   "Botao X pressionado"
stringBotao_Y:           .asciiz   "Botao Y pressionado"
stringBotao_Start:       .asciiz   "Botao Start pressionado"
stringBotao_Select:      .asciiz   "Botao Select pressionado"
stringBotao_Right:       .asciiz   "Botao Right pressionado"
stringBotao_Up:          .asciiz   "Botao Up pressionado"
stringBotao_Left:        .asciiz   "Botao Left pressionado"
stringBotao_Down:        .asciiz   "Botao Down pressionado"
stringBotao_R:           .asciiz   "Botao R pressionado"
stringBotao_L:           .asciiz   "Botao L pressionado"

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
    ## Habilita deteccao de excecoes do teclado ##
    la $t0, 0x66666666
    li $t1, 1
    sw $t1, 0($t0)
    ## Limpa a tela ##
    li $v0, 48
    li $a0, 0x4B
    syscall
    la $t0, inputManagerFlags
    li $t1, 0
    sw $t1, 0($t0)
main:
    jal inputManagerUpdate

    la $t0, 0xFFFF0100 
    lw $s7, 0($t0)

botao_A:
    jal isButtonDown_A
    move $s2, $v0
    beq $v0, $zero, botao_B
    li $v0, 104
    la $a0, stringBotao_A
    li $a1, 2
    li $a2, 2
    li $a3, 0x4BB4
    syscall
botao_B:
    jal isButtonDown_B
    move $s3, $v0
    beq $v0, $zero, botao_X
    li $v0, 104
    la $a0, stringBotao_B
    li $a1, 2
    li $a2, 12
    li $a3, 0x4BB4
    syscall
botao_X:
    jal isButtonDown_X
    move $s4, $v0
    beq $v0, $zero, botao_Y
    li $v0, 104
    la $a0, stringBotao_X
    li $a1, 2
    li $a2, 22
    li $a3, 0x4BB4
    syscall
botao_Y:
    jal isButtonDown_Y
    move $s5, $v0
    beq $v0, $zero, botao_Start
    li $v0, 104
    la $a0, stringBotao_Y
    li $a1, 2
    li $a2, 32
    li $a3, 0x4BB4
    syscall
botao_Start:
    jal isButtonDown_Start
    beq $v0, $zero, botao_Select
    li $v0, 104
    la $a0, stringBotao_Start
    li $a1, 2
    li $a2, 42
    li $a3, 0x4BB4
    syscall
botao_Select:
    jal isButtonDown_Select
    beq $v0, $zero, botao_Right
    li $v0, 104
    la $a0, stringBotao_Select
    li $a1, 2
    li $a2, 52
    li $a3, 0x4BB4
    syscall
botao_Right:
    jal isButtonDown_Right
    beq $v0, $zero, botao_Up
    li $v0, 104
    la $a0, stringBotao_Right
    li $a1, 2
    li $a2, 62
    li $a3, 0x4BB4
    syscall
botao_Up:
    jal isButtonDown_Up
    beq $v0, $zero, botao_Left
    li $v0, 104
    la $a0, stringBotao_Up
    li $a1, 2
    li $a2, 72
    li $a3, 0x4BB4
    syscall
botao_Left:
    jal isButtonDown_Left
    beq $v0, $zero, botao_Down
    li $v0, 104
    la $a0, stringBotao_Left
    li $a1, 2
    li $a2, 82
    li $a3, 0x4BB4
    syscall
botao_Down:
    jal isButtonDown_Down
    beq $v0, $zero, botao_R
    li $v0, 104
    la $a0, stringBotao_Down
    li $a1, 2
    li $a2, 92
    li $a3, 0x4BB4
    syscall
botao_R:
    jal isButtonDown_R
    beq $v0, $zero, botao_L
    li $v0, 104
    la $a0, stringBotao_R
    li $a1, 2
    li $a2, 102
    li $a3, 0x4BB4
    syscall
botao_L:
    jal isButtonDown_L
    beq $v0, $zero, end
    li $v0, 104
    la $a0, stringBotao_L
    li $a1, 2
    li $a2, 112
    li $a3, 0x4BB4
    syscall

end:
    j main

    .include "inputManager.s"
