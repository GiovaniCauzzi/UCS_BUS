
#include <stdio.h>
//#define tamanho 6

int main()
{
unsigned  char vetor[7],resultado=0,varre=0,xorr=0x00;

/*printf("Determine um novo delay de display (segundos): ");
scanf("%f",&DELAY);*/

printf("Inputs");
vetor[0]=0x02;
vetor[1]=0x06;
vetor[2]=0x05;
vetor[3]=0x55;
vetor[4]=0x91;
vetor[5]=0x10; //BCC=d5    02 06 05 55 91 10 d5 tudo certo - comandos aleatorios

printf("Inputs");
vetor[0]=0x02;
vetor[1]=0x06;
vetor[2]=0x06;
vetor[3]=0x55;
vetor[4]=0x91;
vetor[5]=0x10; //BCC=d6     02 06 06 55 91 10 d6  endereco errado


printf("Inputs");
vetor[0]=0x03;
vetor[1]=0x06;
vetor[2]=0x05;
vetor[3]=0x55;
vetor[4]=0x91;
vetor[5]=0x10; //BCC=d4     03 06 05 55 91 10 d6  stx errado

printf("Inputs");
vetor[0]=0x02;
vetor[1]=0x06;
vetor[2]=0x05;
vetor[3]=0x99;
vetor[4]=0x03;
vetor[5]=0x01; //BCC=9a     02 06 05 99 03 01 9a  liga led 01

printf("Inputs");
vetor[0]=0x02;
vetor[1]=0x06;
vetor[2]=0x05;
vetor[3]=0x99;
vetor[4]=0x03;
vetor[5]=0x00; //BCC=9b     02 06 05 99 03 00 9b  desliga led 01

printf("Inputs");
vetor[0]=0x02;
vetor[1]=0x07;
vetor[2]=0x05;
vetor[3]=0x99;
vetor[4]=0x05;
vetor[5]=0x06; 
vetor[6]=0xff; //BCC=65      02 07 05 99 05 06 ff 65 pisca led01 6x a cada ff

printf("Inputs");
vetor[0]=0x02;
vetor[1]=0x07;
vetor[2]=0x05;
vetor[3]=0x99;
vetor[4]=0x07;
vetor[5]=0x80; 
vetor[6]=0x47; //BCC=59      02 07 05 99 07 80 47 59 coloca "47h" na pos 80 do display

printf("Inputs");
vetor[0]=0x02;
vetor[1]=0x07;
vetor[2]=0x05;
vetor[3]=0x99;
vetor[4]=0x07;
vetor[5]=0x85; 
vetor[6]=0x48; //BCC=53      02 07 05 99 07 85 48 53 coloca "48h" na pos 85 do display

printf("Inputs");
vetor[0]=0x02;
vetor[1]=0x07;
vetor[2]=0x05;
vetor[3]=0x99;
vetor[4]=0x07;
vetor[5]=0x80; 
vetor[6]=0x00; //BCC=1e      02 07 05 99 07 80 00 1e coloca "00h" na pos 80 do display

printf("Inputs");
vetor[0]=0x02;
vetor[1]=0x07;
vetor[2]=0x05;
vetor[3]=0x99;
vetor[4]=0x07;
vetor[5]=0x80; 
vetor[6]=0x32; //BCC=2c      02 07 05 99 07 80 32 2c coloca "32h" na pos 80 do display

char tamanho=7;
for(varre=0;varre<=tamanho;varre++){
	
	printf("\n%x  ", vetor[varre]);
}

printf("\n\nXor abaixo  ");

for(varre=0;varre<=tamanho-1;varre++){
	xorr=vetor[varre]^xorr;
	printf("\nXOR=%x", xorr);
}



/*
resultado=vetor[0]^vetor[1];
printf("%x\n", vetor[0]);
printf("%x\n", vetor[1]);
printf("%x  ", resultado);
*/






}
