#include<stdio.h>
int main(void)
{
   FILE *fp,*fp1;
   fp = fopen("syscall_data.mif","r+");
   fp1 = fopen("compara_syscall_data.txt","w+");
   char str3[8];
   int year, c;
   
   while(!feof(fp)) {
		c = fgetc(fp);
		c = fgetc(fp);
		c = fgetc(fp);
		c = fgetc(fp);
		c = fgetc(fp);
		c = fgetc(fp);
		c = fgetc(fp);
		c = fgetc(fp);
		c = fgetc(fp);
		c = fgetc(fp);
		fscanf(fp, "%s", str3);
		str3[8] = '\0';
		if(c==EOF)
			break;
			
		fprintf(fp1,"%s\n",str3);
		printf("%s\n",str3);
		while (c != EOF && c != '\n') c = fgetc(fp);
		c = 'k';
		
	}
}
