.data #0x10010000
	BG_1: .word 0x10014000 #onde comeca a sram
	MBG_1: .word 0x00000000
	MAX_FRONT: .word 0x00000000
.text
	
main:
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
	#li $a0, 0
	#li $a1, 0
	#la $a2, BG_1
	#lw $a2, 0($a2)
	#jal printImg
	
	li $v0,48	#syscall para limpar a tela
	li $a0,0x44  #fundo branco
	syscall
	
	la $a0, BG_1
	move $a1, $zero
	lui $a1, 3 #x
	ori $a1, $a1, 4 #y
	jal printTile
	
	la $s0, MBG_1
	lw $a0, 0($s0)
	lui $a1, 3 #x
	ori $a1, $a1, 4 #y
	jal atTile
	

EXIT: j EXIT
	.include "uartRead.s"
	.include "printImg.s"
	.include "tileset.s"