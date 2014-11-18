###############################################################
#  Arquivo de teste para o modulo printImg.                   #
#  O programa printa uma imagem localizada no segmento .data  #
#  segundo as convencoes adotadas para imagens na memoria.    #
#  A imagem deve estar no arquivo "printImgTestData.s"        #
###############################################################
    .data
imgStart:
    .include "printImgTestData.s"
    .text
main:
    ## Limpa a tela ##
    li $v0, 48
    li $a0, 0x004B
    syscall

    ## Printa a imagem ##
    li $a0, 143             # Posicao x da imagem
    li $a1, 90              # Posicao y da imagem
    la $a2, imgStart        # Endereco de inicio da imagem
    
    jal printImg
    
end:
    j end

    .include "printImg.s"