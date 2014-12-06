##########funcoes do antigo syscall#############
#####clear screen######
#######################
#  CLS	              #
#  $a0	=  cor        #
#######################
 CLS:	
 	la $t6,0xFF000000  # Memoria VGA
	la $t2,0xFF012C00  # Fim da memorai vga
Fort3:  beq $t2,$t6, Endt3
	sb $a0,0($t6)
	addi $t6, $t6, 1
	j Fort3
Endt3:  jr $ra





########Plot###########
#######################
#  Plot	              #
#  $a0	=  x          #
#  $a1	=  y          #
#  $a2	=  cor        #
#######################
Plot:
	li $at,320  
	mult $a1,$at
	mflo $a1
	add $a0,$a0,$a1
	la $a1, 0xFF000000   #endereco VGA
	or $a0,$a0,$a1
	sb $a2,0($a0)
	jr $ra