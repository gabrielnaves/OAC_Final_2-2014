	.data # a partir do endereço 4 x 0x1000 = 0x4000
	.include "printImgTestData.s"
	.text
main:
	addi $sp, $sp, -4
	la $t0, LokiStart
	sw $t0, 0($sp)				# Endereço da imagem vai para a pilha
	li $a0, 143				# Posicao x
	li $a1, 90				# Posicao y
	li $a2, 34				# Largura do loki
	li $a3, 60				# Altura do loki
	
	jal printImg
	
	addi $sp, $sp, 4
	
	li $v0, 10
	syscall
	
	.include "printImg.s"