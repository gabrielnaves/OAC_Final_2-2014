.data #0x10010000
    BG_1: .word 0x00000000
    MBG_1: .word 0x00000000
    MAX_FRONT: .word 0x00000000
    MAX_BACK: .word 0x00000000
    MAX_RIGHT: .word 0x00000000
    MAX_LEFT: .word 0x00000000
    MAX_2_FRONT: .word 0x00000000
    MAX_2_BACK: .word 0x00000000
    MAX_2_RIGHT: .word 0x00000000
    MAX_2_LEFT: .word 0x00000000
    MVBLOCK: .word 0x00000000
##############################################################################################################
    FRAME_COUNTER: .word 0x00000000
.text

main:
    li $a0, 11 # Numero de elementos no jogo
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
    # Seta o lado inicial do max e o sprite inicial
    sw $zero, maxSide
    lw $t0, MAX_FRONT
    sw $t0, maxCurrentImage
    # Seta o estado inicial do max
    sw $zero, maxCurrentState
    # printa o max
    jal printMax

    #inicializa o mapa atual, TODO: fazer um initMap generico que inicialize a matrizAtual e printe todos os objetos na tela
    jal initMap2
##############################################################################################################
mainGameLoop:
    lw $t0, FRAME_COUNTER
    addi $t0, $t0, 1
    sw $t0, FRAME_COUNTER

    jal inputManagerUpdate
    jal updateMap2 #TODO: usar um updateMap genérico
    jal updateMax
    j mainGameLoop
##############################################################################################################
.include "include.s"
