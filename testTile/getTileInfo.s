#Dado um endere�o de mem�ria de uma matriz de movimenta��o, retornar o conteudo de uma posicao dessa matriz
#$v0 -> conteudo da posicao da matriz
#$a0 -> come�o da matriz
#$a1 -> x
#$a2 -> y

.text
getTileInfo:
	addi $t0, $zero, 16 
	mult $a2, $t0
	mflo $t0
	add $t0, $t0, $a1 
	
	add $t0, $a0, $t0 
	lb $v0, 0($t0) #carrega em $v0 o conteudo desejado
	jr $ra