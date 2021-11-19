
#include <stdio.h>

void teste(char um, char dois){
	
	if(um==NULL){
		printf("NULL");
		
		
	}else{
		printf("nao nulo");
		
	}
	
	
}

void func(char variav){
	teste(variav,0x00);
}


int main(void) {


	func(NULL);




}
