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

/* Private functions ---------------------------------------------------------*/
/* Global variables ----------------------------------------------------------*/
u8 BlinkSpeed = 6;
int NumberOfStart;
int CheckFlag = 1;

/* Public functions ----------------------------------------------------------*/

/*--------------Display-----------------------------------------------*/

#define LCD_PORT                              GPIOB
 
#define LCD_RS                                GPIO_PIN_0     
#define LCD_EN                                GPIO_PIN_1   
#define LCD_DB4                               GPIO_PIN_2       
#define LCD_DB5                               GPIO_PIN_3
#define LCD_DB6                               GPIO_PIN_4 
#define LCD_DB7                               GPIO_PIN_5 
 
#define clear_display                         0x01                
#define goto_home                             0x02
#define cursor_direction_inc                  (0x04 | 0x02)
#define cursor_direction_dec                  (0x04 | 0x00)
#define display_shift                         (0x04 | 0x01) 
#define display_no_shift                      (0x04 | 0x00)
 
#define display_on                            (0x08 | 0x04)
#define display_off                           (0x08 | 0x02) 
#define cursor_on                             (0x08 | 0x02)       
#define cursor_off                            (0x08 | 0x00)   
#define blink_on                              (0x08 | 0x01)   
#define blink_off                             (0x08 | 0x00)   
                                    
#define _8_pin_interface                      (0x20 | 0x10)   
#define _4_pin_interface                      (0x20 | 0x00)      
#define _2_row_display                        (0x20 | 0x08) 
#define _1_row_display                        (0x20 | 0x00)
#define _5x10_dots                            (0x20 | 0x40)      
#define _5x7_dots                             (0x20 | 0x00)
 
#define DAT                                   1
#define CMD                                   0
 
 
void LCD_GPIO_init(void);
void LCD_init(void);  
void LCD_send(unsigned char value, unsigned char mode);
void LCD_4bit_send(unsigned char lcd_data);              
void LCD_putstr(char *lcd_string);               
void LCD_putchar(char char_data);             
void LCD_clear_home(void);            
void LCD_goto(unsigned char  x_pos, unsigned char  y_pos);
void toggle_EN_pin(void);
void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num);





/**
 ******************************************************************************
 * @brief Main function.
 * @par Parameters:
 * None
 * @retval void None
 * @par Required preconditions:
 * None
 ******************************************************************************
 */

void enviaTodoBuffer(char msg[], char tamanhoMsg) {
  char varre = 0;
  for (varre = 0; varre <= tamanhoMsg; varre++) {
    UART2_SendData8(msg[varre]);
    while (UART2_GetFlagStatus(UART2_FLAG_TC) == FALSE); //aguarda termino envio na serial
  }
}

char calculateBCC(char msg[], char tamanhoMsg) {
  char varre = 0, XOR = 0x00;

  for (varre = 0; varre <= tamanhoMsg - 1; varre++) {
    XOR = msg[varre] ^ XOR;
  }
  return XOR;
}

#define tamanhoMax 100

#include <stdio.h>

void main(void) {
  unsigned long tempo, tempo_RX = 0xFFFF;
  char delay = 0xFFFFF, tamanhoMsg = 0, varredura = 0, 
	Dado_RX_buffer[tamanhoMax];
  /* Configures clocks */
  CLK_Configuration();

  /* Configures GPIOs */
  GPIO_Configuration();

  UART2_Init(115200, UART2_WORDLENGTH_8D, UART2_STOPBITS_1, 
	UART2_PARITY_NO, UART2_SYNCMODE_CLOCK_DISABLE, 
	UART2_MODE_TXRX_ENABLE);

  while (1) { //===================================================================WHILE(1)============================

    tempo_RX = 0xFFFF;
    tamanhoMsg = 0;
    while (tempo_RX > 0) {
      if (UART2_GetFlagStatus(UART2_FLAG_RXNE) == TRUE) {
        Dado_RX_buffer[tamanhoMsg] = UART2_ReceiveData8();
        tempo_RX = 0xFFF;
        tamanhoMsg++;
      }
      tempo_RX--;
    }

    if (tamanhoMsg > 0) {
      enviaTodoBuffer(Dado_RX_buffer, tamanhoMsg);
    }

  }
}

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
void ExtraCode_Init(void) {

  u8 i;

  /* All keys are implemented and enabled */

  for (i = 0; i < NUMBER_OF_SINGLE_CHANNEL_KEYS; i++) {
    sSCKeyInfo[i].Setting.b.IMPLEMENTED = 1;
    sSCKeyInfo[i].Setting.b.ENABLED = 1;
    sSCKeyInfo[i].DxSGroup = 0x01; /* Put 0x00 to disable the DES on these pins */
  }

  #if NUMBER_OF_MULTI_CHANNEL_KEYS > 0
  for (i = 0; i < NUMBER_OF_MULTI_CHANNEL_KEYS; i++) {
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
void ExtraCode_StateMachine(void) {
  if ((TSL_GlobalSetting.b.CHANGED) && (TSLState == TSL_IDLE_STATE)) {
    TSL_GlobalSetting.b.CHANGED = 0;

    if (sSCKeyInfo[0].Setting.b.DETECTED) /* KEY 1 touched */ {
      BlinkSpeed++;
      BlinkSpeed = BlinkSpeed % 3;
    }
  }

  switch (BlinkSpeed) {
  case 0:
    GPIO_WriteHigh(GPIOD, GPIO_PIN_0);
    break;

  case 1:
    if (TSL_Tick_Flags.b.User1_Flag_100ms == 1) {
      Delay( & Toggle, 2 * MilliSec);
    }
    break;

  case 2:
    if (TSL_Tick_Flags.b.User1_Flag_100ms == 1) {
      Delay( & Toggle, 1 * MilliSec);
    }
    break;

  default:
    if (TSL_Tick_Flags.b.User1_Flag_100ms == 1) {
      Delay( & Toggle, 1 * Sec);
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
void CLK_Configuration(void) {

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
void GPIO_Configuration(void) {
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
  GPIO_Init(GPIOD, GPIO_PIN_6, GPIO_MODE_IN_FL_NO_IT); //rX

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
void Delay(void action(void), int NumberofTIMCycles) {
  if ((CheckFlag) != 0)
    NumberOfStart = NumberofTIMCycles;
  if (NumberOfStart != 0) {
    TSL_Tick_Flags.b.User1_Start_100ms = 1;
    CheckFlag = 0;
  }
  if (TSL_Tick_Flags.b.User1_Flag_100ms) {
    TSL_Tick_Flags.b.User1_Flag_100ms = 0;
    NumberOfStart--;
  }
  if (NumberOfStart == 0) {
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
void Toggle(void) {
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