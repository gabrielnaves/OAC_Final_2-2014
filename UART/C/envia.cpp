#include <iostream>
#include <cstdio>
#include <string>
#include <vector>
#include <cstdlib>
#include "rs232.c"

using namespace std;

void sleep(int n)
{
    for (int i = 0; i < n; ++i);
}

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
    int cport_nr=4, bdrate=115200;
    char mode[]={'8','N','2',0};
    unsigned char byte;
    FILE *fileIn;

    if(RS232_OpenComport(cport_nr, bdrate, mode))
    {
        printf("Can not open comport\n");
        return(0);
    }

    fileIn = fopen("mapalvl2.bin", "rb");
    int nbytes = 0;
    
    // ENVIA ARQUIVO PARA FPGA
    
    fread(&byte, sizeof(unsigned char), 1, fileIn);
    RS232_SendByte(cport_nr, byte);
    nbytes = nbytes | (byte << 24);
    
    fread(&byte, sizeof(unsigned char), 1, fileIn);
    RS232_SendByte(cport_nr, byte);
    nbytes = nbytes | (byte << 16);
    
    fread(&byte, sizeof(unsigned char), 1, fileIn);
    RS232_SendByte(cport_nr, byte);
    nbytes = nbytes | (byte << 8);
    
    fread(&byte, sizeof(unsigned char), 1, fileIn);
    RS232_SendByte(cport_nr, byte);
    nbytes = nbytes | byte;
    
    cout << nbytes << endl;
    
    while (true)
    //for (/*int i = 0*/; !feof(fileIn);/* ++i*/)
    {
        fread(&byte, sizeof(unsigned char), 1, fileIn);
        if (feof(fileIn)) break;
        RS232_SendByte(cport_nr, byte);
        sleep(1000);
    }

    fclose (fileIn);
    return 0;
}
