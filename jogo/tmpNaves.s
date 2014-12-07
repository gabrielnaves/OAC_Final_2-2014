.data #0x10010000
    BG_0: .word 0x00000000
    MBG_0: .word 0x00000000
    BG_1: .word 0x00000000
    MBG_1: .word 0x00000000
    BG_2: .word 0x00000000
    MBG_2: .word 0x00000000
    BG_3: .word 0x00000000
    MBG_3: .word 0x00000000
    BG_4: .word 0x00000000
    MBG_4: .word 0x00000000
    BG_5: .word 0x00000000
    MBG_5: .word 0x00000000
    BG_6: .word 0x00000000
    MBG_6: .word 0x00000000
    BG_7: .word 0x00000000
    MBG_7: .word 0x00000000
    BG_8: .word 0x00000000
    MBG_8: .word 0x00000000
    BG_9: .word 0x00000000
    MBG_9: .word 0x00000000
    BG_10: .word 0x00000000
    MBG_10: .word 0x00000000
    BG_11: .word 0x00000000
    MBG_11: .word 0x00000000
    BG_12: .word 0x00000000
    MBG_12: .word 0x00000000
    BG_13: .word 0x00000000
    MBG_13: .word 0x00000000
    BG_14: .word 0x00000000
    MBG_14: .word 0x00000000
    BG_15: .word 0x00000000
    MBG_15: .word 0x00000000
    MAX_FRONT: .word 0x00000000
    MAX_BACK: .word 0x00000000
    MAX_RIGHT: .word 0x00000000
    MAX_LEFT: .word 0x00000000
    MATUAL: .space 0x000000E0
##############################################################################################################
    FRAME_COUNTER: .word 0x00000000
.text

main:
    li $a0, 36 # Numero de elementos no jogo
    jal loadGame
    sw $zero, inputManagerFlags # Zera as flags do inputManager
    # Define o mapa0 como BG_ATUAL
    lw $t0, BG_0
    sw $t0, BG_ATUAL
    # Printa o mapa
    li $a0, 0
    li $a1, 0
    lw $a2, BG_ATUAL
    jal printImg
    # Seta a posicao inicial do max (temporario)
    li $t0, 5
    sw $t0, maxPositionX
    li $t0, 5
    sw $t0, maxPositionY

    # Seta o lado inicial do max e o sprite inicial
    sw $zero, maxSide
    lw $t0, MAX_FRONT
    sw $t0, maxCurrentImage

    # printa o max
    jal printMax
    #coloca a matriz atual com o conteudo do matrix_mapa0
    lw $a0, MBG_0
    lw $a1, MATUAL
    jal copiaMatriz


##############################################################################################################
mainGameLoop:
    lw $t0, FRAME_COUNTER
    addi $t0, $t0, 1
    sw $t0, FRAME_COUNTER

    jal inputManagerUpdate
    jal updateMax
    jal updateMap
    j mainGameLoop
##############################################################################################################
.include "include.s"