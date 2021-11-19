   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
   4                     ; Optimizer V4.5.3 - 16 Jun 2021
  47                     ; 47 void UART2_DeInit(void)
  47                     ; 48 {
  49                     	switch	.text
  50  0000               _UART2_DeInit:
  54                     ; 51     (void) UART2->SR;
  56  0000 c65240        	ld	a,21056
  57                     ; 52     (void)UART2->DR;
  59  0003 c65241        	ld	a,21057
  60                     ; 54     UART2->BRR2 = UART2_BRR2_RESET_VALUE;  /*  Set UART2_BRR2 to reset value 0x00 */
  62  0006 725f5243      	clr	21059
  63                     ; 55     UART2->BRR1 = UART2_BRR1_RESET_VALUE;  /*  Set UART2_BRR1 to reset value 0x00 */
  65  000a 725f5242      	clr	21058
  66                     ; 57     UART2->CR1 = UART2_CR1_RESET_VALUE; /*  Set UART2_CR1 to reset value 0x00  */
  68  000e 725f5244      	clr	21060
  69                     ; 58     UART2->CR2 = UART2_CR2_RESET_VALUE; /*  Set UART2_CR2 to reset value 0x00  */
  71  0012 725f5245      	clr	21061
  72                     ; 59     UART2->CR3 = UART2_CR3_RESET_VALUE; /*  Set UART2_CR3 to reset value 0x00  */
  74  0016 725f5246      	clr	21062
  75                     ; 60     UART2->CR4 = UART2_CR4_RESET_VALUE; /*  Set UART2_CR4 to reset value 0x00  */
  77  001a 725f5247      	clr	21063
  78                     ; 61     UART2->CR5 = UART2_CR5_RESET_VALUE; /*  Set UART2_CR5 to reset value 0x00  */
  80  001e 725f5248      	clr	21064
  81                     ; 62     UART2->CR6 = UART2_CR6_RESET_VALUE; /*  Set UART2_CR6 to reset value 0x00  */
  83  0022 725f5249      	clr	21065
  84                     ; 64 }
  87  0026 81            	ret	
 408                     .const:	section	.text
 409  0000               L41:
 410  0000 00000064      	dc.l	100
 411                     ; 80 void UART2_Init(uint32_t BaudRate, UART2_WordLength_TypeDef WordLength, UART2_StopBits_TypeDef StopBits, UART2_Parity_TypeDef Parity, UART2_SyncMode_TypeDef SyncMode, UART2_Mode_TypeDef Mode)
 411                     ; 81 {
 412                     	switch	.text
 413  0027               _UART2_Init:
 415  0027 520e          	subw	sp,#14
 416       0000000e      OFST:	set	14
 419                     ; 82     uint8_t BRR2_1 = 0, BRR2_2 = 0;
 423                     ; 83     uint32_t BaudRate_Mantissa = 0, BaudRate_Mantissa100 = 0;
 427                     ; 86     assert_param(IS_UART2_BAUDRATE_OK(BaudRate));
 429                     ; 87     assert_param(IS_UART2_WORDLENGTH_OK(WordLength));
 431                     ; 88     assert_param(IS_UART2_STOPBITS_OK(StopBits));
 433                     ; 89     assert_param(IS_UART2_PARITY_OK(Parity));
 435                     ; 90     assert_param(IS_UART2_MODE_OK((uint8_t)Mode));
 437                     ; 91     assert_param(IS_UART2_SYNCMODE_OK((uint8_t)SyncMode));
 439                     ; 94     UART2->CR1 &= (uint8_t)(~UART2_CR1_M);
 441  0029 72195244      	bres	21060,#4
 442                     ; 96     UART2->CR1 |= (uint8_t)WordLength; 
 444  002d c65244        	ld	a,21060
 445  0030 1a15          	or	a,(OFST+7,sp)
 446  0032 c75244        	ld	21060,a
 447                     ; 99     UART2->CR3 &= (uint8_t)(~UART2_CR3_STOP);
 449  0035 c65246        	ld	a,21062
 450  0038 a4cf          	and	a,#207
 451  003a c75246        	ld	21062,a
 452                     ; 101     UART2->CR3 |= (uint8_t)StopBits; 
 454  003d c65246        	ld	a,21062
 455  0040 1a16          	or	a,(OFST+8,sp)
 456  0042 c75246        	ld	21062,a
 457                     ; 104     UART2->CR1 &= (uint8_t)(~(UART2_CR1_PCEN | UART2_CR1_PS  ));
 459  0045 c65244        	ld	a,21060
 460  0048 a4f9          	and	a,#249
 461  004a c75244        	ld	21060,a
 462                     ; 106     UART2->CR1 |= (uint8_t)Parity;
 464  004d c65244        	ld	a,21060
 465  0050 1a17          	or	a,(OFST+9,sp)
 466  0052 c75244        	ld	21060,a
 467                     ; 109     UART2->BRR1 &= (uint8_t)(~UART2_BRR1_DIVM);
 469  0055 725f5242      	clr	21058
 470                     ; 111     UART2->BRR2 &= (uint8_t)(~UART2_BRR2_DIVM);
 472  0059 c65243        	ld	a,21059
 473  005c a40f          	and	a,#15
 474  005e c75243        	ld	21059,a
 475                     ; 113     UART2->BRR2 &= (uint8_t)(~UART2_BRR2_DIVF);
 477  0061 c65243        	ld	a,21059
 478  0064 a4f0          	and	a,#240
 479  0066 c75243        	ld	21059,a
 480                     ; 116     BaudRate_Mantissa    = ((uint32_t)CLK_GetClockFreq() / (BaudRate << 4));
 482  0069 96            	ldw	x,sp
 483  006a cd012e        	call	LC001
 485  006d 96            	ldw	x,sp
 486  006e 5c            	incw	x
 487  006f cd0000        	call	c_rtol
 490  0072 cd0000        	call	_CLK_GetClockFreq
 492  0075 96            	ldw	x,sp
 493  0076 5c            	incw	x
 494  0077 cd0000        	call	c_ludv
 496  007a 96            	ldw	x,sp
 497  007b 1c000b        	addw	x,#OFST-3
 498  007e cd0000        	call	c_rtol
 501                     ; 117     BaudRate_Mantissa100 = (((uint32_t)CLK_GetClockFreq() * 100) / (BaudRate << 4));
 503  0081 96            	ldw	x,sp
 504  0082 cd012e        	call	LC001
 506  0085 96            	ldw	x,sp
 507  0086 5c            	incw	x
 508  0087 cd0000        	call	c_rtol
 511  008a cd0000        	call	_CLK_GetClockFreq
 513  008d a664          	ld	a,#100
 514  008f cd0000        	call	c_smul
 516  0092 96            	ldw	x,sp
 517  0093 5c            	incw	x
 518  0094 cd0000        	call	c_ludv
 520  0097 96            	ldw	x,sp
 521  0098 1c0007        	addw	x,#OFST-7
 522  009b cd0000        	call	c_rtol
 525                     ; 121     BRR2_1 = (uint8_t)((uint8_t)(((BaudRate_Mantissa100 - (BaudRate_Mantissa * 100))
 525                     ; 122                         << 4) / 100) & (uint8_t)0x0F); 
 527  009e 96            	ldw	x,sp
 528  009f 1c000b        	addw	x,#OFST-3
 529  00a2 cd0000        	call	c_ltor
 531  00a5 a664          	ld	a,#100
 532  00a7 cd0000        	call	c_smul
 534  00aa 96            	ldw	x,sp
 535  00ab 5c            	incw	x
 536  00ac cd0000        	call	c_rtol
 539  00af 96            	ldw	x,sp
 540  00b0 1c0007        	addw	x,#OFST-7
 541  00b3 cd0000        	call	c_ltor
 543  00b6 96            	ldw	x,sp
 544  00b7 5c            	incw	x
 545  00b8 cd0000        	call	c_lsub
 547  00bb a604          	ld	a,#4
 548  00bd cd0000        	call	c_llsh
 550  00c0 ae0000        	ldw	x,#L41
 551  00c3 cd0000        	call	c_ludv
 553  00c6 b603          	ld	a,c_lreg+3
 554  00c8 a40f          	and	a,#15
 555  00ca 6b05          	ld	(OFST-9,sp),a
 557                     ; 123     BRR2_2 = (uint8_t)((BaudRate_Mantissa >> 4) & (uint8_t)0xF0);
 559  00cc 1e0d          	ldw	x,(OFST-1,sp)
 560  00ce 54            	srlw	x
 561  00cf 54            	srlw	x
 562  00d0 54            	srlw	x
 563  00d1 54            	srlw	x
 564  00d2 01            	rrwa	x,a
 565  00d3 a4f0          	and	a,#240
 566  00d5 6b06          	ld	(OFST-8,sp),a
 568                     ; 125     UART2->BRR2 = (uint8_t)(BRR2_1 | BRR2_2);
 570  00d7 1a05          	or	a,(OFST-9,sp)
 571  00d9 c75243        	ld	21059,a
 572                     ; 127     UART2->BRR1 = (uint8_t)BaudRate_Mantissa;           
 574  00dc 7b0e          	ld	a,(OFST+0,sp)
 575  00de c75242        	ld	21058,a
 576                     ; 130     UART2->CR2 &= (uint8_t)~(UART2_CR2_TEN | UART2_CR2_REN);
 578  00e1 c65245        	ld	a,21061
 579  00e4 a4f3          	and	a,#243
 580  00e6 c75245        	ld	21061,a
 581                     ; 132     UART2->CR3 &= (uint8_t)~(UART2_CR3_CPOL | UART2_CR3_CPHA | UART2_CR3_LBCL);
 583  00e9 c65246        	ld	a,21062
 584  00ec a4f8          	and	a,#248
 585  00ee c75246        	ld	21062,a
 586                     ; 134     UART2->CR3 |= (uint8_t)((uint8_t)SyncMode & (uint8_t)(UART2_CR3_CPOL | \
 586                     ; 135                                               UART2_CR3_CPHA | UART2_CR3_LBCL));
 588  00f1 7b18          	ld	a,(OFST+10,sp)
 589  00f3 a407          	and	a,#7
 590  00f5 ca5246        	or	a,21062
 591  00f8 c75246        	ld	21062,a
 592                     ; 137     if ((uint8_t)(Mode & UART2_MODE_TX_ENABLE))
 594  00fb 7b19          	ld	a,(OFST+11,sp)
 595  00fd a504          	bcp	a,#4
 596  00ff 2706          	jreq	L302
 597                     ; 140         UART2->CR2 |= (uint8_t)UART2_CR2_TEN;
 599  0101 72165245      	bset	21061,#3
 601  0105 2004          	jra	L502
 602  0107               L302:
 603                     ; 145         UART2->CR2 &= (uint8_t)(~UART2_CR2_TEN);
 605  0107 72175245      	bres	21061,#3
 606  010b               L502:
 607                     ; 147     if ((uint8_t)(Mode & UART2_MODE_RX_ENABLE))
 609  010b a508          	bcp	a,#8
 610  010d 2706          	jreq	L702
 611                     ; 150         UART2->CR2 |= (uint8_t)UART2_CR2_REN;
 613  010f 72145245      	bset	21061,#2
 615  0113 2004          	jra	L112
 616  0115               L702:
 617                     ; 155         UART2->CR2 &= (uint8_t)(~UART2_CR2_REN);
 619  0115 72155245      	bres	21061,#2
 620  0119               L112:
 621                     ; 159     if ((uint8_t)(SyncMode & UART2_SYNCMODE_CLOCK_DISABLE))
 623  0119 7b18          	ld	a,(OFST+10,sp)
 624  011b 2a06          	jrpl	L312
 625                     ; 162         UART2->CR3 &= (uint8_t)(~UART2_CR3_CKEN); 
 627  011d 72175246      	bres	21062,#3
 629  0121 2008          	jra	L512
 630  0123               L312:
 631                     ; 166         UART2->CR3 |= (uint8_t)((uint8_t)SyncMode & UART2_CR3_CKEN);
 633  0123 a408          	and	a,#8
 634  0125 ca5246        	or	a,21062
 635  0128 c75246        	ld	21062,a
 636  012b               L512:
 637                     ; 168 }
 640  012b 5b0e          	addw	sp,#14
 641  012d 81            	ret	
 642  012e               LC001:
 643  012e 1c0011        	addw	x,#OFST+3
 644  0131 cd0000        	call	c_ltor
 646  0134 a604          	ld	a,#4
 647  0136 cc0000        	jp	c_llsh
 702                     ; 176 void UART2_Cmd(FunctionalState NewState)
 702                     ; 177 {
 703                     	switch	.text
 704  0139               _UART2_Cmd:
 708                     ; 179     if (NewState != DISABLE)
 710  0139 4d            	tnz	a
 711  013a 2705          	jreq	L542
 712                     ; 182         UART2->CR1 &= (uint8_t)(~UART2_CR1_UARTD);
 714  013c 721b5244      	bres	21060,#5
 717  0140 81            	ret	
 718  0141               L542:
 719                     ; 187         UART2->CR1 |= UART2_CR1_UARTD; 
 721  0141 721a5244      	bset	21060,#5
 722                     ; 189 }
 725  0145 81            	ret	
 857                     ; 206 void UART2_ITConfig(UART2_IT_TypeDef UART2_IT, FunctionalState NewState)
 857                     ; 207 {
 858                     	switch	.text
 859  0146               _UART2_ITConfig:
 861  0146 89            	pushw	x
 862  0147 89            	pushw	x
 863       00000002      OFST:	set	2
 866                     ; 208     uint8_t uartreg = 0, itpos = 0x00;
 870                     ; 211     assert_param(IS_UART2_CONFIG_IT_OK(UART2_IT));
 872                     ; 212     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 874                     ; 215     uartreg = (uint8_t)((uint16_t)UART2_IT >> 0x08);
 876  0148 9e            	ld	a,xh
 877  0149 6b01          	ld	(OFST-1,sp),a
 879                     ; 218     itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)UART2_IT & (uint8_t)0x0F));
 881  014b 9f            	ld	a,xl
 882  014c a40f          	and	a,#15
 883  014e 5f            	clrw	x
 884  014f 97            	ld	xl,a
 885  0150 a601          	ld	a,#1
 886  0152 5d            	tnzw	x
 887  0153 2704          	jreq	L22
 888  0155               L42:
 889  0155 48            	sll	a
 890  0156 5a            	decw	x
 891  0157 26fc          	jrne	L42
 892  0159               L22:
 893  0159 6b02          	ld	(OFST+0,sp),a
 895                     ; 220     if (NewState != DISABLE)
 897  015b 7b07          	ld	a,(OFST+5,sp)
 898  015d 272a          	jreq	L133
 899                     ; 223         if (uartreg == 0x01)
 901  015f 7b01          	ld	a,(OFST-1,sp)
 902  0161 a101          	cp	a,#1
 903  0163 2607          	jrne	L333
 904                     ; 225             UART2->CR1 |= itpos;
 906  0165 c65244        	ld	a,21060
 907  0168 1a02          	or	a,(OFST+0,sp)
 909  016a 2029          	jp	LC004
 910  016c               L333:
 911                     ; 227         else if (uartreg == 0x02)
 913  016c a102          	cp	a,#2
 914  016e 2607          	jrne	L733
 915                     ; 229             UART2->CR2 |= itpos;
 917  0170 c65245        	ld	a,21061
 918  0173 1a02          	or	a,(OFST+0,sp)
 920  0175 202d          	jp	LC003
 921  0177               L733:
 922                     ; 231         else if (uartreg == 0x03)
 924  0177 a103          	cp	a,#3
 925  0179 2607          	jrne	L343
 926                     ; 233             UART2->CR4 |= itpos;
 928  017b c65247        	ld	a,21063
 929  017e 1a02          	or	a,(OFST+0,sp)
 931  0180 2031          	jp	LC005
 932  0182               L343:
 933                     ; 237             UART2->CR6 |= itpos;
 935  0182 c65249        	ld	a,21065
 936  0185 1a02          	or	a,(OFST+0,sp)
 937  0187 2035          	jp	LC002
 938  0189               L133:
 939                     ; 243         if (uartreg == 0x01)
 941  0189 7b01          	ld	a,(OFST-1,sp)
 942  018b a101          	cp	a,#1
 943  018d 260b          	jrne	L153
 944                     ; 245             UART2->CR1 &= (uint8_t)(~itpos);
 946  018f 7b02          	ld	a,(OFST+0,sp)
 947  0191 43            	cpl	a
 948  0192 c45244        	and	a,21060
 949  0195               LC004:
 950  0195 c75244        	ld	21060,a
 952  0198 2027          	jra	L743
 953  019a               L153:
 954                     ; 247         else if (uartreg == 0x02)
 956  019a a102          	cp	a,#2
 957  019c 260b          	jrne	L553
 958                     ; 249             UART2->CR2 &= (uint8_t)(~itpos);
 960  019e 7b02          	ld	a,(OFST+0,sp)
 961  01a0 43            	cpl	a
 962  01a1 c45245        	and	a,21061
 963  01a4               LC003:
 964  01a4 c75245        	ld	21061,a
 966  01a7 2018          	jra	L743
 967  01a9               L553:
 968                     ; 251         else if (uartreg == 0x03)
 970  01a9 a103          	cp	a,#3
 971  01ab 260b          	jrne	L163
 972                     ; 253             UART2->CR4 &= (uint8_t)(~itpos);
 974  01ad 7b02          	ld	a,(OFST+0,sp)
 975  01af 43            	cpl	a
 976  01b0 c45247        	and	a,21063
 977  01b3               LC005:
 978  01b3 c75247        	ld	21063,a
 980  01b6 2009          	jra	L743
 981  01b8               L163:
 982                     ; 257             UART2->CR6 &= (uint8_t)(~itpos);
 984  01b8 7b02          	ld	a,(OFST+0,sp)
 985  01ba 43            	cpl	a
 986  01bb c45249        	and	a,21065
 987  01be               LC002:
 988  01be c75249        	ld	21065,a
 989  01c1               L743:
 990                     ; 260 }
 993  01c1 5b04          	addw	sp,#4
 994  01c3 81            	ret	
1051                     ; 267 void UART2_IrDAConfig(UART2_IrDAMode_TypeDef UART2_IrDAMode)
1051                     ; 268 {
1052                     	switch	.text
1053  01c4               _UART2_IrDAConfig:
1057                     ; 269     assert_param(IS_UART2_IRDAMODE_OK(UART2_IrDAMode));
1059                     ; 271     if (UART2_IrDAMode != UART2_IRDAMODE_NORMAL)
1061  01c4 4d            	tnz	a
1062  01c5 2705          	jreq	L314
1063                     ; 273         UART2->CR5 |= UART2_CR5_IRLP;
1065  01c7 72145248      	bset	21064,#2
1068  01cb 81            	ret	
1069  01cc               L314:
1070                     ; 277         UART2->CR5 &= ((uint8_t)~UART2_CR5_IRLP);
1072  01cc 72155248      	bres	21064,#2
1073                     ; 279 }
1076  01d0 81            	ret	
1111                     ; 287 void UART2_IrDACmd(FunctionalState NewState)
1111                     ; 288 {
1112                     	switch	.text
1113  01d1               _UART2_IrDACmd:
1117                     ; 290     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1119                     ; 292     if (NewState != DISABLE)
1121  01d1 4d            	tnz	a
1122  01d2 2705          	jreq	L534
1123                     ; 295         UART2->CR5 |= UART2_CR5_IREN;
1125  01d4 72125248      	bset	21064,#1
1128  01d8 81            	ret	
1129  01d9               L534:
1130                     ; 300         UART2->CR5 &= ((uint8_t)~UART2_CR5_IREN);
1132  01d9 72135248      	bres	21064,#1
1133                     ; 302 }
1136  01dd 81            	ret	
1195                     ; 311 void UART2_LINBreakDetectionConfig(UART2_LINBreakDetectionLength_TypeDef UART2_LINBreakDetectionLength)
1195                     ; 312 {
1196                     	switch	.text
1197  01de               _UART2_LINBreakDetectionConfig:
1201                     ; 314     assert_param(IS_UART2_LINBREAKDETECTIONLENGTH_OK(UART2_LINBreakDetectionLength));
1203                     ; 316     if (UART2_LINBreakDetectionLength != UART2_LINBREAKDETECTIONLENGTH_10BITS)
1205  01de 4d            	tnz	a
1206  01df 2705          	jreq	L764
1207                     ; 318         UART2->CR4 |= UART2_CR4_LBDL;
1209  01e1 721a5247      	bset	21063,#5
1212  01e5 81            	ret	
1213  01e6               L764:
1214                     ; 322         UART2->CR4 &= ((uint8_t)~UART2_CR4_LBDL);
1216  01e6 721b5247      	bres	21063,#5
1217                     ; 324 }
1220  01ea 81            	ret	
1341                     ; 336 void UART2_LINConfig(UART2_LinMode_TypeDef UART2_Mode, 
1341                     ; 337                      UART2_LinAutosync_TypeDef UART2_Autosync, 
1341                     ; 338                      UART2_LinDivUp_TypeDef UART2_DivUp)
1341                     ; 339 {
1342                     	switch	.text
1343  01eb               _UART2_LINConfig:
1345  01eb 89            	pushw	x
1346       00000000      OFST:	set	0
1349                     ; 341     assert_param(IS_UART2_SLAVE_OK(UART2_Mode));
1351                     ; 342     assert_param(IS_UART2_AUTOSYNC_OK(UART2_Autosync));
1353                     ; 343     assert_param(IS_UART2_DIVUP_OK(UART2_DivUp));
1355                     ; 345     if (UART2_Mode != UART2_LIN_MODE_MASTER)
1357  01ec 9e            	ld	a,xh
1358  01ed 4d            	tnz	a
1359  01ee 2706          	jreq	L155
1360                     ; 347         UART2->CR6 |=  UART2_CR6_LSLV;
1362  01f0 721a5249      	bset	21065,#5
1364  01f4 2004          	jra	L355
1365  01f6               L155:
1366                     ; 351         UART2->CR6 &= ((uint8_t)~UART2_CR6_LSLV);
1368  01f6 721b5249      	bres	21065,#5
1369  01fa               L355:
1370                     ; 354     if (UART2_Autosync != UART2_LIN_AUTOSYNC_DISABLE)
1372  01fa 7b02          	ld	a,(OFST+2,sp)
1373  01fc 2706          	jreq	L555
1374                     ; 356         UART2->CR6 |=  UART2_CR6_LASE ;
1376  01fe 72185249      	bset	21065,#4
1378  0202 2004          	jra	L755
1379  0204               L555:
1380                     ; 360         UART2->CR6 &= ((uint8_t)~ UART2_CR6_LASE );
1382  0204 72195249      	bres	21065,#4
1383  0208               L755:
1384                     ; 363     if (UART2_DivUp != UART2_LIN_DIVUP_LBRR1)
1386  0208 7b05          	ld	a,(OFST+5,sp)
1387  020a 2706          	jreq	L165
1388                     ; 365         UART2->CR6 |=  UART2_CR6_LDUM;
1390  020c 721e5249      	bset	21065,#7
1392  0210 2004          	jra	L365
1393  0212               L165:
1394                     ; 369         UART2->CR6 &= ((uint8_t)~ UART2_CR6_LDUM);
1396  0212 721f5249      	bres	21065,#7
1397  0216               L365:
1398                     ; 371 }
1401  0216 85            	popw	x
1402  0217 81            	ret	
1437                     ; 379 void UART2_LINCmd(FunctionalState NewState)
1437                     ; 380 {
1438                     	switch	.text
1439  0218               _UART2_LINCmd:
1443                     ; 381     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1445                     ; 383     if (NewState != DISABLE)
1447  0218 4d            	tnz	a
1448  0219 2705          	jreq	L306
1449                     ; 386         UART2->CR3 |= UART2_CR3_LINEN;
1451  021b 721c5246      	bset	21062,#6
1454  021f 81            	ret	
1455  0220               L306:
1456                     ; 391         UART2->CR3 &= ((uint8_t)~UART2_CR3_LINEN);
1458  0220 721d5246      	bres	21062,#6
1459                     ; 393 }
1462  0224 81            	ret	
1497                     ; 400 void UART2_SmartCardCmd(FunctionalState NewState)
1497                     ; 401 {
1498                     	switch	.text
1499  0225               _UART2_SmartCardCmd:
1503                     ; 403     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1505                     ; 405     if (NewState != DISABLE)
1507  0225 4d            	tnz	a
1508  0226 2705          	jreq	L526
1509                     ; 408         UART2->CR5 |= UART2_CR5_SCEN;
1511  0228 721a5248      	bset	21064,#5
1514  022c 81            	ret	
1515  022d               L526:
1516                     ; 413         UART2->CR5 &= ((uint8_t)(~UART2_CR5_SCEN));
1518  022d 721b5248      	bres	21064,#5
1519                     ; 415 }
1522  0231 81            	ret	
1558                     ; 423 void UART2_SmartCardNACKCmd(FunctionalState NewState)
1558                     ; 424 {
1559                     	switch	.text
1560  0232               _UART2_SmartCardNACKCmd:
1564                     ; 426     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1566                     ; 428     if (NewState != DISABLE)
1568  0232 4d            	tnz	a
1569  0233 2705          	jreq	L746
1570                     ; 431         UART2->CR5 |= UART2_CR5_NACK;
1572  0235 72185248      	bset	21064,#4
1575  0239 81            	ret	
1576  023a               L746:
1577                     ; 436         UART2->CR5 &= ((uint8_t)~(UART2_CR5_NACK));
1579  023a 72195248      	bres	21064,#4
1580                     ; 438 }
1583  023e 81            	ret	
1640                     ; 446 void UART2_WakeUpConfig(UART2_WakeUp_TypeDef UART2_WakeUp)
1640                     ; 447 {
1641                     	switch	.text
1642  023f               _UART2_WakeUpConfig:
1646                     ; 448     assert_param(IS_UART2_WAKEUP_OK(UART2_WakeUp));
1648                     ; 450     UART2->CR1 &= ((uint8_t)~UART2_CR1_WAKE);
1650  023f 72175244      	bres	21060,#3
1651                     ; 451     UART2->CR1 |= (uint8_t)UART2_WakeUp;
1653  0243 ca5244        	or	a,21060
1654  0246 c75244        	ld	21060,a
1655                     ; 452 }
1658  0249 81            	ret	
1694                     ; 460 void UART2_ReceiverWakeUpCmd(FunctionalState NewState)
1694                     ; 461 {
1695                     	switch	.text
1696  024a               _UART2_ReceiverWakeUpCmd:
1700                     ; 462     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1702                     ; 464     if (NewState != DISABLE)
1704  024a 4d            	tnz	a
1705  024b 2705          	jreq	L717
1706                     ; 467         UART2->CR2 |= UART2_CR2_RWU;
1708  024d 72125245      	bset	21061,#1
1711  0251 81            	ret	
1712  0252               L717:
1713                     ; 472         UART2->CR2 &= ((uint8_t)~UART2_CR2_RWU);
1715  0252 72135245      	bres	21061,#1
1716                     ; 474 }
1719  0256 81            	ret	
1742                     ; 481 uint8_t UART2_ReceiveData8(void)
1742                     ; 482 {
1743                     	switch	.text
1744  0257               _UART2_ReceiveData8:
1748                     ; 483     return ((uint8_t)UART2->DR);
1750  0257 c65241        	ld	a,21057
1753  025a 81            	ret	
1787                     ; 491 uint16_t UART2_ReceiveData9(void)
1787                     ; 492 {
1788                     	switch	.text
1789  025b               _UART2_ReceiveData9:
1791  025b 89            	pushw	x
1792       00000002      OFST:	set	2
1795                     ; 493   uint16_t temp = 0;
1797                     ; 495   temp = ((uint16_t)(((uint16_t)((uint16_t)UART2->CR1 & (uint16_t)UART2_CR1_R8)) << 1));
1799  025c c65244        	ld	a,21060
1800  025f a480          	and	a,#128
1801  0261 5f            	clrw	x
1802  0262 02            	rlwa	x,a
1803  0263 58            	sllw	x
1804  0264 1f01          	ldw	(OFST-1,sp),x
1806                     ; 497   return (uint16_t)((((uint16_t)UART2->DR) | temp) & ((uint16_t)0x01FF));
1808  0266 c65241        	ld	a,21057
1809  0269 5f            	clrw	x
1810  026a 97            	ld	xl,a
1811  026b 01            	rrwa	x,a
1812  026c 1a02          	or	a,(OFST+0,sp)
1813  026e 01            	rrwa	x,a
1814  026f 1a01          	or	a,(OFST-1,sp)
1815  0271 a401          	and	a,#1
1816  0273 01            	rrwa	x,a
1819  0274 5b02          	addw	sp,#2
1820  0276 81            	ret	
1854                     ; 505 void UART2_SendData8(uint8_t Data)
1854                     ; 506 {
1855                     	switch	.text
1856  0277               _UART2_SendData8:
1860                     ; 508     UART2->DR = Data;
1862  0277 c75241        	ld	21057,a
1863                     ; 509 }
1866  027a 81            	ret	
1900                     ; 516 void UART2_SendData9(uint16_t Data)
1900                     ; 517 {
1901                     	switch	.text
1902  027b               _UART2_SendData9:
1904  027b 89            	pushw	x
1905       00000000      OFST:	set	0
1908                     ; 519     UART2->CR1 &= ((uint8_t)~UART2_CR1_T8);                  
1910  027c 721d5244      	bres	21060,#6
1911                     ; 522     UART2->CR1 |= (uint8_t)(((uint8_t)(Data >> 2)) & UART2_CR1_T8); 
1913  0280 54            	srlw	x
1914  0281 54            	srlw	x
1915  0282 9f            	ld	a,xl
1916  0283 a440          	and	a,#64
1917  0285 ca5244        	or	a,21060
1918  0288 c75244        	ld	21060,a
1919                     ; 525     UART2->DR   = (uint8_t)(Data);                    
1921  028b 7b02          	ld	a,(OFST+2,sp)
1922  028d c75241        	ld	21057,a
1923                     ; 527 }
1926  0290 85            	popw	x
1927  0291 81            	ret	
1950                     ; 534 void UART2_SendBreak(void)
1950                     ; 535 {
1951                     	switch	.text
1952  0292               _UART2_SendBreak:
1956                     ; 536     UART2->CR2 |= UART2_CR2_SBK;
1958  0292 72105245      	bset	21061,#0
1959                     ; 537 }
1962  0296 81            	ret	
1996                     ; 544 void UART2_SetAddress(uint8_t UART2_Address)
1996                     ; 545 {
1997                     	switch	.text
1998  0297               _UART2_SetAddress:
2000  0297 88            	push	a
2001       00000000      OFST:	set	0
2004                     ; 547     assert_param(IS_UART2_ADDRESS_OK(UART2_Address));
2006                     ; 550     UART2->CR4 &= ((uint8_t)~UART2_CR4_ADD);
2008  0298 c65247        	ld	a,21063
2009  029b a4f0          	and	a,#240
2010  029d c75247        	ld	21063,a
2011                     ; 552     UART2->CR4 |= UART2_Address;
2013  02a0 c65247        	ld	a,21063
2014  02a3 1a01          	or	a,(OFST+1,sp)
2015  02a5 c75247        	ld	21063,a
2016                     ; 553 }
2019  02a8 84            	pop	a
2020  02a9 81            	ret	
2054                     ; 561 void UART2_SetGuardTime(uint8_t UART2_GuardTime)
2054                     ; 562 {
2055                     	switch	.text
2056  02aa               _UART2_SetGuardTime:
2060                     ; 564     UART2->GTR = UART2_GuardTime;
2062  02aa c7524a        	ld	21066,a
2063                     ; 565 }
2066  02ad 81            	ret	
2100                     ; 589 void UART2_SetPrescaler(uint8_t UART2_Prescaler)
2100                     ; 590 {
2101                     	switch	.text
2102  02ae               _UART2_SetPrescaler:
2106                     ; 592     UART2->PSCR = UART2_Prescaler;
2108  02ae c7524b        	ld	21067,a
2109                     ; 593 }
2112  02b1 81            	ret	
2269                     ; 601 FlagStatus UART2_GetFlagStatus(UART2_Flag_TypeDef UART2_FLAG)
2269                     ; 602 {
2270                     	switch	.text
2271  02b2               _UART2_GetFlagStatus:
2273  02b2 89            	pushw	x
2274  02b3 88            	push	a
2275       00000001      OFST:	set	1
2278                     ; 603     FlagStatus status = RESET;
2280                     ; 606     assert_param(IS_UART2_FLAG_OK(UART2_FLAG));
2282                     ; 609     if (UART2_FLAG == UART2_FLAG_LBDF)
2284  02b4 a30210        	cpw	x,#528
2285  02b7 2608          	jrne	L5511
2286                     ; 611         if ((UART2->CR4 & (uint8_t)UART2_FLAG) != (uint8_t)0x00)
2288  02b9 9f            	ld	a,xl
2289  02ba c45247        	and	a,21063
2290  02bd 2726          	jreq	L3611
2291                     ; 614             status = SET;
2293  02bf 201f          	jp	LC008
2294                     ; 619             status = RESET;
2295  02c1               L5511:
2296                     ; 622     else if (UART2_FLAG == UART2_FLAG_SBK)
2298  02c1 a30101        	cpw	x,#257
2299  02c4 2609          	jrne	L5611
2300                     ; 624         if ((UART2->CR2 & (uint8_t)UART2_FLAG) != (uint8_t)0x00)
2302  02c6 c65245        	ld	a,21061
2303  02c9 1503          	bcp	a,(OFST+2,sp)
2304  02cb 2717          	jreq	L1021
2305                     ; 627             status = SET;
2307  02cd 2011          	jp	LC008
2308                     ; 632             status = RESET;
2309  02cf               L5611:
2310                     ; 635     else if ((UART2_FLAG == UART2_FLAG_LHDF) || (UART2_FLAG == UART2_FLAG_LSF))
2312  02cf a30302        	cpw	x,#770
2313  02d2 2705          	jreq	L7711
2315  02d4 a30301        	cpw	x,#769
2316  02d7 260f          	jrne	L5711
2317  02d9               L7711:
2318                     ; 637         if ((UART2->CR6 & (uint8_t)UART2_FLAG) != (uint8_t)0x00)
2320  02d9 c65249        	ld	a,21065
2321  02dc 1503          	bcp	a,(OFST+2,sp)
2322  02de 2704          	jreq	L1021
2323                     ; 640             status = SET;
2325  02e0               LC008:
2329  02e0 a601          	ld	a,#1
2333  02e2 2001          	jra	L3611
2334  02e4               L1021:
2335                     ; 645             status = RESET;
2339  02e4 4f            	clr	a
2341  02e5               L3611:
2342                     ; 663     return  status;
2346  02e5 5b03          	addw	sp,#3
2347  02e7 81            	ret	
2348  02e8               L5711:
2349                     ; 650         if ((UART2->SR & (uint8_t)UART2_FLAG) != (uint8_t)0x00)
2351  02e8 c65240        	ld	a,21056
2352  02eb 1503          	bcp	a,(OFST+2,sp)
2353  02ed 27f5          	jreq	L1021
2354                     ; 653             status = SET;
2356  02ef 20ef          	jp	LC008
2357                     ; 658             status = RESET;
2392                     ; 693 void UART2_ClearFlag(UART2_Flag_TypeDef UART2_FLAG)
2392                     ; 694 {
2393                     	switch	.text
2394  02f1               _UART2_ClearFlag:
2396       00000000      OFST:	set	0
2399                     ; 695     assert_param(IS_UART2_CLEAR_FLAG_OK(UART2_FLAG));
2401                     ; 698     if (UART2_FLAG == UART2_FLAG_RXNE)
2403  02f1 a30020        	cpw	x,#32
2404  02f4 2605          	jrne	L1321
2405                     ; 700         UART2->SR = (uint8_t)~(UART2_SR_RXNE);
2407  02f6 35df5240      	mov	21056,#223
2410  02fa 81            	ret	
2411  02fb               L1321:
2412                     ; 703     else if (UART2_FLAG == UART2_FLAG_LBDF)
2414  02fb a30210        	cpw	x,#528
2415  02fe 2605          	jrne	L5321
2416                     ; 705         UART2->CR4 &= (uint8_t)(~UART2_CR4_LBDF);
2418  0300 72195247      	bres	21063,#4
2421  0304 81            	ret	
2422  0305               L5321:
2423                     ; 708     else if (UART2_FLAG == UART2_FLAG_LHDF)
2425  0305 a30302        	cpw	x,#770
2426  0308 2605          	jrne	L1421
2427                     ; 710         UART2->CR6 &= (uint8_t)(~UART2_CR6_LHDF);
2429  030a 72135249      	bres	21065,#1
2432  030e 81            	ret	
2433  030f               L1421:
2434                     ; 715         UART2->CR6 &= (uint8_t)(~UART2_CR6_LSF);
2436  030f 72115249      	bres	21065,#0
2437                     ; 717 }
2440  0313 81            	ret	
2522                     ; 732 ITStatus UART2_GetITStatus(UART2_IT_TypeDef UART2_IT)
2522                     ; 733 {
2523                     	switch	.text
2524  0314               _UART2_GetITStatus:
2526  0314 89            	pushw	x
2527  0315 89            	pushw	x
2528       00000002      OFST:	set	2
2531                     ; 734     ITStatus pendingbitstatus = RESET;
2533                     ; 735     uint8_t itpos = 0;
2535                     ; 736     uint8_t itmask1 = 0;
2537                     ; 737     uint8_t itmask2 = 0;
2539                     ; 738     uint8_t enablestatus = 0;
2541                     ; 741     assert_param(IS_UART2_GET_IT_OK(UART2_IT));
2543                     ; 744     itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)UART2_IT & (uint8_t)0x0F));
2545  0316 9f            	ld	a,xl
2546  0317 a40f          	and	a,#15
2547  0319 5f            	clrw	x
2548  031a 97            	ld	xl,a
2549  031b a601          	ld	a,#1
2550  031d 5d            	tnzw	x
2551  031e 2704          	jreq	L67
2552  0320               L001:
2553  0320 48            	sll	a
2554  0321 5a            	decw	x
2555  0322 26fc          	jrne	L001
2556  0324               L67:
2557  0324 6b01          	ld	(OFST-1,sp),a
2559                     ; 746     itmask1 = (uint8_t)((uint8_t)UART2_IT >> (uint8_t)4);
2561  0326 7b04          	ld	a,(OFST+2,sp)
2562  0328 4e            	swap	a
2563  0329 a40f          	and	a,#15
2564  032b 6b02          	ld	(OFST+0,sp),a
2566                     ; 748     itmask2 = (uint8_t)((uint8_t)1 << itmask1);
2568  032d 5f            	clrw	x
2569  032e 97            	ld	xl,a
2570  032f a601          	ld	a,#1
2571  0331 5d            	tnzw	x
2572  0332 2704          	jreq	L201
2573  0334               L401:
2574  0334 48            	sll	a
2575  0335 5a            	decw	x
2576  0336 26fc          	jrne	L401
2577  0338               L201:
2578  0338 6b02          	ld	(OFST+0,sp),a
2580                     ; 751     if (UART2_IT == UART2_IT_PE)
2582  033a 1e03          	ldw	x,(OFST+1,sp)
2583  033c a30100        	cpw	x,#256
2584  033f 260c          	jrne	L7031
2585                     ; 754         enablestatus = (uint8_t)((uint8_t)UART2->CR1 & itmask2);
2587  0341 c65244        	ld	a,21060
2588  0344 1402          	and	a,(OFST+0,sp)
2589  0346 6b02          	ld	(OFST+0,sp),a
2591                     ; 757         if (((UART2->SR & itpos) != (uint8_t)0x00) && enablestatus)
2593  0348 c65240        	ld	a,21056
2595                     ; 760             pendingbitstatus = SET;
2597  034b 2020          	jp	LC011
2598                     ; 765             pendingbitstatus = RESET;
2599  034d               L7031:
2600                     ; 768     else if (UART2_IT == UART2_IT_LBDF)
2602  034d a30346        	cpw	x,#838
2603  0350 260c          	jrne	L7131
2604                     ; 771         enablestatus = (uint8_t)((uint8_t)UART2->CR4 & itmask2);
2606  0352 c65247        	ld	a,21063
2607  0355 1402          	and	a,(OFST+0,sp)
2608  0357 6b02          	ld	(OFST+0,sp),a
2610                     ; 773         if (((UART2->CR4 & itpos) != (uint8_t)0x00) && enablestatus)
2612  0359 c65247        	ld	a,21063
2614                     ; 776             pendingbitstatus = SET;
2616  035c 200f          	jp	LC011
2617                     ; 781             pendingbitstatus = RESET;
2618  035e               L7131:
2619                     ; 784     else if (UART2_IT == UART2_IT_LHDF)
2621  035e a30412        	cpw	x,#1042
2622  0361 2616          	jrne	L7231
2623                     ; 787         enablestatus = (uint8_t)((uint8_t)UART2->CR6 & itmask2);
2625  0363 c65249        	ld	a,21065
2626  0366 1402          	and	a,(OFST+0,sp)
2627  0368 6b02          	ld	(OFST+0,sp),a
2629                     ; 789         if (((UART2->CR6 & itpos) != (uint8_t)0x00) && enablestatus)
2631  036a c65249        	ld	a,21065
2633  036d               LC011:
2634  036d 1501          	bcp	a,(OFST-1,sp)
2635  036f 271a          	jreq	L7331
2636  0371 7b02          	ld	a,(OFST+0,sp)
2637  0373 2716          	jreq	L7331
2638                     ; 792             pendingbitstatus = SET;
2640  0375               LC010:
2644  0375 a601          	ld	a,#1
2647  0377 2013          	jra	L5131
2648                     ; 797             pendingbitstatus = RESET;
2649  0379               L7231:
2650                     ; 803         enablestatus = (uint8_t)((uint8_t)UART2->CR2 & itmask2);
2652  0379 c65245        	ld	a,21061
2653  037c 1402          	and	a,(OFST+0,sp)
2654  037e 6b02          	ld	(OFST+0,sp),a
2656                     ; 805         if (((UART2->SR & itpos) != (uint8_t)0x00) && enablestatus)
2658  0380 c65240        	ld	a,21056
2659  0383 1501          	bcp	a,(OFST-1,sp)
2660  0385 2704          	jreq	L7331
2662  0387 7b02          	ld	a,(OFST+0,sp)
2663                     ; 808             pendingbitstatus = SET;
2665  0389 26ea          	jrne	LC010
2666  038b               L7331:
2667                     ; 813             pendingbitstatus = RESET;
2672  038b 4f            	clr	a
2674  038c               L5131:
2675                     ; 817     return  pendingbitstatus;
2679  038c 5b04          	addw	sp,#4
2680  038e 81            	ret	
2716                     ; 846 void UART2_ClearITPendingBit(UART2_IT_TypeDef UART2_IT)
2716                     ; 847 {
2717                     	switch	.text
2718  038f               _UART2_ClearITPendingBit:
2720       00000000      OFST:	set	0
2723                     ; 848     assert_param(IS_UART2_CLEAR_IT_OK(UART2_IT));
2725                     ; 851     if (UART2_IT == UART2_IT_RXNE)
2727  038f a30255        	cpw	x,#597
2728  0392 2605          	jrne	L1631
2729                     ; 853         UART2->SR = (uint8_t)~(UART2_SR_RXNE);
2731  0394 35df5240      	mov	21056,#223
2734  0398 81            	ret	
2735  0399               L1631:
2736                     ; 856     else if (UART2_IT == UART2_IT_LBDF)
2738  0399 a30346        	cpw	x,#838
2739  039c 2605          	jrne	L5631
2740                     ; 858         UART2->CR4 &= (uint8_t)~(UART2_CR4_LBDF);
2742  039e 72195247      	bres	21063,#4
2745  03a2 81            	ret	
2746  03a3               L5631:
2747                     ; 863         UART2->CR6 &= (uint8_t)(~UART2_CR6_LHDF);
2749  03a3 72135249      	bres	21065,#1
2750                     ; 865 }
2753  03a7 81            	ret	
2766                     	xdef	_UART2_ClearITPendingBit
2767                     	xdef	_UART2_GetITStatus
2768                     	xdef	_UART2_ClearFlag
2769                     	xdef	_UART2_GetFlagStatus
2770                     	xdef	_UART2_SetPrescaler
2771                     	xdef	_UART2_SetGuardTime
2772                     	xdef	_UART2_SetAddress
2773                     	xdef	_UART2_SendBreak
2774                     	xdef	_UART2_SendData9
2775                     	xdef	_UART2_SendData8
2776                     	xdef	_UART2_ReceiveData9
2777                     	xdef	_UART2_ReceiveData8
2778                     	xdef	_UART2_ReceiverWakeUpCmd
2779                     	xdef	_UART2_WakeUpConfig
2780                     	xdef	_UART2_SmartCardNACKCmd
2781                     	xdef	_UART2_SmartCardCmd
2782                     	xdef	_UART2_LINCmd
2783                     	xdef	_UART2_LINConfig
2784                     	xdef	_UART2_LINBreakDetectionConfig
2785                     	xdef	_UART2_IrDACmd
2786                     	xdef	_UART2_IrDAConfig
2787                     	xdef	_UART2_ITConfig
2788                     	xdef	_UART2_Cmd
2789                     	xdef	_UART2_Init
2790                     	xdef	_UART2_DeInit
2791                     	xref	_CLK_GetClockFreq
2792                     	xref.b	c_lreg
2793                     	xref.b	c_x
2812                     	xref	c_lsub
2813                     	xref	c_smul
2814                     	xref	c_ludv
2815                     	xref	c_rtol
2816                     	xref	c_llsh
2817                     	xref	c_ltor
2818                     	end
