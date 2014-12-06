.text
updateMax:
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal isButtonDown_Up
	bne $v0, $zero, CIMA
	jal isButtonDown_Down
	bne $v0, $zero, BAIXO
	jal isButtonDown_Right
	bne $v0, $zero, DIREITA
	jal isButtonDown_Left
	bne $v0, $zero, ESQUERDA
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra



	CIMA:
		la $a0, BG_1
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $s1 #y
		jal printTilePixel
		la $a0, BG_1
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

		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
	BAIXO:
		la $a0, BG_1
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $s1 #y
		jal printTilePixel
		la $a0, BG_1
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
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
	DIREITA:
		la $a0, BG_1
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $s1 #y
		jal printTilePixel
		la $a0, BG_1
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
		add $a1, $a1, $s1
		addi $a1, $a1, 17
		jal printTilePixel

		addi $s0, $s0, 20
		add $a0, $s0, $zero
		add $a1, $s1, $zero
		la $a2, MAX_FRONT			#endereço da imagem na sram
		jal printImg
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
	ESQUERDA:
		la $a0, BG_1
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
  	  	add $a1, $a1, $s1 #y
		jal printTilePixel
		la $a0, BG_1
		move $a1, $zero
		add $a1, $s0, $zero
    		sll $a1, $a1, 16 #x
		add $a1, $a1, $s1
		addi $a1, $a1, 17
		jal printTilePixel

		addi $s0, $s0, -20
		add $a0, $s0, $zero
		add $a1, $s1, $zero
		la $a2, MAX_FRONT			#endereço da imagem na sram
		jal printImg

		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra