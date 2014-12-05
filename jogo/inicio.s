.data #0x10010000
obj1: .word 0x10014000 #isso é importante
obj2: .word 0x00000000
obj3: .word 0x00000000
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
	
main:
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
	li $s0, 14 #numero de arquivos
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
	la $a2, obj1
	lw $a2, 0($a2)
	jal printImg

	li $a0, 20
	li $a1, 0
	la $a2, obj2
	lw $a2, 0($a2)
	jal printImg


	li $a0, 40
	li $a1, 0
	la $a2, obj3
	lw $a2, 0($a2)
	jal printImg


	li $a0, 60
	li $a1, 0
	la $a2, obj4
	lw $a2, 0($a2)
	jal printImg


	li $a0, 80
	li $a1, 0
	la $a2, obj5
	lw $a2, 0($a2)
	jal printImg

	li $a0, 100
	li $a1, 0
	la $a2, obj6
	lw $a2, 0($a2)
	jal printImg

	li $a0, 120
	li $a1, 0
	la $a2, obj7
	lw $a2, 0($a2)
	jal printImg

	li $a0, 140
	li $a1, 0
	la $a2, obj8
	lw $a2, 0($a2)
	jal printImg

	li $a0, 160
	li $a1, 0
	la $a2, obj9
	lw $a2, 0($a2)
	jal printImg

	li $a0, 180
	li $a1, 0
	la $a2, obj10
	lw $a2, 0($a2)
	jal printImg

	li $a0, 200
	li $a1, 0
	la $a2, obj11
	lw $a2, 0($a2)
	jal printImg

	li $a0, 220
	li $a1, 0
	la $a2, obj12
	lw $a2, 0($a2)
	jal printImg

	li $a0, 240
	li $a1, 0
	la $a2, obj13
	lw $a2, 0($a2)
	jal printImg

	li $a0, 260
	li $a1, 0
	la $a2, obj14
	lw $a2, 0($a2)
	jal printImg



EXIT: j EXIT
	.include "modulos/loadBar.s"
	.include "modulos/uartRead.s"
	.include "modulos/inputManager.s"
	.include "modulos/printImg.s"
	.include "modulos/tileset.s"