.data
	addrdados: .word 0x10010004 #aqui tem aquele endereço loco de MBG_1
	dados: .word 1 2 3 4 5 #dados efetivos (o que tem em BG1 de verdade, só que tá lá na sram)
	espaco: .space 0x00000014 #mesmo tamanho de dados
	
.text
	lw $s0, addrdados
	la $s1, espaco
	
	#move $s1, $s0  #nao funciona, nao confiem, serio, olha, serio, nao da
	
	li $t0, 0x00000014
	loopPreencheSpace:
		beq $t0, $zero, AGORASIM
		lw $t1, 0($s0)
		sw $t1, 0($s1)
		
		addi $s0, $s0, 4
		addi $s1, $s1, 4
		addi $t0, $t0, -1
		
		j loopPreencheSpace
	AGORASIM: