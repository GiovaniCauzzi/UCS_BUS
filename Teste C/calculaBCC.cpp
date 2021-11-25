
#include <stdio.h>
//#define tamanho 9

int main()
{
unsigned  char vetor[9],resultado=0,varre=0,xorr=0x00;

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

printf("Inputs");
vetor[0]=0x02;
vetor[1]=0x09;
vetor[2]=0x05;
vetor[3]=0x99;
vetor[4]=0x07;
vetor[5]=0x02; 
vetor[6]=0x32; 
vetor[7]=0x33; 
vetor[8]=0x34; //BCC=a7   02 09 05 99 07 02 32 33 34 a7 escreve 2 3 4 na  pos 2

//43 6f 6d 75 6e 69 63 20 64 65 20 64 61 64 6f 73

printf("Inputs");
vetor[0]=0x02;
vetor[1]=0x22;
vetor[2]=0x05;
vetor[3]=0x99;
vetor[4]=0x07;
vetor[5]=0x00; 
vetor[6]=0x43; 
vetor[7]=0x67; 
vetor[8]=0x6d; 
vetor[9]=0x75;
vetor[10]=0x6e;
vetor[11]=0x69;
vetor[12]=0x63;
vetor[13]=0x20;
vetor[14]=0x64;
vetor[15]=0x65;
vetor[16]=0x20;
vetor[17]=0x64;
vetor[18]=0x61;
vetor[19]=0x64;
vetor[20]=0x6f;
vetor[21]=0x73; //BCC=52   02 22 05 99 07 00 43 67 6d 75 6e 69 63 20 64 65 20 64 61 64 6f 73 52 escreve comucacao de dados

char tamanho=22;
for(varre=0;varre<=tamanho-1;varre++){
	
	printf("\n%x  ", vetor[varre]);
}

printf("\n\nXor abaixo  ");
xorr=0;
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
