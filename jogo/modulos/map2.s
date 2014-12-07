.text

##TODO: initMap devem atualizar a matrizAtual e printar os objetos na tela
#atualmente apenas printa 1 bloco movel numa posicao fixa
initMap2:
	addi $sp, $sp, -4
    sw $ra, 0($sp)

    jal printBlock

    li $t0, 8
    sw $t0, mvBlockPosX
    sw $t0, mvBlockPosY
    jal printBlock

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
##TODO: updateMap deve dar update de todos os tipos de objetos diferentes. Os proprio objetos saberao se devem ser atualizados ou nao
#atualmente move o bloco para a direita
updateMap2:
	addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $a1, 1
    li $a2, 0
    jal updateBlock

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra