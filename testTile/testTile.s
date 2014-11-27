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

	#la $a0, 0x10014000
	#la $a1, 0x00000000
	#jal printTile


	la $t7, 0xabcdaaac
	lh $s0, 0($t7) #x
    lh $s1, 2($t7) #y


EXIT:
	j EXIT

	.include "printImg.s"
	.include "uartRead.s"