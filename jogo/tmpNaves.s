.data #0x10010000
    BG_1: .word 0x00000000
    MBG_1: .word 0x00000000
    MAX_FRONT: .word 0x00000000
##############################################################################################################
    FRAME_COUNTER: .word 0x00000000
.text

main:
    li $a0, 3 # Numero de elementos no jogo
    jal loadGame
    sw $zero, inputManagerFlags # Zera as flags do inputManager
    # Printa o mapa
    li $a0, 0
    li $a1, 0
    lw $a2, BG_1
    jal printImg
    # Seta a posicao inicial do max (temporario)
    li $t0, 1
    sw $t0, maxPositionX
    li $t0, 2
    sw $t0, maxPositionY
    # printa o max
    jal printMax

##############################################################################################################
mainGameLoop:
    lw $t0, FRAME_COUNTER
    addi $t0, $t0, 1
    sw $t0, FRAME_COUNTER

    jal inputManagerUpdate
    jal updateMax
    j mainGameLoop
##############################################################################################################
.include "include.s"