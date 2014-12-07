#include <stdio.h>

char diminui(char c){
	if (c=='0'||c=='1'||c=='2'||c=='3'||c=='4'||c=='5'||c=='6'||c=='7'||c=='8'||c=='9')
		return c - 48;
	else
		return c - 87;
	
}

int main(){
	
	FILE *fp, *fp1;
	char c[8],k;
	int aux,i = 0;
	
	fp = fopen("compara_syscall_data.txt","r");
	fp1 = fopen("syscall_databin.txt","w+b");
	
	if (fp==NULL)
		return 0;
	while(!feof(fp)) {	
	
		fscanf(fp, "%s", c);
		printf("%s\n",c);
		
		c[0] = diminui(c[0]);	
		c[1] = diminui(c[1]);
		c[2] = diminui(c[2]);
		c[3] = diminui(c[3]);
		c[4] = diminui(c[4]);
		c[5] = diminui(c[5]);
		c[6] = diminui(c[6]);
		c[7] = diminui(c[7]);
		
		aux = ((c[0] << 4) | c[1] );
	    fwrite(&aux, sizeof(char), 1, fp1);	
	    aux = ((c[2] << 4) | c[3] );
	    fwrite(&aux, sizeof(char), 1, fp1);	
	    aux = ((c[4] << 4) | c[5] );
	    fwrite(&aux, sizeof(char), 1, fp1);	
	    aux = ((c[6] << 4) | c[7] );
	    fwrite(&aux, sizeof(char), 1, fp1);	

	}
	fclose(fp);
	fclose(fp1);
	return 0;
}
