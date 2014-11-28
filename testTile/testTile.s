.text

	li $v0,48	#syscall para limpar a tela
	li $a0,0xFF  #fundo branco
	syscall
	
	la $a0, 0x10014000
	jal UART_READ

	li $v0,48	#syscall para limpar a tela
	li $a0,0x44  #fundo diferente de branco
	syscall


	#imprime background
	li $a0, 0				# Posicao x
	li $a1, 0				# Posicao y
	la $a2, 0x10014000			#endereço da imagem na sram
	jal printImg

	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 0 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 1 #x
	ori $a1, $a1, 1 #y
	jal printTile
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 0 #x
	ori $a1, $a1, 16 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 120 #x
	ori $a1, $a1, 120 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 20 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 40 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 60 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 80 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 100 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 120 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 140 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 160 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 180 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 200 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 220 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 240 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 260 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 280 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel
	
	la $a0, 0x10014000
	move $a1, $zero
	lui $a1, 300 #x
	ori $a1, $a1, 0 #y
	jal printTilePixel


EXIT:
	j EXIT

	.include "printImg.s"
	.include "tileset.s"
	.include "uartRead.s"
