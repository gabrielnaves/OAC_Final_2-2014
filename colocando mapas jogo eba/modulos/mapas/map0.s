.text

map0_main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

