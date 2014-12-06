.data #0x10010000
    BG_1: .word 0x00000000
    MBG_1: .word 0x00000000
    MAX_FRONT: .word 0x00000000

.text

main:
    li $a0, 3 # Numero de elementos no jogo
    jal loadGame
    sw $zero, inputManagerFlags
    li $t0, 1
    sw $t0, maxPositionX
    sw $t0, maxPositionY
    #li $a0, 0
    #li $a1, 0
    #lw $a2, MAX_FRONT
    #jal printImg
    jal printMax
##############################################################################################################
mainGameLoop:
    jal inputManagerUpdate
    jal updateMax
    j mainGameLoop
##############################################################################################################
.include "include.s"