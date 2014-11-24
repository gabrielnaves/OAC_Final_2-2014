
/**************************************************

file: demo_tx.c
purpose: simple demo that transmits characters to
the serial port and print them on the screen,
exit the program by pressing Ctrl-C

compile with the command: gcc demo_tx.c rs232.c -Wall -Wextra -std=c99 -o2 -o test_tx

**************************************************/

#include <iostream>
#include <string>
#include <vector>
#include <stdlib.h>
#include <stdio.h>

#ifdef _WIN32
#include <Windows.h>
#else
#include <unistd.h>
#endif

#include "rs232.c"

using namespace std;

int main()
{
  int cport_nr=7,        /* /dev/ttyS0 (COM1 on windows) */
      bdrate=115200;       /* 9600 baud */

  char mode[]={'8','N','2',0};
  int i = 0;

  unsigned char *buffer;
  long int lSize;
  size_t result;
  FILE *arq = fopen("max.bin", "rb");

  if(!arq){
    printf("Não abriu o arquivo");
    return 0;
  }

  if(RS232_OpenComport(cport_nr, bdrate, mode))
  {
    printf("Can not open comport\n");
    return(0);
  }
  printf("Abriu portas\n");
  // obtain file size:
  fseek (arq , 0 , SEEK_END);
  lSize = ftell (arq);
  rewind (arq);
  printf("lSize = %ld\n", lSize);

  // allocate memory to contain the whole file:
  buffer = (unsigned char*) malloc (sizeof(unsigned char)*lSize);
  if (buffer == NULL) {fputs ("Memory error",stderr); exit (2);}

  // copy the file into the buffer:
  result = fread (buffer,1,lSize,arq);
  if (result != lSize) {fputs ("Reading error",stderr); exit (3);}
        
  while(lSize > 0)
  {
    RS232_SendByte(cport_nr, buffer[i]);

    printf("sent: %x\n", buffer[i]);
    for(int j = 0; j < 1000; j++);
    i++;
    lSize--;
    
  }

  free (buffer);
  fclose(arq);
  return 0;
}
