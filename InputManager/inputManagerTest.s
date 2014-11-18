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
    beq $v0, $zero, botao_A_apaga
    li $v0, 104
    la $a0, stringBotao_A
    li $a1, 2
    li $a2, 2
    li $a3, 0x4BB4
    syscall
    j botao_B
botao_A_apaga:
    li $v0, 104
    la $a0, stringBotao_A
    li $a1, 2
    li $a2, 2
    li $a3, 0x4B4B
    syscall
botao_B:
    jal isButtonDown_B
    move $s3, $v0
    beq $v0, $zero, botao_B_apaga
    li $v0, 104
    la $a0, stringBotao_B
    li $a1, 2
    li $a2, 12
    li $a3, 0x4BB4
    syscall
    j botao_X
botao_B_apaga:
    li $v0, 104
    la $a0, stringBotao_B
    li $a1, 2
    li $a2, 12
    li $a3, 0x4B4B
    syscall
botao_X:
    jal isButtonDown_X
    move $s4, $v0
    beq $v0, $zero, botao_X_apaga
    li $v0, 104
    la $a0, stringBotao_X
    li $a1, 2
    li $a2, 22
    li $a3, 0x4BB4
    syscall
    j botao_Y
botao_X_apaga:
    li $v0, 104
    la $a0, stringBotao_X
    li $a1, 2
    li $a2, 22
    li $a3, 0x4B4B
    syscall
botao_Y:
    jal isButtonDown_Y
    move $s4, $v0
    beq $v0, $zero, botao_Y_apaga
    li $v0, 104
    la $a0, stringBotao_Y
    li $a1, 2
    li $a2, 32
    li $a3, 0x4BB4
    syscall
    j botao_Start
botao_Y_apaga:
    li $v0, 104
    la $a0, stringBotao_Y
    li $a1, 2
    li $a2, 32
    li $a3, 0x4B4B
    syscall
botao_Start:
    jal isButtonDown_Start
    beq $v0, $zero, botao_Start_apaga
    li $v0, 104
    la $a0, stringBotao_Start
    li $a1, 2
    li $a2, 42
    li $a3, 0x4BB4
    syscall
    j botao_Select
botao_Start_apaga:
    li $v0, 104
    la $a0, stringBotao_Start
    li $a1, 2
    li $a2, 42
    li $a3, 0x4B4B
    syscall
botao_Select:
    jal isButtonDown_Select
    beq $v0, $zero, botao_Select_apaga
    li $v0, 104
    la $a0, stringBotao_Select
    li $a1, 2
    li $a2, 52
    li $a3, 0x4BB4
    syscall
j botao_Right
botao_Select_apaga:
    li $v0, 104
    la $a0, stringBotao_Select
    li $a1, 2
    li $a2, 52
    li $a3, 0x4B4B
    syscall
botao_Right:
    jal isButtonDown_Right
    beq $v0, $zero, botao_Right_apaga
    li $v0, 104
    la $a0, stringBotao_Right
    li $a1, 2
    li $a2, 62
    li $a3, 0x4BB4
    syscall
    j botao_Up
botao_Right_apaga:
    li $v0, 104
    la $a0, stringBotao_Right
    li $a1, 2
    li $a2, 62
    li $a3, 0x4B4B
    syscall
botao_Up:
    jal isButtonDown_Up
    beq $v0, $zero, botao_Up_apaga
    li $v0, 104
    la $a0, stringBotao_Up
    li $a1, 2
    li $a2, 72
    li $a3, 0x4BB4
    syscall
    j botao_Left
botao_Up_apaga:
    li $v0, 104
    la $a0, stringBotao_Up
    li $a1, 2
    li $a2, 72
    li $a3, 0x4B4B
    syscall
botao_Left:
    jal isButtonDown_Left
    beq $v0, $zero, botao_Left_apaga
    li $v0, 104
    la $a0, stringBotao_Left
    li $a1, 2
    li $a2, 82
    li $a3, 0x4BB4
    syscall
    j botao_Down
botao_Left_apaga:
    li $v0, 104
    la $a0, stringBotao_Left
    li $a1, 2
    li $a2, 82
    li $a3, 0x4B4B
    syscall
botao_Down:
    jal isButtonDown_Down
    beq $v0, $zero, botao_Down_apaga
    li $v0, 104
    la $a0, stringBotao_Down
    li $a1, 2
    li $a2, 92
    li $a3, 0x4BB4
    syscall
    j botao_R
botao_Down_apaga:
    li $v0, 104
    la $a0, stringBotao_Down
    li $a1, 2
    li $a2, 92
    li $a3, 0x4B4B
    syscall
botao_R:
    jal isButtonDown_R
    beq $v0, $zero, botao_R_apaga
    li $v0, 104
    la $a0, stringBotao_R
    li $a1, 2
    li $a2, 102
    li $a3, 0x4BB4
    syscall
    j botao_L
botao_R_apaga:
    li $v0, 104
    la $a0, stringBotao_R
    li $a1, 2
    li $a2, 102
    li $a3, 0x4B4B
    syscall
botao_L:
    jal isButtonDown_L
    beq $v0, $zero, botao_L_apaga
    li $v0, 104
    la $a0, stringBotao_L
    li $a1, 2
    li $a2, 112
    li $a3, 0x4BB4
    syscall
    j end
botao_L_apaga:
    li $v0, 104
    la $a0, stringBotao_L
    li $a1, 2
    li $a2, 112
    li $a3, 0x4B4B
    syscall

end:
    j main

    .include "inputManager.s"
