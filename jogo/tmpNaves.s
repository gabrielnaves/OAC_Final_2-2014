.data #0x10010000
    BG_1: .word 0x00000000
    MBG_1: .word 0x00000000
    MAX_FRONT: .word 0x00000000

.text

main:
    li $a0, 3 # Numero de elementos no jogo
    jal loadGame
    la $t0, inputManagerFlags
    sw $zero, 0($t0)
##############################################################################################################
mainGameLoop:
    jal inputManagerUpdate
    jal updateMax
    j mainGameLoop
##############################################################################################################
.include "include.s"