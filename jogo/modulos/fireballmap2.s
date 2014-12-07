.data
################################################
# Cada posicao da bola de fogo segue o padrao: #
# Posicao X na half word mais significativa    #
# Posicao Y na half word menos significativa   #
################################################
fireball1Pos: .word 0x00
fireball2Pos: .word 0x00
fireball3Pos: .word 0x00
fireball4Pos: .word 0x00

.text
##################################################################
# Inicializa a posicao das bolas de fogo (especificas do mapa 2) #
##################################################################
fireballInit:
    li $t0, 0x00030004
    sw $t0, fireball1Pos
    li $t0, 0x00060004
    sw $t0, fireball2Pos
    li $t0, 0x00090004
    sw $t0, fireball3Pos
    li $t0, 0x000c0004
    sw $t0, fireball4Pos
    jr $ra

##################################################################
# Update de todas as quatro bolas de fogo.                       #
# Se o mapa atual nao for o mapa #2, nao ha nada a fazer.        #
# Se for o mapa #2, atualiza as posicoes de cada fireball.       #
##################################################################
fireballUpdate:
    lw $t0, BG_2
    lw $t1, BG_ATUAL
    bne $t0, $t1, fireballUpdate_end # Se o mapa atual nao for o mapa 2, nao tem update
    addi $sp, $sp, -4
    sw $ra, 0($sp)
fireballUpdate_1:
    li $t0, 1000
    lw $t1, FRAME_COUNTER
    div $t1, $t0
    mfhi $t0
    bne $t0, $zero, fireballUpdate_2 # Se o frame nao corresponder, nao faz esse update
    lw $a0, fireball1Pos
    jal moveFireball
    sw $v0, fireball1Pos
    move $a0, $v0
    jal printFireball
fireballUpdate_2:
    li $t0, 6800
    lw $t1, FRAME_COUNTER
    div $t1, $t0
    mfhi $t0
    bne $t0, $zero, fireballUpdate_3 # Se o frame nao corresponder, nao faz esse update
    lw $a0, fireball2Pos
    jal moveFireball
    sw $v0, fireball2Pos
    move $a0, $v0
    jal printFireball
fireballUpdate_3:
    li $t0, 1300
    lw $t1, FRAME_COUNTER
    div $t1, $t0
    mfhi $t0
    bne $t0, $zero, fireballUpdate_4 # Se o frame nao corresponder, nao faz esse update
    lw $a0, fireball3Pos
    jal moveFireball
    sw $v0, fireball3Pos
    move $a0, $v0
    jal printFireball
fireballUpdate_4:
    li $t0, 3380
    lw $t1, FRAME_COUNTER
    div $t1, $t0
    mfhi $t0
    bne $t0, $zero, fireballUpdate_loadStack # Se o frame nao corresponder, nao faz esse update
    lw $a0, fireball4Pos
    jal moveFireball
    sw $v0, fireball4Pos
    move $a0, $v0
    jal printFireball
fireballUpdate_loadStack:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
fireballUpdate_end:
    jr $ra

#####
# Dada a posicao de uma fireball, a movimenta, verifica colisao com o max e retorna a nova posicao
# $a0 = posicao da fireball
#####
moveFireball:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    ## Verifica colisao com o max

    lw $t0, maxPositionX
    lw $t1, maxPositionY
    sll $t0, $t0, 16
    or $t0, $t0, $t1
    beq $t0, $a0, moveFireball_ColideComMax
    addi $a0, $a0, 1

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra