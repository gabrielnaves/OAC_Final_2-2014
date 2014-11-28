###########################################
# Argumentos:
# 	$a0: endereço para leitura dos bytes
#
# NOTA: Os primeiros 4 bytes de $a0 devem ser a quantidade de bytes a serem enviados
# NOTA2: eu não me importo com temporários
###########################################

UART_WRITE:
###################
# a0: endereço dos bytes a serem escritos
# t0: endereço do rs232
#
# t1: setar start
# t2: quantidade de bytes a serem lidos
# t7: byte lido
# s0: registrador de debug
###################
	move $t0, $zero
	move $t1, $zero
	move $t2, $zero
	move $t3, $zero
	move $t4, $zero
	move $t5, $zero
	move $t6, $zero
	move $t7, $zero
	move $t8, $zero
	move $t9, $zero

	addi $sp, $sp, -4
    sw $s0, 0($sp)

	addi	$sp, $sp, -4		# Aloca na Pilha
	sw	$ra, 0 ($sp)		# Guarda na Pilha o ra
	
	li 	$t1, 1
	lw 	$t2, 0($a0)		# Le o numero de bytes a serem transmitidos
	addi	$a0, $a0, 4		# Pula para os dados a serem mandados
	la 	$t0, 0xFFFF0120		# Endereço de interface da RS 232

	#la 	$t0, dados3
	#li $t2, 26  			#isso aqui não deve estar aqui
	#j UART_WRITE_LOOP 		#isso aqui não deve estar aqui

	add 	$t7, $zero, $t2	
	
	sb 	$t7, 4($t0) 		# byte 1
	sb 	$t1, 8($t0) 		# controle: start 1
	sb 	$zero, 8($t0)		# start 0
	andi 	$s0, $t7, 0x00ff	# Pega o byte menos significativo
	#add $s0,$s0,$t7

	jal	SLEEP			# SLEEP
	
	
	srl 	$t7, $t7, 8		# alinha os proximos bytes na menor posicao de memoria
	sb 	$t7, 4($t0)		# byte 2
	sb 	$t1, 8($t0) 		# controle: start 1
	sb 	$zero, 8($t0) 		# start 0
	andi 	$t4, $t7, 0x00FF	# Pega o byte menos significativo
	sll  	$t4, $t4, 8		# Alinha para a concatenacao
	add  	$s0, $s0,$t4		# Soma no registrador debug

	jal	SLEEP			# SLEEP
	
	srl 	$t7, $t7, 8
	sb 	$t7, 4($t0) 		# byte 3
	sb	$t1, 8($t0) 		# controle: start 1
	sb 	$zero, 8($t0) 		# start 0
	andi 	$t4, $t7, 0x00FF	# Pega o byte menos significativo
	sll  	$t4, $t4, 16		# Alinha para a concatenacao
	add  	$s0, $s0,$t4		# Soma no registrador debug
	
	jal	SLEEP			# SLEEP
	
	srl 	$t7, $t7, 8
	sb 	$t7, 4($t0) 		#byte 4
	sb 	$t1, 8($t0) 		#controle: start 1
	sb 	$zero, 8($t0) 		#start 0
	andi 	$t4, $t7, 0x00FF	# Pega o byte menos significativo
	sll  	$t4, $t4, 24		# Alinha para a concatenacao
	add  	$s0, $s0,$t4		# Soma no registrador debug

	jal	SLEEP			# SLEEP
	
	UART_WRITE_LOOP:	
		lb $t7, 0($a0)
		
		sb $t7, 4($t0) 		#dado
		sb $t1, 8($t0) 		#controle: start 1
		sb $zero, 8($t0) 	#start 0
		
		jal	SLEEP		# Sleep 
		
		
		addi $t2, $t2, -1
		addi $a0, $a0, 1	# Proximo byte
		
		bne $t2, $zero, UART_WRITE_LOOP
	
	lw	$ra, 0($sp)		# Valor de retorno
	addi	$sp, $sp, 4		# Desaloca

	lw $s0, 0($sp)
	addi $sp, $sp, 4

	jr 	$ra


SLEEP:	
###########################################
# Metodo sleep necessario para a RS232 acompanhar o clock do mips
# 
###########################################
		#jr	$ra		# Para o debug
		li 	$t9, 1000
	slp_loop:	
		addi 	$t9, $t9, -1
		bne 	$t9, $zero, slp_loop
	jr	$ra