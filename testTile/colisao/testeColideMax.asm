.data #0x10010000
	BG_1: .word 0x10014000 #onde comeca a sram
	MBG_1: .word 0x00000000
	MAX_FRONT: .word 0x00000000
	
.text
	
	li $v0,48	#syscall para limpar a tela
	li $a0,0xFF  #fundo branco
	syscall
	
	li $v0,48	#syscall para limpar a tela
	li $a0,0xFF  #fundo branco
	syscall
	########
	#printa uma tela de load 
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
		j loadLoop

	fimLoad:
	
	li $v0,48	#syscall para limpar a tela
	li $a0,0xFF  #fundo branco
	syscall

	li $a0, 0
	li $a1, 0
	la $a2, BG_1
	lw $a2, 0($a2)
	jal printImg
	
	add $a1, $zero, $zero
	lui $a1, 140	#pos inicial x
	ori $a1, $a1, 85	#pos inicial y
	jal getTile
	
	srl $s0, $v0, 16 #i
	sll $s1, $v0, 16
	srl $s1, $s1, 16 #j
	
	la $a0, MAX_FRONT
	lw $a0, 0($a0)
	add $a1, $zero, $s0
	sll $a1, $a1, 16
	add $a1, $a1, $s1
	#move $a1, $v0
	jal printInTile
	
	# $s0: posição i do Max = x
	# $s1: posição j do Max = y 
	
	la $t0, inputManagerFlags
	sw $zero, 0($t0)
	move $v0, $zero
	
	maxMove:
		jal inputManagerUpdate
		jal isButtonDown_Up
		bne $v0, $zero, CIMA
		jal isButtonDown_Down
		bne $v0, $zero, BAIXO
		jal isButtonDown_Right
		bne $v0, $zero, DIREITA
		jal isButtonDown_Left
		bne $v0, $zero, ESQUERDA
		
		move $s7, $zero
		j maxMove
	
	CIMA:
		li $s7, 0x00005678
		
		addi $s2, $s1, -1

		add $a1, $zero, $s0
		add $a2, $zero, $s1
		la $a0, MBG_1
		lw $a0, 0($a0)
		jal getTileInfo
		
		li $t0, 0x2A
		bne $v0, $t0, maxMove
		
		#printa tile do BG
		
		#cima
		la $a0, BG_1
		lw $a0, 0($a0)
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $s1 #y
		jal printTile
		
		#baixo
		la $a0, BG_1
		lw $a0, 0($a0)
		addi $t0, $s1, 1
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $t0 #y
		jal printTile
		
		
		#printa Max na posição acima
		move $s1, $s2
		la $a0, MAX_FRONT
		lw $a0, 0($a0)
		add $a1, $zero, $s0
		sll $a1, $a1, 16
		add $a1, $a1, $s1
		jal printInTile
		
		j maxMove
		
	BAIXO:
		li $s7, 0x00001234
		
		addi $s2, $s1, 1
		addi $s3, $s1, 2

		add $a1, $zero, $s0
		add $a2, $zero, $s3
		la $a0, MBG_1
		lw $a0, 0($a0)
		jal getTileInfo
		
		li $t0, 0x2A
		bne $v0, $t0, maxMove
		
		#printa tile do BG
		
		#cima
		la $a0, BG_1
		lw $a0, 0($a0)
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $s1 #y
		jal printTile
		
		#baixo
		la $a0, BG_1
		lw $a0, 0($a0)
		addi $t0, $s1, 1
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $t0 #y
		jal printTile
		
		
		#printa Max na posição 
		move $s1, $s2
		la $a0, MAX_FRONT
		lw $a0, 0($a0)
		add $a1, $zero, $s0
		sll $a1, $a1, 16
		add $a1, $a1, $s1
		jal printInTile
	
		j maxMove
	DIREITA:
		li $s7, 0x12340000
	
		j maxMove
	ESQUERDA:
		li $s7, 0x56780000
	
		j maxMove
	
EXIT:
	j EXIT

	.include "printImg.s"
	.include "tileset.s"
	.include "uartRead.s"
	.include "inputManager.s"