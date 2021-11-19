#include <stdio.h>

int main(void){
	
	char estado=0x00;
	
	char maqEstados[15]={10,15,16,17,18,19};
	char flag=0x01;
	
	
	while (flag==0x01){
	switch (estado){
	case 0x00:
		printf("Estado=%x\n", estado);
		estado=0x01;
		break;
	case 0x01:
		printf("Estado=%x\n", estado);
		estado=0x02;
		break;
		case 0x02:
		printf("Estado=%x\n", estado);
		estado=0x03;
		flag++;
		break;
	
	}
}
	
	
	
	
	
}






