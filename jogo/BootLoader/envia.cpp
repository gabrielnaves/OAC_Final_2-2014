#include <iostream>
#include <cstdio>
#include <string>
#include <vector>
#include <cstdlib>
#include "rs232.c"
#include <windows.h>
using namespace std;

void sleep(int n)
{
    for (int i = 0; i < n; ++i);
}
static int cport_nr = 5,bdrate=115200;
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
	//printf("lSize = %ld\n", lSize);

    
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
    //FILE *fileIn;
    FILE *arq[4];

    //fileIn = fopen("mapalvl2.bin", "rb");
    
    arq[0] = fopen("ktext.txt","rb");
    arq[1] = fopen("kdata.txt","rb");
    arq[2] = fopen("text.txt","rb");
    arq[3] = fopen("data.txt","rb");
    
    
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
	
	lSize = mandaArquivo("obj1.bin\0");
	if(lSize > 0)
		printf("Enviando o Objeto de tamanho = %d\n",lSize);
	else
		return -1;
    
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
   
   lSize = mandaArquivo("lvl2mapa2.bin");
    if(lSize > 0)
		printf("Enviando o Objeto de tamanho = %d\n",lSize);
	else
		return -1;
	Sleep(10);
   
    lSize = mandaArquivo("lvl2mapa2_matriz.bin");
    if(lSize > 0)
		printf("Enviando o Objeto de tamanho = %d\n",lSize);
	else
		return -1;
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
	
	lSize = mandaArquivo("max_parado_front.bin\0");
    if(lSize > 0)
		printf("Enviando o Objeto de tamanho = %d\n",lSize);
	else
		return -1;
	Sleep(10);
	
	lSize = mandaArquivo("max_parado_back.bin\0");
    if(lSize > 0)
		printf("Enviando o Objeto de tamanho = %d\n",lSize);
	else
		return -1;
	Sleep(10);
	
	lSize = mandaArquivo("max_parado_right.bin\0");
    if(lSize > 0)
		printf("Enviando o Objeto de tamanho = %d\n",lSize);
	else
		return -1;
	Sleep(10);
	
	lSize = mandaArquivo("max_parado_left.bin\0");
    if(lSize > 0)
		printf("Enviando o Objeto de tamanho = %d\n",lSize);
	else
		return -1;
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
	
	//Exemplo
	//lSize = mandaArquivo("obj1.bin\0");
    //if(lSize > 0)
	//	printf("Enviando o Objeto de tamanho = %d",lSize);
	//else
	//	return -1;
	//Sleep(10);
   
	RS232_CloseComport(cport_nr);
	
	return 0;
	
}

int main()
{
	int errorHandler = 0;
	char c;
	
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
	
	
	printf("Envia Objetos? ");
	c = getchar();
	while ( getchar() != '\n' ); //LIMPA BUFFER
	if (c =='s' || c == 'S' )
		errorHandler = enviaObjetos();
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
	
	
	printf("Envia Audio? ");
	c = getchar();
	while ( getchar() != '\n' ); //LIMPA BUFFER
	if (c =='s' || c == 'S' )
		errorHandler = enviaAudio();
	if (errorHandler==-1){
		printf("\n#####Erro interno####\n");
		return 0;
	}
	
    return 0;
}




















