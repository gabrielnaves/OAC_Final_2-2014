.data #0x10010000
BACKGROUND: .word 0x10014000 #isso é importante
MATRIX: .word 0x00000000
MAX_FRONT: .word 0x00000000
obj4: .word 0x00000000
obj5: .word 0x00000000
obj6: .word 0x00000000
obj7: .word 0x00000000
obj8: .word 0x00000000
obj9: .word 0x00000000
obj10: .word 0x00000000
obj11: .word 0x00000000
obj12: .word 0x00000000
obj13: .word 0x00000000
obj14: .word 0x00000000
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
	li $a0, 0
	li $a1, 0
	lw $a2, BACKGROUND
	jal printImg

	li $s0, 60
	li $s1, 68

LOOP:
	jal inputManagerUpdate


	#add $a1, $zero, $zero
	#move $a1, $s0
	#sll $a1, $a1, 16
	#add $a1, $a1, $s1
	#jal getTile

	#trap: j trap

	#add $a1, $zero, $v0
	#move $a1, $v0
	#ori $a2, $a1, 0x0000ffff
	#srl $a1, $a1, 16
	
	lw $a0, MATRIX
	div $a1, $s0, 20
	div $a2, $s1, 17
	jal getTileInfo
	move $t8, $v0
	#add $a0, $zero, $v0
	#addi $a1, $zero, 8
	#addi $a2, $zero, 8
	#addi $a3, $zero, 0x44ff
	#addi $v0, $a0, 1
	#syscall
	#add $v0, $zero, $a0


	jal isButtonDown_Up
	bne $v0, $zero, CIMA
	jal isButtonDown_Down
	bne $v0, $zero, BAIXO
	jal isButtonDown_Right
	bne $v0, $zero, DIREITA
	jal isButtonDown_Left
	bne $v0, $zero, ESQUERDA
	j LOOP


	CIMA:
		lw $a0, BACKGROUND
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $s1 #y
		jal printTilePixel
		lw $a0, BACKGROUND
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
		add $a1, $a1, $s1
		addi $a1, $a1, 17
		jal printTilePixel

		addi $s1, $s1, -17
		add $a0, $s0, $zero
		add $a1, $s1, $zero
		lw $a2, MAX_FRONT			#endereço da imagem na sram
		jal printImg
		j LOOP
	BAIXO:
		lw $a0, BACKGROUND
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $s1 #y
		jal printTilePixel
		lw $a0, BACKGROUND
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
		add $a1, $a1, $s1
		addi $a1, $a1, 17
		jal printTilePixel

		addi $s1, $s1, 17
		add $a0, $s0, $zero
		add $a1, $s1, $zero
		lw $a2, MAX_FRONT			#endereço da imagem na sram
		jal printImg
		j LOOP
	DIREITA:
		lw $a0, BACKGROUND
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $s1 #y
		jal printTilePixel
		lw $a0, BACKGROUND
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
		add $a1, $a1, $s1
		addi $a1, $a1, 17
		jal printTilePixel

		addi $s0, $s0, 20
		add $a0, $s0, $zero
		add $a1, $s1, $zero
		lw $a2, MAX_FRONT			#endereço da imagem na sram
		jal printImg
		j LOOP
	ESQUERDA:
		lw $a0, BACKGROUND
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $s1 #y
		jal printTilePixel
		lw $a0, BACKGROUND
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
		add $a1, $a1, $s1
		addi $a1, $a1, 17
		jal printTilePixel

		addi $s0, $s0, -20
		add $a0, $s0, $zero
		add $a1, $s1, $zero
		lw $a2, MAX_FRONT			#endereço da imagem na sram
		jal printImg
		j LOOP

	
EXIT:
	j EXIT
	.include "modulos/loadBar.s"
	.include "printImg.s"
	.include "modulos/tileset.s"
	.include "modulos/uartRead.s"
	.include "modulos/inputManager.s"
