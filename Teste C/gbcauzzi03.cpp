
#include <stdio.h>
#define tamanho 6

int main()
{
unsigned  char vetor[tamanho],resultado=0,varre=0,xorr=0x00;




vetor[0]=0x02;
vetor[1]=0x01;
vetor[2]=0x56;
vetor[3]=0x78;
vetor[4]=0x91;
vetor[5]=0x10; //Bcc=AC


vetor[0]=0x02;
vetor[1]=0x01;
vetor[2]=0x05;
vetor[3]=0x55;
vetor[4]=0x91;
vetor[5]=0x10; //Bcc=d2

vetor[0]=0x02;
vetor[1]=0x01;
vetor[2]=0x06;
vetor[3]=0x55;
vetor[4]=0x91;
vetor[5]=0x10; //Bcc=d1

vetor[0]=0x03;
vetor[1]=0x01;
vetor[2]=0x05;
vetor[3]=0x55;
vetor[4]=0x91;
vetor[5]=0x10; //Bcc=d3


/*
vetor[0]=0x01;
vetor[1]=0x10;
vetor[2]=0x0A;
vetor[3]=0xB0;
vetor[4]=0x80;
vetor[5]=0x22;*/


for(varre=0;varre<=tamanho;varre++){
	
	printf("\n%x  ", vetor[varre]);
}

printf("\nXor abaixo  ");

for(varre=0;varre<=tamanho-1;varre++){
	xorr=vetor[varre]^xorr;
	printf("\n%x", xorr);
}



/*
resultado=vetor[0]^vetor[1];
printf("%x\n", vetor[0]);
printf("%x\n", vetor[1]);
printf("%x  ", resultado);
*/






}
