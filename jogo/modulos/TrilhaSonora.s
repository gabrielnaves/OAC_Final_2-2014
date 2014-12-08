.data
CONTADOR_MUS: .word 0x00
TAMANHO_MUS: .word 0x0000a000
MUS_ATUAL: .word 0x00000000

.text

TocaMusica:

	lw $t5, CONTADOR_MUS
	lw $t3, TAMANHO_MUS
	lw $t4, MUS_ATUAL
	add $t4, $t4, $t3

	la $t0,0xFFFF0000	# Endereco base
	li $s0,3			#  os dois canais 011

	slt $t6, $t5, $t4
	bne $t6, $zero, Segue
		lw $t5, MUS_ATUAL 	# Se chegou ao fim da musica, recomeca

Segue:
	sw $zero,20($t0)	# Aviso ao CODEC que pode iniciar

J1: 	lw $t1,16($t0)		# Aguarda que as amostras L e R estejam prontas
	bne $t1,$s0,J1

	#lw $t2,0($t0)  #Le do canal R
	#lw $t3,4($t0)	#Le do canal L
	
	lw $t2, 0($t5)	# Le do arquivo
	lw $t3, 4($t5)
	
	sw $t2,8($t0)  # Escreve no Canal R 
	#sll $t3,$t2,2	# amplifica: x4 
	sw $t3,12($t0)  # Escreve no canal L

	sw $s0,20($t0)   # Avisa ao CODEC que está tudo lido e escrito
	
	addi $t5, $t5, 8 # próximo local da memoria
	
J2: 	lw $t3,16($t0)		# Aguarda o CODEC reconhecer
	bne $t3,$zero,J2

	sw $t5, CONTADOR_MUS

	jr $ra

###############################
#$a0 = endereço da musica nova#
###############################
trocaMus:
	sw $a0, MUS_ATUAL
	sw $a0, CONTADOR_MUS
	jr $ra
