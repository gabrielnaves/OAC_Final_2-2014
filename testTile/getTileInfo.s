#Dado um endereço de memória de uma matriz de movimentação, retornar o conteudo de uma posicao dessa matriz
#$v0 -> conteudo da posicao da matriz
#$a0 -> começo da matriz
#$a1 -> linha da matriz - 1
#$a2 -> coluna da matriz - 1

.text
FUNCAO:
	addi $t0, $zero, 4 #$t0 = 4
	mul $t0, $a1, $t0 #$t0 = 4*L
	add $t0, $t0, $a2 #$t0 = 4L + C (numero do byte a ser acessado)
	
	add $t0, $a0, $t0 #$t0 = posicao inicial da matriz + o que deve deslocar em bytes
	lb $v0, 0($t0) #carrega em $v0 o conteudo desejado
	jr $ra