.text
.eqv BACKGROUND_1 0x10014000

	li $v0,48	#syscall para limpar a tela
	li $a0,0xFF  #fundo branco
	syscall
	
	la $a0, BACKGROUND_1
	jal UART_READ

	li $v0,48	#syscall para limpar a tela
	li $a0,0x00  #fundo diferente de branco
	syscall


	#la $a0, BACKGROUND_1
	#move $a1, $zero
	#lui $a1, 0 #x
	#ori $a1, $a1, 0 #y
	#jal printTile

	#la $a0, BACKGROUND_1
	#move $a1, $zero
	#lui $a1, 1 #x
	#ori $a1, $a1, 0 #y
	#jal printTile

	#la $a0, BACKGROUND_1
	#move $a1, $zero
	#lui $a1, 2 #x
	#ori $a1, $a1, 0 #y
	#jal printTile

	#la $a0, BACKGROUND_1
	#move $a1, $zero
	#lui $a1, 3 #x
	#ori $a1, $a1, 0 #y
	#jal printTile

	la $a0, BACKGROUND_1
	move $a1, $zero
	lui $a1, 3 #x
	ori $a1, $a1, 4 #y
	jal printTile



 li $s0, 0
 li $s1, 0
 li $s3, 16
 li $s4, 13
 LOOP:
 beq $s0, $s3, pulaLinha
 la $a0, BACKGROUND_1
 add $a1, $zero, $s0
 sll $a1, $a1, 16
 add $a1, $a1, $s1
 addi $s0, $s0, 1

 jal printTile
 j LOOP

 pulaLinha:
  beq $s1, $s4, EXIT
  addi $s1, $s1, 1
  add $s0, $zero, $zero
  j LOOP
	
EXIT:
	j EXIT

	.include "printImg.s"
	.include "tileset.s"
	.include "uartRead.s"
