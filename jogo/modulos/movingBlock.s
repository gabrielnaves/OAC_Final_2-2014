.data
	mvBlockPosX: .word 0x00000000
	mvBlockPosY: .word 0x00000000

.text

##TODO: parar de usar o .data para armazenar a posicao do bloco. O max deve informar ao bloco a sua posicao (do bloco) quando o chutar, 
##assim como a direcao para a qual mover

#move o bloco, se necessario, e o printa na tela, caso tenha movido
#TODO: apagar rastro
updateBlock:
    addi $sp, $sp, -4
    sw $ra, 0($sp)    

    jal moveBlock
    beq $v0, $zero, printBlockEnd #se nao mover o bloco, nao o printa

    jal printBlock

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

#Atualmente, move o bloco para a direcao data
#$a1 -> tiles em X para mover o bloco
#$a2 -> tiles em Y para mover o bloco
moveBlock:
    lw $t0, FRAME_COUNTER
    li $t1, 10000
    div $t0, $t1
    mfhi $t0
    bne $t0, $zero, dontMoveBlock #nao mover caso nao esteja dentro do tempo do frame
    ##nao mover se $a1 e $a2 forem 0
    bne $a1, $zero, willMoveBlock
    bne $a2, $zero, willMoveBlock
dontMoveEnd:
    move $v0, $zero
    jr $ra
willMoveBlock:
    lw $t1, mvBlockPosX
    add $t1, $t1, $a1
    sw $t1, mvBlockPosX #atualiza posicao em X
    lw $t1, mvBlockPosY
    add $t1, $t1, $a2
    sw $t1, mvBlockPosY #atualiza posicao em Y

    li $v0, 1
    jr $ra

printBlock:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    lw $a0, MVBLOCK
    lw $t0, mvBlockPosX
    sll $t0, $t0, 16
    lw $t1, mvBlockPosY
    or $a1, $t0, $t1
    jal printInTile
printBlockEnd:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
