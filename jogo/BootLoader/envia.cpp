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

int mandaArquivo(char *fileName)
{
	unsigned int timeSleep = 1;
	unsigned char byte;
	long int lSize;
	int cport_nr=4;
	FILE *arq = fopen(fileName, "rb");

	if(!arq){
		printf("Não abriu o arquivo de img");
		return 0;
	}
	// obtain file size:
	fseek (arq , 0 , SEEK_END);
	lSize = ftell (arq);
	rewind (arq);
	printf("lSize = %ld\n", lSize);

    
	while(true)
	{
		fread(&byte, sizeof(unsigned char), 1, arq);
		if (feof(arq)) break;
		RS232_SendByte(cport_nr, byte);
		sleep(100000);
   
	}
	fclose(arq);
	return 0;
}



int main()
{
	char c;
	unsigned int timeSleep = 1;
    int cport_nr=4, bdrate=115200, i = 0;
    char mode[]={'8','N','2',0};
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
    	return(0);
	}
	 if (arq[1]==NULL){
    	printf("Erro ao abrir Arquivo kdata\n");
    	return(0);
	}
	 if (arq[2]==NULL){
    	printf("Erro ao abrir Arquivo text\n");
    	return(0);
	}
	 if (arq[3]==NULL){
    	printf("Erro ao abrir Arquivo data\n");
    	return(0);
	}

	
    for (i=0;i<4;i++){
	    	
	    nbytes = 0;
	    fseek (arq[i] , 0 , SEEK_END);
	 	nbytes = ftell (arq[i]);
	  	rewind (arq[i]);
	  	printf("lSize = %u\n", nbytes);
	    
	    
	    // ENVIA ARQUIVO PARA FPGA
	
	    //fread(&byte, sizeof(unsigned char), 1, fileIn);
	    
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
	    //for (/*int i = 0*/; !feof(fileIn);/* ++i*/)
	    {
	        fread(&aux0, sizeof(unsigned char), 1, arq[i]);
	        if (feof(arq[i])) break;
	        fread(&aux1, sizeof(unsigned char), 1, arq[i]);
	        if (feof(arq[i])) break;
	        fread(&aux2, sizeof(unsigned char), 1, arq[i]);
	        if (feof(arq[i])) break;
	        fread(&aux3, sizeof(unsigned char), 1, arq[i]);
	        if (feof(arq[i])) break;
	        
	        RS232_SendByte(cport_nr, aux3);
	        //Sleep(1);
	        RS232_SendByte(cport_nr, aux2);
	        //Sleep(1);
	        RS232_SendByte(cport_nr, aux1);
	        //Sleep(1);
	        RS232_SendByte(cport_nr, aux0);
	        //Sleep(1);
	    }
	
	    fclose (arq[i]);
	    
	}
	RS232_CloseComport(cport_nr);
	
	printf("Pressione alguma tecla para enviar os arquivos do jogo");
	c = getchar();
	
	    if(RS232_OpenComport(cport_nr, bdrate, mode))
    {
        printf("Can not open comport\n");
        //return(0);
    }
	
	mandaArquivo("obj1.bin\0");
	Sleep(1);
    mandaArquivo("obj2.bin\0");
    Sleep(1);
    mandaArquivo("obj3.bin\0");
    Sleep(1);
    mandaArquivo("obj4.bin\0");
    Sleep(1);
    mandaArquivo("obj5.bin\0");
    Sleep(1);
    mandaArquivo("obj6.bin\0");
    Sleep(1);
    mandaArquivo("obj7.bin\0");
    Sleep(1);
    mandaArquivo("obj8.bin\0");
    Sleep(1);
    mandaArquivo("obj9.bin\0");
    Sleep(1);
    mandaArquivo("obj10.bin\0");
    Sleep(1);
    mandaArquivo("obj11.bin\0");
    Sleep(1);
    mandaArquivo("obj12.bin\0");
    Sleep(1);
    mandaArquivo("obj13.bin\0");
    Sleep(1);
    mandaArquivo("obj14.bin\0");
    Sleep(1);
    
	RS232_CloseComport(cport_nr);
    return 0;
}
