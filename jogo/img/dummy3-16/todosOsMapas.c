
/**************************************************

file: demo_tx.c
purpose: simple demo that transmits characters to
the serial port and print them on the screen,
exit the program by pressing Ctrl-C

compile with the command: gcc demo_tx.c rs232.c -Wall -Wextra -std=c99 -o2 -o test_tx

**************************************************/

#include <stdlib.h>
#include <stdio.h>
         
#ifdef _WIN32
#include <Windows.h>
#else
#include <unistd.h>
#endif

#include "rs232.c"

int main(){
        //mandaArquivo("lamar.bin\0");
    mandaArquivo("lvl2mapa0.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa0_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa1.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa1_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa2.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa2_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa3.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa3_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa4.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa4_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa5.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa5_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa6.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa6_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa7.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa7_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa8.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa8_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa9.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa9_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa10.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa10_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa11.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa11_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa12.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa12_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa13.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa13_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa14.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa14_matriz.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa15.bin\0");
    Sleep(100);
    mandaArquivo("lvl2mapa15_matriz.bin\0");
    Sleep(100);
    //32

    mandaArquivo("max_parado_front.bin\0");
    Sleep(100);
    mandaArquivo("max_parado_back.bin\0");
    Sleep(100);
    mandaArquivo("max_parado_right.bin\0");
    Sleep(100);
    mandaArquivo("max_parado_left.bin\0");
    Sleep(100);
    mandaArquivo("max_1_front.bin\0");
    Sleep(100);
    mandaArquivo("max_1_back.bin\0");
    Sleep(100);
    mandaArquivo("max_1_right.bin\0");
    Sleep(100);
    mandaArquivo("max_1_left.bin\0");
    Sleep(100);
    //40

    mandaArquivo("movingBlock.bin\0");
    Sleep(100);
    mandaArquivo("movingBlock2.bin\0");
    Sleep(100);
    mandaArquivo("barrel.bin\0");
    Sleep(100);
    mandaArquivo("plant.bin\0");
    Sleep(100);
    mandaArquivo("key.bin\0");
    Sleep(100);
    mandaArquivo("bossKey.bin\0");
    Sleep(100);
    mandaArquivo("cherry.bin\0");
    Sleep(100);
    mandaArquivo("gancho.bin\0");
    Sleep(100);
    mandaArquivo("tabua.bin\0");
    Sleep(100);
    mandaArquivo("diamondRed.bin\0"); //50
    return 0;
}



int mandaArquivo(char *fileName)
{

  int cport_nr=4,        /* /dev/ttyS0 (COM1 on windows) */
      bdrate=115200;       /* 9600 baud */

  char mode[]={'8','N','1',0};
  int i = 0;

  char *buffer;
  long int lSize;
  size_t result;
//  FILE *arq = fopen("mips_rs232_computador.acbnna", "rb");
  FILE *arq = fopen(fileName, "rb");

  if(!arq){
    printf("Não abriu o arquivo");
            system("pause");
    return 0;
  }

  if(RS232_OpenComport(cport_nr, bdrate, mode))
  {
    printf("Can not open comport\n");
        system("pause");
    return(0);
  }
  printf("Abriu portas\n");
  
  // obtain file size:
  fseek (arq , 0 , SEEK_END);
  lSize = ftell (arq);
  rewind (arq);
  printf("lSize = %ld\n", lSize);

  // allocate memory to contain the whole file:
  buffer = (char*) malloc (sizeof(char)*lSize);
  if (buffer == NULL) {fputs ("Memory error",stderr); exit (2);}

   // copy the file into the buffer:
  result = fread (buffer,1,lSize,arq);
  if (result != lSize) {fputs ("Reading error",stderr); exit (3);}
  //printf("%d\n", result);
  //printf("\nbuffer: %s\n", buffer);


  //envia o que está no buffer
  /*printf("Aperte enter para enviar");
  getchar();
	RS232_cputs(cport_nr, buffer);
  //printf("sent: %s\n", buffer);

    #ifdef _WIN32
        Sleep(10);
    #else
        usleep(1000);  
    #endif*/

        
  while(lSize > 0)
  {
    RS232_SendByte(cport_nr, buffer[i]);

    //printf("sent: %c\n", buffer[i]);
    int j;
    for(j = 0; j < 1000; j++);
    i++;
    lSize--;
    
  }

  free (buffer);
  fclose(arq);
  RS232_CloseComport(cport_nr);  
  return 0;
}
