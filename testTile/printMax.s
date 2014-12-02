.text
.eqv BACKGROUND 0x10014000
.eqv MAX_FRONT 0x10026c08

	li $v0,48	#syscall para limpar a tela
	li $a0,0xFF  #fundo branco
	syscall
	
	la $a0, BACKGROUND
	jal UART_READ

	li $v0,48	#syscall para limpar a tela
	li $a0,0x44  #fundo branco
	syscall


	la $a0, MAX_FRONT
	jal UART_READ

	li $v0,48	#syscall para limpar a tela
	li $a0,0x00  #fundo diferente de branco
	syscall

	la $a0, BACKGROUND
	move $a1, $zero
	lui $a1, 3 #x
	ori $a1, $a1, 4 #y
	jal printTile

	li $a0, 0
	li $a1, 0
	la $a2, BACKGROUND
	jal printImg

	li $a0, 20
	li $a1, 17
	la $a2, MAX_FRONT			#endereço da imagem na sram
	jal printImg


	li $s0, 60
	li $s1, 68

LOOP:
	jal inputManagerUpdate
	jal isButtonDown_Up
	bne $v0, $zero, CIMA
	jal isButtonDown_Down
	bne $v0, $zero, BAIXO
	j LOOP



	CIMA:
		la $a0, BACKGROUND
		move $a1, $zero
		add $a1, $s0, $zero
    	sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $s1 #y
		jal printTilePixel
		la $a0, BACKGROUND
		move $a1, $zero
		add $a1, $s0, $zero
    	sll $a1, $a1, 16 #x
		add $a1, $a1, $s1
		addi $a1, $a1, 17
		jal printTilePixel

		addi $s1, $s1, -17
		add $a0, $s0, $zero
		add $a1, $s1, $zero
		la $a2, MAX_FRONT			#endereço da imagem na sram
		jal printImg
		j LOOP
	BAIXO:
		la $a0, BACKGROUND
		move $a1, $zero
		add $a1, $s0, $zero
    	sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $s1 #y
		jal printTilePixel
		la $a0, BACKGROUND
		move $a1, $zero
		add $a1, $s0, $zero
    	sll $a1, $a1, 16 #x
		add $a1, $a1, $s1
		addi $a1, $a1, 17
		jal printTilePixel

		addi $s1, $s1, 17
		add $a0, $s0, $zero
		add $a1, $s1, $zero
		la $a2, MAX_FRONT			#endereço da imagem na sram
		jal printImg
		j LOOP


	
EXIT:
	j EXIT

	.include "printImg.s"
	.include "tileset.s"
	.include "uartRead.s"
	.include "inputManager.s"