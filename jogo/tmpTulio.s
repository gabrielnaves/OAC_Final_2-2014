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

    ####inicializacao padrao do mapa
    #lw $a0,BG_1         #mapa 0
    #la $a1,MAX_END_INI  #endereco inical do Max
    #jal mudaMapa

    li $a0, 0
    li $a1, 0
    lw $a2, BG_1
    jal printImg

    ##print inicial do max
    # li $a0, 20
    # li $a1, 17
    # lw $a2, MAX_FRONT           #endereço da imagem na sram
    # jal printImg

    jal startMax
    jal printMax
##############################################################################################################
mainGameLoop:
    jal inputManagerUpdate
    jal updateMax
    li $v0,0
    bne $v0,$zero,mudaMapa

    jal updateMapa
    j mainGameLoop
##############################################################################################################
mudaMapa:
    jr $ra

updateMapa:
    jr $ra

#####
#a0 = x inicial
#a1 = y inicial
#####
startMax:
    addi $t0, $zero,5
    sw $t0, maxPositionX
    sw $t0, maxPositionY
    jr $ra

.include "include.s"
