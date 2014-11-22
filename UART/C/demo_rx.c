
/**************************************************

file: demo_rx.c
purpose: simple demo that receives characters from
the serial port and print them on the screen,
exit the program by pressing Ctrl-C

compile with the command: gcc demo_rx.c rs232.c -Wall -Wextra -o2 -o test_rx

**************************************************/

#include <stdlib.h>
#include <stdio.h>

#ifdef _WIN32
#include <Windows.h>
#else
#include <unistd.h>
#endif

#include <string.h>
#include "rs232.h"

int colocaLugarCerto(unsigned char buf[], int tam){
  int aux, auxsoma = 0, i;

  for(i = 0; i < tam; i++){
    aux = buf[i] << (8 * i);
    //printf("aux = %d\t buf[%d] = %c = %d\n", aux, i, buf[i], buf[i]);
    if(i != 0)
      auxsoma += aux;
    else
      auxsoma = buf[i];
  }

  return auxsoma;
}

int main()
{
  int i, n,
      cport_nr=11,        /* /dev/ttyS0 (COM1 on windows) */
      bdrate=115200;       /* 9600 baud */
  int cont;

  unsigned char buf[4096], contbuf[4], c;
  FILE *arq = fopen("mips_rs232_computador.acbnna","wb");

  if(!arq)
    return 0;

  char mode[]={'8','N','2',0};


  if(RS232_OpenComport(cport_nr, bdrate, mode)){
    printf("Can not open comport\n");

    return(0);
  }

  buf[0] = '\0';
  n = 0;
  cont = 0;
  while(cont < 4){
      n = RS232_PollComport(cport_nr, &c, 1);
      if(n > 0){
        printf("n = %d\n", n);
        contbuf[cont] = c;
        cont++;
        contbuf[cont] = '\0';
        printf("buf[0] = %c = %d\n", buf[0], buf[0]);
        printf("buf[1] = %c = %d\n", buf[1], buf[1]);
        printf("buf[2] = %c = %d\n", buf[2], buf[2]);
        printf("buf[3] = %c = %d\n\n", buf[3], buf[3]);

        printf("\n c = %c = %d", c, c);

        printf("contbuf[0] = %c = %d\n", contbuf[0], contbuf[0]);
        printf("contbuf[1] = %c = %d\n", contbuf[1], contbuf[1]);
        printf("contbuf[2] = %c = %d\n", contbuf[2], contbuf[2]);
        printf("contbuf[3] = %c = %d\n", contbuf[3], contbuf[3]);
      }
    }
  

  cont = colocaLugarCerto(contbuf, 4);
  //fwrite(&cont, sizeof(int), 1, arq);
  fwrite(&contbuf[3], sizeof(char), 1, arq);
  fwrite(&contbuf[2], sizeof(char), 1, arq);
  fwrite(&contbuf[1], sizeof(char), 1, arq);
  fwrite(&contbuf[0], sizeof(char), 1, arq);
  printf("cont: %d\n", cont);

  while(cont > 0){
      n = RS232_PollComport(cport_nr, buf, 4096);

      if(n > 0){
        cont -= n;
        buf[n] = 0;   // always put a "null" at the end of a string! 
        fwrite(buf, sizeof(char), n, arq);

        for(i=0; i < n; i++){
          if(buf[i] < 32){  // replace unreadable control-codes by dots 
            //buf[i] = '.';
            printf("%d ", buf[i]);
          }
        }
        printf("\nreceived %i bytes buf: %s\n", n, (char *)buf);
      }

    }


  fclose(arq);
  return(0);
}

