   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
   4                     ; Optimizer V4.5.3 - 16 Jun 2021
  19                     	bsct
  20  0000               _BlinkSpeed:
  21  0000 06            	dc.b	6
  22  0001               _CheckFlag:
  23  0001 0001          	dc.w	1
  65                     ; 113 void enviaSerial(char dado)
  65                     ; 114 {
  67                     	switch	.text
  68  0000               _enviaSerial:
  72                     ; 115   UART2_SendData8(dado);
  74  0000 cd0000        	call	_UART2_SendData8
  77  0003               L13:
  78                     ; 116   while (UART2_GetFlagStatus(UART2_FLAG_TC) == FALSE)
  80  0003 ae0040        	ldw	x,#64
  81  0006 cd0000        	call	_UART2_GetFlagStatus
  83  0009 4d            	tnz	a
  84  000a 27f7          	jreq	L13
  85                     ; 118 }
  88  000c 81            	ret	
 141                     ; 120 void limpaVetor(char vetor[], char tamanho)
 141                     ; 121 {
 142                     	switch	.text
 143  000d               _limpaVetor:
 145  000d 89            	pushw	x
 146  000e 88            	push	a
 147       00000001      OFST:	set	1
 150                     ; 122   char varre = 0;
 152                     ; 123   for (varre = 0; varre < tamanho; varre++)
 154  000f 0f01          	clr	(OFST+0,sp)
 157  0011 2008          	jra	L76
 158  0013               L36:
 159                     ; 125     vetor[varre] = '\0';
 161  0013 5f            	clrw	x
 162  0014 97            	ld	xl,a
 163  0015 72fb02        	addw	x,(OFST+1,sp)
 164  0018 7f            	clr	(x)
 165                     ; 123   for (varre = 0; varre < tamanho; varre++)
 167  0019 0c01          	inc	(OFST+0,sp)
 169  001b               L76:
 172  001b 7b01          	ld	a,(OFST+0,sp)
 173  001d 1106          	cp	a,(OFST+5,sp)
 174  001f 25f2          	jrult	L36
 175                     ; 127 }
 178  0021 5b03          	addw	sp,#3
 179  0023 81            	ret	
 233                     ; 129 void enviaTodoBuffer(char msg[], char tamanhoMsg)
 233                     ; 130 {
 234                     	switch	.text
 235  0024               _enviaTodoBuffer:
 237  0024 89            	pushw	x
 238  0025 88            	push	a
 239       00000001      OFST:	set	1
 242                     ; 131   char varre = 0;
 244                     ; 132   for (varre = 0; varre < tamanhoMsg; varre++)
 246  0026 0f01          	clr	(OFST+0,sp)
 249  0028 200a          	jra	L521
 250  002a               L121:
 251                     ; 134     enviaSerial(msg[varre]);
 253  002a 5f            	clrw	x
 254  002b 97            	ld	xl,a
 255  002c 72fb02        	addw	x,(OFST+1,sp)
 256  002f f6            	ld	a,(x)
 257  0030 adce          	call	_enviaSerial
 259                     ; 132   for (varre = 0; varre < tamanhoMsg; varre++)
 261  0032 0c01          	inc	(OFST+0,sp)
 263  0034               L521:
 266  0034 7b01          	ld	a,(OFST+0,sp)
 267  0036 1106          	cp	a,(OFST+5,sp)
 268  0038 25f0          	jrult	L121
 269                     ; 138 }
 272  003a 5b03          	addw	sp,#3
 273  003c 81            	ret	
 335                     ; 140 char calculateBCC_RX(char msg[], char tamanhoMsg)
 335                     ; 141 {
 336                     	switch	.text
 337  003d               _calculateBCC_RX:
 339  003d 89            	pushw	x
 340  003e 89            	pushw	x
 341       00000002      OFST:	set	2
 344                     ; 142   char varre = 0, BCC_RX = 0x00;
 348  003f 0f01          	clr	(OFST-1,sp)
 350                     ; 144   for (varre = 0; varre <= tamanhoMsg - 2; varre++)
 352  0041 0f02          	clr	(OFST+0,sp)
 355  0043 200c          	jra	L761
 356  0045               L361:
 357                     ; 146     BCC_RX = msg[varre] ^ BCC_RX;
 359  0045 5f            	clrw	x
 360  0046 97            	ld	xl,a
 361  0047 72fb03        	addw	x,(OFST+1,sp)
 362  004a 7b01          	ld	a,(OFST-1,sp)
 363  004c f8            	xor	a,(x)
 364  004d 6b01          	ld	(OFST-1,sp),a
 366                     ; 144   for (varre = 0; varre <= tamanhoMsg - 2; varre++)
 368  004f 0c02          	inc	(OFST+0,sp)
 370  0051               L761:
 373  0051 7b07          	ld	a,(OFST+5,sp)
 374  0053 5f            	clrw	x
 375  0054 97            	ld	xl,a
 376  0055 1d0002        	subw	x,#2
 377  0058 7b02          	ld	a,(OFST+0,sp)
 378  005a 905f          	clrw	y
 379  005c 9097          	ld	yl,a
 380  005e 90bf00        	ldw	c_y,y
 381  0061 b300          	cpw	x,c_y
 382  0063 2ee0          	jrsge	L361
 383                     ; 148   return BCC_RX;
 385  0065 7b01          	ld	a,(OFST-1,sp)
 388  0067 5b04          	addw	sp,#4
 389  0069 81            	ret	
 459                     ; 151 char calculateBCC_Param(char enderecoDestino, char comando, char dados1, char dados2)
 459                     ; 152 {
 460                     	switch	.text
 461  006a               _calculateBCC_Param:
 463  006a 89            	pushw	x
 464  006b 88            	push	a
 465       00000001      OFST:	set	1
 468                     ; 153   char BCC = 0x00;
 470  006c 0f01          	clr	(OFST+0,sp)
 472                     ; 155   if (dados1 == '\0' && dados2 == '\0') //Tamanho = 0x05
 474  006e 7b06          	ld	a,(OFST+5,sp)
 475  0070 260d          	jrne	L132
 477  0072 7b07          	ld	a,(OFST+6,sp)
 478  0074 2609          	jrne	L132
 479                     ; 157     BCC = STX ^ BCC;
 481                     ; 158     BCC = 0x05 ^ BCC;
 483                     ; 159     BCC = enderecoDestino ^ BCC;
 485  0076 9e            	ld	a,xh
 486  0077 a807          	xor	a,#7
 488                     ; 160     BCC = ENDERECO_DISP ^ BCC;
 490  0079 a801          	xor	a,#1
 492                     ; 161     BCC = comando ^ BCC;
 494  007b 1803          	xor	a,(OFST+2,sp)
 496  007d 2028          	jp	LC001
 497  007f               L132:
 498                     ; 163   else if (!dados1 == '\0' && dados2 == '\0') //Tamanho = 0x06
 500  007f 7b06          	ld	a,(OFST+5,sp)
 501  0081 2710          	jreq	L532
 503  0083 7b07          	ld	a,(OFST+6,sp)
 504  0085 260c          	jrne	L532
 505                     ; 165     BCC = STX ^ BCC;
 507                     ; 166     BCC = 0x06 ^ BCC;
 509                     ; 167     BCC = enderecoDestino ^ BCC;
 511  0087 7b02          	ld	a,(OFST+1,sp)
 512  0089 a804          	xor	a,#4
 514                     ; 168     BCC = ENDERECO_DISP ^ BCC;
 516  008b a801          	xor	a,#1
 518                     ; 169     BCC = comando ^ BCC;
 520  008d 1803          	xor	a,(OFST+2,sp)
 522                     ; 170     BCC = dados1 ^ BCC;
 524  008f 1806          	xor	a,(OFST+5,sp)
 526  0091 2014          	jp	LC001
 527  0093               L532:
 528                     ; 172   else if (!dados1 == '\0' && !dados2 == '\0') //Tamanho = 0x07
 530  0093 7b06          	ld	a,(OFST+5,sp)
 531  0095 2712          	jreq	L332
 533  0097 7b07          	ld	a,(OFST+6,sp)
 534  0099 270e          	jreq	L332
 535                     ; 174     BCC = STX ^ BCC;
 537                     ; 175     BCC = 0x07 ^ BCC;
 539                     ; 176     BCC = enderecoDestino ^ BCC;
 541  009b 7b02          	ld	a,(OFST+1,sp)
 542  009d a805          	xor	a,#5
 544                     ; 177     BCC = ENDERECO_DISP ^ BCC;
 546  009f a801          	xor	a,#1
 548                     ; 178     BCC = comando ^ BCC;
 550  00a1 1803          	xor	a,(OFST+2,sp)
 552                     ; 179     BCC = dados1 ^ BCC;
 554  00a3 1806          	xor	a,(OFST+5,sp)
 556                     ; 180     BCC = dados2 ^ BCC;
 558  00a5 1807          	xor	a,(OFST+6,sp)
 559  00a7               LC001:
 560  00a7 6b01          	ld	(OFST+0,sp),a
 562  00a9               L332:
 563                     ; 182   return BCC;
 565  00a9 7b01          	ld	a,(OFST+0,sp)
 568  00ab 5b03          	addw	sp,#3
 569  00ad 81            	ret	
 640                     ; 185 void piscaLED(char LED, char qtdePiscadas, char intervalo)
 640                     ; 186 {
 641                     	switch	.text
 642  00ae               _piscaLED:
 644  00ae 89            	pushw	x
 645  00af 5203          	subw	sp,#3
 646       00000003      OFST:	set	3
 649                     ; 187   char varre = 0x00, flagAUX = 0x00, varre2;
 653  00b1 0f02          	clr	(OFST-1,sp)
 655                     ; 189   for (varre = 0; varre <= qtdePiscadas; varre++)
 657  00b3 0f01          	clr	(OFST-2,sp)
 660  00b5 2025          	jra	L503
 661  00b7               L103:
 662                     ; 192     if (flagAUX == 0x00)
 664  00b7 7b02          	ld	a,(OFST-1,sp)
 665  00b9 261b          	jrne	L113
 666                     ; 194       if (LED == 0x01)
 668  00bb 7b04          	ld	a,(OFST+1,sp)
 669  00bd a101          	cp	a,#1
 670  00bf 2604          	jrne	L313
 671                     ; 196         GPIO_WriteHigh(GPIOD, GPIO_PIN_2);
 673  00c1 4b04          	push	#4
 676  00c3 2006          	jp	LC002
 677  00c5               L313:
 678                     ; 198       else if (LED == 0x02)
 680  00c5 a102          	cp	a,#2
 681  00c7 2609          	jrne	L513
 682                     ; 200         GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
 684  00c9 4b08          	push	#8
 686  00cb               LC002:
 687  00cb ae500f        	ldw	x,#20495
 688  00ce cd0000        	call	_GPIO_WriteHigh
 689  00d1 84            	pop	a
 690  00d2               L513:
 691                     ; 202       flagAUX = 0x01;
 693  00d2 a601          	ld	a,#1
 694  00d4 6b02          	ld	(OFST-1,sp),a
 696  00d6               L113:
 697                     ; 205     for (varre2 = 0; varre2 < 0xffff; varre2++)
 699  00d6 0f03          	clr	(OFST+0,sp)
 701  00d8               L523:
 704  00d8 0c03          	inc	(OFST+0,sp)
 707  00da 20fc          	jra	L523
 708  00dc               L503:
 709                     ; 189   for (varre = 0; varre <= qtdePiscadas; varre++)
 712  00dc 7b01          	ld	a,(OFST-2,sp)
 713  00de 1105          	cp	a,(OFST+2,sp)
 714  00e0 23d5          	jrule	L103
 715                     ; 225 }
 718  00e2 5b05          	addw	sp,#5
 719  00e4 81            	ret	
 836                     ; 227 void debugCOM(char Dados_comando_RX[], char STX_RX, char tamanhoPacote_RX, char enderecoDestino_RX, char enderecoOrigem_RX, char comando_RX, char dadosPacote1_RX, char dadosPacote2_RX, char BCC_RX, char tamanhoMsg, char flagCOM_RX)
 836                     ; 228 {
 837                     	switch	.text
 838  00e5               _debugCOM:
 840  00e5 89            	pushw	x
 841  00e6 88            	push	a
 842       00000001      OFST:	set	1
 845                     ; 229   char varredura = 0x00;
 847                     ; 231   enviaSerial(0x00);
 849  00e7 4f            	clr	a
 850  00e8 cd0000        	call	_enviaSerial
 852                     ; 232   enviaSerial(STX_RX);
 854  00eb 7b06          	ld	a,(OFST+5,sp)
 855  00ed cd0000        	call	_enviaSerial
 857                     ; 233   enviaSerial(0x01);
 859  00f0 a601          	ld	a,#1
 860  00f2 cd0000        	call	_enviaSerial
 862                     ; 234   enviaSerial(tamanhoPacote_RX);
 864  00f5 7b07          	ld	a,(OFST+6,sp)
 865  00f7 cd0000        	call	_enviaSerial
 867                     ; 235   enviaSerial(0x02);
 869  00fa a602          	ld	a,#2
 870  00fc cd0000        	call	_enviaSerial
 872                     ; 236   enviaSerial(enderecoDestino_RX);
 874  00ff 7b08          	ld	a,(OFST+7,sp)
 875  0101 cd0000        	call	_enviaSerial
 877                     ; 237   enviaSerial(0x03);
 879  0104 a603          	ld	a,#3
 880  0106 cd0000        	call	_enviaSerial
 882                     ; 238   enviaSerial(enderecoOrigem_RX);
 884  0109 7b09          	ld	a,(OFST+8,sp)
 885  010b cd0000        	call	_enviaSerial
 887                     ; 239   enviaSerial(0x04);
 889  010e a604          	ld	a,#4
 890  0110 cd0000        	call	_enviaSerial
 892                     ; 240   enviaSerial(comando_RX);
 894  0113 7b0a          	ld	a,(OFST+9,sp)
 895  0115 cd0000        	call	_enviaSerial
 897                     ; 241   enviaSerial(0x05);
 899  0118 a605          	ld	a,#5
 900  011a cd0000        	call	_enviaSerial
 902                     ; 242     for(varredura=0; varredura<=sizeof(Dados_comando_RX)-1;varredura++)
 904  011d 4f            	clr	a
 905  011e 6b01          	ld	(OFST+0,sp),a
 907  0120               L114:
 908                     ; 244 			enviaSerial(Dados_comando_RX[varredura]);
 910  0120 5f            	clrw	x
 911  0121 97            	ld	xl,a
 912  0122 72fb02        	addw	x,(OFST+1,sp)
 913  0125 f6            	ld	a,(x)
 914  0126 cd0000        	call	_enviaSerial
 916                     ; 242     for(varredura=0; varredura<=sizeof(Dados_comando_RX)-1;varredura++)
 918  0129 0c01          	inc	(OFST+0,sp)
 922  012b 7b01          	ld	a,(OFST+0,sp)
 923  012d a102          	cp	a,#2
 924  012f 25ef          	jrult	L114
 925                     ; 249   enviaSerial(0x07);
 927  0131 a607          	ld	a,#7
 928  0133 cd0000        	call	_enviaSerial
 930                     ; 250   enviaSerial(BCC_RX);
 932  0136 7b0d          	ld	a,(OFST+12,sp)
 933  0138 cd0000        	call	_enviaSerial
 935                     ; 251   enviaSerial(0x08);
 937  013b a608          	ld	a,#8
 938  013d cd0000        	call	_enviaSerial
 940                     ; 252   enviaSerial(tamanhoMsg);
 942  0140 7b0e          	ld	a,(OFST+13,sp)
 943  0142 cd0000        	call	_enviaSerial
 945                     ; 253   enviaSerial(0x09);
 947  0145 a609          	ld	a,#9
 948  0147 cd0000        	call	_enviaSerial
 950                     ; 254   enviaSerial(flagCOM_RX);
 952  014a 7b0f          	ld	a,(OFST+14,sp)
 953  014c cd0000        	call	_enviaSerial
 955                     ; 255 }
 958  014f 5b03          	addw	sp,#3
 959  0151 81            	ret	
1015                     ; 257 char coletaBuffer(char buffer[])
1015                     ; 258 {
1016                     	switch	.text
1017  0152               _coletaBuffer:
1019  0152 89            	pushw	x
1020  0153 5205          	subw	sp,#5
1021       00000005      OFST:	set	5
1024                     ; 259   unsigned long tempo_RX = 0xFFFF;
1026  0155 aeffff        	ldw	x,#65535
1027  0158 1f04          	ldw	(OFST-1,sp),x
1028  015a 5f            	clrw	x
1029  015b 1f02          	ldw	(OFST-3,sp),x
1031                     ; 260   char tamanhoMsg = 0;
1033  015d 0f01          	clr	(OFST-4,sp)
1035                     ; 262   GPIO_WriteLow(GPIOD, GPIO_PIN_1); //Hab leitura
1037  015f 4b02          	push	#2
1038  0161 ae500f        	ldw	x,#20495
1039  0164 cd0000        	call	_GPIO_WriteLow
1041  0167 84            	pop	a
1043  0168 2029          	jra	L744
1044  016a               L544:
1045                     ; 265     if (UART2_GetFlagStatus(UART2_FLAG_RXNE) == TRUE)
1047  016a ae0020        	ldw	x,#32
1048  016d cd0000        	call	_UART2_GetFlagStatus
1050  0170 4a            	dec	a
1051  0171 2617          	jrne	L354
1052                     ; 267       buffer[tamanhoMsg] = UART2_ReceiveData8();
1054  0173 7b01          	ld	a,(OFST-4,sp)
1055  0175 5f            	clrw	x
1056  0176 97            	ld	xl,a
1057  0177 72fb06        	addw	x,(OFST+1,sp)
1058  017a 89            	pushw	x
1059  017b cd0000        	call	_UART2_ReceiveData8
1061  017e 85            	popw	x
1062  017f f7            	ld	(x),a
1063                     ; 268       tempo_RX = 0xFFF;
1065  0180 ae0fff        	ldw	x,#4095
1066  0183 1f04          	ldw	(OFST-1,sp),x
1067  0185 5f            	clrw	x
1068  0186 1f02          	ldw	(OFST-3,sp),x
1070                     ; 269       tamanhoMsg++;
1072  0188 0c01          	inc	(OFST-4,sp)
1074  018a               L354:
1075                     ; 271     tempo_RX--;
1077  018a 96            	ldw	x,sp
1078  018b 1c0002        	addw	x,#OFST-3
1079  018e a601          	ld	a,#1
1080  0190 cd0000        	call	c_lgsbc
1083  0193               L744:
1084                     ; 263   while (tempo_RX > 0)
1086  0193 96            	ldw	x,sp
1087  0194 1c0002        	addw	x,#OFST-3
1088  0197 cd0000        	call	c_lzmp
1090  019a 26ce          	jrne	L544
1091                     ; 273   return tamanhoMsg;
1093  019c 7b01          	ld	a,(OFST-4,sp)
1096  019e 5b07          	addw	sp,#7
1097  01a0 81            	ret	
1222                     ; 276 void zeraRegistradoresRX(char Dados_comando_RX[], char *STX_RX, char *tamanhoPacote_RX, char *enderecoDestino_RX, char *enderecoOrigem_RX, char *comando_RX, char *dadosPacote1_RX, char *dadosPacote2_RX, char *BCC_RX, char *tamanhoMsg, char *flagCOM_RX)
1222                     ; 277 {
1223                     	switch	.text
1224  01a1               _zeraRegistradoresRX:
1226  01a1 89            	pushw	x
1227  01a2 88            	push	a
1228       00000001      OFST:	set	1
1231                     ; 278   char varredura=0x00;
1233                     ; 280   *STX_RX = '\0';
1235  01a3 1e06          	ldw	x,(OFST+5,sp)
1236  01a5 7f            	clr	(x)
1237                     ; 281   *tamanhoPacote_RX = '\0';
1239  01a6 1e08          	ldw	x,(OFST+7,sp)
1240  01a8 7f            	clr	(x)
1241                     ; 282   *enderecoDestino_RX = '\0';
1243  01a9 1e0a          	ldw	x,(OFST+9,sp)
1244  01ab 7f            	clr	(x)
1245                     ; 283   *enderecoOrigem_RX = '\0';
1247  01ac 1e0c          	ldw	x,(OFST+11,sp)
1248  01ae 7f            	clr	(x)
1249                     ; 284   *comando_RX = '\0';
1251  01af 1e0e          	ldw	x,(OFST+13,sp)
1252  01b1 7f            	clr	(x)
1253                     ; 285   *dadosPacote1_RX = '\0';
1255  01b2 1e10          	ldw	x,(OFST+15,sp)
1256  01b4 7f            	clr	(x)
1257                     ; 286   *dadosPacote2_RX = '\0';
1259  01b5 1e12          	ldw	x,(OFST+17,sp)
1260                     ; 287   for(varredura=0; varredura<=TAMANHO_DADOS_RX-1;varredura++){
1262  01b7 4f            	clr	a
1263  01b8 7f            	clr	(x)
1264  01b9 6b01          	ld	(OFST+0,sp),a
1266  01bb               L735:
1267                     ; 288     Dados_comando_RX[varredura] = '\0';
1269  01bb 5f            	clrw	x
1270  01bc 97            	ld	xl,a
1271  01bd 72fb02        	addw	x,(OFST+1,sp)
1272  01c0 7f            	clr	(x)
1273                     ; 287   for(varredura=0; varredura<=TAMANHO_DADOS_RX-1;varredura++){
1275  01c1 0c01          	inc	(OFST+0,sp)
1279  01c3 7b01          	ld	a,(OFST+0,sp)
1280  01c5 a114          	cp	a,#20
1281  01c7 25f2          	jrult	L735
1282                     ; 290   *BCC_RX = '\0';
1284  01c9 1e14          	ldw	x,(OFST+19,sp)
1285  01cb 7f            	clr	(x)
1286                     ; 293 }
1289  01cc 5b03          	addw	sp,#3
1290  01ce 81            	ret	
1373                     ; 295 void enviaPacote(char enderecoDestino, char comando, char dados1, char dados2)
1373                     ; 296 {
1374                     	switch	.text
1375  01cf               _enviaPacote:
1377  01cf 89            	pushw	x
1378  01d0 89            	pushw	x
1379       00000002      OFST:	set	2
1382                     ; 298   char BCC = 0x00, tamanhoPacote = 0x00;
1386                     ; 300   GPIO_WriteHigh(GPIOD, GPIO_PIN_1); //Hab escrita
1388  01d1 4b02          	push	#2
1389  01d3 ae500f        	ldw	x,#20495
1390  01d6 cd0000        	call	_GPIO_WriteHigh
1392  01d9 84            	pop	a
1393                     ; 301   if (dados1 == '\0' && dados2 == '\0') //Tamanho = 0x05
1395  01da 7b07          	ld	a,(OFST+5,sp)
1396  01dc 262d          	jrne	L706
1398  01de 7b08          	ld	a,(OFST+6,sp)
1399  01e0 2629          	jrne	L706
1400                     ; 303     tamanhoPacote = 0x05;
1402  01e2 a605          	ld	a,#5
1403  01e4 6b02          	ld	(OFST+0,sp),a
1405                     ; 304     BCC = calculateBCC_Param(enderecoDestino, comando, dados1, dados2);
1407  01e6 7b08          	ld	a,(OFST+6,sp)
1408  01e8 88            	push	a
1409  01e9 7b08          	ld	a,(OFST+6,sp)
1410  01eb 88            	push	a
1411  01ec 7b06          	ld	a,(OFST+4,sp)
1412  01ee 97            	ld	xl,a
1413  01ef 7b05          	ld	a,(OFST+3,sp)
1414  01f1 95            	ld	xh,a
1415  01f2 cd006a        	call	_calculateBCC_Param
1417  01f5 85            	popw	x
1418  01f6 6b01          	ld	(OFST-1,sp),a
1420                     ; 305     enviaSerial(STX);
1422  01f8 a602          	ld	a,#2
1423  01fa cd0000        	call	_enviaSerial
1425                     ; 306     enviaSerial(tamanhoPacote); //tamanho
1427  01fd 7b02          	ld	a,(OFST+0,sp)
1428  01ff cd0000        	call	_enviaSerial
1430                     ; 307     enviaSerial(enderecoDestino);
1432  0202 7b03          	ld	a,(OFST+1,sp)
1433  0204 cd028c        	call	LC004
1435                     ; 309     enviaSerial(comando);
1437  0207 7b04          	ld	a,(OFST+2,sp)
1439                     ; 310     enviaSerial(BCC);
1442  0209 206d          	jp	LC003
1443  020b               L706:
1444                     ; 312   else if (!dados1 == '\0' && dados2 == '\0') //Tamanho = 0x06
1446  020b 7b07          	ld	a,(OFST+5,sp)
1447  020d 2731          	jreq	L316
1449  020f 7b08          	ld	a,(OFST+6,sp)
1450  0211 262d          	jrne	L316
1451                     ; 314     tamanhoPacote = 0x06;
1453  0213 a606          	ld	a,#6
1454  0215 6b02          	ld	(OFST+0,sp),a
1456                     ; 315     BCC = calculateBCC_Param(enderecoDestino, comando, dados1, dados2);
1458  0217 7b08          	ld	a,(OFST+6,sp)
1459  0219 88            	push	a
1460  021a 7b08          	ld	a,(OFST+6,sp)
1461  021c 88            	push	a
1462  021d 7b06          	ld	a,(OFST+4,sp)
1463  021f 97            	ld	xl,a
1464  0220 7b05          	ld	a,(OFST+3,sp)
1465  0222 95            	ld	xh,a
1466  0223 cd006a        	call	_calculateBCC_Param
1468  0226 85            	popw	x
1469  0227 6b01          	ld	(OFST-1,sp),a
1471                     ; 316     enviaSerial(STX);
1473  0229 a602          	ld	a,#2
1474  022b cd0000        	call	_enviaSerial
1476                     ; 317     enviaSerial(tamanhoPacote); //tamanho
1478  022e 7b02          	ld	a,(OFST+0,sp)
1479  0230 cd0000        	call	_enviaSerial
1481                     ; 318     enviaSerial(enderecoDestino);
1483  0233 7b03          	ld	a,(OFST+1,sp)
1484  0235 ad55          	call	LC004
1486                     ; 320     enviaSerial(comando);
1488  0237 7b04          	ld	a,(OFST+2,sp)
1489  0239 cd0000        	call	_enviaSerial
1491                     ; 321     enviaSerial(dados1);
1493  023c 7b07          	ld	a,(OFST+5,sp)
1495                     ; 322     enviaSerial(BCC);
1498  023e 2038          	jp	LC003
1499  0240               L316:
1500                     ; 324   else if (!dados1 == '\0' && !dados2 == '\0') //Tamanho = 0x07
1502  0240 7b07          	ld	a,(OFST+5,sp)
1503  0242 273c          	jreq	L116
1505  0244 7b08          	ld	a,(OFST+6,sp)
1506  0246 2738          	jreq	L116
1507                     ; 326     tamanhoPacote = 0x07;
1509  0248 a607          	ld	a,#7
1510  024a 6b02          	ld	(OFST+0,sp),a
1512                     ; 327     BCC = calculateBCC_Param(enderecoDestino, comando, dados1, dados2);
1514  024c 7b08          	ld	a,(OFST+6,sp)
1515  024e 88            	push	a
1516  024f 7b08          	ld	a,(OFST+6,sp)
1517  0251 88            	push	a
1518  0252 7b06          	ld	a,(OFST+4,sp)
1519  0254 97            	ld	xl,a
1520  0255 7b05          	ld	a,(OFST+3,sp)
1521  0257 95            	ld	xh,a
1522  0258 cd006a        	call	_calculateBCC_Param
1524  025b 85            	popw	x
1525  025c 6b01          	ld	(OFST-1,sp),a
1527                     ; 328     enviaSerial(STX);
1529  025e a602          	ld	a,#2
1530  0260 cd0000        	call	_enviaSerial
1532                     ; 329     enviaSerial(tamanhoPacote); //tamanho
1534  0263 7b02          	ld	a,(OFST+0,sp)
1535  0265 cd0000        	call	_enviaSerial
1537                     ; 330     enviaSerial(enderecoDestino);
1539  0268 7b03          	ld	a,(OFST+1,sp)
1540  026a ad20          	call	LC004
1542                     ; 332     enviaSerial(comando);
1544  026c 7b04          	ld	a,(OFST+2,sp)
1545  026e cd0000        	call	_enviaSerial
1547                     ; 333     enviaSerial(dados1);
1549  0271 7b07          	ld	a,(OFST+5,sp)
1550  0273 cd0000        	call	_enviaSerial
1552                     ; 334     enviaSerial(dados2);
1554  0276 7b08          	ld	a,(OFST+6,sp)
1556                     ; 335     enviaSerial(BCC);
1558  0278               LC003:
1559  0278 cd0000        	call	_enviaSerial
1562  027b 7b01          	ld	a,(OFST-1,sp)
1563  027d cd0000        	call	_enviaSerial
1565  0280               L116:
1566                     ; 337   GPIO_WriteLow(GPIOD, GPIO_PIN_1); //Hab leitura
1568  0280 4b02          	push	#2
1569  0282 ae500f        	ldw	x,#20495
1570  0285 cd0000        	call	_GPIO_WriteLow
1572  0288 84            	pop	a
1573                     ; 338 }
1576  0289 5b04          	addw	sp,#4
1577  028b 81            	ret	
1578  028c               LC004:
1579  028c cd0000        	call	_enviaSerial
1581                     ; 331     enviaSerial(ENDERECO_DISP);
1583  028f a601          	ld	a,#1
1584  0291 cc0000        	jp	_enviaSerial
1680                     ; 340 void processaPacoteRX(char Dados_comando_RX[],char STX_RX, char tamanhoPacote_RX, char enderecoDestino_RX, char enderecoOrigem_RX, char comando_RX, char dadosPacote1_RX, char dadosPacote2_RX, char BCC_RX, char flagCOM_RX, char qtdeDadosRX)
1680                     ; 341 { //função para tomar a decisão do que fazer a partir dos dados recebidos
1681                     	switch	.text
1682  0294               _processaPacoteRX:
1684  0294 89            	pushw	x
1685  0295 89            	pushw	x
1686       00000002      OFST:	set	2
1689                     ; 342 	char varreduraAux=0x00;
1691                     ; 343 	char posicao=0x00;
1693  0296 0f01          	clr	(OFST-1,sp)
1695                     ; 345 	switch (flagCOM_RX)
1697  0298 7b0f          	ld	a,(OFST+13,sp)
1699                     ; 421     break;
1700  029a 2709          	jreq	L126
1701  029c 4a            	dec	a
1702  029d 2603cc036e    	jreq	L146
1703  02a2 cc037c        	jra	L317
1704  02a5               L126:
1705                     ; 347   case 0x00:
1705                     ; 348     switch (comando_RX)
1707  02a5 7b0b          	ld	a,(OFST+9,sp)
1709                     ; 413       break;
1710  02a7 4a            	dec	a
1711  02a8 2715          	jreq	L326
1712  02aa 4a            	dec	a
1713  02ab 2721          	jreq	L526
1714  02ad 4a            	dec	a
1715  02ae 273b          	jreq	L726
1716  02b0 4a            	dec	a
1717  02b1 274f          	jreq	L136
1718  02b3 4a            	dec	a
1719  02b4 2764          	jreq	L336
1720  02b6 4a            	dec	a
1721  02b7 2770          	jreq	L536
1722  02b9 4a            	dec	a
1723  02ba 277c          	jreq	L736
1724  02bc cc037c        	jra	L317
1725  02bf               L326:
1726                     ; 350     case 0x01: //0x1: Leitura do status do botão 1, 0 quando não estiver acionado e 1 quando estiver acionado
1726                     ; 351       if (GPIO_ReadInputPin(GPIOD, GPIO_PIN_4) == 0)
1728  02bf 4b10          	push	#16
1729  02c1 ae500f        	ldw	x,#20495
1730  02c4 cd0000        	call	_GPIO_ReadInputPin
1732  02c7 5b01          	addw	sp,#1
1733  02c9 4d            	tnz	a
1734  02ca 2613          	jrne	L527
1735                     ; 353         enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x00);
1738  02cc 200d          	jp	LC008
1739                     ; 357         enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x01);
1741  02ce               L526:
1742                     ; 361     case 0x02: //0x2: Leitura do status do botão 2, 0 quando não estiver acionado e 1 quando estiver acionado
1742                     ; 362       if (GPIO_ReadInputPin(GPIOD, GPIO_PIN_7) == 0)
1744  02ce 4b80          	push	#128
1745  02d0 ae500f        	ldw	x,#20495
1746  02d3 cd0000        	call	_GPIO_ReadInputPin
1748  02d6 5b01          	addw	sp,#1
1749  02d8 4d            	tnz	a
1750  02d9 2604          	jrne	L527
1751                     ; 364         enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x00);
1753  02db               LC008:
1755  02db 4b00          	push	#0
1758  02dd 2002          	jp	LC006
1759  02df               L527:
1760                     ; 368         enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x01);
1763  02df 4b01          	push	#1
1764  02e1               LC006:
1765  02e1 4b06          	push	#6
1766  02e3 7b0c          	ld	a,(OFST+10,sp)
1767  02e5 ae0001        	ldw	x,#1
1769  02e8 cc0377        	jp	LC005
1770  02eb               L726:
1771                     ; 373     case 0x03: //0x3: Escrita no Led 1, 0 para desligar o LED e 1 para ligar o LED
1771                     ; 374       if (Dados_comando_RX[0] == 0x01)
1773  02eb 1e03          	ldw	x,(OFST+1,sp)
1774  02ed f6            	ld	a,(x)
1775  02ee 4a            	dec	a
1776  02ef 2604          	jrne	L137
1777                     ; 376         GPIO_WriteHigh(GPIOD, GPIO_PIN_2);
1779  02f1 4b04          	push	#4
1782  02f3 2015          	jp	LC010
1783  02f5               L137:
1784                     ; 378       else if (Dados_comando_RX[0] == 0x00)
1786  02f5 f6            	ld	a,(x)
1787  02f6 26c4          	jrne	L317
1788                     ; 380         GPIO_WriteLow(GPIOD, GPIO_PIN_2);
1790  02f8 4b04          	push	#4
1791  02fa               LC011:
1792  02fa ae500f        	ldw	x,#20495
1793  02fd cd0000        	call	_GPIO_WriteLow
1795  0300 200e          	jp	LC009
1796  0302               L136:
1797                     ; 384     case 0x04: //0x4: Escrita no Led 2, 0 para desligar o LED e 1 para ligar o LED
1797                     ; 385       if (Dados_comando_RX[0] == 0x01)
1799  0302 1e03          	ldw	x,(OFST+1,sp)
1800  0304 f6            	ld	a,(x)
1801  0305 4a            	dec	a
1802  0306 260b          	jrne	L737
1803                     ; 387         GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
1805  0308 4b08          	push	#8
1806  030a               LC010:
1807  030a ae500f        	ldw	x,#20495
1808  030d cd0000        	call	_GPIO_WriteHigh
1810  0310               LC009:
1811  0310 84            	pop	a
1813  0311 2069          	jra	L317
1814  0313               L737:
1815                     ; 389       else if (Dados_comando_RX[0] == 0x00)
1817  0313 f6            	ld	a,(x)
1818  0314 2666          	jrne	L317
1819                     ; 391         GPIO_WriteLow(GPIOD, GPIO_PIN_3);
1821  0316 4b08          	push	#8
1823  0318 20e0          	jp	LC011
1824  031a               L336:
1825                     ; 395     case 0x05: //0x5: Pisca Led1, primeiro byte o número de piscadas e o segundo byte o tempo de cada piscada
1825                     ; 396       piscaLED(0x01, Dados_comando_RX[0], Dados_comando_RX[1]);
1827  031a 1e03          	ldw	x,(OFST+1,sp)
1828  031c e601          	ld	a,(1,x)
1829  031e 88            	push	a
1830  031f f6            	ld	a,(x)
1831  0320 ae0100        	ldw	x,#256
1832  0323 97            	ld	xl,a
1833  0324 cd00ae        	call	_piscaLED
1835                     ; 397       break;
1837  0327 20e7          	jp	LC009
1838  0329               L536:
1839                     ; 399     case 0x06: //0x6: Pisca Led2, primeiro byte o número de piscadas e o segundo byte o tempo de cada piscada
1839                     ; 400       piscaLED(0x02, Dados_comando_RX[0], Dados_comando_RX[1]);
1841  0329 1e03          	ldw	x,(OFST+1,sp)
1842  032b e601          	ld	a,(1,x)
1843  032d 88            	push	a
1844  032e f6            	ld	a,(x)
1845  032f ae0200        	ldw	x,#512
1846  0332 97            	ld	xl,a
1847  0333 cd00ae        	call	_piscaLED
1849                     ; 401       break;
1851  0336 20d8          	jp	LC009
1852  0338               L736:
1853                     ; 403     case 0x07: //0x7 : Escreve uma mensagem do display, onde o primeiro dado é a posição do display (0x80 para a primeira posição) e os demais dados a mensagem (em ASCII)
1853                     ; 404       LCD_goto(Dados_comando_RX[0], 0);
1855  0338 1e03          	ldw	x,(OFST+1,sp)
1856  033a f6            	ld	a,(x)
1857  033b ad42          	call	LC012
1859                     ; 405       for(varreduraAux=1;varreduraAux<=qtdeDadosRX-1;varreduraAux++){
1861  033d a601          	ld	a,#1
1862  033f 6b02          	ld	(OFST+0,sp),a
1865  0341 2013          	jra	L157
1866  0343               L547:
1867                     ; 406         LCD_goto(posicao, 0); 
1869  0343 7b01          	ld	a,(OFST-1,sp)
1870  0345 ad38          	call	LC012
1872                     ; 407         LCD_putchar(Dados_comando_RX[varreduraAux]);
1874  0347 7b02          	ld	a,(OFST+0,sp)
1875  0349 5f            	clrw	x
1876  034a 97            	ld	xl,a
1877  034b 72fb03        	addw	x,(OFST+1,sp)
1878  034e f6            	ld	a,(x)
1879  034f cd0785        	call	_LCD_putchar
1881                     ; 408         posicao++;
1883  0352 0c01          	inc	(OFST-1,sp)
1885                     ; 405       for(varreduraAux=1;varreduraAux<=qtdeDadosRX-1;varreduraAux++){
1887  0354 0c02          	inc	(OFST+0,sp)
1889  0356               L157:
1892  0356 7b10          	ld	a,(OFST+14,sp)
1893  0358 5f            	clrw	x
1894  0359 97            	ld	xl,a
1895  035a 5a            	decw	x
1896  035b 7b02          	ld	a,(OFST+0,sp)
1897  035d 905f          	clrw	y
1898  035f 9097          	ld	yl,a
1899  0361 90bf00        	ldw	c_y,y
1900  0364 b300          	cpw	x,c_y
1901  0366 2edb          	jrsge	L547
1902                     ; 411       LCD_goto(posicao, 0);                              
1904  0368 7b01          	ld	a,(OFST-1,sp)
1905  036a ad13          	call	LC012
1907                     ; 413       break;
1909  036c 200e          	jra	L317
1910                     ; 416     break;
1912  036e               L146:
1913                     ; 418   case 0x01:
1913                     ; 419     //ENVIA NAK
1913                     ; 420     enviaPacote(enderecoOrigem_RX, 0x20, 0x15, '\0');
1915  036e 4b00          	push	#0
1916  0370 4b15          	push	#21
1917  0372 7b0c          	ld	a,(OFST+10,sp)
1918  0374 ae0020        	ldw	x,#32
1920  0377               LC005:
1921  0377 95            	ld	xh,a
1922  0378 cd01cf        	call	_enviaPacote
1923  037b 85            	popw	x
1924                     ; 421     break;
1926  037c               L317:
1927                     ; 423 }
1930  037c 5b04          	addw	sp,#4
1931  037e 81            	ret	
1932  037f               LC012:
1933  037f 5f            	clrw	x
1934  0380 95            	ld	xh,a
1935  0381 cc0798        	jp	_LCD_goto
1938                     .const:	section	.text
1939  0000               L557_maqEstados:
1940  0000 01            	dc.b	1
1941  0001 02            	dc.b	2
1942  0002 03            	dc.b	3
1943  0003 04            	dc.b	4
1944  0004 05            	dc.b	5
1945  0005 06            	dc.b	6
1946  0006 000000000000  	ds.b	9
2172                     ; 425 void main(void)
2172                     ; 426 {
2173                     	switch	.text
2174  0384               _main:
2176  0384 529d          	subw	sp,#157
2177       0000009d      OFST:	set	157
2180                     ; 427   char indiceMaqEstados = 0x00;
2182                     ; 428   unsigned long tempo, tempo_RX = 0xFFF;
2184                     ; 429   char delay = 0xFFFFF, tamanhoMsg = 0, varredura = 0,
2188  0386 0f36          	clr	(OFST-103,sp)
2192                     ; 430        Dado_RX_buffer[TAMANHO_MAX], BCC_RX = 0x00, STX_RX = 0x00,
2194  0388 0f34          	clr	(OFST-105,sp)
2198  038a 0f1c          	clr	(OFST-129,sp)
2200                     ; 431        tamanhoPacote_RX = 0x00, enderecoDestino_RX = 0x00, enderecoOrigem_RX = 0x00,
2202  038c 0f35          	clr	(OFST-104,sp)
2206  038e 0f1d          	clr	(OFST-128,sp)
2210  0390 0f1e          	clr	(OFST-127,sp)
2212                     ; 432        comando_RX = 0x00, dadosPacote1_RX = 0x00, dadosPacote2_RX = 0x00,Dados_comando_RX[TAMANHO_DADOS_RX],qtdeDadosRX=0x00;
2214  0392 0f1f          	clr	(OFST-126,sp)
2218  0394 0f19          	clr	(OFST-132,sp)
2222  0396 0f1a          	clr	(OFST-131,sp)
2226  0398 0f1b          	clr	(OFST-130,sp)
2228                     ; 434   char flagDados = '\0'; //Se 0 -> um byte de dados. Se 1 -> dois bytes de daods.
2230                     ; 435   char flagCOM_RX = '\0';
2232  039a 0f37          	clr	(OFST-102,sp)
2234                     ; 443   char estado = 0x00;
2236                     ; 453   char maqEstados[15] = {
2236                     ; 454       0x01,
2236                     ; 455       0x02,
2236                     ; 456       0x03,
2236                     ; 457       0x04,
2236                     ; 458       0x05,
2236                     ; 459       0x06};
2238  039c 96            	ldw	x,sp
2239  039d 1c000a        	addw	x,#OFST-147
2240  03a0 90ae0000      	ldw	y,#L557_maqEstados
2241  03a4 a60f          	ld	a,#15
2242  03a6 cd0000        	call	c_xymov
2244                     ; 462   CLK_Configuration();
2246  03a9 cd058f        	call	_CLK_Configuration
2248                     ; 465   GPIO_Configuration();
2250  03ac cd0593        	call	_GPIO_Configuration
2252                     ; 467   UART2_Init(9600, UART2_WORDLENGTH_8D, UART2_STOPBITS_1,
2252                     ; 468              UART2_PARITY_NO, UART2_SYNCMODE_CLOCK_DISABLE,
2252                     ; 469              UART2_MODE_TXRX_ENABLE);
2254  03af 4b0c          	push	#12
2255  03b1 4b80          	push	#128
2256  03b3 4b00          	push	#0
2257  03b5 4b00          	push	#0
2258  03b7 4b00          	push	#0
2259  03b9 ae2580        	ldw	x,#9600
2260  03bc 89            	pushw	x
2261  03bd 5f            	clrw	x
2262  03be 89            	pushw	x
2263  03bf cd0000        	call	_UART2_Init
2265  03c2 5b09          	addw	sp,#9
2266                     ; 471   LCD_init();
2268  03c4 cd068c        	call	_LCD_init
2270                     ; 472   LCD_clear_home();
2272  03c7 cd078c        	call	_LCD_clear_home
2274                     ; 481   GPIO_WriteLow(GPIOD, GPIO_PIN_1); //Hab leitura
2276  03ca cd0512        	call	LC016
2277  03cd               L1311:
2278                     ; 499 		GPIO_WriteLow(GPIOD, GPIO_PIN_1); //Hab leitura
2280  03cd cd0512        	call	LC016
2281                     ; 500 		limpaVetor(Dado_RX_buffer, TAMANHO_MAX);
2283  03d0 4b64          	push	#100
2284  03d2 96            	ldw	x,sp
2285  03d3 1c003b        	addw	x,#OFST-98
2286  03d6 cd000d        	call	_limpaVetor
2288  03d9 84            	pop	a
2289                     ; 501     tamanhoMsg = coletaBuffer(Dado_RX_buffer); //Abre o buffer e recebe dados
2291  03da 96            	ldw	x,sp
2292  03db 1c003a        	addw	x,#OFST-99
2293  03de cd0152        	call	_coletaBuffer
2295  03e1 6b36          	ld	(OFST-103,sp),a
2297                     ; 503     if (tamanhoMsg > 0)
2299  03e3 27e8          	jreq	L1311
2300                     ; 505       flagCOM_RX = 0x04; // Processamento em andamento
2302  03e5 a604          	ld	a,#4
2303  03e7 6b37          	ld	(OFST-102,sp),a
2305                     ; 506       indiceMaqEstados = 0x00;
2307  03e9 0f38          	clr	(OFST-101,sp)
2310  03eb cc04df        	jra	L1411
2311  03ee               L7311:
2312                     ; 511         estado = maqEstados[indiceMaqEstados];
2314  03ee 96            	ldw	x,sp
2315  03ef 1c000a        	addw	x,#OFST-147
2316  03f2 9f            	ld	a,xl
2317  03f3 5e            	swapw	x
2318  03f4 1b38          	add	a,(OFST-101,sp)
2319  03f6 2401          	jrnc	L072
2320  03f8 5c            	incw	x
2321  03f9               L072:
2322  03f9 02            	rlwa	x,a
2323  03fa f6            	ld	a,(x)
2324  03fb 6b39          	ld	(OFST-100,sp),a
2326                     ; 513         switch (estado)
2329                     ; 592           break;
2330  03fd 4a            	dec	a
2331  03fe 2712          	jreq	L757
2332  0400 4a            	dec	a
2333  0401 273a          	jreq	L167
2334  0403 4a            	dec	a
2335  0404 2746          	jreq	L367
2336  0406 4a            	dec	a
2337  0407 2766          	jreq	L567
2338  0409 4a            	dec	a
2339  040a 2771          	jreq	L767
2340  040c 4a            	dec	a
2341  040d 2776          	jreq	L177
2342  040f cc04df        	jra	L1411
2343  0412               L757:
2344                     ; 516         case 0x01: //LIMPA REGISTRADORES
2344                     ; 517           zeraRegistradoresRX(Dados_comando_RX, &STX_RX, &tamanhoPacote_RX, &enderecoDestino_RX, &enderecoOrigem_RX, &comando_RX, &dadosPacote1_RX, &dadosPacote2_RX, &BCC_RX, &tamanhoMsg, &flagCOM_RX);
2346  0412 96            	ldw	x,sp
2347  0413 1c0037        	addw	x,#OFST-102
2348  0416 89            	pushw	x
2349  0417 5a            	decw	x
2350  0418 89            	pushw	x
2351  0419 1d0002        	subw	x,#2
2352  041c 89            	pushw	x
2353  041d 1d001a        	subw	x,#26
2354  0420 89            	pushw	x
2355  0421 5a            	decw	x
2356  0422 89            	pushw	x
2357  0423 1c0006        	addw	x,#6
2358  0426 89            	pushw	x
2359  0427 5a            	decw	x
2360  0428 89            	pushw	x
2361  0429 5a            	decw	x
2362  042a 89            	pushw	x
2363  042b 1c0018        	addw	x,#24
2364  042e 89            	pushw	x
2365  042f 1d0019        	subw	x,#25
2366  0432 89            	pushw	x
2367  0433 1c0004        	addw	x,#4
2368  0436 cd01a1        	call	_zeraRegistradoresRX
2370  0439 5b14          	addw	sp,#20
2371                     ; 518           indiceMaqEstados++;
2372                     ; 519           break;
2374  043b 2044          	jp	LC014
2375  043d               L167:
2376                     ; 521         case 0x02: //VALIDA STX_RX
2376                     ; 522           if (Dado_RX_buffer[0] == 0x02)
2378  043d 7b3a          	ld	a,(OFST-99,sp)
2379  043f a102          	cp	a,#2
2380  0441 2604          	jrne	L1511
2381                     ; 524             STX_RX = Dado_RX_buffer[0];
2383  0443 6b1c          	ld	(OFST-129,sp),a
2385                     ; 525             indiceMaqEstados++;
2387  0445 203a          	jp	LC014
2388  0447               L1511:
2389                     ; 529             flagCOM_RX = 0x03;
2391  0447 a603          	ld	a,#3
2392  0449 cc04dd        	jp	L1711
2393  044c               L367:
2394                     ; 533         case 0x03: //CALCULA E VALIDA BCC_RX
2394                     ; 534           BCC_RX = calculateBCC_RX(Dado_RX_buffer, tamanhoMsg);
2396  044c 7b36          	ld	a,(OFST-103,sp)
2397  044e 88            	push	a
2398  044f 96            	ldw	x,sp
2399  0450 1c003b        	addw	x,#OFST-98
2400  0453 cd003d        	call	_calculateBCC_RX
2402  0456 5b01          	addw	sp,#1
2403  0458 6b34          	ld	(OFST-105,sp),a
2405                     ; 535           if (BCC_RX == Dado_RX_buffer[tamanhoMsg - 1])
2407  045a 96            	ldw	x,sp
2408  045b 1c003a        	addw	x,#OFST-99
2409  045e 1f01          	ldw	(OFST-156,sp),x
2411  0460 5f            	clrw	x
2412  0461 7b36          	ld	a,(OFST-103,sp)
2413  0463 97            	ld	xl,a
2414  0464 5a            	decw	x
2415  0465 72fb01        	addw	x,(OFST-156,sp)
2416  0468 f6            	ld	a,(x)
2417  0469 1134          	cp	a,(OFST-105,sp)
2418  046b 2672          	jrne	L1411
2419                     ; 537             indiceMaqEstados++;
2421  046d 2012          	jp	LC014
2422  046f               L567:
2423                     ; 545         case 0x04: //VALIDA ENDERE�O DE DESTINO
2423                     ; 546           if (ENDERECO_DISP == Dado_RX_buffer[2])
2425  046f 7b3c          	ld	a,(OFST-97,sp)
2426  0471 a101          	cp	a,#1
2427  0473 2604          	jrne	L1611
2428                     ; 548             enderecoDestino_RX = Dado_RX_buffer[2];
2430  0475 6b1d          	ld	(OFST-128,sp),a
2432                     ; 549             indiceMaqEstados++;
2434  0477 2008          	jp	LC014
2435  0479               L1611:
2436                     ; 553             flagCOM_RX = 0x02;
2438  0479 a602          	ld	a,#2
2439  047b 2060          	jp	L1711
2440  047d               L767:
2441                     ; 557         case 0x05: //VERIFICA TAMANHO DO PACOTE
2441                     ; 558           tamanhoPacote_RX = Dado_RX_buffer[1];
2443  047d 7b3b          	ld	a,(OFST-98,sp)
2444  047f 6b35          	ld	(OFST-104,sp),a
2446                     ; 559           indiceMaqEstados++;
2448  0481               LC014:
2453  0481 0c38          	inc	(OFST-101,sp)
2455                     ; 560           break;
2457  0483 205a          	jra	L1411
2458  0485               L177:
2459                     ; 562         case 0x06: //ALOCA enderecoOrigem_RX / comando_RX / dadosPacote1_RX / dadosPacote2_RX
2459                     ; 563           enderecoOrigem_RX = Dado_RX_buffer[3];
2461  0485 7b3d          	ld	a,(OFST-96,sp)
2462  0487 6b1e          	ld	(OFST-127,sp),a
2464                     ; 564           comando_RX = Dado_RX_buffer[4];
2466  0489 7b3e          	ld	a,(OFST-95,sp)
2467  048b 6b1f          	ld	(OFST-126,sp),a
2469                     ; 565           if (tamanhoPacote_RX == 0x05)
2471  048d 7b35          	ld	a,(OFST-104,sp)
2472  048f a105          	cp	a,#5
2473                     ; 567             indiceMaqEstados++;
2474                     ; 568             flagCOM_RX = 0x00;
2476  0491 2744          	jreq	LC015
2477                     ; 570           else if (tamanhoPacote_RX > 0x05)
2479  0493 a106          	cp	a,#6
2480  0495 a605          	ld	a,#5
2481  0497 2544          	jrult	L1711
2482                     ; 572             char varreduraAux=0x00;
2484                     ; 573             for(varreduraAux=5;varreduraAux<=tamanhoMsg-2;varreduraAux++){
2486  0499 6b39          	ld	(OFST-100,sp),a
2489  049b 2020          	jra	L7711
2490  049d               L3711:
2491                     ; 574             Dados_comando_RX[varreduraAux-5]=Dado_RX_buffer[varreduraAux];
2493  049d 96            	ldw	x,sp
2494  049e 1c0020        	addw	x,#OFST-125
2495  04a1 1f01          	ldw	(OFST-156,sp),x
2497  04a3 5f            	clrw	x
2498  04a4 97            	ld	xl,a
2499  04a5 1d0005        	subw	x,#5
2500  04a8 72fb01        	addw	x,(OFST-156,sp)
2501  04ab 89            	pushw	x
2502  04ac 96            	ldw	x,sp
2503  04ad 1c003c        	addw	x,#OFST-97
2504  04b0 9f            	ld	a,xl
2505  04b1 5e            	swapw	x
2506  04b2 1b3b          	add	a,(OFST-98,sp)
2507  04b4 2401          	jrnc	L672
2508  04b6 5c            	incw	x
2509  04b7               L672:
2510  04b7 02            	rlwa	x,a
2511  04b8 f6            	ld	a,(x)
2512  04b9 85            	popw	x
2513  04ba f7            	ld	(x),a
2514                     ; 573             for(varreduraAux=5;varreduraAux<=tamanhoMsg-2;varreduraAux++){
2516  04bb 0c39          	inc	(OFST-100,sp)
2518  04bd               L7711:
2521  04bd 7b36          	ld	a,(OFST-103,sp)
2522  04bf 5f            	clrw	x
2523  04c0 97            	ld	xl,a
2524  04c1 1d0002        	subw	x,#2
2525  04c4 7b39          	ld	a,(OFST-100,sp)
2526  04c6 905f          	clrw	y
2527  04c8 9097          	ld	yl,a
2528  04ca 90bf00        	ldw	c_y,y
2529  04cd b300          	cpw	x,c_y
2530  04cf 2ecc          	jrsge	L3711
2531                     ; 576 						qtdeDadosRX=tamanhoMsg-6;
2533  04d1 7b36          	ld	a,(OFST-103,sp)
2534  04d3 a006          	sub	a,#6
2535  04d5 6b1b          	ld	(OFST-130,sp),a
2537                     ; 578             indiceMaqEstados++;
2539                     ; 579             flagCOM_RX = 0x00;
2541  04d7               LC015:
2543  04d7 0c38          	inc	(OFST-101,sp)
2546  04d9 0f37          	clr	(OFST-102,sp)
2549  04db 2002          	jra	L1411
2550  04dd               L1711:
2551                     ; 590             flagCOM_RX = 0x05;
2553  04dd 6b37          	ld	(OFST-102,sp),a
2555  04df               L1411:
2556                     ; 508       while (flagCOM_RX == 0x04)
2558  04df 7b37          	ld	a,(OFST-102,sp)
2559  04e1 a104          	cp	a,#4
2560  04e3 2603cc03ee    	jreq	L7311
2561                     ; 599       processaPacoteRX(Dados_comando_RX, STX_RX, tamanhoPacote_RX, enderecoDestino_RX, enderecoOrigem_RX, comando_RX, dadosPacote1_RX, dadosPacote2_RX, BCC_RX, flagCOM_RX,qtdeDadosRX);
2563  04e8 7b1b          	ld	a,(OFST-130,sp)
2564  04ea 88            	push	a
2565  04eb 7b38          	ld	a,(OFST-101,sp)
2566  04ed 88            	push	a
2567  04ee 7b36          	ld	a,(OFST-103,sp)
2568  04f0 88            	push	a
2569  04f1 7b1d          	ld	a,(OFST-128,sp)
2570  04f3 88            	push	a
2571  04f4 7b1d          	ld	a,(OFST-128,sp)
2572  04f6 88            	push	a
2573  04f7 7b24          	ld	a,(OFST-121,sp)
2574  04f9 88            	push	a
2575  04fa 7b24          	ld	a,(OFST-121,sp)
2576  04fc 88            	push	a
2577  04fd 7b24          	ld	a,(OFST-121,sp)
2578  04ff 88            	push	a
2579  0500 7b3d          	ld	a,(OFST-96,sp)
2580  0502 88            	push	a
2581  0503 7b25          	ld	a,(OFST-120,sp)
2582  0505 88            	push	a
2583  0506 96            	ldw	x,sp
2584  0507 1c002a        	addw	x,#OFST-115
2585  050a cd0294        	call	_processaPacoteRX
2587  050d 5b0a          	addw	sp,#10
2588  050f cc03cd        	jra	L1311
2589  0512               LC016:
2590  0512 4b02          	push	#2
2591  0514 ae500f        	ldw	x,#20495
2592  0517 cd0000        	call	_GPIO_WriteLow
2594  051a 84            	pop	a
2595  051b 81            	ret	
2631                     ; 648 void ExtraCode_Init(void)
2631                     ; 649 {
2632                     	switch	.text
2633  051c               _ExtraCode_Init:
2635  051c 88            	push	a
2636       00000001      OFST:	set	1
2639                     ; 655   for (i = 0; i < NUMBER_OF_SINGLE_CHANNEL_KEYS; i++)
2641  051d 0f01          	clr	(OFST+0,sp)
2643  051f               L3221:
2644                     ; 657     sSCKeyInfo[i].Setting.b.IMPLEMENTED = 1;
2646  051f 7b01          	ld	a,(OFST+0,sp)
2647  0521 97            	ld	xl,a
2648  0522 a60f          	ld	a,#15
2649  0524 42            	mul	x,a
2650  0525 e602          	ld	a,(_sSCKeyInfo+2,x)
2651                     ; 658     sSCKeyInfo[i].Setting.b.ENABLED = 1;
2653  0527 aa03          	or	a,#3
2654  0529 e702          	ld	(_sSCKeyInfo+2,x),a
2655                     ; 659     sSCKeyInfo[i].DxSGroup = 0x01; /* Put 0x00 to disable the DES on these pins */
2657  052b a601          	ld	a,#1
2658  052d e704          	ld	(_sSCKeyInfo+4,x),a
2659                     ; 655   for (i = 0; i < NUMBER_OF_SINGLE_CHANNEL_KEYS; i++)
2661  052f 0c01          	inc	(OFST+0,sp)
2665  0531 27ec          	jreq	L3221
2666                     ; 671   enableInterrupts();
2669  0533 9a            	rim	
2671                     ; 672 }
2675  0534 84            	pop	a
2676  0535 81            	ret	
2711                     ; 687 void ExtraCode_StateMachine(void)
2711                     ; 688 {
2712                     	switch	.text
2713  0536               _ExtraCode_StateMachine:
2717                     ; 689   if ((TSL_GlobalSetting.b.CHANGED) && (TSLState == TSL_IDLE_STATE))
2719  0536 720700011c    	btjf	_TSL_GlobalSetting+1,#3,L1521
2721  053b b600          	ld	a,_TSLState
2722  053d 4a            	dec	a
2723  053e 2617          	jrne	L1521
2724                     ; 691     TSL_GlobalSetting.b.CHANGED = 0;
2726  0540 72170001      	bres	_TSL_GlobalSetting+1,#3
2727                     ; 693     if (sSCKeyInfo[0].Setting.b.DETECTED) /* KEY 1 touched */
2729  0544 720500020e    	btjf	_sSCKeyInfo+2,#2,L1521
2730                     ; 695       BlinkSpeed++;
2732  0549 3c00          	inc	_BlinkSpeed
2733                     ; 696       BlinkSpeed = BlinkSpeed % 3;
2735  054b 5f            	clrw	x
2736  054c b600          	ld	a,_BlinkSpeed
2737  054e 97            	ld	xl,a
2738  054f a603          	ld	a,#3
2739  0551 62            	div	x,a
2740  0552 5f            	clrw	x
2741  0553 97            	ld	xl,a
2742  0554 01            	rrwa	x,a
2743  0555 b700          	ld	_BlinkSpeed,a
2744  0557               L1521:
2745                     ; 700   switch (BlinkSpeed)
2747  0557 b600          	ld	a,_BlinkSpeed
2749                     ; 723       Delay(&Toggle, 1 * Sec);
2750  0559 2710          	jreq	L1321
2751  055b 4a            	dec	a
2752  055c 2717          	jreq	L3321
2753  055e 4a            	dec	a
2754  055f 271e          	jreq	L5321
2755                     ; 720   default:
2755                     ; 721     if (TSL_Tick_Flags.b.User1_Flag_100ms == 1)
2757  0561 7205000028    	btjf	_TSL_Tick_Flags,#2,L7521
2758                     ; 723       Delay(&Toggle, 1 * Sec);
2760  0566 ae000a        	ldw	x,#10
2762  0569 201c          	jp	LC017
2763  056b               L1321:
2764                     ; 702   case 0:
2764                     ; 703     GPIO_WriteHigh(GPIOD, GPIO_PIN_0);
2766  056b 4b01          	push	#1
2767  056d ae500f        	ldw	x,#20495
2768  0570 cd0000        	call	_GPIO_WriteHigh
2770  0573 84            	pop	a
2771                     ; 704     break;
2774  0574 81            	ret	
2775  0575               L3321:
2776                     ; 706   case 1:
2776                     ; 707     if (TSL_Tick_Flags.b.User1_Flag_100ms == 1)
2778  0575 7205000014    	btjf	_TSL_Tick_Flags,#2,L7521
2779                     ; 709       Delay(&Toggle, 2 * MilliSec);
2781  057a ae0002        	ldw	x,#2
2783  057d 2008          	jp	LC017
2784  057f               L5321:
2785                     ; 713   case 2:
2785                     ; 714     if (TSL_Tick_Flags.b.User1_Flag_100ms == 1)
2787  057f 720500000a    	btjf	_TSL_Tick_Flags,#2,L7521
2788                     ; 716       Delay(&Toggle, 1 * MilliSec);
2790  0584 ae0001        	ldw	x,#1
2792  0587               LC017:
2793  0587 89            	pushw	x
2794  0588 ae0622        	ldw	x,#_Toggle
2795  058b ad65          	call	_Delay
2796  058d 85            	popw	x
2797  058e               L7521:
2798                     ; 726 }
2801  058e 81            	ret	
2825                     ; 738 void CLK_Configuration(void)
2825                     ; 739 {
2826                     	switch	.text
2827  058f               _CLK_Configuration:
2831                     ; 742   CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
2833  058f 4f            	clr	a
2835                     ; 743 }
2838  0590 cc0000        	jp	_CLK_HSIPrescalerConfig
2863                     ; 755 void GPIO_Configuration(void)
2863                     ; 756 {
2864                     	switch	.text
2865  0593               _GPIO_Configuration:
2869                     ; 758   GPIO_DeInit(GPIOD);
2871  0593 ae500f        	ldw	x,#20495
2872  0596 cd0000        	call	_GPIO_DeInit
2874                     ; 761   GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST);
2876  0599 4be0          	push	#224
2877  059b 4b01          	push	#1
2878  059d ae500f        	ldw	x,#20495
2879  05a0 cd0000        	call	_GPIO_Init
2881  05a3 85            	popw	x
2882                     ; 763   GPIO_Init(GPIOD, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); //led1
2884  05a4 4be0          	push	#224
2885  05a6 4b04          	push	#4
2886  05a8 ae500f        	ldw	x,#20495
2887  05ab cd0000        	call	_GPIO_Init
2889  05ae 85            	popw	x
2890                     ; 764   GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); //led2
2892  05af 4be0          	push	#224
2893  05b1 4b08          	push	#8
2894  05b3 ae500f        	ldw	x,#20495
2895  05b6 cd0000        	call	_GPIO_Init
2897  05b9 85            	popw	x
2898                     ; 765   GPIO_Init(GPIOD, GPIO_PIN_1, GPIO_MODE_OUT_PP_LOW_FAST); //R/W 485
2900  05ba 4be0          	push	#224
2901  05bc 4b02          	push	#2
2902  05be ae500f        	ldw	x,#20495
2903  05c1 cd0000        	call	_GPIO_Init
2905  05c4 85            	popw	x
2906                     ; 767   GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT); //BT1
2908  05c5 4b00          	push	#0
2909  05c7 4b10          	push	#16
2910  05c9 ae500f        	ldw	x,#20495
2911  05cc cd0000        	call	_GPIO_Init
2913  05cf 85            	popw	x
2914                     ; 768   GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_IN_FL_NO_IT); //BT2
2916  05d0 4b00          	push	#0
2917  05d2 4b80          	push	#128
2918  05d4 ae500f        	ldw	x,#20495
2919  05d7 cd0000        	call	_GPIO_Init
2921  05da 85            	popw	x
2922                     ; 771   GPIO_Init(GPIOD, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); //TX
2924  05db 4be0          	push	#224
2925  05dd 4b20          	push	#32
2926  05df ae500f        	ldw	x,#20495
2927  05e2 cd0000        	call	_GPIO_Init
2929  05e5 85            	popw	x
2930                     ; 772   GPIO_Init(GPIOD, GPIO_PIN_6, GPIO_MODE_IN_FL_NO_IT);     //rX
2932  05e6 4b00          	push	#0
2933  05e8 4b40          	push	#64
2934  05ea ae500f        	ldw	x,#20495
2935  05ed cd0000        	call	_GPIO_Init
2937  05f0 85            	popw	x
2938                     ; 773 }
2941  05f1 81            	ret	
2989                     ; 786 void Delay(void action(void), int NumberofTIMCycles)
2989                     ; 787 {
2990                     	switch	.text
2991  05f2               _Delay:
2993  05f2 89            	pushw	x
2994       00000000      OFST:	set	0
2997                     ; 788   if ((CheckFlag) != 0)
2999  05f3 be01          	ldw	x,_CheckFlag
3000  05f5 2704          	jreq	L1331
3001                     ; 789     NumberOfStart = NumberofTIMCycles;
3003  05f7 1e05          	ldw	x,(OFST+5,sp)
3004  05f9 bf00          	ldw	_NumberOfStart,x
3005  05fb               L1331:
3006                     ; 790   if (NumberOfStart != 0)
3008  05fb be00          	ldw	x,_NumberOfStart
3009  05fd 2707          	jreq	L3331
3010                     ; 792     TSL_Tick_Flags.b.User1_Start_100ms = 1;
3012  05ff 72120000      	bset	_TSL_Tick_Flags,#1
3013                     ; 793     CheckFlag = 0;
3015  0603 5f            	clrw	x
3016  0604 bf01          	ldw	_CheckFlag,x
3017  0606               L3331:
3018                     ; 795   if (TSL_Tick_Flags.b.User1_Flag_100ms)
3020  0606 7205000009    	btjf	_TSL_Tick_Flags,#2,L5331
3021                     ; 797     TSL_Tick_Flags.b.User1_Flag_100ms = 0;
3023  060b 72150000      	bres	_TSL_Tick_Flags,#2
3024                     ; 798     NumberOfStart--;
3026  060f be00          	ldw	x,_NumberOfStart
3027  0611 5a            	decw	x
3028  0612 bf00          	ldw	_NumberOfStart,x
3029  0614               L5331:
3030                     ; 800   if (NumberOfStart == 0)
3032  0614 be00          	ldw	x,_NumberOfStart
3033  0616 2608          	jrne	L7331
3034                     ; 802     action();
3036  0618 1e01          	ldw	x,(OFST+1,sp)
3037  061a fd            	call	(x)
3039                     ; 803     CheckFlag = 1;
3041  061b ae0001        	ldw	x,#1
3042  061e bf01          	ldw	_CheckFlag,x
3043  0620               L7331:
3044                     ; 805 }
3047  0620 85            	popw	x
3048  0621 81            	ret	
3072                     ; 817 void Toggle(void)
3072                     ; 818 {
3073                     	switch	.text
3074  0622               _Toggle:
3078                     ; 819   GPIO_WriteReverse(GPIOD, GPIO_PIN_0);
3080  0622 4b01          	push	#1
3081  0624 ae500f        	ldw	x,#20495
3082  0627 cd0000        	call	_GPIO_WriteReverse
3084  062a 84            	pop	a
3085                     ; 820 }
3088  062b 81            	ret	
3123                     	switch	.const
3124  000f               L673:
3125  000f 0000ffff      	dc.l	65535
3126                     ; 835 void LCD_GPIO_init(void)
3126                     ; 836 {
3127                     	switch	.text
3128  062c               _LCD_GPIO_init:
3130  062c 5204          	subw	sp,#4
3131       00000004      OFST:	set	4
3134                     ; 838   GPIO_Init(LCD_PORT, LCD_RS, GPIO_MODE_OUT_PP_HIGH_FAST);
3136  062e 4bf0          	push	#240
3137  0630 4b01          	push	#1
3138  0632 ae5005        	ldw	x,#20485
3139  0635 cd0000        	call	_GPIO_Init
3141  0638 85            	popw	x
3142                     ; 839   GPIO_Init(LCD_PORT, LCD_EN, GPIO_MODE_OUT_PP_HIGH_FAST);
3144  0639 4bf0          	push	#240
3145  063b 4b02          	push	#2
3146  063d ae5005        	ldw	x,#20485
3147  0640 cd0000        	call	_GPIO_Init
3149  0643 85            	popw	x
3150                     ; 840   GPIO_Init(LCD_PORT, LCD_DB4, GPIO_MODE_OUT_PP_HIGH_FAST);
3152  0644 4bf0          	push	#240
3153  0646 4b04          	push	#4
3154  0648 ae5005        	ldw	x,#20485
3155  064b cd0000        	call	_GPIO_Init
3157  064e 85            	popw	x
3158                     ; 841   GPIO_Init(LCD_PORT, LCD_DB5, GPIO_MODE_OUT_PP_HIGH_FAST);
3160  064f 4bf0          	push	#240
3161  0651 4b08          	push	#8
3162  0653 ae5005        	ldw	x,#20485
3163  0656 cd0000        	call	_GPIO_Init
3165  0659 85            	popw	x
3166                     ; 842   GPIO_Init(LCD_PORT, LCD_DB6, GPIO_MODE_OUT_PP_HIGH_FAST);
3168  065a 4bf0          	push	#240
3169  065c 4b10          	push	#16
3170  065e ae5005        	ldw	x,#20485
3171  0661 cd0000        	call	_GPIO_Init
3173  0664 85            	popw	x
3174                     ; 843   GPIO_Init(LCD_PORT, LCD_DB7, GPIO_MODE_OUT_PP_HIGH_FAST);
3176  0665 4bf0          	push	#240
3177  0667 4b20          	push	#32
3178  0669 ae5005        	ldw	x,#20485
3179  066c cd0000        	call	_GPIO_Init
3181  066f 85            	popw	x
3182                     ; 845   for (Tempo_Aux = 0; Tempo_Aux < 0xFFFF; Tempo_Aux++)
3184  0670 5f            	clrw	x
3185  0671 1f03          	ldw	(OFST-1,sp),x
3186  0673 1f01          	ldw	(OFST-3,sp),x
3188  0675               L1731:
3191  0675 96            	ldw	x,sp
3192  0676 5c            	incw	x
3193  0677 a601          	ld	a,#1
3194  0679 cd0000        	call	c_lgadc
3199  067c 96            	ldw	x,sp
3200  067d 5c            	incw	x
3201  067e cd0000        	call	c_ltor
3203  0681 ae000f        	ldw	x,#L673
3204  0684 cd0000        	call	c_lcmp
3206  0687 25ec          	jrult	L1731
3207                     ; 847 }
3210  0689 5b04          	addw	sp,#4
3211  068b 81            	ret	
3239                     ; 849 void LCD_init(void)
3239                     ; 850 {
3240                     	switch	.text
3241  068c               _LCD_init:
3245                     ; 851   LCD_GPIO_init();
3247  068c ad9e          	call	_LCD_GPIO_init
3249                     ; 852   toggle_EN_pin();
3251  068e cd07ad        	call	_toggle_EN_pin
3253                     ; 854   GPIO_WriteLow(LCD_PORT, LCD_RS);
3255  0691 4b01          	push	#1
3256  0693 ae5005        	ldw	x,#20485
3257  0696 cd0000        	call	_GPIO_WriteLow
3259  0699 84            	pop	a
3260                     ; 855   GPIO_WriteLow(LCD_PORT, LCD_DB7);
3262  069a ad2c          	call	LC018
3263                     ; 858   GPIO_WriteHigh(LCD_PORT, LCD_DB4);
3265  069c ad46          	call	LC019
3267                     ; 861   GPIO_WriteLow(LCD_PORT, LCD_DB7);
3269  069e ad28          	call	LC018
3270                     ; 864   GPIO_WriteHigh(LCD_PORT, LCD_DB4);
3272  06a0 ad42          	call	LC019
3274                     ; 867   GPIO_WriteLow(LCD_PORT, LCD_DB7);
3276  06a2 ad24          	call	LC018
3277                     ; 870   GPIO_WriteHigh(LCD_PORT, LCD_DB4);
3279  06a4 ad3e          	call	LC019
3281                     ; 873   GPIO_WriteLow(LCD_PORT, LCD_DB7);
3283  06a6 ad20          	call	LC018
3284                     ; 876   GPIO_WriteLow(LCD_PORT, LCD_DB4);
3286  06a8 4b04          	push	#4
3287  06aa ae5005        	ldw	x,#20485
3288  06ad cd0000        	call	_GPIO_WriteLow
3290  06b0 84            	pop	a
3291                     ; 877   toggle_EN_pin();
3293  06b1 cd07ad        	call	_toggle_EN_pin
3295                     ; 879   LCD_send((_4_pin_interface | _2_row_display | _5x7_dots), CMD);
3297  06b4 ae2800        	ldw	x,#10240
3298  06b7 ad37          	call	_LCD_send
3300                     ; 880   LCD_send((display_on | cursor_off | blink_off), CMD);
3302  06b9 ae0c00        	ldw	x,#3072
3303  06bc ad32          	call	_LCD_send
3305                     ; 881   LCD_send(clear_display, CMD);
3307  06be ae0100        	ldw	x,#256
3308  06c1 ad2d          	call	_LCD_send
3310                     ; 882   LCD_send((cursor_direction_inc | display_no_shift), CMD);
3312  06c3 ae0600        	ldw	x,#1536
3314                     ; 883 }
3317  06c6 2028          	jp	_LCD_send
3318  06c8               LC018:
3319  06c8 4b20          	push	#32
3320  06ca ae5005        	ldw	x,#20485
3321  06cd cd0000        	call	_GPIO_WriteLow
3323  06d0 84            	pop	a
3324                     ; 856   GPIO_WriteLow(LCD_PORT, LCD_DB6);
3326  06d1 4b10          	push	#16
3327  06d3 ae5005        	ldw	x,#20485
3328  06d6 cd0000        	call	_GPIO_WriteLow
3330  06d9 84            	pop	a
3331                     ; 857   GPIO_WriteHigh(LCD_PORT, LCD_DB5);
3333  06da 4b08          	push	#8
3334  06dc ae5005        	ldw	x,#20485
3335  06df cd0000        	call	_GPIO_WriteHigh
3337  06e2 84            	pop	a
3338  06e3 81            	ret	
3339  06e4               LC019:
3340  06e4 4b04          	push	#4
3341  06e6 ae5005        	ldw	x,#20485
3342  06e9 cd0000        	call	_GPIO_WriteHigh
3344  06ec 84            	pop	a
3345                     ; 871   toggle_EN_pin();
3347  06ed cc07ad        	jp	_toggle_EN_pin
3393                     ; 885 void LCD_send(unsigned char value, unsigned char mode)
3393                     ; 886 {
3394                     	switch	.text
3395  06f0               _LCD_send:
3397  06f0 89            	pushw	x
3398       00000000      OFST:	set	0
3401                     ; 887   switch (mode)
3403  06f1 9f            	ld	a,xl
3405                     ; 897     break;
3406  06f2 4d            	tnz	a
3407  06f3 270d          	jreq	L7041
3408  06f5 4a            	dec	a
3409  06f6 2613          	jrne	L5341
3410                     ; 891     GPIO_WriteHigh(LCD_PORT, LCD_RS);
3412  06f8 4b01          	push	#1
3413  06fa ae5005        	ldw	x,#20485
3414  06fd cd0000        	call	_GPIO_WriteHigh
3416                     ; 892     break;
3418  0700 2008          	jp	LC020
3419  0702               L7041:
3420                     ; 896     GPIO_WriteLow(LCD_PORT, LCD_RS);
3422  0702 4b01          	push	#1
3423  0704 ae5005        	ldw	x,#20485
3424  0707 cd0000        	call	_GPIO_WriteLow
3426  070a               LC020:
3427  070a 84            	pop	a
3428                     ; 897     break;
3430  070b               L5341:
3431                     ; 901   LCD_4bit_send(value);
3433  070b 7b01          	ld	a,(OFST+1,sp)
3434  070d ad02          	call	_LCD_4bit_send
3436                     ; 902 }
3439  070f 85            	popw	x
3440  0710 81            	ret	
3476                     ; 904 void LCD_4bit_send(unsigned char lcd_data)
3476                     ; 905 {
3477                     	switch	.text
3478  0711               _LCD_4bit_send:
3480  0711 88            	push	a
3481       00000000      OFST:	set	0
3484                     ; 906   toggle_io(lcd_data, 7, LCD_DB7);
3486  0712 4b20          	push	#32
3487  0714 ae0007        	ldw	x,#7
3488  0717 95            	ld	xh,a
3489  0718 cd07dd        	call	_toggle_io
3491  071b 84            	pop	a
3492                     ; 907   toggle_io(lcd_data, 6, LCD_DB6);
3494  071c 4b10          	push	#16
3495  071e 7b02          	ld	a,(OFST+2,sp)
3496  0720 ae0006        	ldw	x,#6
3497  0723 95            	ld	xh,a
3498  0724 cd07dd        	call	_toggle_io
3500  0727 84            	pop	a
3501                     ; 908   toggle_io(lcd_data, 5, LCD_DB5);
3503  0728 4b08          	push	#8
3504  072a 7b02          	ld	a,(OFST+2,sp)
3505  072c ae0005        	ldw	x,#5
3506  072f 95            	ld	xh,a
3507  0730 cd07dd        	call	_toggle_io
3509  0733 84            	pop	a
3510                     ; 909   toggle_io(lcd_data, 4, LCD_DB4);
3512  0734 4b04          	push	#4
3513  0736 7b02          	ld	a,(OFST+2,sp)
3514  0738 ae0004        	ldw	x,#4
3515  073b 95            	ld	xh,a
3516  073c cd07dd        	call	_toggle_io
3518  073f 84            	pop	a
3519                     ; 910   toggle_EN_pin();
3521  0740 ad6b          	call	_toggle_EN_pin
3523                     ; 911   toggle_io(lcd_data, 3, LCD_DB7);
3525  0742 4b20          	push	#32
3526  0744 7b02          	ld	a,(OFST+2,sp)
3527  0746 ae0003        	ldw	x,#3
3528  0749 95            	ld	xh,a
3529  074a cd07dd        	call	_toggle_io
3531  074d 84            	pop	a
3532                     ; 912   toggle_io(lcd_data, 2, LCD_DB6);
3534  074e 4b10          	push	#16
3535  0750 7b02          	ld	a,(OFST+2,sp)
3536  0752 ae0002        	ldw	x,#2
3537  0755 95            	ld	xh,a
3538  0756 cd07dd        	call	_toggle_io
3540  0759 84            	pop	a
3541                     ; 913   toggle_io(lcd_data, 1, LCD_DB5);
3543  075a 4b08          	push	#8
3544  075c 7b02          	ld	a,(OFST+2,sp)
3545  075e ae0001        	ldw	x,#1
3546  0761 95            	ld	xh,a
3547  0762 ad79          	call	_toggle_io
3549  0764 84            	pop	a
3550                     ; 914   toggle_io(lcd_data, 0, LCD_DB4);
3552  0765 4b04          	push	#4
3553  0767 7b02          	ld	a,(OFST+2,sp)
3554  0769 5f            	clrw	x
3555  076a 95            	ld	xh,a
3556  076b ad70          	call	_toggle_io
3558  076d 84            	pop	a
3559                     ; 915   toggle_EN_pin();
3561  076e ad3d          	call	_toggle_EN_pin
3563                     ; 916 }
3566  0770 84            	pop	a
3567  0771 81            	ret	
3603                     ; 918 void LCD_putstr(char *lcd_string)
3603                     ; 919 {
3604                     	switch	.text
3605  0772               _LCD_putstr:
3607  0772 89            	pushw	x
3608       00000000      OFST:	set	0
3611  0773 f6            	ld	a,(x)
3612  0774               L3741:
3613                     ; 922     LCD_send(*lcd_string++, DAT);
3615  0774 5c            	incw	x
3616  0775 1f01          	ldw	(OFST+1,sp),x
3617  0777 ae0001        	ldw	x,#1
3618  077a 95            	ld	xh,a
3619  077b cd06f0        	call	_LCD_send
3621                     ; 923   } while (*lcd_string != '\0');
3623  077e 1e01          	ldw	x,(OFST+1,sp)
3624  0780 f6            	ld	a,(x)
3625  0781 26f1          	jrne	L3741
3626                     ; 924 }
3629  0783 85            	popw	x
3630  0784 81            	ret	
3665                     ; 926 void LCD_putchar(char char_data)
3665                     ; 927 {
3666                     	switch	.text
3667  0785               _LCD_putchar:
3671                     ; 928   LCD_send(char_data, DAT);
3673  0785 ae0001        	ldw	x,#1
3674  0788 95            	ld	xh,a
3676                     ; 929 }
3679  0789 cc06f0        	jp	_LCD_send
3703                     ; 931 void LCD_clear_home(void)
3703                     ; 932 {
3704                     	switch	.text
3705  078c               _LCD_clear_home:
3709                     ; 933   LCD_send(clear_display, CMD);
3711  078c ae0100        	ldw	x,#256
3712  078f cd06f0        	call	_LCD_send
3714                     ; 934   LCD_send(goto_home, CMD);
3716  0792 ae0200        	ldw	x,#512
3718                     ; 935 }
3721  0795 cc06f0        	jp	_LCD_send
3765                     ; 937 void LCD_goto(unsigned char x_pos, unsigned char y_pos)
3765                     ; 938 {
3766                     	switch	.text
3767  0798               _LCD_goto:
3769  0798 89            	pushw	x
3770       00000000      OFST:	set	0
3773                     ; 939   if (y_pos == 0)
3775  0799 9f            	ld	a,xl
3776  079a 4d            	tnz	a
3777  079b 2605          	jrne	L1551
3778                     ; 941     LCD_send((0x80 | x_pos), CMD);
3780  079d 9e            	ld	a,xh
3781  079e aa80          	or	a,#128
3784  07a0 2004          	jra	L3551
3785  07a2               L1551:
3786                     ; 945     LCD_send((0x80 | 0x40 | x_pos), CMD);
3788  07a2 7b01          	ld	a,(OFST+1,sp)
3789  07a4 aac0          	or	a,#192
3791  07a6               L3551:
3792  07a6 5f            	clrw	x
3793  07a7 95            	ld	xh,a
3794  07a8 cd06f0        	call	_LCD_send
3795                     ; 947 }
3798  07ab 85            	popw	x
3799  07ac 81            	ret	
3835                     ; 949 void toggle_EN_pin(void)
3835                     ; 950 {
3836                     	switch	.text
3837  07ad               _toggle_EN_pin:
3839  07ad 5204          	subw	sp,#4
3840       00000004      OFST:	set	4
3843                     ; 952   GPIO_WriteHigh(LCD_PORT, LCD_EN);
3845  07af 4b02          	push	#2
3846  07b1 ae5005        	ldw	x,#20485
3847  07b4 cd0000        	call	_GPIO_WriteHigh
3849  07b7 5f            	clrw	x
3850  07b8 84            	pop	a
3851                     ; 954   for (Tempo_Aux = 0; Tempo_Aux < 0xFFFF; Tempo_Aux++)
3853  07b9 1f03          	ldw	(OFST-1,sp),x
3854  07bb 1f01          	ldw	(OFST-3,sp),x
3856  07bd               L5751:
3859  07bd 96            	ldw	x,sp
3860  07be 5c            	incw	x
3861  07bf a601          	ld	a,#1
3862  07c1 cd0000        	call	c_lgadc
3867  07c4 96            	ldw	x,sp
3868  07c5 5c            	incw	x
3869  07c6 cd0000        	call	c_ltor
3871  07c9 ae000f        	ldw	x,#L673
3872  07cc cd0000        	call	c_lcmp
3874  07cf 25ec          	jrult	L5751
3875                     ; 956   GPIO_WriteLow(LCD_PORT, LCD_EN);
3877  07d1 4b02          	push	#2
3878  07d3 ae5005        	ldw	x,#20485
3879  07d6 cd0000        	call	_GPIO_WriteLow
3881  07d9 84            	pop	a
3882                     ; 957 }
3885  07da 5b04          	addw	sp,#4
3886  07dc 81            	ret	
3970                     ; 959 void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num)
3970                     ; 960 {
3971                     	switch	.text
3972  07dd               _toggle_io:
3974  07dd 89            	pushw	x
3975  07de 88            	push	a
3976       00000001      OFST:	set	1
3979                     ; 961   bool temp = FALSE;
3981                     ; 963   temp = (0x01 & (lcd_data >> bit_pos));
3983  07df 9f            	ld	a,xl
3984  07e0 5f            	clrw	x
3985  07e1 97            	ld	xl,a
3986  07e2 7b02          	ld	a,(OFST+1,sp)
3987  07e4 5d            	tnzw	x
3988  07e5 2704          	jreq	L265
3989  07e7               L465:
3990  07e7 44            	srl	a
3991  07e8 5a            	decw	x
3992  07e9 26fc          	jrne	L465
3993  07eb               L265:
3994  07eb a401          	and	a,#1
3995  07ed 6b01          	ld	(OFST+0,sp),a
3997                     ; 965   switch (temp)
3999  07ef 4a            	dec	a
4000  07f0 260b          	jrne	L3061
4003                     ; 969     GPIO_WriteHigh(LCD_PORT, pin_num);
4005  07f2 7b06          	ld	a,(OFST+5,sp)
4006  07f4 88            	push	a
4007  07f5 ae5005        	ldw	x,#20485
4008  07f8 cd0000        	call	_GPIO_WriteHigh
4010                     ; 970     break;
4012  07fb 2009          	jra	L1561
4013  07fd               L3061:
4014                     ; 975     GPIO_WriteLow(LCD_PORT, pin_num);
4016  07fd 7b06          	ld	a,(OFST+5,sp)
4017  07ff 88            	push	a
4018  0800 ae5005        	ldw	x,#20485
4019  0803 cd0000        	call	_GPIO_WriteLow
4021                     ; 976     break;
4022  0806               L1561:
4023  0806 84            	pop	a
4024                     ; 979 }
4027  0807 5b03          	addw	sp,#3
4028  0809 81            	ret	
4070                     	xdef	_main
4071                     	xdef	_processaPacoteRX
4072                     	xdef	_enviaPacote
4073                     	xdef	_zeraRegistradoresRX
4074                     	xdef	_coletaBuffer
4075                     	xdef	_debugCOM
4076                     	xdef	_piscaLED
4077                     	xdef	_calculateBCC_Param
4078                     	xdef	_calculateBCC_RX
4079                     	xdef	_enviaTodoBuffer
4080                     	xdef	_limpaVetor
4081                     	xdef	_enviaSerial
4082                     	xdef	_CheckFlag
4083                     	switch	.ubsct
4084  0000               _NumberOfStart:
4085  0000 0000          	ds.b	2
4086                     	xdef	_NumberOfStart
4087                     	xdef	_BlinkSpeed
4088                     	xdef	_Toggle
4089                     	xdef	_Delay
4090                     	xdef	_ExtraCode_StateMachine
4091                     	xdef	_ExtraCode_Init
4092                     	xdef	_GPIO_Configuration
4093                     	xdef	_CLK_Configuration
4094                     	xref.b	_sSCKeyInfo
4095                     	xref.b	_TSL_GlobalSetting
4096                     	xref.b	_TSLState
4097                     	xref.b	_TSL_Tick_Flags
4098                     	xref	_UART2_GetFlagStatus
4099                     	xref	_UART2_SendData8
4100                     	xref	_UART2_ReceiveData8
4101                     	xref	_UART2_Init
4102                     	xref	_GPIO_ReadInputPin
4103                     	xref	_GPIO_WriteReverse
4104                     	xref	_GPIO_WriteLow
4105                     	xref	_GPIO_WriteHigh
4106                     	xref	_GPIO_Init
4107                     	xref	_GPIO_DeInit
4108                     	xref	_CLK_HSIPrescalerConfig
4109                     	xdef	_toggle_io
4110                     	xdef	_toggle_EN_pin
4111                     	xdef	_LCD_goto
4112                     	xdef	_LCD_clear_home
4113                     	xdef	_LCD_putchar
4114                     	xdef	_LCD_putstr
4115                     	xdef	_LCD_4bit_send
4116                     	xdef	_LCD_send
4117                     	xdef	_LCD_init
4118                     	xdef	_LCD_GPIO_init
4119                     	xref.b	c_x
4120                     	xref.b	c_y
4140                     	xref	c_lcmp
4141                     	xref	c_ltor
4142                     	xref	c_lgadc
4143                     	xref	c_xymov
4144                     	xref	c_lzmp
4145                     	xref	c_lgsbc
4146                     	end
