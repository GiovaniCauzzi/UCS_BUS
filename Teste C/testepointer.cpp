#include <stdio.h>
/*
void func(int (*B)[10]){   // ptr to array of 10 ints.
        (*B)[0] = 5;   // note, *B[0] means *(B[0])
         //B[0][0] = 5;  // same, but could be misleading here; see below.
}

int main(void){

        int B[10] = {0};   // not NULL, which is for pointers.
        printf("b[0] = %d\n\n", B[0]);
        func(&B);            // &B is ptr to arry of 10 ints.
        printf("b[0] = %d\n\n", B[0]);

        return 0;
        
        void limpaBuffer(char (*buffer)[], char tamanho){
	char varre = 0;
  for (varre = 0; varre < tamanho; varre++) {
    (*buffer)[varre]='\0'; 
  }
}
limpaBuffer(&Dado_RX_buffer,tamanhoMaxAUX);
        
        
}*/



/*
void func(int B[10]){   // ptr to array of 10 ints.
        B[0] = 5;   // note, *B[0] means *(B[0])
         //B[0][0] = 5;  // same, but could be misleading here; see below.
}

int main(void){

        int B[10] = {0};   // not NULL, which is for pointers.
        B[0]=44;
        printf("b[0] = %d\n\n", B[0]);
        func(B);            // &B is ptr to arry of 10 ints.
        printf("b[0] = %d\n\n", B[0]);

        return 0;
}
*/

/*
void func(char *var){   

	*var=*var+1;

}

int main(void){
	  char  stx = 0x00,
    tamanhoPacote = 0x00, enderecoDestino = 0x00, enderecoOrigem = 0x00,
    comando = 0x00, dadosPacote1 = 0x00, dadosPacote2 = 0x00;
    
    stx=0x10;
    printf("antes da funcao = %x\n", stx);
    func(&stx);
    printf("depois da funcao = %x\n", stx);
    
    

        return 0;
}*/



void enviaSerial(char dado) {

}

void limpaVetor(char vetor[], char tamanho) {
  char varre = 0;
  for (varre = 0; varre < tamanho; varre++) {
    vetor[varre] = '\0';
  }
}

void enviaTodoBuffer(char msg[], char tamanhoMsg) {
  char varre = 0;
  for (varre = 0; varre < tamanhoMsg; varre++) {

    /*UART2_SendData8(msg[varre]);
    while (UART2_GetFlagStatus(UART2_FLAG_TC) == FALSE); //aguarda termino envio na serial*/
  }
}

char calculateBCC(char msg[], char tamanhoMsg) {
  char varre = 0, BCC = 0x00;

  for (varre = 0; varre <= tamanhoMsg - 2; varre++) {
    BCC = msg[varre] ^ BCC;
  }
  return BCC;
}

void debugCOM(char *STX, char *tamanhoPacote , char *enderecoDestino, char *enderecoOrigem, char *comando, char *dadosPacote1, char *dadosPacote2, char *BCC,char *tamanhoMsg) {
	
}

char coletaBuffer(char buffer[]) {
  unsigned long tempo_RX = 0xFFFF;
  char tamanhoMsg = 0;

  return tamanhoMsg;
}

void desmontaPacote(char Dado_RX_buffer[], char *STX, char *tamanhoPacote , char *enderecoDestino, char *enderecoOrigem, char *comando, char *dadosPacote1, char *dadosPacote2, char *BCC,char *tamanhoMsg, char *flagDados, char *flagCOM)
{
		*flagCOM= '\0';
    *dadosPacote1 = '\0';
    *dadosPacote2 = '\0';
		*flagDados='\0';
			enviaTodoBuffer(Dado_RX_buffer, *tamanhoMsg);
			debugCOM(&STX, &tamanhoPacote , &enderecoDestino, &enderecoOrigem, &comando, &dadosPacote1, &dadosPacote2, &BCC,&tamanhoMsg);
      if (Dado_RX_buffer[0] == 0x02) {
        *STX = Dado_RX_buffer[0];
        *BCC = calculateBCC(Dado_RX_buffer, *tamanhoMsg);
        if (*BCC == Dado_RX_buffer[*tamanhoMsg - 1]) {
          *tamanhoPacote = Dado_RX_buffer[1];
          *enderecoDestino = Dado_RX_buffer[2];
          *enderecoOrigem = Dado_RX_buffer[3];
          *comando = Dado_RX_buffer[4];
          if (*tamanhoMsg == 7) {
						*flagDados=0x00;
            *dadosPacote1 = Dado_RX_buffer[4];
            *dadosPacote2 = '\0';
          } else if (*tamanhoMsg == 8) {
						*flagDados=0x01;
            *dadosPacote1 = Dado_RX_buffer[4];
            *dadosPacote2 = Dado_RX_buffer[5];
          }
			}else{
				*flagCOM=0x01; //BCC errado
			}
		}else{
			*flagCOM=0x03; //STX errado		
		}
	}


#define tamanhoMax 100
#define tamanhoDados 10
#include <stdio.h>

int main(void) {
  unsigned long tempo, tempo_RX = 0xFFFF;
  char delay = 0xFFFFF, tamanhoMsg = 0, varredura = 0,
    Dado_RX_buffer[tamanhoMax], BCC = 0x00, STX = 0x00,
    tamanhoPacote = 0x00, enderecoDestino = 0x00, enderecoOrigem = 0x00,
    comando = 0x00, dadosPacote1 = 0x00, dadosPacote2 = 0x00;
  //char dadosPacote[tamanhoDados];
	char flagDados='\0'; //Se 0 -> um byte de dados. Se 1 -> dois bytes de daods.
	char flagCOM='\0';




  while (1) { //===================================================================WHILE(1)============================
    //limpaVetor(Dado_RX_buffer,tamanhoMax);
    //limpaVetor(dadosPacote,tamanhoDados);
    tamanhoMsg = coletaBuffer(Dado_RX_buffer); //Abre o buffer e recebe dados
		if (tamanhoMsg > 0) {
			desmontaPacote(Dado_RX_buffer, &STX, &tamanhoPacote , &enderecoDestino, &enderecoOrigem, &comando, &dadosPacote1, &dadosPacote2, &BCC, &tamanhoMsg, &flagDados, &flagCOM);
	}






  }//===============END WHILE(1)====================================
}
