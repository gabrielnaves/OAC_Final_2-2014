#include <stdio.h>

int main(){
	char str1[8],str2[8],str3[8];
	FILE *fp,*fp1;
	
	fp = fopen("syscall.txt","r");
	fp1 = fopen("compara_syscall.txt","r");
	
	int i = 0;
	
	while (!feof(fp)){

		fscanf(fp, "%s", str1);
		fscanf(fp1, "%s", str2);
	
		if (strcmp(str1,str2)){
			printf("%s %s %d \n",str1,str2,i);
		}else
			//printf("ok %d\n",i);
			
			
		i++;
		
	}
	fclose(fp);
	fclose(fp1);
	
	return 0;
}
