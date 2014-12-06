.text	
###########plota a barra de load####################
loadBar:
	addi $sp, $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)

	li $s2, 200 #y
linhasdeloadhorizontal:
	li $s1, 60 #x inicial
	li $s3, 260 #x final
	add $a0, $s1, $zero
	add $a1, $s2, $zero
	li $a2, 0x44
	li $v0, 45
	    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal Plot
    lw $ra, 0($sp)
    addi $sp, $sp, 4
	#linha de cima
	linhaLoadhorizontal:
		beq $s1, $s3, proximaLinhaloadhorizontal
		add $a0, $s1, $zero
		add $a1, $s2, $zero
		li $a2, 0x44
		li $v0, 45

		addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	jal Plot
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4

		addi $s1, $s1, 1
		j linhaLoadhorizontal

		proximaLinhaloadhorizontal:
			li $t0, 210
			beq $t0, $s2, linhasverticais
			li $s2, 210 #y
			j linhasdeloadhorizontal


linhasverticais:
	li $s2, 60 #agora é o x
linhasdeloadverticais:
	li $s1, 200 #y inicial
	li $s3, 210 #y final
	add $a0, $s2, $zero
	add $a1, $s1, $zero
	li $a2, 0x44
	li $v0, 45
	    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal Plot
    lw $ra, 0($sp)
    addi $sp, $sp, 4
	#linha da esquerda
	linhaLoadvertical:
		beq $s1, $s3, proximaLinhaloadvertical
		add $a0, $s2, $zero
		add $a1, $s1, $zero
		li $a2, 0x44
		li $v0, 45

		addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	jal Plot
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4

		addi $s1, $s1, 1
		j linhaLoadvertical


		proximaLinhaloadvertical:
			li $t0, 260
			beq $t0, $s2, preenchendoBarra
			li $s2, 260
			j linhasdeloadverticais


preenchendoBarra:
	li $s0, 201 #y inicial
	li $s1, 209 #y final
	li $s2, 61  #x inicial
	li $s3, 260 #x final
	loopPreencher:
		beq $s2, $s3, pulaPreencher
		add $a0, $s2, $zero
		add $a1, $s0, $zero
		li $a2, 0xff
		li $v0, 45

		addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	jal Plot
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4

		addi $s2, $s2, 1
		j loopPreencher

		pulaPreencher:
			beq $s0, $s1, fimLinhaload
			addi $s0, $s0, 1
			li $s2, 61
			j loopPreencher


fimLinhaload:
addi $a0, $zero, 260
addi $a1, $zero, 210
li $a2, 0x44
li $v0, 45
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal Plot
    lw $ra, 0($sp)
    addi $sp, $sp, 4


lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
addi $sp, $sp, 16
jr $ra



##################################################
#  Funcao para preencher a barra de load         #
#  Parametros:                                   #
#  $a0 -> numero do arquivo	que ja passou 		 #
#  $a1 -> numero total de arquivos               #
##################################################
preenchePorcentagem:#
	#tem que salvar os $s
	addi $sp, $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
	
	li $s0, 202 #y inicial
	li $s1, 209 #y final
	li $s2, 62  #x inicial
	li $s3, 258 #x final

	sub $t0, $s3, $s2
	mult $t0, $a0
	mflo $t0
	div $t0, $a1
	mflo $t0
	add $t0, $t0, $s2
	move $s3, $t0

	loopPreencherPorcetagem:
		beq $s0, $s1, pulaPreencherPorcetagem
		add $a0, $s2, $zero
		add $a1, $s0, $zero
		li $a2, 0x44
		li $v0, 45

		addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	jal Plot
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4

		addi $s0, $s0, 1
		j loopPreencherPorcetagem

		pulaPreencherPorcetagem:
			beq $s2, $s3, fimPorcentagem
			addi $s2, $s2, 1
			li $s0, 202
			j loopPreencherPorcetagem


fimPorcentagem:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
	addi $sp, $sp, 16

    jr $ra

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

loadGame:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    move $s0, $a0 # numero de arquivos para ler
    li $a0,0xaa  #fundo azul
    jal CLS
    ########
    jal loadBar
    ########
    li $s1, 0 #contador

    li $s2, 0x10010000 #.data
    li $s3, 0x10014000 # sram
    sw $s3, 0($s2)

    loadGameLoop:
        beq $s0, $s1, loadGameFim
        lw $s3, 0($s2)
        move $a0, $s3 #endereco para ser escrito na sram
        jal UART_READ
        add $t0, $s3, $v0 #endereco anterior mais o numero de bytes do arquivo anterior
        add $s2, $s2, 4 #aponta para a proxima label no .data
        sw $t0, 0($s2)  #altera essa label para o proximo endereco vago
        #printa alguma coisa referete ao load
        addi $s1, $s1, 1
        
        move $a0, $s1
        move $a1, $s0
        jal preenchePorcentagem

        j loadGameLoop
loadGameFim:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra