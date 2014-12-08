#include <iostream>
#include <cstdio>
#include <string>
#include <vector>
#include <cstdlib>
#include "transmissao/rs232.c"
#include <windows.h>
using namespace std;

void sleep(int n)
{
    for (int i = 0; i < n; ++i);
}
static int cport_nr = 4,bdrate=115200;
static char mode[]={'8','N','2',0};

int mandaArquivo(char *fileName)
{
	unsigned char byte;
	long int lSize;
	FILE *arq = fopen(fileName, "rb");

	if(!arq){
		printf("Não abriu o arquivo de img");
		return -1;
	}
	// obtain file size:
	fseek (arq , 0 , SEEK_END);
	lSize = ftell (arq);
	rewind (arq);

    
	while(true)
	{
		fread(&byte, sizeof(unsigned char), 1, arq);
		if (feof(arq)) break;
		RS232_SendByte(cport_nr, byte);
		sleep(100000);
   
	}
	fclose(arq);
	return lSize;
}

int enviaBootLoader(){
    int i = 0;
    unsigned char byte, aux0,aux1,aux2,aux3;
    unsigned int nbytes = 0;
    FILE *arq[4];

    
    arq[0] = fopen("bootLoader/ktext.txt","rb");
    arq[1] = fopen("bootLoader/kdata.txt","rb");
    arq[2] = fopen("bootLoader/text.txt","rb");
    arq[3] = fopen("bootLoader/data.txt","rb");
    
    
    //Error Handling (fingindo)
    if(RS232_OpenComport(cport_nr, bdrate, mode))
    {
        printf("Can not open comport\n");
        //return(0);
    }
    if (arq[0]==NULL){
    	printf("Erro ao abrir Arquivo ktext\n");
    	return(-1);
	}
	 if (arq[1]==NULL){
    	printf("Erro ao abrir Arquivo kdata\n");
    	return(-1);
	}
	 if (arq[2]==NULL){
    	printf("Erro ao abrir Arquivo text\n");
    	return(-1);
	}
	 if (arq[3]==NULL){
    	printf("Erro ao abrir Arquivo data\n");
    	return(-1);
	}

	
    for (i=0;i<4;i++){
	    	
	    nbytes = 0;
	    fseek (arq[i] , 0 , SEEK_END);
	 	nbytes = ftell (arq[i]);
	  	rewind (arq[i]);
	  	printf("lSize = %u\n", nbytes);
	    
	    
	    // ENVIA ARQUIVO PARA FPGA
	    
	    //Envia o tamanho em bytes do arquivo para a FPGA
	    byte = nbytes >> 24;				//8 mais significativos
	    RS232_SendByte(cport_nr, byte);
	    byte = nbytes >> 16;
	    RS232_SendByte(cport_nr, byte);
	    byte = nbytes >> 8;
	    RS232_SendByte(cport_nr, byte);
	    byte = nbytes;						//8 menos significativos
	    RS232_SendByte(cport_nr, byte);
		Sleep(1);
	    //Envia o arquivo em si para a FPGA
	    while (true)
	    {
	        fread(&aux0, sizeof(unsigned char), 1, arq[i]);
	        if (feof(arq[i])) break;
	        fread(&aux1, sizeof(unsigned char), 1, arq[i]);
	        if (feof(arq[i])) break;
	        fread(&aux2, sizeof(unsigned char), 1, arq[i]);
	        if (feof(arq[i])) break;
	        fread(&aux3, sizeof(unsigned char), 1, arq[i]);
	        if (feof(arq[i])) break;
	        if(i>1){
	        	//.data e .text estao invertidos por causa do dump memory
	        	RS232_SendByte(cport_nr, aux3);
	        	RS232_SendByte(cport_nr, aux2);
	       		RS232_SendByte(cport_nr, aux1);
	        	RS232_SendByte(cport_nr, aux0);
	        }else{
	        	//.kdata e .ktext nao estao invertidos porque eu compilei eles a partir do mif
	        	RS232_SendByte(cport_nr, aux0);
	        	RS232_SendByte(cport_nr, aux1);
	        	RS232_SendByte(cport_nr, aux2);
	        	RS232_SendByte(cport_nr, aux3);
	        }

	    }
	
	    fclose (arq[i]);
	    
	}
	RS232_CloseComport(cport_nr);
	return 0;
}

int enviaObjetos(){
	int lSize = 0;
	
	if(RS232_OpenComport(cport_nr, bdrate, mode))
    {
        printf("Can not open comport\n");
        return(-1);
    }
	printf("Enviando Objetos: \n");
	
	lSize = mandaArquivo("img/objetos/movingBlock.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/objetos/movingBlock2.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/objetos/barrel.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/objetos/plant.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/objetos/key.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/objetos/bossKey.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/objetos/cherry.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/objetos/gancho.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/objetos/tabua.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/objetos/diamondRed.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
    
	RS232_CloseComport(cport_nr);
}

int enviaMapas(){
	
	int lSize = 0;
	
	if(RS232_OpenComport(cport_nr, bdrate, mode))
    {
        printf("Can not open comport\n");
        return(-1);
    }
	
	printf("Enviando Mapas: \n");
	
	//Exemplo
	//lSize = mandaArquivo("obj1.bin\0");
    //if(lSize > 0)
	//	printf("Enviando o Objeto de tamanho = %d",lSize);
	//else
	//	return -1;
	//Sleep(10);
   
	lSize = mandaArquivo("img/mapas/lvl2mapa0.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa0_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   ////////////////////////////////////////////////////////////
   
   	lSize = mandaArquivo("img/mapas/lvl2mapa1.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa1_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	////////////////////////////////////////////////////////////
		lSize = mandaArquivo("img/mapas/lvl2mapa2.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa2_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	///////////////////////////////////////////////////////////
		lSize = mandaArquivo("img/mapas/lvl2mapa3.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa3_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	///////////////////////////////////////////////////////////
		lSize = mandaArquivo("img/mapas/lvl2mapa4.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa4_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	///////////////////////////////////////////////////////////	
		lSize = mandaArquivo("img/mapas/lvl2mapa5.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa5_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	///////////////////////////////////////////////////////////	
		lSize = mandaArquivo("img/mapas/lvl2mapa6.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa6_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	///////////////////////////////////////////////////////////	
		lSize = mandaArquivo("img/mapas/lvl2mapa7.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa7_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	///////////////////////////////////////////////////////////	
		lSize = mandaArquivo("img/mapas/lvl2mapa8.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa8_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	///////////////////////////////////////////////////////////	
		lSize = mandaArquivo("img/mapas/lvl2mapa9.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa9_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	///////////////////////////////////////////////////////////	
		lSize = mandaArquivo("img/mapas/lvl2mapa10.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa10_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	///////////////////////////////////////////////////////////	
		lSize = mandaArquivo("img/mapas/lvl2mapa11.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa11_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	///////////////////////////////////////////////////////////	
		lSize = mandaArquivo("img/mapas/lvl2mapa12.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa12_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	///////////////////////////////////////////////////////////	
		lSize = mandaArquivo("img/mapas/lvl2mapa13.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa13_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	///////////////////////////////////////////////////////////	
		lSize = mandaArquivo("img/mapas/lvl2mapa14.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa14_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	///////////////////////////////////////////////////////////	
		lSize = mandaArquivo("img/mapas/lvl2mapa15.bin");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
   
    lSize = mandaArquivo("img/mapas/lvl2mapa15_matriz.bin");
	printf("Enviado o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
   
	RS232_CloseComport(cport_nr);
	
	return 0;
}

int enviaSeresVivos(){
			
	int lSize = 0;
	
	if(RS232_OpenComport(cport_nr, bdrate, mode))
    {
        printf("Can not open comport\n");
        return(-1);
    }
	printf("Enviando Seres Vivos: \n");
	
	//Exemplo
	//lSize = mandaArquivo("obj1.bin\0");
    //if(lSize > 0)
	//	printf("Enviando o Objeto de tamanho = %d",lSize);
	//else
	//	return -1;
	//Sleep(10);
	
	lSize = mandaArquivo("img/max/max_parado_front.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/max/max_parado_back.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/max/max_parado_right.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/max/max_parado_left.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/max/max_1_front.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/max/max_1_back.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/max/max_1_right.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	lSize = mandaArquivo("img/max/max_1_left.bin\0");
	printf("Enviando o Objeto de tamanho = %d\n",lSize);
	Sleep(10);
	
	
	RS232_CloseComport(cport_nr);
	return 0;
}

int enviaAudio(){
	
			
	int lSize = 0;
	
	
	if(RS232_OpenComport(cport_nr, bdrate, mode))
    {
        printf("Can not open comport\n");
        return(-1);
    }
	printf("Enviando Audio: \n");
	

	lSize = mandaArquivo("musica/assobio\0");
	printf("Enviando o Objeto de tamanho = %d",lSize);
	Sleep(10);
   
	lSize = mandaArquivo("musica/batida2\0");
	printf("Enviando o Objeto de tamanho = %d",lSize);
	Sleep(10);
   
	RS232_CloseComport(cport_nr);
	
	return 0;
	
}

int main()
{
	int errorHandler = 0,enviaTudo = 0;
	char c;
	
	printf("Envia tudo? ");
	c = getchar();
	while ( getchar() != '\n' ); //LIMPA BUFFER
	if (c =='s' || c == 'S' )
	{
		
		enviaBootLoader();
		Sleep(100);
		enviaMapas();
		enviaSeresVivos();
		enviaObjetos();
		enviaAudio();
		enviaTudo = 1;
	}

	
	if(enviaTudo == 0){
		
		printf("Envia Boot? ");
		c = getchar();
		while ( getchar() != '\n' ); //LIMPA BUFFER
		if (c =='s' || c == 'S' )
			errorHandler = enviaBootLoader();
		if (errorHandler==-1){
			printf("\n#####Erro interno####\n");
			return 0;
		}
	
		printf("Envia Mapas? ");
		c = getchar();
		while ( getchar() != '\n' ); //LIMPA BUFFER
		if (c =='s' || c == 'S' )
			errorHandler = enviaMapas();
		if (errorHandler==-1){
			printf("\n#####Erro interno####\n");
			return 0;
		}	
		
		printf("Envia Seres vivos? ");
		c = getchar();
		while ( getchar() != '\n' ); //LIMPA BUFFER
		if (c =='s' || c == 'S' )
			errorHandler = enviaSeresVivos();
		if (errorHandler==-1){
			printf("\n#####Erro interno####\n");
			return 0;
		}
		
		
		printf("Envia Objetos? ");
		c = getchar();
		while ( getchar() != '\n' ); //LIMPA BUFFER
		if (c =='s' || c == 'S' )
			errorHandler = enviaObjetos();
		if (errorHandler==-1){
			printf("\n#####Erro interno####\n");
			return 0;
		}		
		
		
		printf("Envia Audio? ");
		c = getchar();
		while ( getchar() != '\n' ); //LIMPA BUFFER
		if (c =='s' || c == 'S' )
			errorHandler = enviaAudio();
		if (errorHandler==-1){
			printf("\n#####Erro interno####\n");
			return 0;
		}
	}
    return 0;
}




















