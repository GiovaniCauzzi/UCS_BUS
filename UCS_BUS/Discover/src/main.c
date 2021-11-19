/**
 ******************************************************************************
 * @file main.c
 * @brief Adjustable LED blinking speed using STM8S-DISCOVERY touch sensing key
 * Application example.
 * @author STMicroelectronics - MCD Application Team
 * @version V2.0.0
 * @date 15-MAR-2011
 ******************************************************************************
 *
 * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
 * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
 * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
 * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
 * FROM THE tamanhoMsgENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
 * CODING INFORMATION tamanhoMsgAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
 *
 * <h2><center>&copy; COPYRIGHT 2008 STMicroelectronics</center></h2>
 * @image html logo.bmp
 ******************************************************************************
 */

/*--------------Display-----------------------------------------------*/

#define LCD_PORT GPIOB

#define LCD_RS GPIO_PIN_0
#define LCD_EN GPIO_PIN_1
#define LCD_DB4 GPIO_PIN_2
#define LCD_DB5 GPIO_PIN_3
#define LCD_DB6 GPIO_PIN_4
#define LCD_DB7 GPIO_PIN_5

#define clear_display 0x01
#define goto_home 0x02
#define cursor_direction_inc (0x04 | 0x02)
#define cursor_direction_dec (0x04 | 0x00)
#define display_shift (0x04 | 0x01)
#define display_no_shift (0x04 | 0x00)

#define display_on (0x08 | 0x04)
#define display_off (0x08 | 0x02)
#define cursor_on (0x08 | 0x02)
#define cursor_off (0x08 | 0x00)
#define blink_on (0x08 | 0x01)
#define blink_off (0x08 | 0x00)

#define _8_pin_interface (0x20 | 0x10)
#define _4_pin_interface (0x20 | 0x00)
#define _2_row_display (0x20 | 0x08)
#define _1_row_display (0x20 | 0x00)
#define _5x10_dots (0x20 | 0x40)
#define _5x7_dots (0x20 | 0x00)

#define DAT 1
#define CMD 0

void LCD_GPIO_init(void);
void LCD_init(void);
void LCD_send(unsigned char value, unsigned char mode);
void LCD_4bit_send(unsigned char lcd_data);
void LCD_putstr(char *lcd_string);
void LCD_putchar(char char_data);
void LCD_clear_home(void);
void LCD_goto(unsigned char x_pos, unsigned char y_pos);
void toggle_EN_pin(void);
void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num);

#include <stdio.h>

#define TAMANHO_MAX 100
//#define tamanhoDados 10
#define STX 0x02
#define ENDERECO_DISP 0x05
#define ComLeituraBT1 0x01
#define ComLeituraBT2 0x02
#define ComWriteLED1 0x03
#define ComWriteLED2 0x04
#define ComBlinkLED1 0x05
#define ComBlinkLED2 0x06
#define WriteLCD 0x07

/* Includes ------------------------------------------------------------------*/
#include "stm8s.h"

#include "stm8_tsl_api.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
#define MilliSec 1
#define Sec 10
#define led1 GPIO_PIN_2
#define led2 GPIO_PIN_3
#define botao1 GPIO_PIN_4
#define botao2 GPIO_PIN_7
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
void CLK_Configuration(void);
void GPIO_Configuration(void);
void ExtraCode_Init(void);
void ExtraCode_StateMachine(void);
void Delay(void action(void), int NumberofTIMCycles);
void Toggle(void);

/* Global variables ----------------------------------------------------------*/
u8 BlinkSpeed = 6;
int NumberOfStart;
int CheckFlag = 1;

void enviaSerial(char dado)
{
  UART2_SendData8(dado);
  while (UART2_GetFlagStatus(UART2_FLAG_TC) == FALSE)
    ; //aguarda termino envio na serial
}

void limpaVetor(char vetor[], char tamanho)
{
  char varre = 0;
  for (varre = 0; varre < tamanho; varre++)
  {
    vetor[varre] = '\0';
  }
}

void enviaTodoBuffer(char msg[], char tamanhoMsg)
{
  char varre = 0;
  for (varre = 0; varre < tamanhoMsg; varre++)
  {
    enviaSerial(msg[varre]);
    /*UART2_SendData8(msg[varre]);
    while (UART2_GetFlagStatus(UART2_FLAG_TC) == FALSE); //aguarda termino envio na serial*/
  }
}

char calculateBCC_RX(char msg[], char tamanhoMsg)
{
  char varre = 0, BCC_RX = 0x00;

  for (varre = 0; varre <= tamanhoMsg - 2; varre++)
  {
    BCC_RX = msg[varre] ^ BCC_RX;
  }
  return BCC_RX;
}

char calculateBCC_Param(char enderecoDestino, char comando, char dados1, char dados2)
{
  char BCC = 0x00;

  if (dados1 == '\0' && dados2 == '\0') //Tamanho = 0x05
  {
    BCC = STX ^ BCC;
    BCC = 0x05 ^ BCC;
    BCC = enderecoDestino ^ BCC;
    BCC = ENDERECO_DISP ^ BCC;
    BCC = comando ^ BCC;
  }
  else if (!dados1 == '\0' && dados2 == '\0') //Tamanho = 0x06
  {
    BCC = STX ^ BCC;
    BCC = 0x06 ^ BCC;
    BCC = enderecoDestino ^ BCC;
    BCC = ENDERECO_DISP ^ BCC;
    BCC = comando ^ BCC;
    BCC = dados1 ^ BCC;
  }
  else if (!dados1 == '\0' && !dados2 == '\0') //Tamanho = 0x07
  {
    BCC = STX ^ BCC;
    BCC = 0x07 ^ BCC;
    BCC = enderecoDestino ^ BCC;
    BCC = ENDERECO_DISP ^ BCC;
    BCC = comando ^ BCC;
    BCC = dados1 ^ BCC;
    BCC = dados2 ^ BCC;
  }
  return BCC;
}

void piscaLED(char LED, char qtdePiscadas, char intervalo)
{
  char varre = 0x00, flagAUX = 0x00, varre2;

  for (varre = 0; varre <= qtdePiscadas; varre++)
  {

    if (flagAUX == 0x00)
    {
      if (LED == 0x01)
      {
        GPIO_WriteHigh(GPIOD, GPIO_PIN_2);
      }
      else if (LED == 0x02)
      {
        GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
      }
      flagAUX = 0x01;
    }

    for (varre2 = 0; varre2 < 0xffff; varre2++)
      continue;

    if (flagAUX == 0x01)
    {

      if (LED == 0x01)
      {
        GPIO_WriteHigh(GPIOD, GPIO_PIN_2);
      }
      else if (LED == 0x02)
      {
        GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
      }
      flagAUX = 0x00;
    }

    for (varre2 = 0; varre2 < 0xffff; varre2++)
      continue;
  }
}

void debugCOM(char STX_RX, char tamanhoPacote_RX, char enderecoDestino_RX, char enderecoOrigem_RX, char comando_RX, char dadosPacote1_RX, char dadosPacote2_RX, char BCC_RX, char tamanhoMsg, char flagCOM_RX)
{

  enviaSerial(0x00);
  enviaSerial(STX_RX);
  enviaSerial(0x01);
  enviaSerial(tamanhoPacote_RX);
  enviaSerial(0x02);
  enviaSerial(enderecoDestino_RX);
  enviaSerial(0x03);
  enviaSerial(enderecoOrigem_RX);
  enviaSerial(0x04);
  enviaSerial(comando_RX);
  enviaSerial(0x05);
  enviaSerial(dadosPacote1_RX);
  enviaSerial(0x06);
  enviaSerial(dadosPacote2_RX);
  enviaSerial(0x07);
  enviaSerial(BCC_RX);
  enviaSerial(0x08);
  enviaSerial(tamanhoMsg);
  enviaSerial(0x09);
  enviaSerial(flagCOM_RX);
}

char coletaBuffer(char buffer[])
{
  unsigned long tempo_RX = 0xFFFF;
  char tamanhoMsg = 0;

  while (tempo_RX > 0)
  {
    if (UART2_GetFlagStatus(UART2_FLAG_RXNE) == TRUE)
    {
      buffer[tamanhoMsg] = UART2_ReceiveData8();
      tempo_RX = 0xFFF;
      tamanhoMsg++;
    }
    tempo_RX--;
  }
  return tamanhoMsg;
}

void zeraRegistradoresRX(char *STX_RX, char *tamanhoPacote_RX, char *enderecoDestino_RX, char *enderecoOrigem_RX, char *comando_RX, char *dadosPacote1_RX, char *dadosPacote2_RX, char *BCC_RX, char *tamanhoMsg, char *flagCOM_RX)
{
  *STX_RX = '\0';
  *tamanhoPacote_RX = '\0';
  *enderecoDestino_RX = '\0';
  *enderecoOrigem_RX = '\0';
  *comando_RX = '\0';
  *dadosPacote1_RX = '\0';
  *dadosPacote2_RX = '\0';
  *BCC_RX = '\0';
  //* tamanhoMsg = '\0';
  //* flagCOM_RX = '\0';
}

void enviaPacote(char enderecoDestino, char comando, char dados1, char dados2)
{
  //Endereco de origem (RX) da msg se torna o endereco de destino
  char BCC = 0x00, tamanhoPacote = 0x00;

  if (dados1 == '\0' && dados2 == '\0') //Tamanho = 0x05
  {
    tamanhoPacote = 0x05;
    BCC = calculateBCC_Param(enderecoDestino, comando, dados1, dados2);
    enviaSerial(STX);
    enviaSerial(tamanhoPacote); //tamanho
    enviaSerial(enderecoDestino);
    enviaSerial(ENDERECO_DISP);
    enviaSerial(comando);
    enviaSerial(BCC);
  }
  else if (!dados1 == '\0' && dados2 == '\0') //Tamanho = 0x06
  {
    tamanhoPacote = 0x06;
    BCC = calculateBCC_Param(enderecoDestino, comando, dados1, dados2);
    enviaSerial(STX);
    enviaSerial(tamanhoPacote); //tamanho
    enviaSerial(enderecoDestino);
    enviaSerial(ENDERECO_DISP);
    enviaSerial(comando);
    enviaSerial(dados1);
    enviaSerial(BCC);
  }
  else if (!dados1 == '\0' && !dados2 == '\0') //Tamanho = 0x07
  {
    tamanhoPacote = 0x07;
    BCC = calculateBCC_Param(enderecoDestino, comando, dados1, dados2);
    enviaSerial(STX);
    enviaSerial(tamanhoPacote); //tamanho
    enviaSerial(enderecoDestino);
    enviaSerial(ENDERECO_DISP);
    enviaSerial(comando);
    enviaSerial(dados1);
    enviaSerial(dados2);
    enviaSerial(BCC);
  }
}

void processaPacoteRX(char STX_RX, char tamanhoPacote_RX, char enderecoDestino_RX, char enderecoOrigem_RX, char comando_RX, char dadosPacote1_RX, char dadosPacote2_RX, char BCC_RX, char flagCOM_RX)
{ //função para tomar a decisão do que fazer a partir dos dados recebidos
  switch (flagCOM_RX)
  {
  case 0x00:
    switch (comando_RX)
    {
    case 0x01: //0x1: Leitura do status do botão 1, 0 quando não estiver acionado e 1 quando estiver acionado
      if (GPIO_ReadInputPin(GPIOD, GPIO_PIN_4) == 0)
      {
        enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x00);
      }
      else
      {
        enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x01);
      }
      break;

    case 0x02: //0x2: Leitura do status do botão 2, 0 quando não estiver acionado e 1 quando estiver acionado
      if (GPIO_ReadInputPin(GPIOD, GPIO_PIN_7) == 0)
      {
        enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x00);
      }
      else
      {
        enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x01);
      }

      break;

    case 0x03: //0x3: Escrita no Led 1, 0 para desligar o LED e 1 para ligar o LED
      if (dadosPacote1_RX == 0x01)
      {
        GPIO_WriteHigh(GPIOD, GPIO_PIN_2);
      }
      else if (dadosPacote1_RX == 0x00)
      {
        GPIO_WriteLow(GPIOD, GPIO_PIN_2);
      }
      break;

    case 0x04: //0x4: Escrita no Led 2, 0 para desligar o LED e 1 para ligar o LED
      if (dadosPacote1_RX == 0x01)
      {
        GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
      }
      else if (dadosPacote1_RX == 0x00)
      {
        GPIO_WriteLow(GPIOD, GPIO_PIN_3);
      }
      break;

    case 0x05: //0x5: Pisca Led1, primeiro byte o número de piscadas e o segundo byte o tempo de cada piscada
      piscaLED(0x01, dadosPacote1_RX, dadosPacote2_RX);
      break;

    case 0x06: //0x6: Pisca Led2, primeiro byte o número de piscadas e o segundo byte o tempo de cada piscada
      piscaLED(0x02, dadosPacote1_RX, dadosPacote2_RX);
      break;

    case 0x07: //0x7 : Escreve uma mensagem do display, onde o primeiro dado é a posição do display (0x80 para a primeira posição) e os demais dados a mensagem (em ASCII)
      
      LCD_goto(dadosPacote1_RX, 0);                              
      LCD_putchar(dadosPacote2_RX);
      break;
    }

    break;

  case 0x01:
    //ENVIA NAK
    enviaPacote(enderecoOrigem_RX, 0x20, 0x15, '\0');
    break;
  }
}

void main(void)
{
  char indiceMaqEstados = 0x00;
  unsigned long tempo, tempo_RX = 0xFFF;
  char delay = 0xFFFFF, tamanhoMsg = 0, varredura = 0,
       Dado_RX_buffer[TAMANHO_MAX], BCC_RX = 0x00, STX_RX = 0x00,
       tamanhoPacote_RX = 0x00, enderecoDestino_RX = 0x00, enderecoOrigem_RX = 0x00,
       comando_RX = 0x00, dadosPacote1_RX = 0x00, dadosPacote2_RX = 0x00;
  //char dadosPacote[tamanhoDados];
  char flagDados = '\0'; //Se 0 -> um byte de dados. Se 1 -> dois bytes de daods.
  char flagCOM_RX = '\0';
  /*0x00: PACOTE RECEBIDO COM SUCESSO (ENDERECO DO DISPOSITIVO)
  	0x01: ERRO NA RECEPCAO DO PACOTE (BCC_RX ERRADO)
  	0x02: PACOTE RECEBIDO MAS COM ENDERECO ERRADO
  	0x03: STX_RX errado
  	0x04: PROCESSAMENTO EM ANDAMENTO
		0x05: OTHER
		*/
  char estado = 0x00;
  /*MAQUINA DE ESTADOS
  	0x00:
  	0x01: LIMPA REGISTRADORES
  	0x02: VALIDA STX_RX
  	0x03: CALCULA E VALIDA BCC_RX
  	0x04: VALIDA ENDERE�O DE DESTINO
  	0x05: VERIFICA TAMANHO DO PACOTE
  	0x06: ALOCA enderecoOrigem_RX / comando_RX / dadosPacote1_RX / dadosPacote2_RX
	*/
  char maqEstados[15] = {
      0x01,
      0x02,
      0x03,
      0x04,
      0x05,
      0x06};

  /* Configures clocks */
  CLK_Configuration();

  /* Configures GPIOs */
  GPIO_Configuration();

  UART2_Init(9600, UART2_WORDLENGTH_8D, UART2_STOPBITS_1,
             UART2_PARITY_NO, UART2_SYNCMODE_CLOCK_DISABLE,
             UART2_MODE_TXRX_ENABLE);

  LCD_init();
  LCD_clear_home();


  while (1)
  { //===================================================================WHILE(1)============================
    limpaVetor(Dado_RX_buffer, TAMANHO_MAX);
    tamanhoMsg = coletaBuffer(Dado_RX_buffer); //Abre o buffer e recebe dados

    if (tamanhoMsg > 0)
    {
      flagCOM_RX = 0x04; // Processamento em andamento
      indiceMaqEstados = 0x00;

      while (flagCOM_RX == 0x04)
      {

        estado = maqEstados[indiceMaqEstados];
        //indiceMaqEstados++;
        switch (estado)
        {

        case 0x01: //LIMPA REGISTRADORES
          zeraRegistradoresRX(&STX_RX, &tamanhoPacote_RX, &enderecoDestino_RX, &enderecoOrigem_RX, &comando_RX, &dadosPacote1_RX, &dadosPacote2_RX, &BCC_RX, &tamanhoMsg, &flagCOM_RX);
          indiceMaqEstados++;
          break;

        case 0x02: //VALIDA STX_RX
          if (Dado_RX_buffer[0] == 0x02)
          { //STX_RX CERTO
            STX_RX = Dado_RX_buffer[0];
            indiceMaqEstados++;
          }
          else
          {
            flagCOM_RX = 0x03;
          }
          break;

        case 0x03: //CALCULA E VALIDA BCC_RX
          BCC_RX = calculateBCC_RX(Dado_RX_buffer, tamanhoMsg);
          if (BCC_RX == Dado_RX_buffer[tamanhoMsg - 1])
          { //BCC_RX CERTO
            indiceMaqEstados++;
          }
          else
          {
            flagCOM_RX = 0x01;
          }
          break;

        case 0x04: //VALIDA ENDERE�O DE DESTINO
          if (ENDERECO_DISP == Dado_RX_buffer[2])
          { //ENDERECO CERTO
            enderecoDestino_RX = Dado_RX_buffer[2];
            indiceMaqEstados++;
          }
          else
          {
            flagCOM_RX = 0x02;
          }
          break;

        case 0x05: //VERIFICA TAMANHO DO PACOTE
          tamanhoPacote_RX = Dado_RX_buffer[1];
          indiceMaqEstados++;
          break;

        case 0x06: //ALOCA enderecoOrigem_RX / comando_RX / dadosPacote1_RX / dadosPacote2_RX
          enderecoOrigem_RX = Dado_RX_buffer[3];
          comando_RX = Dado_RX_buffer[4];
          if (tamanhoPacote_RX == 0x05)
          {
            indiceMaqEstados++;
            flagCOM_RX = 0x00;
          }
          else if (tamanhoPacote_RX == 0x06)
          {
            dadosPacote1_RX = Dado_RX_buffer[5];
            indiceMaqEstados++;
            flagCOM_RX = 0x00;
          }
          else if (tamanhoPacote_RX == 0x07)
          {
            dadosPacote1_RX = Dado_RX_buffer[5];
            dadosPacote2_RX = Dado_RX_buffer[6];
            indiceMaqEstados++;
            flagCOM_RX = 0x00;
          }
          else
          {
            flagCOM_RX = 0x05;
          }
          break;

        } // End switch case

      } // End while(flag)

      debugCOM(STX_RX, tamanhoPacote_RX, enderecoDestino_RX, enderecoOrigem_RX, comando_RX, dadosPacote1_RX, dadosPacote2_RX, BCC_RX, tamanhoMsg, flagCOM_RX);
      processaPacoteRX(STX_RX, tamanhoPacote_RX, enderecoDestino_RX, enderecoOrigem_RX, comando_RX, dadosPacote1_RX, dadosPacote2_RX, BCC_RX, flagCOM_RX);
    }

  } //===============END WHILE(1)====================================}
}
//==============END MAIN()====================

/*		zeraRegistradoresRX(&STX_RX, &tamanhoPacote_RX, &enderecoDestino_RX, &enderecoOrigem_RX, &comando_RX, &dadosPacote1_RX, &dadosPacote2_RX, &BCC_RX, &tamanhoMsg, &flagCOM_RX);
			if (Dado_RX_buffer[0] == 0x02) { //STX_RX CERTO
        STX_RX = Dado_RX_buffer[0];
        BCC_RX = calculateBCC_RX(Dado_RX_buffer, tamanhoMsg);
        if (ENDERECO_DISP == Dado_RX_buffer[2]) { //ENDERECO CERTO
            if (BCC_RX == Dado_RX_buffer[tamanhoMsg - 1]) { //BCC_RX CERTO
                tamanhoPacote_RX = Dado_RX_buffer[1];
                enderecoDestino_RX = Dado_RX_buffer[2];
                enderecoOrigem_RX = Dado_RX_buffer[3];
                comando_RX = Dado_RX_buffer[4];
                if (tamanhoPacote_RX == 0x06) {
                    flagDados = 0x00;
                    dadosPacote1_RX = Dado_RX_buffer[4];
                    dadosPacote2_RX = '\0';
                } else if (tamanhoPacote_RX == 0x07) {
                    flagDados = 0x01;
                    dadosPacote1_RX = Dado_RX_buffer[4];
                    dadosPacote2_RX = Dado_RX_buffer[5];
							} else if (tamanhoPacote_RX == 0x05){
											
							}
            } else { //BCC_RX errado
                flagCOM_RX = 0x01;
            }
        } else { //Endereco de destino diferente
            flagCOM_RX = 0x02;
        }
    } else {
        flagCOM_RX = 0x03; //STX_RX errado		
    }
		*/

/**
 ******************************************************************************
 * @brief Initialize all the TS keys
 * @par Parameters:
 * None
 * @retval void None
 * @par Required preconditions:
 * None
 ******************************************************************************
 */
void ExtraCode_Init(void)
{

  u8 i;

  /* All keys are implemented and enabled */

  for (i = 0; i < NUMBER_OF_SINGLE_CHANNEL_KEYS; i++)
  {
    sSCKeyInfo[i].Setting.b.IMPLEMENTED = 1;
    sSCKeyInfo[i].Setting.b.ENABLED = 1;
    sSCKeyInfo[i].DxSGroup = 0x01; /* Put 0x00 to disable the DES on these pins */
  }

#if NUMBER_OF_MULTI_CHANNEL_KEYS > 0
  for (i = 0; i < NUMBER_OF_MULTI_CHANNEL_KEYS; i++)
  {
    sMCKeyInfo[i].Setting.b.IMPLEMENTED = 1;
    sMCKeyInfo[i].Setting.b.ENABLED = 1;
    sMCKeyInfo[i].DxSGroup = 0x01; /* Put 0x00 to disable the DES on these pins */
  }
#endif

  enableInterrupts();
}

/**
 ******************************************************************************
 * @brief Adjustable led blinking speed using touch sensing keys
 * KEY1: LED1 is blinking
 * KEY1: LED1 is blinking faster
 * KEY1: LED1 don't blink anymore
 * @par Parameters:
 * None
 * @retval void None
 * @par Required preconditions:
 * None
 ******************************************************************************
 */
void ExtraCode_StateMachine(void)
{
  if ((TSL_GlobalSetting.b.CHANGED) && (TSLState == TSL_IDLE_STATE))
  {
    TSL_GlobalSetting.b.CHANGED = 0;

    if (sSCKeyInfo[0].Setting.b.DETECTED) /* KEY 1 touched */
    {
      BlinkSpeed++;
      BlinkSpeed = BlinkSpeed % 3;
    }
  }

  switch (BlinkSpeed)
  {
  case 0:
    GPIO_WriteHigh(GPIOD, GPIO_PIN_0);
    break;

  case 1:
    if (TSL_Tick_Flags.b.User1_Flag_100ms == 1)
    {
      Delay(&Toggle, 2 * MilliSec);
    }
    break;

  case 2:
    if (TSL_Tick_Flags.b.User1_Flag_100ms == 1)
    {
      Delay(&Toggle, 1 * MilliSec);
    }
    break;

  default:
    if (TSL_Tick_Flags.b.User1_Flag_100ms == 1)
    {
      Delay(&Toggle, 1 * Sec);
    }
  }
}

/**
 ******************************************************************************
 * @brief Configures clocks
 * @par Parameters:
 * None
 * @retval void None
 * @par Required preconditions:
 * None
 ******************************************************************************
 */
void CLK_Configuration(void)
{

  /* Fmaster = 16MHz */
  CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
}

/**
 ******************************************************************************
 * @brief Configures GPIOs
 * @par Parameters:
 * None
 * @retval void None
 * @par Required preconditions:
 * None
 ******************************************************************************
 */
void GPIO_Configuration(void)
{
  /* GPIOD reset */
  GPIO_DeInit(GPIOD);

  /* Configure PD0 (LED1) as output push-pull low (led switched on) */
  GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST);
  //saidas
  GPIO_Init(GPIOD, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); //led1
  GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); //led2
  //entradas
  GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT); //BT1
  GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_IN_FL_NO_IT); //BT2

  //uart
  GPIO_Init(GPIOD, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); //TX
  GPIO_Init(GPIOD, GPIO_PIN_6, GPIO_MODE_IN_FL_NO_IT);     //rX
}

/**
 ******************************************************************************
 * @brief Delay before completing the action
 * @param[in] function action() to be performed once the delay past
 * @param[in]
 * None
 * @retval void None
 * @par Required preconditions:
 * None
 ******************************************************************************
 */
void Delay(void action(void), int NumberofTIMCycles)
{
  if ((CheckFlag) != 0)
    NumberOfStart = NumberofTIMCycles;
  if (NumberOfStart != 0)
  {
    TSL_Tick_Flags.b.User1_Start_100ms = 1;
    CheckFlag = 0;
  }
  if (TSL_Tick_Flags.b.User1_Flag_100ms)
  {
    TSL_Tick_Flags.b.User1_Flag_100ms = 0;
    NumberOfStart--;
  }
  if (NumberOfStart == 0)
  {
    action();
    CheckFlag = 1;
  }
}

/**
 ******************************************************************************
 * @brief Toggle PD0 (Led LD1)
 * @par Parameters:
 * None
 * @retval void None
 * @par Required preconditions:
 * None
 ******************************************************************************
 */
void Toggle(void)
{
  GPIO_WriteReverse(GPIOD, GPIO_PIN_0);
}
/****************** (c) 2008  STMicroelectronics ******************************/

/*		UART2_SendData8(0x54);
		for(tempo=0;tempo<=0xFFFF;tempo++) tamanhoMsginue;
		UART2_SendData8(0x68);
		for(tempo=0;tempo<=0xFFFF;tempo++) tamanhoMsginue;
				UART2_SendData8(0x61);
				for(tempo=0;tempo<=0xFFFF;tempo++) tamanhoMsginue;
						UART2_SendData8(0x74);
						for(tempo=0;tempo<=0xFFFF;tempo++) tamanhoMsginue;
								UART2_SendData8(0x68);
								for(tempo=0;tempo<=0xFFFF;tempo++) tamanhoMsginue;
								UART2_SendData8(0x61);*/

void LCD_GPIO_init(void)
{
  unsigned long Tempo_Aux;
  GPIO_Init(LCD_PORT, LCD_RS, GPIO_MODE_OUT_PP_HIGH_FAST);
  GPIO_Init(LCD_PORT, LCD_EN, GPIO_MODE_OUT_PP_HIGH_FAST);
  GPIO_Init(LCD_PORT, LCD_DB4, GPIO_MODE_OUT_PP_HIGH_FAST);
  GPIO_Init(LCD_PORT, LCD_DB5, GPIO_MODE_OUT_PP_HIGH_FAST);
  GPIO_Init(LCD_PORT, LCD_DB6, GPIO_MODE_OUT_PP_HIGH_FAST);
  GPIO_Init(LCD_PORT, LCD_DB7, GPIO_MODE_OUT_PP_HIGH_FAST);
  //delay_ms(10);
  for (Tempo_Aux = 0; Tempo_Aux < 0xFFFF; Tempo_Aux++)
    continue;
}

void LCD_init(void)
{
  LCD_GPIO_init();
  toggle_EN_pin();

  GPIO_WriteLow(LCD_PORT, LCD_RS);
  GPIO_WriteLow(LCD_PORT, LCD_DB7);
  GPIO_WriteLow(LCD_PORT, LCD_DB6);
  GPIO_WriteHigh(LCD_PORT, LCD_DB5);
  GPIO_WriteHigh(LCD_PORT, LCD_DB4);
  toggle_EN_pin();

  GPIO_WriteLow(LCD_PORT, LCD_DB7);
  GPIO_WriteLow(LCD_PORT, LCD_DB6);
  GPIO_WriteHigh(LCD_PORT, LCD_DB5);
  GPIO_WriteHigh(LCD_PORT, LCD_DB4);
  toggle_EN_pin();

  GPIO_WriteLow(LCD_PORT, LCD_DB7);
  GPIO_WriteLow(LCD_PORT, LCD_DB6);
  GPIO_WriteHigh(LCD_PORT, LCD_DB5);
  GPIO_WriteHigh(LCD_PORT, LCD_DB4);
  toggle_EN_pin();

  GPIO_WriteLow(LCD_PORT, LCD_DB7);
  GPIO_WriteLow(LCD_PORT, LCD_DB6);
  GPIO_WriteHigh(LCD_PORT, LCD_DB5);
  GPIO_WriteLow(LCD_PORT, LCD_DB4);
  toggle_EN_pin();

  LCD_send((_4_pin_interface | _2_row_display | _5x7_dots), CMD);
  LCD_send((display_on | cursor_off | blink_off), CMD);
  LCD_send(clear_display, CMD);
  LCD_send((cursor_direction_inc | display_no_shift), CMD);
}

void LCD_send(unsigned char value, unsigned char mode)
{
  switch (mode)
  {
  case DAT:
  {
    GPIO_WriteHigh(LCD_PORT, LCD_RS);
    break;
  }
  case CMD:
  {
    GPIO_WriteLow(LCD_PORT, LCD_RS);
    break;
  }
  }

  LCD_4bit_send(value);
}

void LCD_4bit_send(unsigned char lcd_data)
{
  toggle_io(lcd_data, 7, LCD_DB7);
  toggle_io(lcd_data, 6, LCD_DB6);
  toggle_io(lcd_data, 5, LCD_DB5);
  toggle_io(lcd_data, 4, LCD_DB4);
  toggle_EN_pin();
  toggle_io(lcd_data, 3, LCD_DB7);
  toggle_io(lcd_data, 2, LCD_DB6);
  toggle_io(lcd_data, 1, LCD_DB5);
  toggle_io(lcd_data, 0, LCD_DB4);
  toggle_EN_pin();
}

void LCD_putstr(char *lcd_string)
{
  do
  {
    LCD_send(*lcd_string++, DAT);
  } while (*lcd_string != '\0');
}

void LCD_putchar(char char_data)
{
  LCD_send(char_data, DAT);
}

void LCD_clear_home(void)
{
  LCD_send(clear_display, CMD);
  LCD_send(goto_home, CMD);
}

void LCD_goto(unsigned char x_pos, unsigned char y_pos)
{
  if (y_pos == 0)
  {
    LCD_send((0x80 | x_pos), CMD);
  }
  else
  {
    LCD_send((0x80 | 0x40 | x_pos), CMD);
  }
}

void toggle_EN_pin(void)
{
  unsigned long Tempo_Aux;
  GPIO_WriteHigh(LCD_PORT, LCD_EN);
  //delay_ms(2);
  for (Tempo_Aux = 0; Tempo_Aux < 0xFFFF; Tempo_Aux++)
    continue;
  GPIO_WriteLow(LCD_PORT, LCD_EN);
}

void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num)
{
  bool temp = FALSE;

  temp = (0x01 & (lcd_data >> bit_pos));

  switch (temp)
  {
  case TRUE:
  {
    GPIO_WriteHigh(LCD_PORT, pin_num);
    break;
  }

  default:
  {
    GPIO_WriteLow(LCD_PORT, pin_num);
    break;
  }
  }
}