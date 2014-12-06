
.include "inicio.s"

main:
    li $a0, 3 # Numero de elementos no jogo
    jal loadGame
    la $t0, inputManagerFlags
    sw $zero, 0($t0)


    li $s0, 60 #x max
    li $s1, 68#y max
##############################################################################################################
mainGameLoop:

    jal inputManagerUpdate
    jal updateMax
    jal map0_main

    j mainGameLoop
##############################################################################################################

EXIT: j EXIT
    .include "include.s"