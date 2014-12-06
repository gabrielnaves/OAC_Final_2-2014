.text
	
	li $v0,48	#syscall para limpar a tela
	li $a0,0xaa  #fundo branco
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal CLS
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	########
	jal loadBar
	########
	li $s0, 3 #numero de arquivos
	li $s1, 0 #contador

	li $s2, 0x10010000 #.data

	loadLoop:
		beq $s0, $s1, fimLoad
		lw $s3, 0($s2)
		move $a0, $s3 #endereco para ser escrito na sram
		jal UART_READ
		add $t0, $s3, $v0 #endereco anterior mais o numero de bytes do arquivo anterior
		add $s2, $s2, 4 #aponta para a proxima label no .data
		sw $t0, 0($s2)	#altera essa label para o proximo endereco vago
		#printa alguma coisa referete ao load
		addi $s1, $s1, 1
		
		move $a0, $s1
		move $a1, $s0
		jal preenchePorcentagem

		j loadLoop

fimLoad:

