.data #0x10010000
    BG_1: .word 0x00000000
    MBG_1: .word 0x00000000
    MAX_FRONT: .word 0x00000000
.eqv MAX_END_INI 0x10020005
.text

main:
    li $a0, 2 # Numero de elementos no jogo
    jal loadGame
    la $t0, inputManagerFlags
    sw $zero, 0($t0)

    ####inicializacao padrao
    la $v0,BG_1         #mapa 0
    la $v1,MAX_END_INI  #endereco inical do Max
    ####
selecionaMapa:
    move $a0,$v0
    move $a1,$v1
    jal mudaMapa

##############################################################################################################
mainGameLoop:
    jal inputManagerUpdate
    jal updateMax
    bne $v0,$zero,selecionaMapa

    jal updateMapa
    j mainGameLoop
##############################################################################################################
mudaMapa:
    jr $ra
updateMax:
    jr $ra
updateMapa:
    jr $ra

.include "include.s"
