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
 490  0079 a805          	xor	a,#5
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
 516  008b a805          	xor	a,#5
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
 546  009f a805          	xor	a,#5
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
1014                     ; 257 char coletaBuffer(char buffer[])
1014                     ; 258 {
1015                     	switch	.text
1016  0152               _coletaBuffer:
1018  0152 89            	pushw	x
1019  0153 5205          	subw	sp,#5
1020       00000005      OFST:	set	5
1023                     ; 259   unsigned long tempo_RX = 0xFFFF;
1025  0155 aeffff        	ldw	x,#65535
1026  0158 1f04          	ldw	(OFST-1,sp),x
1027  015a 5f            	clrw	x
1028  015b 1f02          	ldw	(OFST-3,sp),x
1030                     ; 260   char tamanhoMsg = 0;
1032  015d 0f01          	clr	(OFST-4,sp)
1035  015f 2029          	jra	L154
1036  0161               L544:
1037                     ; 264     if (UART2_GetFlagStatus(UART2_FLAG_RXNE) == TRUE)
1039  0161 ae0020        	ldw	x,#32
1040  0164 cd0000        	call	_UART2_GetFlagStatus
1042  0167 4a            	dec	a
1043  0168 2617          	jrne	L554
1044                     ; 266       buffer[tamanhoMsg] = UART2_ReceiveData8();
1046  016a 7b01          	ld	a,(OFST-4,sp)
1047  016c 5f            	clrw	x
1048  016d 97            	ld	xl,a
1049  016e 72fb06        	addw	x,(OFST+1,sp)
1050  0171 89            	pushw	x
1051  0172 cd0000        	call	_UART2_ReceiveData8
1053  0175 85            	popw	x
1054  0176 f7            	ld	(x),a
1055                     ; 267       tempo_RX = 0xFFF;
1057  0177 ae0fff        	ldw	x,#4095
1058  017a 1f04          	ldw	(OFST-1,sp),x
1059  017c 5f            	clrw	x
1060  017d 1f02          	ldw	(OFST-3,sp),x
1062                     ; 268       tamanhoMsg++;
1064  017f 0c01          	inc	(OFST-4,sp)
1066  0181               L554:
1067                     ; 270     tempo_RX--;
1069  0181 96            	ldw	x,sp
1070  0182 1c0002        	addw	x,#OFST-3
1071  0185 a601          	ld	a,#1
1072  0187 cd0000        	call	c_lgsbc
1075  018a               L154:
1076                     ; 262   while (tempo_RX > 0)
1078  018a 96            	ldw	x,sp
1079  018b 1c0002        	addw	x,#OFST-3
1080  018e cd0000        	call	c_lzmp
1082  0191 26ce          	jrne	L544
1083                     ; 272   return tamanhoMsg;
1085  0193 7b01          	ld	a,(OFST-4,sp)
1088  0195 5b07          	addw	sp,#7
1089  0197 81            	ret	
1214                     ; 275 void zeraRegistradoresRX(char Dados_comando_RX[], char *STX_RX, char *tamanhoPacote_RX, char *enderecoDestino_RX, char *enderecoOrigem_RX, char *comando_RX, char *dadosPacote1_RX, char *dadosPacote2_RX, char *BCC_RX, char *tamanhoMsg, char *flagCOM_RX)
1214                     ; 276 {
1215                     	switch	.text
1216  0198               _zeraRegistradoresRX:
1218  0198 89            	pushw	x
1219  0199 88            	push	a
1220       00000001      OFST:	set	1
1223                     ; 277   char varredura=0x00;
1225                     ; 279   *STX_RX = '\0';
1227  019a 1e06          	ldw	x,(OFST+5,sp)
1228  019c 7f            	clr	(x)
1229                     ; 280   *tamanhoPacote_RX = '\0';
1231  019d 1e08          	ldw	x,(OFST+7,sp)
1232  019f 7f            	clr	(x)
1233                     ; 281   *enderecoDestino_RX = '\0';
1235  01a0 1e0a          	ldw	x,(OFST+9,sp)
1236  01a2 7f            	clr	(x)
1237                     ; 282   *enderecoOrigem_RX = '\0';
1239  01a3 1e0c          	ldw	x,(OFST+11,sp)
1240  01a5 7f            	clr	(x)
1241                     ; 283   *comando_RX = '\0';
1243  01a6 1e0e          	ldw	x,(OFST+13,sp)
1244  01a8 7f            	clr	(x)
1245                     ; 284   *dadosPacote1_RX = '\0';
1247  01a9 1e10          	ldw	x,(OFST+15,sp)
1248  01ab 7f            	clr	(x)
1249                     ; 285   *dadosPacote2_RX = '\0';
1251  01ac 1e12          	ldw	x,(OFST+17,sp)
1252                     ; 286   for(varredura=0; varredura<=TAMANHO_DADOS_RX-1;varredura++){
1254  01ae 4f            	clr	a
1255  01af 7f            	clr	(x)
1256  01b0 6b01          	ld	(OFST+0,sp),a
1258  01b2               L145:
1259                     ; 287     Dados_comando_RX[varredura] = '\0';
1261  01b2 5f            	clrw	x
1262  01b3 97            	ld	xl,a
1263  01b4 72fb02        	addw	x,(OFST+1,sp)
1264  01b7 7f            	clr	(x)
1265                     ; 286   for(varredura=0; varredura<=TAMANHO_DADOS_RX-1;varredura++){
1267  01b8 0c01          	inc	(OFST+0,sp)
1271  01ba 7b01          	ld	a,(OFST+0,sp)
1272  01bc a114          	cp	a,#20
1273  01be 25f2          	jrult	L145
1274                     ; 289   *BCC_RX = '\0';
1276  01c0 1e14          	ldw	x,(OFST+19,sp)
1277  01c2 7f            	clr	(x)
1278                     ; 292 }
1281  01c3 5b03          	addw	sp,#3
1282  01c5 81            	ret	
1363                     ; 294 void enviaPacote(char enderecoDestino, char comando, char dados1, char dados2)
1363                     ; 295 {
1364                     	switch	.text
1365  01c6               _enviaPacote:
1367  01c6 89            	pushw	x
1368  01c7 89            	pushw	x
1369       00000002      OFST:	set	2
1372                     ; 297   char BCC = 0x00, tamanhoPacote = 0x00;
1376                     ; 299   if (dados1 == '\0' && dados2 == '\0') //Tamanho = 0x05
1378  01c8 7b07          	ld	a,(OFST+5,sp)
1379  01ca 2629          	jrne	L116
1381  01cc 7b08          	ld	a,(OFST+6,sp)
1382  01ce 2625          	jrne	L116
1383                     ; 301     tamanhoPacote = 0x05;
1385  01d0 a605          	ld	a,#5
1386  01d2 6b02          	ld	(OFST+0,sp),a
1388                     ; 302     BCC = calculateBCC_Param(enderecoDestino, comando, dados1, dados2);
1390  01d4 7b08          	ld	a,(OFST+6,sp)
1391  01d6 88            	push	a
1392  01d7 7b08          	ld	a,(OFST+6,sp)
1393  01d9 88            	push	a
1394  01da 7b05          	ld	a,(OFST+3,sp)
1395  01dc 95            	ld	xh,a
1396  01dd cd006a        	call	_calculateBCC_Param
1398  01e0 85            	popw	x
1399  01e1 6b01          	ld	(OFST-1,sp),a
1401                     ; 303     enviaSerial(STX);
1403  01e3 a602          	ld	a,#2
1404  01e5 cd0000        	call	_enviaSerial
1406                     ; 304     enviaSerial(tamanhoPacote); //tamanho
1408  01e8 7b02          	ld	a,(OFST+0,sp)
1409  01ea cd0000        	call	_enviaSerial
1411                     ; 305     enviaSerial(enderecoDestino);
1413  01ed 7b03          	ld	a,(OFST+1,sp)
1414  01ef ad7c          	call	LC004
1416                     ; 307     enviaSerial(comando);
1418  01f1 7b04          	ld	a,(OFST+2,sp)
1420                     ; 308     enviaSerial(BCC);
1423  01f3 206d          	jp	LC003
1424  01f5               L116:
1425                     ; 310   else if (!dados1 == '\0' && dados2 == '\0') //Tamanho = 0x06
1427  01f5 7b07          	ld	a,(OFST+5,sp)
1428  01f7 2731          	jreq	L516
1430  01f9 7b08          	ld	a,(OFST+6,sp)
1431  01fb 262d          	jrne	L516
1432                     ; 312     tamanhoPacote = 0x06;
1434  01fd a606          	ld	a,#6
1435  01ff 6b02          	ld	(OFST+0,sp),a
1437                     ; 313     BCC = calculateBCC_Param(enderecoDestino, comando, dados1, dados2);
1439  0201 7b08          	ld	a,(OFST+6,sp)
1440  0203 88            	push	a
1441  0204 7b08          	ld	a,(OFST+6,sp)
1442  0206 88            	push	a
1443  0207 7b06          	ld	a,(OFST+4,sp)
1444  0209 97            	ld	xl,a
1445  020a 7b05          	ld	a,(OFST+3,sp)
1446  020c 95            	ld	xh,a
1447  020d cd006a        	call	_calculateBCC_Param
1449  0210 85            	popw	x
1450  0211 6b01          	ld	(OFST-1,sp),a
1452                     ; 314     enviaSerial(STX);
1454  0213 a602          	ld	a,#2
1455  0215 cd0000        	call	_enviaSerial
1457                     ; 315     enviaSerial(tamanhoPacote); //tamanho
1459  0218 7b02          	ld	a,(OFST+0,sp)
1460  021a cd0000        	call	_enviaSerial
1462                     ; 316     enviaSerial(enderecoDestino);
1464  021d 7b03          	ld	a,(OFST+1,sp)
1465  021f ad4c          	call	LC004
1467                     ; 318     enviaSerial(comando);
1469  0221 7b04          	ld	a,(OFST+2,sp)
1470  0223 cd0000        	call	_enviaSerial
1472                     ; 319     enviaSerial(dados1);
1474  0226 7b07          	ld	a,(OFST+5,sp)
1476                     ; 320     enviaSerial(BCC);
1479  0228 2038          	jp	LC003
1480  022a               L516:
1481                     ; 322   else if (!dados1 == '\0' && !dados2 == '\0') //Tamanho = 0x07
1483  022a 7b07          	ld	a,(OFST+5,sp)
1484  022c 273c          	jreq	L316
1486  022e 7b08          	ld	a,(OFST+6,sp)
1487  0230 2738          	jreq	L316
1488                     ; 324     tamanhoPacote = 0x07;
1490  0232 a607          	ld	a,#7
1491  0234 6b02          	ld	(OFST+0,sp),a
1493                     ; 325     BCC = calculateBCC_Param(enderecoDestino, comando, dados1, dados2);
1495  0236 7b08          	ld	a,(OFST+6,sp)
1496  0238 88            	push	a
1497  0239 7b08          	ld	a,(OFST+6,sp)
1498  023b 88            	push	a
1499  023c 7b06          	ld	a,(OFST+4,sp)
1500  023e 97            	ld	xl,a
1501  023f 7b05          	ld	a,(OFST+3,sp)
1502  0241 95            	ld	xh,a
1503  0242 cd006a        	call	_calculateBCC_Param
1505  0245 85            	popw	x
1506  0246 6b01          	ld	(OFST-1,sp),a
1508                     ; 326     enviaSerial(STX);
1510  0248 a602          	ld	a,#2
1511  024a cd0000        	call	_enviaSerial
1513                     ; 327     enviaSerial(tamanhoPacote); //tamanho
1515  024d 7b02          	ld	a,(OFST+0,sp)
1516  024f cd0000        	call	_enviaSerial
1518                     ; 328     enviaSerial(enderecoDestino);
1520  0252 7b03          	ld	a,(OFST+1,sp)
1521  0254 ad17          	call	LC004
1523                     ; 330     enviaSerial(comando);
1525  0256 7b04          	ld	a,(OFST+2,sp)
1526  0258 cd0000        	call	_enviaSerial
1528                     ; 331     enviaSerial(dados1);
1530  025b 7b07          	ld	a,(OFST+5,sp)
1531  025d cd0000        	call	_enviaSerial
1533                     ; 332     enviaSerial(dados2);
1535  0260 7b08          	ld	a,(OFST+6,sp)
1537                     ; 333     enviaSerial(BCC);
1539  0262               LC003:
1540  0262 cd0000        	call	_enviaSerial
1543  0265 7b01          	ld	a,(OFST-1,sp)
1544  0267 cd0000        	call	_enviaSerial
1546  026a               L316:
1547                     ; 335 }
1550  026a 5b04          	addw	sp,#4
1551  026c 81            	ret	
1552  026d               LC004:
1553  026d cd0000        	call	_enviaSerial
1555                     ; 329     enviaSerial(ENDERECO_DISP);
1557  0270 a605          	ld	a,#5
1558  0272 cc0000        	jp	_enviaSerial
1654                     ; 337 void processaPacoteRX(char Dados_comando_RX[],char STX_RX, char tamanhoPacote_RX, char enderecoDestino_RX, char enderecoOrigem_RX, char comando_RX, char dadosPacote1_RX, char dadosPacote2_RX, char BCC_RX, char flagCOM_RX, char qtdeDadosRX)
1654                     ; 338 { //função para tomar a decisão do que fazer a partir dos dados recebidos
1655                     	switch	.text
1656  0275               _processaPacoteRX:
1658  0275 89            	pushw	x
1659  0276 89            	pushw	x
1660       00000002      OFST:	set	2
1663                     ; 339 	char varreduraAux=0x00;
1665                     ; 340 	char posicao=0x00;
1667  0277 0f01          	clr	(OFST-1,sp)
1669                     ; 342 	switch (flagCOM_RX)
1671  0279 7b0f          	ld	a,(OFST+13,sp)
1673                     ; 418     break;
1674  027b 2709          	jreq	L326
1675  027d 4a            	dec	a
1676  027e 2603cc034f    	jreq	L346
1677  0283 cc035d        	jra	L517
1678  0286               L326:
1679                     ; 344   case 0x00:
1679                     ; 345     switch (comando_RX)
1681  0286 7b0b          	ld	a,(OFST+9,sp)
1683                     ; 410       break;
1684  0288 4a            	dec	a
1685  0289 2715          	jreq	L526
1686  028b 4a            	dec	a
1687  028c 2721          	jreq	L726
1688  028e 4a            	dec	a
1689  028f 273b          	jreq	L136
1690  0291 4a            	dec	a
1691  0292 274f          	jreq	L336
1692  0294 4a            	dec	a
1693  0295 2764          	jreq	L536
1694  0297 4a            	dec	a
1695  0298 2770          	jreq	L736
1696  029a 4a            	dec	a
1697  029b 277c          	jreq	L146
1698  029d cc035d        	jra	L517
1699  02a0               L526:
1700                     ; 347     case 0x01: //0x1: Leitura do status do botão 1, 0 quando não estiver acionado e 1 quando estiver acionado
1700                     ; 348       if (GPIO_ReadInputPin(GPIOD, GPIO_PIN_4) == 0)
1702  02a0 4b10          	push	#16
1703  02a2 ae500f        	ldw	x,#20495
1704  02a5 cd0000        	call	_GPIO_ReadInputPin
1706  02a8 5b01          	addw	sp,#1
1707  02aa 4d            	tnz	a
1708  02ab 2613          	jrne	L727
1709                     ; 350         enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x00);
1712  02ad 200d          	jp	LC008
1713                     ; 354         enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x01);
1715  02af               L726:
1716                     ; 358     case 0x02: //0x2: Leitura do status do botão 2, 0 quando não estiver acionado e 1 quando estiver acionado
1716                     ; 359       if (GPIO_ReadInputPin(GPIOD, GPIO_PIN_7) == 0)
1718  02af 4b80          	push	#128
1719  02b1 ae500f        	ldw	x,#20495
1720  02b4 cd0000        	call	_GPIO_ReadInputPin
1722  02b7 5b01          	addw	sp,#1
1723  02b9 4d            	tnz	a
1724  02ba 2604          	jrne	L727
1725                     ; 361         enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x00);
1727  02bc               LC008:
1729  02bc 4b00          	push	#0
1732  02be 2002          	jp	LC006
1733  02c0               L727:
1734                     ; 365         enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x01);
1737  02c0 4b01          	push	#1
1738  02c2               LC006:
1739  02c2 4b06          	push	#6
1740  02c4 7b0c          	ld	a,(OFST+10,sp)
1741  02c6 ae0001        	ldw	x,#1
1743  02c9 cc0358        	jp	LC005
1744  02cc               L136:
1745                     ; 370     case 0x03: //0x3: Escrita no Led 1, 0 para desligar o LED e 1 para ligar o LED
1745                     ; 371       if (Dados_comando_RX[0] == 0x01)
1747  02cc 1e03          	ldw	x,(OFST+1,sp)
1748  02ce f6            	ld	a,(x)
1749  02cf 4a            	dec	a
1750  02d0 2604          	jrne	L337
1751                     ; 373         GPIO_WriteHigh(GPIOD, GPIO_PIN_2);
1753  02d2 4b04          	push	#4
1756  02d4 2015          	jp	LC010
1757  02d6               L337:
1758                     ; 375       else if (Dados_comando_RX[0] == 0x00)
1760  02d6 f6            	ld	a,(x)
1761  02d7 26c4          	jrne	L517
1762                     ; 377         GPIO_WriteLow(GPIOD, GPIO_PIN_2);
1764  02d9 4b04          	push	#4
1765  02db               LC011:
1766  02db ae500f        	ldw	x,#20495
1767  02de cd0000        	call	_GPIO_WriteLow
1769  02e1 200e          	jp	LC009
1770  02e3               L336:
1771                     ; 381     case 0x04: //0x4: Escrita no Led 2, 0 para desligar o LED e 1 para ligar o LED
1771                     ; 382       if (Dados_comando_RX[0] == 0x01)
1773  02e3 1e03          	ldw	x,(OFST+1,sp)
1774  02e5 f6            	ld	a,(x)
1775  02e6 4a            	dec	a
1776  02e7 260b          	jrne	L147
1777                     ; 384         GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
1779  02e9 4b08          	push	#8
1780  02eb               LC010:
1781  02eb ae500f        	ldw	x,#20495
1782  02ee cd0000        	call	_GPIO_WriteHigh
1784  02f1               LC009:
1785  02f1 84            	pop	a
1787  02f2 2069          	jra	L517
1788  02f4               L147:
1789                     ; 386       else if (Dados_comando_RX[0] == 0x00)
1791  02f4 f6            	ld	a,(x)
1792  02f5 2666          	jrne	L517
1793                     ; 388         GPIO_WriteLow(GPIOD, GPIO_PIN_3);
1795  02f7 4b08          	push	#8
1797  02f9 20e0          	jp	LC011
1798  02fb               L536:
1799                     ; 392     case 0x05: //0x5: Pisca Led1, primeiro byte o número de piscadas e o segundo byte o tempo de cada piscada
1799                     ; 393       piscaLED(0x01, Dados_comando_RX[0], Dados_comando_RX[1]);
1801  02fb 1e03          	ldw	x,(OFST+1,sp)
1802  02fd e601          	ld	a,(1,x)
1803  02ff 88            	push	a
1804  0300 f6            	ld	a,(x)
1805  0301 ae0100        	ldw	x,#256
1806  0304 97            	ld	xl,a
1807  0305 cd00ae        	call	_piscaLED
1809                     ; 394       break;
1811  0308 20e7          	jp	LC009
1812  030a               L736:
1813                     ; 396     case 0x06: //0x6: Pisca Led2, primeiro byte o número de piscadas e o segundo byte o tempo de cada piscada
1813                     ; 397       piscaLED(0x02, Dados_comando_RX[0], Dados_comando_RX[1]);
1815  030a 1e03          	ldw	x,(OFST+1,sp)
1816  030c e601          	ld	a,(1,x)
1817  030e 88            	push	a
1818  030f f6            	ld	a,(x)
1819  0310 ae0200        	ldw	x,#512
1820  0313 97            	ld	xl,a
1821  0314 cd00ae        	call	_piscaLED
1823                     ; 398       break;
1825  0317 20d8          	jp	LC009
1826  0319               L146:
1827                     ; 400     case 0x07: //0x7 : Escreve uma mensagem do display, onde o primeiro dado é a posição do display (0x80 para a primeira posição) e os demais dados a mensagem (em ASCII)
1827                     ; 401       LCD_goto(Dados_comando_RX[0], 0);
1829  0319 1e03          	ldw	x,(OFST+1,sp)
1830  031b f6            	ld	a,(x)
1831  031c ad42          	call	LC012
1833                     ; 402       for(varreduraAux=1;varreduraAux<=qtdeDadosRX-1;varreduraAux++){
1835  031e a601          	ld	a,#1
1836  0320 6b02          	ld	(OFST+0,sp),a
1839  0322 2013          	jra	L357
1840  0324               L747:
1841                     ; 403         LCD_goto(posicao, 0); 
1843  0324 7b01          	ld	a,(OFST-1,sp)
1844  0326 ad38          	call	LC012
1846                     ; 404         LCD_putchar(Dados_comando_RX[varreduraAux]);
1848  0328 7b02          	ld	a,(OFST+0,sp)
1849  032a 5f            	clrw	x
1850  032b 97            	ld	xl,a
1851  032c 72fb03        	addw	x,(OFST+1,sp)
1852  032f f6            	ld	a,(x)
1853  0330 cd074f        	call	_LCD_putchar
1855                     ; 405         posicao++;
1857  0333 0c01          	inc	(OFST-1,sp)
1859                     ; 402       for(varreduraAux=1;varreduraAux<=qtdeDadosRX-1;varreduraAux++){
1861  0335 0c02          	inc	(OFST+0,sp)
1863  0337               L357:
1866  0337 7b10          	ld	a,(OFST+14,sp)
1867  0339 5f            	clrw	x
1868  033a 97            	ld	xl,a
1869  033b 5a            	decw	x
1870  033c 7b02          	ld	a,(OFST+0,sp)
1871  033e 905f          	clrw	y
1872  0340 9097          	ld	yl,a
1873  0342 90bf00        	ldw	c_y,y
1874  0345 b300          	cpw	x,c_y
1875  0347 2edb          	jrsge	L747
1876                     ; 408       LCD_goto(posicao, 0);                              
1878  0349 7b01          	ld	a,(OFST-1,sp)
1879  034b ad13          	call	LC012
1881                     ; 410       break;
1883  034d 200e          	jra	L517
1884                     ; 413     break;
1886  034f               L346:
1887                     ; 415   case 0x01:
1887                     ; 416     //ENVIA NAK
1887                     ; 417     enviaPacote(enderecoOrigem_RX, 0x20, 0x15, '\0');
1889  034f 4b00          	push	#0
1890  0351 4b15          	push	#21
1891  0353 7b0c          	ld	a,(OFST+10,sp)
1892  0355 ae0020        	ldw	x,#32
1894  0358               LC005:
1895  0358 95            	ld	xh,a
1896  0359 cd01c6        	call	_enviaPacote
1897  035c 85            	popw	x
1898                     ; 418     break;
1900  035d               L517:
1901                     ; 420 }
1904  035d 5b04          	addw	sp,#4
1905  035f 81            	ret	
1906  0360               LC012:
1907  0360 5f            	clrw	x
1908  0361 95            	ld	xh,a
1909  0362 cc0762        	jp	_LCD_goto
1912                     .const:	section	.text
1913  0000               L757_maqEstados:
1914  0000 01            	dc.b	1
1915  0001 02            	dc.b	2
1916  0002 03            	dc.b	3
1917  0003 04            	dc.b	4
1918  0004 05            	dc.b	5
1919  0005 06            	dc.b	6
1920  0006 000000000000  	ds.b	9
2145                     ; 422 void main(void)
2145                     ; 423 {
2146                     	switch	.text
2147  0365               _main:
2149  0365 529d          	subw	sp,#157
2150       0000009d      OFST:	set	157
2153                     ; 424   char indiceMaqEstados = 0x00;
2155                     ; 425   unsigned long tempo, tempo_RX = 0xFFF;
2157                     ; 426   char delay = 0xFFFFF, tamanhoMsg = 0, varredura = 0,
2161  0367 0f36          	clr	(OFST-103,sp)
2165                     ; 427        Dado_RX_buffer[TAMANHO_MAX], BCC_RX = 0x00, STX_RX = 0x00,
2167  0369 0f34          	clr	(OFST-105,sp)
2171  036b 0f1c          	clr	(OFST-129,sp)
2173                     ; 428        tamanhoPacote_RX = 0x00, enderecoDestino_RX = 0x00, enderecoOrigem_RX = 0x00,
2175  036d 0f35          	clr	(OFST-104,sp)
2179  036f 0f1d          	clr	(OFST-128,sp)
2183  0371 0f1e          	clr	(OFST-127,sp)
2185                     ; 429        comando_RX = 0x00, dadosPacote1_RX = 0x00, dadosPacote2_RX = 0x00,Dados_comando_RX[TAMANHO_DADOS_RX],qtdeDadosRX=0x00;
2187  0373 0f1f          	clr	(OFST-126,sp)
2191  0375 0f19          	clr	(OFST-132,sp)
2195  0377 0f1a          	clr	(OFST-131,sp)
2199  0379 0f1b          	clr	(OFST-130,sp)
2201                     ; 431   char flagDados = '\0'; //Se 0 -> um byte de dados. Se 1 -> dois bytes de daods.
2203                     ; 432   char flagCOM_RX = '\0';
2205  037b 0f38          	clr	(OFST-101,sp)
2207                     ; 440   char estado = 0x00;
2209                     ; 450   char maqEstados[15] = {
2209                     ; 451       0x01,
2209                     ; 452       0x02,
2209                     ; 453       0x03,
2209                     ; 454       0x04,
2209                     ; 455       0x05,
2209                     ; 456       0x06};
2211  037d 96            	ldw	x,sp
2212  037e 1c000a        	addw	x,#OFST-147
2213  0381 90ae0000      	ldw	y,#L757_maqEstados
2214  0385 a60f          	ld	a,#15
2215  0387 cd0000        	call	c_xymov
2217                     ; 459   CLK_Configuration();
2219  038a cd0564        	call	_CLK_Configuration
2221                     ; 462   GPIO_Configuration();
2223  038d cd0568        	call	_GPIO_Configuration
2225                     ; 464   UART2_Init(9600, UART2_WORDLENGTH_8D, UART2_STOPBITS_1,
2225                     ; 465              UART2_PARITY_NO, UART2_SYNCMODE_CLOCK_DISABLE,
2225                     ; 466              UART2_MODE_TXRX_ENABLE);
2227  0390 4b0c          	push	#12
2228  0392 4b80          	push	#128
2229  0394 4b00          	push	#0
2230  0396 4b00          	push	#0
2231  0398 4b00          	push	#0
2232  039a ae2580        	ldw	x,#9600
2233  039d 89            	pushw	x
2234  039e 5f            	clrw	x
2235  039f 89            	pushw	x
2236  03a0 cd0000        	call	_UART2_Init
2238  03a3 5b09          	addw	sp,#9
2239                     ; 468   LCD_init();
2241  03a5 cd0656        	call	_LCD_init
2243                     ; 469   LCD_clear_home();
2245  03a8 cd0756        	call	_LCD_clear_home
2247  03ab               L3311:
2248                     ; 474     limpaVetor(Dado_RX_buffer, TAMANHO_MAX);
2250  03ab 4b64          	push	#100
2251  03ad 96            	ldw	x,sp
2252  03ae 1c003b        	addw	x,#OFST-98
2253  03b1 cd000d        	call	_limpaVetor
2255  03b4 84            	pop	a
2256                     ; 475     tamanhoMsg = coletaBuffer(Dado_RX_buffer); //Abre o buffer e recebe dados
2258  03b5 96            	ldw	x,sp
2259  03b6 1c003a        	addw	x,#OFST-99
2260  03b9 cd0152        	call	_coletaBuffer
2262  03bc 6b36          	ld	(OFST-103,sp),a
2264                     ; 477     if (tamanhoMsg > 0)
2266  03be 27eb          	jreq	L3311
2267                     ; 479       flagCOM_RX = 0x04; // Processamento em andamento
2269  03c0 a604          	ld	a,#4
2270  03c2 6b38          	ld	(OFST-101,sp),a
2272                     ; 480       indiceMaqEstados = 0x00;
2274  03c4 0f37          	clr	(OFST-102,sp)
2277  03c6 cc04be        	jra	L3411
2278  03c9               L1411:
2279                     ; 485         estado = maqEstados[indiceMaqEstados];
2281  03c9 96            	ldw	x,sp
2282  03ca 1c000a        	addw	x,#OFST-147
2283  03cd 9f            	ld	a,xl
2284  03ce 5e            	swapw	x
2285  03cf 1b37          	add	a,(OFST-102,sp)
2286  03d1 2401          	jrnc	L652
2287  03d3 5c            	incw	x
2288  03d4               L652:
2289  03d4 02            	rlwa	x,a
2290  03d5 f6            	ld	a,(x)
2291  03d6 6b39          	ld	(OFST-100,sp),a
2293                     ; 487         switch (estado)
2296                     ; 566           break;
2297  03d8 4a            	dec	a
2298  03d9 2712          	jreq	L167
2299  03db 4a            	dec	a
2300  03dc 273c          	jreq	L367
2301  03de 4a            	dec	a
2302  03df 2748          	jreq	L567
2303  03e1 4a            	dec	a
2304  03e2 276a          	jreq	L767
2305  03e4 4a            	dec	a
2306  03e5 2775          	jreq	L177
2307  03e7 4a            	dec	a
2308  03e8 277a          	jreq	L377
2309  03ea cc04be        	jra	L3411
2310  03ed               L167:
2311                     ; 490         case 0x01: //LIMPA REGISTRADORES
2311                     ; 491           zeraRegistradoresRX(Dados_comando_RX, &STX_RX, &tamanhoPacote_RX, &enderecoDestino_RX, &enderecoOrigem_RX, &comando_RX, &dadosPacote1_RX, &dadosPacote2_RX, &BCC_RX, &tamanhoMsg, &flagCOM_RX);
2313  03ed 96            	ldw	x,sp
2314  03ee 1c0038        	addw	x,#OFST-101
2315  03f1 89            	pushw	x
2316  03f2 1d0002        	subw	x,#2
2317  03f5 89            	pushw	x
2318  03f6 1d0002        	subw	x,#2
2319  03f9 89            	pushw	x
2320  03fa 1d001a        	subw	x,#26
2321  03fd 89            	pushw	x
2322  03fe 5a            	decw	x
2323  03ff 89            	pushw	x
2324  0400 1c0006        	addw	x,#6
2325  0403 89            	pushw	x
2326  0404 5a            	decw	x
2327  0405 89            	pushw	x
2328  0406 5a            	decw	x
2329  0407 89            	pushw	x
2330  0408 1c0018        	addw	x,#24
2331  040b 89            	pushw	x
2332  040c 1d0019        	subw	x,#25
2333  040f 89            	pushw	x
2334  0410 1c0004        	addw	x,#4
2335  0413 cd0198        	call	_zeraRegistradoresRX
2337  0416 5b14          	addw	sp,#20
2338                     ; 492           indiceMaqEstados++;
2339                     ; 493           break;
2341  0418 2046          	jp	LC014
2342  041a               L367:
2343                     ; 495         case 0x02: //VALIDA STX_RX
2343                     ; 496           if (Dado_RX_buffer[0] == 0x02)
2345  041a 7b3a          	ld	a,(OFST-99,sp)
2346  041c a102          	cp	a,#2
2347  041e 2604          	jrne	L3511
2348                     ; 498             STX_RX = Dado_RX_buffer[0];
2350  0420 6b1c          	ld	(OFST-129,sp),a
2352                     ; 499             indiceMaqEstados++;
2354  0422 203c          	jp	LC014
2355  0424               L3511:
2356                     ; 503             flagCOM_RX = 0x03;
2358  0424 a603          	ld	a,#3
2359  0426 cc04bc        	jp	L3711
2360  0429               L567:
2361                     ; 507         case 0x03: //CALCULA E VALIDA BCC_RX
2361                     ; 508           BCC_RX = calculateBCC_RX(Dado_RX_buffer, tamanhoMsg);
2363  0429 7b36          	ld	a,(OFST-103,sp)
2364  042b 88            	push	a
2365  042c 96            	ldw	x,sp
2366  042d 1c003b        	addw	x,#OFST-98
2367  0430 cd003d        	call	_calculateBCC_RX
2369  0433 5b01          	addw	sp,#1
2370  0435 6b34          	ld	(OFST-105,sp),a
2372                     ; 509           if (BCC_RX == Dado_RX_buffer[tamanhoMsg - 1])
2374  0437 96            	ldw	x,sp
2375  0438 1c003a        	addw	x,#OFST-99
2376  043b 1f01          	ldw	(OFST-156,sp),x
2378  043d 5f            	clrw	x
2379  043e 7b36          	ld	a,(OFST-103,sp)
2380  0440 97            	ld	xl,a
2381  0441 5a            	decw	x
2382  0442 72fb01        	addw	x,(OFST-156,sp)
2383  0445 f6            	ld	a,(x)
2384  0446 1134          	cp	a,(OFST-105,sp)
2385                     ; 511             indiceMaqEstados++;
2387  0448 2716          	jreq	LC014
2388                     ; 515             flagCOM_RX = 0x01;
2390  044a a601          	ld	a,#1
2391  044c 206e          	jp	L3711
2392  044e               L767:
2393                     ; 519         case 0x04: //VALIDA ENDERE�O DE DESTINO
2393                     ; 520           if (ENDERECO_DISP == Dado_RX_buffer[2])
2395  044e 7b3c          	ld	a,(OFST-97,sp)
2396  0450 a105          	cp	a,#5
2397  0452 2604          	jrne	L3611
2398                     ; 522             enderecoDestino_RX = Dado_RX_buffer[2];
2400  0454 6b1d          	ld	(OFST-128,sp),a
2402                     ; 523             indiceMaqEstados++;
2404  0456 2008          	jp	LC014
2405  0458               L3611:
2406                     ; 527             flagCOM_RX = 0x02;
2408  0458 a602          	ld	a,#2
2409  045a 2060          	jp	L3711
2410  045c               L177:
2411                     ; 531         case 0x05: //VERIFICA TAMANHO DO PACOTE
2411                     ; 532           tamanhoPacote_RX = Dado_RX_buffer[1];
2413  045c 7b3b          	ld	a,(OFST-98,sp)
2414  045e 6b35          	ld	(OFST-104,sp),a
2416                     ; 533           indiceMaqEstados++;
2418  0460               LC014:
2423  0460 0c37          	inc	(OFST-102,sp)
2425                     ; 534           break;
2427  0462 205a          	jra	L3411
2428  0464               L377:
2429                     ; 536         case 0x06: //ALOCA enderecoOrigem_RX / comando_RX / dadosPacote1_RX / dadosPacote2_RX
2429                     ; 537           enderecoOrigem_RX = Dado_RX_buffer[3];
2431  0464 7b3d          	ld	a,(OFST-96,sp)
2432  0466 6b1e          	ld	(OFST-127,sp),a
2434                     ; 538           comando_RX = Dado_RX_buffer[4];
2436  0468 7b3e          	ld	a,(OFST-95,sp)
2437  046a 6b1f          	ld	(OFST-126,sp),a
2439                     ; 539           if (tamanhoPacote_RX == 0x05)
2441  046c 7b35          	ld	a,(OFST-104,sp)
2442  046e a105          	cp	a,#5
2443                     ; 541             indiceMaqEstados++;
2444                     ; 542             flagCOM_RX = 0x00;
2446  0470 2744          	jreq	LC015
2447                     ; 544           else if (tamanhoPacote_RX > 0x05)
2449  0472 a106          	cp	a,#6
2450  0474 a605          	ld	a,#5
2451  0476 2544          	jrult	L3711
2452                     ; 546             char varreduraAux=0x00;
2454                     ; 547             for(varreduraAux=5;varreduraAux<=tamanhoMsg-2;varreduraAux++){
2456  0478 6b39          	ld	(OFST-100,sp),a
2459  047a 2020          	jra	L1021
2460  047c               L5711:
2461                     ; 548             Dados_comando_RX[varreduraAux-5]=Dado_RX_buffer[varreduraAux];
2463  047c 96            	ldw	x,sp
2464  047d 1c0020        	addw	x,#OFST-125
2465  0480 1f01          	ldw	(OFST-156,sp),x
2467  0482 5f            	clrw	x
2468  0483 97            	ld	xl,a
2469  0484 1d0005        	subw	x,#5
2470  0487 72fb01        	addw	x,(OFST-156,sp)
2471  048a 89            	pushw	x
2472  048b 96            	ldw	x,sp
2473  048c 1c003c        	addw	x,#OFST-97
2474  048f 9f            	ld	a,xl
2475  0490 5e            	swapw	x
2476  0491 1b3b          	add	a,(OFST-98,sp)
2477  0493 2401          	jrnc	L462
2478  0495 5c            	incw	x
2479  0496               L462:
2480  0496 02            	rlwa	x,a
2481  0497 f6            	ld	a,(x)
2482  0498 85            	popw	x
2483  0499 f7            	ld	(x),a
2484                     ; 547             for(varreduraAux=5;varreduraAux<=tamanhoMsg-2;varreduraAux++){
2486  049a 0c39          	inc	(OFST-100,sp)
2488  049c               L1021:
2491  049c 7b36          	ld	a,(OFST-103,sp)
2492  049e 5f            	clrw	x
2493  049f 97            	ld	xl,a
2494  04a0 1d0002        	subw	x,#2
2495  04a3 7b39          	ld	a,(OFST-100,sp)
2496  04a5 905f          	clrw	y
2497  04a7 9097          	ld	yl,a
2498  04a9 90bf00        	ldw	c_y,y
2499  04ac b300          	cpw	x,c_y
2500  04ae 2ecc          	jrsge	L5711
2501                     ; 550 						qtdeDadosRX=tamanhoMsg-6;
2503  04b0 7b36          	ld	a,(OFST-103,sp)
2504  04b2 a006          	sub	a,#6
2505  04b4 6b1b          	ld	(OFST-130,sp),a
2507                     ; 552             indiceMaqEstados++;
2509                     ; 553             flagCOM_RX = 0x00;
2511  04b6               LC015:
2513  04b6 0c37          	inc	(OFST-102,sp)
2516  04b8 0f38          	clr	(OFST-101,sp)
2519  04ba 2002          	jra	L3411
2520  04bc               L3711:
2521                     ; 564             flagCOM_RX = 0x05;
2523  04bc 6b38          	ld	(OFST-101,sp),a
2525  04be               L3411:
2526                     ; 482       while (flagCOM_RX == 0x04)
2528  04be 7b38          	ld	a,(OFST-101,sp)
2529  04c0 a104          	cp	a,#4
2530  04c2 2603cc03c9    	jreq	L1411
2531                     ; 573       processaPacoteRX(Dados_comando_RX, STX_RX, tamanhoPacote_RX, enderecoDestino_RX, enderecoOrigem_RX, comando_RX, dadosPacote1_RX, dadosPacote2_RX, BCC_RX, flagCOM_RX,qtdeDadosRX);
2533  04c7 7b1b          	ld	a,(OFST-130,sp)
2534  04c9 88            	push	a
2535  04ca 7b39          	ld	a,(OFST-100,sp)
2536  04cc 88            	push	a
2537  04cd 7b36          	ld	a,(OFST-103,sp)
2538  04cf 88            	push	a
2539  04d0 7b1d          	ld	a,(OFST-128,sp)
2540  04d2 88            	push	a
2541  04d3 7b1d          	ld	a,(OFST-128,sp)
2542  04d5 88            	push	a
2543  04d6 7b24          	ld	a,(OFST-121,sp)
2544  04d8 88            	push	a
2545  04d9 7b24          	ld	a,(OFST-121,sp)
2546  04db 88            	push	a
2547  04dc 7b24          	ld	a,(OFST-121,sp)
2548  04de 88            	push	a
2549  04df 7b3d          	ld	a,(OFST-96,sp)
2550  04e1 88            	push	a
2551  04e2 7b25          	ld	a,(OFST-120,sp)
2552  04e4 88            	push	a
2553  04e5 96            	ldw	x,sp
2554  04e6 1c002a        	addw	x,#OFST-115
2555  04e9 cd0275        	call	_processaPacoteRX
2557  04ec 5b0a          	addw	sp,#10
2558  04ee cc03ab        	jra	L3311
2594                     ; 622 void ExtraCode_Init(void)
2594                     ; 623 {
2595                     	switch	.text
2596  04f1               _ExtraCode_Init:
2598  04f1 88            	push	a
2599       00000001      OFST:	set	1
2602                     ; 629   for (i = 0; i < NUMBER_OF_SINGLE_CHANNEL_KEYS; i++)
2604  04f2 0f01          	clr	(OFST+0,sp)
2606  04f4               L5221:
2607                     ; 631     sSCKeyInfo[i].Setting.b.IMPLEMENTED = 1;
2609  04f4 7b01          	ld	a,(OFST+0,sp)
2610  04f6 97            	ld	xl,a
2611  04f7 a60f          	ld	a,#15
2612  04f9 42            	mul	x,a
2613  04fa e602          	ld	a,(_sSCKeyInfo+2,x)
2614                     ; 632     sSCKeyInfo[i].Setting.b.ENABLED = 1;
2616  04fc aa03          	or	a,#3
2617  04fe e702          	ld	(_sSCKeyInfo+2,x),a
2618                     ; 633     sSCKeyInfo[i].DxSGroup = 0x01; /* Put 0x00 to disable the DES on these pins */
2620  0500 a601          	ld	a,#1
2621  0502 e704          	ld	(_sSCKeyInfo+4,x),a
2622                     ; 629   for (i = 0; i < NUMBER_OF_SINGLE_CHANNEL_KEYS; i++)
2624  0504 0c01          	inc	(OFST+0,sp)
2628  0506 27ec          	jreq	L5221
2629                     ; 645   enableInterrupts();
2632  0508 9a            	rim	
2634                     ; 646 }
2638  0509 84            	pop	a
2639  050a 81            	ret	
2674                     ; 661 void ExtraCode_StateMachine(void)
2674                     ; 662 {
2675                     	switch	.text
2676  050b               _ExtraCode_StateMachine:
2680                     ; 663   if ((TSL_GlobalSetting.b.CHANGED) && (TSLState == TSL_IDLE_STATE))
2682  050b 720700011c    	btjf	_TSL_GlobalSetting+1,#3,L3521
2684  0510 b600          	ld	a,_TSLState
2685  0512 4a            	dec	a
2686  0513 2617          	jrne	L3521
2687                     ; 665     TSL_GlobalSetting.b.CHANGED = 0;
2689  0515 72170001      	bres	_TSL_GlobalSetting+1,#3
2690                     ; 667     if (sSCKeyInfo[0].Setting.b.DETECTED) /* KEY 1 touched */
2692  0519 720500020e    	btjf	_sSCKeyInfo+2,#2,L3521
2693                     ; 669       BlinkSpeed++;
2695  051e 3c00          	inc	_BlinkSpeed
2696                     ; 670       BlinkSpeed = BlinkSpeed % 3;
2698  0520 5f            	clrw	x
2699  0521 b600          	ld	a,_BlinkSpeed
2700  0523 97            	ld	xl,a
2701  0524 a603          	ld	a,#3
2702  0526 62            	div	x,a
2703  0527 5f            	clrw	x
2704  0528 97            	ld	xl,a
2705  0529 01            	rrwa	x,a
2706  052a b700          	ld	_BlinkSpeed,a
2707  052c               L3521:
2708                     ; 674   switch (BlinkSpeed)
2710  052c b600          	ld	a,_BlinkSpeed
2712                     ; 697       Delay(&Toggle, 1 * Sec);
2713  052e 2710          	jreq	L3321
2714  0530 4a            	dec	a
2715  0531 2717          	jreq	L5321
2716  0533 4a            	dec	a
2717  0534 271e          	jreq	L7321
2718                     ; 694   default:
2718                     ; 695     if (TSL_Tick_Flags.b.User1_Flag_100ms == 1)
2720  0536 7205000028    	btjf	_TSL_Tick_Flags,#2,L1621
2721                     ; 697       Delay(&Toggle, 1 * Sec);
2723  053b ae000a        	ldw	x,#10
2725  053e 201c          	jp	LC016
2726  0540               L3321:
2727                     ; 676   case 0:
2727                     ; 677     GPIO_WriteHigh(GPIOD, GPIO_PIN_0);
2729  0540 4b01          	push	#1
2730  0542 ae500f        	ldw	x,#20495
2731  0545 cd0000        	call	_GPIO_WriteHigh
2733  0548 84            	pop	a
2734                     ; 678     break;
2737  0549 81            	ret	
2738  054a               L5321:
2739                     ; 680   case 1:
2739                     ; 681     if (TSL_Tick_Flags.b.User1_Flag_100ms == 1)
2741  054a 7205000014    	btjf	_TSL_Tick_Flags,#2,L1621
2742                     ; 683       Delay(&Toggle, 2 * MilliSec);
2744  054f ae0002        	ldw	x,#2
2746  0552 2008          	jp	LC016
2747  0554               L7321:
2748                     ; 687   case 2:
2748                     ; 688     if (TSL_Tick_Flags.b.User1_Flag_100ms == 1)
2750  0554 720500000a    	btjf	_TSL_Tick_Flags,#2,L1621
2751                     ; 690       Delay(&Toggle, 1 * MilliSec);
2753  0559 ae0001        	ldw	x,#1
2755  055c               LC016:
2756  055c 89            	pushw	x
2757  055d ae05ec        	ldw	x,#_Toggle
2758  0560 ad5a          	call	_Delay
2759  0562 85            	popw	x
2760  0563               L1621:
2761                     ; 700 }
2764  0563 81            	ret	
2788                     ; 712 void CLK_Configuration(void)
2788                     ; 713 {
2789                     	switch	.text
2790  0564               _CLK_Configuration:
2794                     ; 716   CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
2796  0564 4f            	clr	a
2798                     ; 717 }
2801  0565 cc0000        	jp	_CLK_HSIPrescalerConfig
2826                     ; 729 void GPIO_Configuration(void)
2826                     ; 730 {
2827                     	switch	.text
2828  0568               _GPIO_Configuration:
2832                     ; 732   GPIO_DeInit(GPIOD);
2834  0568 ae500f        	ldw	x,#20495
2835  056b cd0000        	call	_GPIO_DeInit
2837                     ; 735   GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST);
2839  056e 4be0          	push	#224
2840  0570 4b01          	push	#1
2841  0572 ae500f        	ldw	x,#20495
2842  0575 cd0000        	call	_GPIO_Init
2844  0578 85            	popw	x
2845                     ; 737   GPIO_Init(GPIOD, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); //led1
2847  0579 4be0          	push	#224
2848  057b 4b04          	push	#4
2849  057d ae500f        	ldw	x,#20495
2850  0580 cd0000        	call	_GPIO_Init
2852  0583 85            	popw	x
2853                     ; 738   GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); //led2
2855  0584 4be0          	push	#224
2856  0586 4b08          	push	#8
2857  0588 ae500f        	ldw	x,#20495
2858  058b cd0000        	call	_GPIO_Init
2860  058e 85            	popw	x
2861                     ; 740   GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT); //BT1
2863  058f 4b00          	push	#0
2864  0591 4b10          	push	#16
2865  0593 ae500f        	ldw	x,#20495
2866  0596 cd0000        	call	_GPIO_Init
2868  0599 85            	popw	x
2869                     ; 741   GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_IN_FL_NO_IT); //BT2
2871  059a 4b00          	push	#0
2872  059c 4b80          	push	#128
2873  059e ae500f        	ldw	x,#20495
2874  05a1 cd0000        	call	_GPIO_Init
2876  05a4 85            	popw	x
2877                     ; 744   GPIO_Init(GPIOD, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); //TX
2879  05a5 4be0          	push	#224
2880  05a7 4b20          	push	#32
2881  05a9 ae500f        	ldw	x,#20495
2882  05ac cd0000        	call	_GPIO_Init
2884  05af 85            	popw	x
2885                     ; 745   GPIO_Init(GPIOD, GPIO_PIN_6, GPIO_MODE_IN_FL_NO_IT);     //rX
2887  05b0 4b00          	push	#0
2888  05b2 4b40          	push	#64
2889  05b4 ae500f        	ldw	x,#20495
2890  05b7 cd0000        	call	_GPIO_Init
2892  05ba 85            	popw	x
2893                     ; 746 }
2896  05bb 81            	ret	
2944                     ; 759 void Delay(void action(void), int NumberofTIMCycles)
2944                     ; 760 {
2945                     	switch	.text
2946  05bc               _Delay:
2948  05bc 89            	pushw	x
2949       00000000      OFST:	set	0
2952                     ; 761   if ((CheckFlag) != 0)
2954  05bd be01          	ldw	x,_CheckFlag
2955  05bf 2704          	jreq	L3331
2956                     ; 762     NumberOfStart = NumberofTIMCycles;
2958  05c1 1e05          	ldw	x,(OFST+5,sp)
2959  05c3 bf00          	ldw	_NumberOfStart,x
2960  05c5               L3331:
2961                     ; 763   if (NumberOfStart != 0)
2963  05c5 be00          	ldw	x,_NumberOfStart
2964  05c7 2707          	jreq	L5331
2965                     ; 765     TSL_Tick_Flags.b.User1_Start_100ms = 1;
2967  05c9 72120000      	bset	_TSL_Tick_Flags,#1
2968                     ; 766     CheckFlag = 0;
2970  05cd 5f            	clrw	x
2971  05ce bf01          	ldw	_CheckFlag,x
2972  05d0               L5331:
2973                     ; 768   if (TSL_Tick_Flags.b.User1_Flag_100ms)
2975  05d0 7205000009    	btjf	_TSL_Tick_Flags,#2,L7331
2976                     ; 770     TSL_Tick_Flags.b.User1_Flag_100ms = 0;
2978  05d5 72150000      	bres	_TSL_Tick_Flags,#2
2979                     ; 771     NumberOfStart--;
2981  05d9 be00          	ldw	x,_NumberOfStart
2982  05db 5a            	decw	x
2983  05dc bf00          	ldw	_NumberOfStart,x
2984  05de               L7331:
2985                     ; 773   if (NumberOfStart == 0)
2987  05de be00          	ldw	x,_NumberOfStart
2988  05e0 2608          	jrne	L1431
2989                     ; 775     action();
2991  05e2 1e01          	ldw	x,(OFST+1,sp)
2992  05e4 fd            	call	(x)
2994                     ; 776     CheckFlag = 1;
2996  05e5 ae0001        	ldw	x,#1
2997  05e8 bf01          	ldw	_CheckFlag,x
2998  05ea               L1431:
2999                     ; 778 }
3002  05ea 85            	popw	x
3003  05eb 81            	ret	
3027                     ; 790 void Toggle(void)
3027                     ; 791 {
3028                     	switch	.text
3029  05ec               _Toggle:
3033                     ; 792   GPIO_WriteReverse(GPIOD, GPIO_PIN_0);
3035  05ec 4b01          	push	#1
3036  05ee ae500f        	ldw	x,#20495
3037  05f1 cd0000        	call	_GPIO_WriteReverse
3039  05f4 84            	pop	a
3040                     ; 793 }
3043  05f5 81            	ret	
3078                     	switch	.const
3079  000f               L263:
3080  000f 0000ffff      	dc.l	65535
3081                     ; 808 void LCD_GPIO_init(void)
3081                     ; 809 {
3082                     	switch	.text
3083  05f6               _LCD_GPIO_init:
3085  05f6 5204          	subw	sp,#4
3086       00000004      OFST:	set	4
3089                     ; 811   GPIO_Init(LCD_PORT, LCD_RS, GPIO_MODE_OUT_PP_HIGH_FAST);
3091  05f8 4bf0          	push	#240
3092  05fa 4b01          	push	#1
3093  05fc ae5005        	ldw	x,#20485
3094  05ff cd0000        	call	_GPIO_Init
3096  0602 85            	popw	x
3097                     ; 812   GPIO_Init(LCD_PORT, LCD_EN, GPIO_MODE_OUT_PP_HIGH_FAST);
3099  0603 4bf0          	push	#240
3100  0605 4b02          	push	#2
3101  0607 ae5005        	ldw	x,#20485
3102  060a cd0000        	call	_GPIO_Init
3104  060d 85            	popw	x
3105                     ; 813   GPIO_Init(LCD_PORT, LCD_DB4, GPIO_MODE_OUT_PP_HIGH_FAST);
3107  060e 4bf0          	push	#240
3108  0610 4b04          	push	#4
3109  0612 ae5005        	ldw	x,#20485
3110  0615 cd0000        	call	_GPIO_Init
3112  0618 85            	popw	x
3113                     ; 814   GPIO_Init(LCD_PORT, LCD_DB5, GPIO_MODE_OUT_PP_HIGH_FAST);
3115  0619 4bf0          	push	#240
3116  061b 4b08          	push	#8
3117  061d ae5005        	ldw	x,#20485
3118  0620 cd0000        	call	_GPIO_Init
3120  0623 85            	popw	x
3121                     ; 815   GPIO_Init(LCD_PORT, LCD_DB6, GPIO_MODE_OUT_PP_HIGH_FAST);
3123  0624 4bf0          	push	#240
3124  0626 4b10          	push	#16
3125  0628 ae5005        	ldw	x,#20485
3126  062b cd0000        	call	_GPIO_Init
3128  062e 85            	popw	x
3129                     ; 816   GPIO_Init(LCD_PORT, LCD_DB7, GPIO_MODE_OUT_PP_HIGH_FAST);
3131  062f 4bf0          	push	#240
3132  0631 4b20          	push	#32
3133  0633 ae5005        	ldw	x,#20485
3134  0636 cd0000        	call	_GPIO_Init
3136  0639 85            	popw	x
3137                     ; 818   for (Tempo_Aux = 0; Tempo_Aux < 0xFFFF; Tempo_Aux++)
3139  063a 5f            	clrw	x
3140  063b 1f03          	ldw	(OFST-1,sp),x
3141  063d 1f01          	ldw	(OFST-3,sp),x
3143  063f               L3731:
3146  063f 96            	ldw	x,sp
3147  0640 5c            	incw	x
3148  0641 a601          	ld	a,#1
3149  0643 cd0000        	call	c_lgadc
3154  0646 96            	ldw	x,sp
3155  0647 5c            	incw	x
3156  0648 cd0000        	call	c_ltor
3158  064b ae000f        	ldw	x,#L263
3159  064e cd0000        	call	c_lcmp
3161  0651 25ec          	jrult	L3731
3162                     ; 820 }
3165  0653 5b04          	addw	sp,#4
3166  0655 81            	ret	
3194                     ; 822 void LCD_init(void)
3194                     ; 823 {
3195                     	switch	.text
3196  0656               _LCD_init:
3200                     ; 824   LCD_GPIO_init();
3202  0656 ad9e          	call	_LCD_GPIO_init
3204                     ; 825   toggle_EN_pin();
3206  0658 cd0777        	call	_toggle_EN_pin
3208                     ; 827   GPIO_WriteLow(LCD_PORT, LCD_RS);
3210  065b 4b01          	push	#1
3211  065d ae5005        	ldw	x,#20485
3212  0660 cd0000        	call	_GPIO_WriteLow
3214  0663 84            	pop	a
3215                     ; 828   GPIO_WriteLow(LCD_PORT, LCD_DB7);
3217  0664 ad2c          	call	LC017
3218                     ; 831   GPIO_WriteHigh(LCD_PORT, LCD_DB4);
3220  0666 ad46          	call	LC018
3222                     ; 834   GPIO_WriteLow(LCD_PORT, LCD_DB7);
3224  0668 ad28          	call	LC017
3225                     ; 837   GPIO_WriteHigh(LCD_PORT, LCD_DB4);
3227  066a ad42          	call	LC018
3229                     ; 840   GPIO_WriteLow(LCD_PORT, LCD_DB7);
3231  066c ad24          	call	LC017
3232                     ; 843   GPIO_WriteHigh(LCD_PORT, LCD_DB4);
3234  066e ad3e          	call	LC018
3236                     ; 846   GPIO_WriteLow(LCD_PORT, LCD_DB7);
3238  0670 ad20          	call	LC017
3239                     ; 849   GPIO_WriteLow(LCD_PORT, LCD_DB4);
3241  0672 4b04          	push	#4
3242  0674 ae5005        	ldw	x,#20485
3243  0677 cd0000        	call	_GPIO_WriteLow
3245  067a 84            	pop	a
3246                     ; 850   toggle_EN_pin();
3248  067b cd0777        	call	_toggle_EN_pin
3250                     ; 852   LCD_send((_4_pin_interface | _2_row_display | _5x7_dots), CMD);
3252  067e ae2800        	ldw	x,#10240
3253  0681 ad37          	call	_LCD_send
3255                     ; 853   LCD_send((display_on | cursor_off | blink_off), CMD);
3257  0683 ae0c00        	ldw	x,#3072
3258  0686 ad32          	call	_LCD_send
3260                     ; 854   LCD_send(clear_display, CMD);
3262  0688 ae0100        	ldw	x,#256
3263  068b ad2d          	call	_LCD_send
3265                     ; 855   LCD_send((cursor_direction_inc | display_no_shift), CMD);
3267  068d ae0600        	ldw	x,#1536
3269                     ; 856 }
3272  0690 2028          	jp	_LCD_send
3273  0692               LC017:
3274  0692 4b20          	push	#32
3275  0694 ae5005        	ldw	x,#20485
3276  0697 cd0000        	call	_GPIO_WriteLow
3278  069a 84            	pop	a
3279                     ; 829   GPIO_WriteLow(LCD_PORT, LCD_DB6);
3281  069b 4b10          	push	#16
3282  069d ae5005        	ldw	x,#20485
3283  06a0 cd0000        	call	_GPIO_WriteLow
3285  06a3 84            	pop	a
3286                     ; 830   GPIO_WriteHigh(LCD_PORT, LCD_DB5);
3288  06a4 4b08          	push	#8
3289  06a6 ae5005        	ldw	x,#20485
3290  06a9 cd0000        	call	_GPIO_WriteHigh
3292  06ac 84            	pop	a
3293  06ad 81            	ret	
3294  06ae               LC018:
3295  06ae 4b04          	push	#4
3296  06b0 ae5005        	ldw	x,#20485
3297  06b3 cd0000        	call	_GPIO_WriteHigh
3299  06b6 84            	pop	a
3300                     ; 844   toggle_EN_pin();
3302  06b7 cc0777        	jp	_toggle_EN_pin
3348                     ; 858 void LCD_send(unsigned char value, unsigned char mode)
3348                     ; 859 {
3349                     	switch	.text
3350  06ba               _LCD_send:
3352  06ba 89            	pushw	x
3353       00000000      OFST:	set	0
3356                     ; 860   switch (mode)
3358  06bb 9f            	ld	a,xl
3360                     ; 870     break;
3361  06bc 4d            	tnz	a
3362  06bd 270d          	jreq	L1141
3363  06bf 4a            	dec	a
3364  06c0 2613          	jrne	L7341
3365                     ; 864     GPIO_WriteHigh(LCD_PORT, LCD_RS);
3367  06c2 4b01          	push	#1
3368  06c4 ae5005        	ldw	x,#20485
3369  06c7 cd0000        	call	_GPIO_WriteHigh
3371                     ; 865     break;
3373  06ca 2008          	jp	LC019
3374  06cc               L1141:
3375                     ; 869     GPIO_WriteLow(LCD_PORT, LCD_RS);
3377  06cc 4b01          	push	#1
3378  06ce ae5005        	ldw	x,#20485
3379  06d1 cd0000        	call	_GPIO_WriteLow
3381  06d4               LC019:
3382  06d4 84            	pop	a
3383                     ; 870     break;
3385  06d5               L7341:
3386                     ; 874   LCD_4bit_send(value);
3388  06d5 7b01          	ld	a,(OFST+1,sp)
3389  06d7 ad02          	call	_LCD_4bit_send
3391                     ; 875 }
3394  06d9 85            	popw	x
3395  06da 81            	ret	
3431                     ; 877 void LCD_4bit_send(unsigned char lcd_data)
3431                     ; 878 {
3432                     	switch	.text
3433  06db               _LCD_4bit_send:
3435  06db 88            	push	a
3436       00000000      OFST:	set	0
3439                     ; 879   toggle_io(lcd_data, 7, LCD_DB7);
3441  06dc 4b20          	push	#32
3442  06de ae0007        	ldw	x,#7
3443  06e1 95            	ld	xh,a
3444  06e2 cd07a7        	call	_toggle_io
3446  06e5 84            	pop	a
3447                     ; 880   toggle_io(lcd_data, 6, LCD_DB6);
3449  06e6 4b10          	push	#16
3450  06e8 7b02          	ld	a,(OFST+2,sp)
3451  06ea ae0006        	ldw	x,#6
3452  06ed 95            	ld	xh,a
3453  06ee cd07a7        	call	_toggle_io
3455  06f1 84            	pop	a
3456                     ; 881   toggle_io(lcd_data, 5, LCD_DB5);
3458  06f2 4b08          	push	#8
3459  06f4 7b02          	ld	a,(OFST+2,sp)
3460  06f6 ae0005        	ldw	x,#5
3461  06f9 95            	ld	xh,a
3462  06fa cd07a7        	call	_toggle_io
3464  06fd 84            	pop	a
3465                     ; 882   toggle_io(lcd_data, 4, LCD_DB4);
3467  06fe 4b04          	push	#4
3468  0700 7b02          	ld	a,(OFST+2,sp)
3469  0702 ae0004        	ldw	x,#4
3470  0705 95            	ld	xh,a
3471  0706 cd07a7        	call	_toggle_io
3473  0709 84            	pop	a
3474                     ; 883   toggle_EN_pin();
3476  070a ad6b          	call	_toggle_EN_pin
3478                     ; 884   toggle_io(lcd_data, 3, LCD_DB7);
3480  070c 4b20          	push	#32
3481  070e 7b02          	ld	a,(OFST+2,sp)
3482  0710 ae0003        	ldw	x,#3
3483  0713 95            	ld	xh,a
3484  0714 cd07a7        	call	_toggle_io
3486  0717 84            	pop	a
3487                     ; 885   toggle_io(lcd_data, 2, LCD_DB6);
3489  0718 4b10          	push	#16
3490  071a 7b02          	ld	a,(OFST+2,sp)
3491  071c ae0002        	ldw	x,#2
3492  071f 95            	ld	xh,a
3493  0720 cd07a7        	call	_toggle_io
3495  0723 84            	pop	a
3496                     ; 886   toggle_io(lcd_data, 1, LCD_DB5);
3498  0724 4b08          	push	#8
3499  0726 7b02          	ld	a,(OFST+2,sp)
3500  0728 ae0001        	ldw	x,#1
3501  072b 95            	ld	xh,a
3502  072c ad79          	call	_toggle_io
3504  072e 84            	pop	a
3505                     ; 887   toggle_io(lcd_data, 0, LCD_DB4);
3507  072f 4b04          	push	#4
3508  0731 7b02          	ld	a,(OFST+2,sp)
3509  0733 5f            	clrw	x
3510  0734 95            	ld	xh,a
3511  0735 ad70          	call	_toggle_io
3513  0737 84            	pop	a
3514                     ; 888   toggle_EN_pin();
3516  0738 ad3d          	call	_toggle_EN_pin
3518                     ; 889 }
3521  073a 84            	pop	a
3522  073b 81            	ret	
3558                     ; 891 void LCD_putstr(char *lcd_string)
3558                     ; 892 {
3559                     	switch	.text
3560  073c               _LCD_putstr:
3562  073c 89            	pushw	x
3563       00000000      OFST:	set	0
3566  073d f6            	ld	a,(x)
3567  073e               L5741:
3568                     ; 895     LCD_send(*lcd_string++, DAT);
3570  073e 5c            	incw	x
3571  073f 1f01          	ldw	(OFST+1,sp),x
3572  0741 ae0001        	ldw	x,#1
3573  0744 95            	ld	xh,a
3574  0745 cd06ba        	call	_LCD_send
3576                     ; 896   } while (*lcd_string != '\0');
3578  0748 1e01          	ldw	x,(OFST+1,sp)
3579  074a f6            	ld	a,(x)
3580  074b 26f1          	jrne	L5741
3581                     ; 897 }
3584  074d 85            	popw	x
3585  074e 81            	ret	
3620                     ; 899 void LCD_putchar(char char_data)
3620                     ; 900 {
3621                     	switch	.text
3622  074f               _LCD_putchar:
3626                     ; 901   LCD_send(char_data, DAT);
3628  074f ae0001        	ldw	x,#1
3629  0752 95            	ld	xh,a
3631                     ; 902 }
3634  0753 cc06ba        	jp	_LCD_send
3658                     ; 904 void LCD_clear_home(void)
3658                     ; 905 {
3659                     	switch	.text
3660  0756               _LCD_clear_home:
3664                     ; 906   LCD_send(clear_display, CMD);
3666  0756 ae0100        	ldw	x,#256
3667  0759 cd06ba        	call	_LCD_send
3669                     ; 907   LCD_send(goto_home, CMD);
3671  075c ae0200        	ldw	x,#512
3673                     ; 908 }
3676  075f cc06ba        	jp	_LCD_send
3720                     ; 910 void LCD_goto(unsigned char x_pos, unsigned char y_pos)
3720                     ; 911 {
3721                     	switch	.text
3722  0762               _LCD_goto:
3724  0762 89            	pushw	x
3725       00000000      OFST:	set	0
3728                     ; 912   if (y_pos == 0)
3730  0763 9f            	ld	a,xl
3731  0764 4d            	tnz	a
3732  0765 2605          	jrne	L3551
3733                     ; 914     LCD_send((0x80 | x_pos), CMD);
3735  0767 9e            	ld	a,xh
3736  0768 aa80          	or	a,#128
3739  076a 2004          	jra	L5551
3740  076c               L3551:
3741                     ; 918     LCD_send((0x80 | 0x40 | x_pos), CMD);
3743  076c 7b01          	ld	a,(OFST+1,sp)
3744  076e aac0          	or	a,#192
3746  0770               L5551:
3747  0770 5f            	clrw	x
3748  0771 95            	ld	xh,a
3749  0772 cd06ba        	call	_LCD_send
3750                     ; 920 }
3753  0775 85            	popw	x
3754  0776 81            	ret	
3790                     ; 922 void toggle_EN_pin(void)
3790                     ; 923 {
3791                     	switch	.text
3792  0777               _toggle_EN_pin:
3794  0777 5204          	subw	sp,#4
3795       00000004      OFST:	set	4
3798                     ; 925   GPIO_WriteHigh(LCD_PORT, LCD_EN);
3800  0779 4b02          	push	#2
3801  077b ae5005        	ldw	x,#20485
3802  077e cd0000        	call	_GPIO_WriteHigh
3804  0781 5f            	clrw	x
3805  0782 84            	pop	a
3806                     ; 927   for (Tempo_Aux = 0; Tempo_Aux < 0xFFFF; Tempo_Aux++)
3808  0783 1f03          	ldw	(OFST-1,sp),x
3809  0785 1f01          	ldw	(OFST-3,sp),x
3811  0787               L7751:
3814  0787 96            	ldw	x,sp
3815  0788 5c            	incw	x
3816  0789 a601          	ld	a,#1
3817  078b cd0000        	call	c_lgadc
3822  078e 96            	ldw	x,sp
3823  078f 5c            	incw	x
3824  0790 cd0000        	call	c_ltor
3826  0793 ae000f        	ldw	x,#L263
3827  0796 cd0000        	call	c_lcmp
3829  0799 25ec          	jrult	L7751
3830                     ; 929   GPIO_WriteLow(LCD_PORT, LCD_EN);
3832  079b 4b02          	push	#2
3833  079d ae5005        	ldw	x,#20485
3834  07a0 cd0000        	call	_GPIO_WriteLow
3836  07a3 84            	pop	a
3837                     ; 930 }
3840  07a4 5b04          	addw	sp,#4
3841  07a6 81            	ret	
3925                     ; 932 void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num)
3925                     ; 933 {
3926                     	switch	.text
3927  07a7               _toggle_io:
3929  07a7 89            	pushw	x
3930  07a8 88            	push	a
3931       00000001      OFST:	set	1
3934                     ; 934   bool temp = FALSE;
3936                     ; 936   temp = (0x01 & (lcd_data >> bit_pos));
3938  07a9 9f            	ld	a,xl
3939  07aa 5f            	clrw	x
3940  07ab 97            	ld	xl,a
3941  07ac 7b02          	ld	a,(OFST+1,sp)
3942  07ae 5d            	tnzw	x
3943  07af 2704          	jreq	L645
3944  07b1               L055:
3945  07b1 44            	srl	a
3946  07b2 5a            	decw	x
3947  07b3 26fc          	jrne	L055
3948  07b5               L645:
3949  07b5 a401          	and	a,#1
3950  07b7 6b01          	ld	(OFST+0,sp),a
3952                     ; 938   switch (temp)
3954  07b9 4a            	dec	a
3955  07ba 260b          	jrne	L5061
3958                     ; 942     GPIO_WriteHigh(LCD_PORT, pin_num);
3960  07bc 7b06          	ld	a,(OFST+5,sp)
3961  07be 88            	push	a
3962  07bf ae5005        	ldw	x,#20485
3963  07c2 cd0000        	call	_GPIO_WriteHigh
3965                     ; 943     break;
3967  07c5 2009          	jra	L3561
3968  07c7               L5061:
3969                     ; 948     GPIO_WriteLow(LCD_PORT, pin_num);
3971  07c7 7b06          	ld	a,(OFST+5,sp)
3972  07c9 88            	push	a
3973  07ca ae5005        	ldw	x,#20485
3974  07cd cd0000        	call	_GPIO_WriteLow
3976                     ; 949     break;
3977  07d0               L3561:
3978  07d0 84            	pop	a
3979                     ; 952 }
3982  07d1 5b03          	addw	sp,#3
3983  07d3 81            	ret	
4025                     	xdef	_main
4026                     	xdef	_processaPacoteRX
4027                     	xdef	_enviaPacote
4028                     	xdef	_zeraRegistradoresRX
4029                     	xdef	_coletaBuffer
4030                     	xdef	_debugCOM
4031                     	xdef	_piscaLED
4032                     	xdef	_calculateBCC_Param
4033                     	xdef	_calculateBCC_RX
4034                     	xdef	_enviaTodoBuffer
4035                     	xdef	_limpaVetor
4036                     	xdef	_enviaSerial
4037                     	xdef	_CheckFlag
4038                     	switch	.ubsct
4039  0000               _NumberOfStart:
4040  0000 0000          	ds.b	2
4041                     	xdef	_NumberOfStart
4042                     	xdef	_BlinkSpeed
4043                     	xdef	_Toggle
4044                     	xdef	_Delay
4045                     	xdef	_ExtraCode_StateMachine
4046                     	xdef	_ExtraCode_Init
4047                     	xdef	_GPIO_Configuration
4048                     	xdef	_CLK_Configuration
4049                     	xref.b	_sSCKeyInfo
4050                     	xref.b	_TSL_GlobalSetting
4051                     	xref.b	_TSLState
4052                     	xref.b	_TSL_Tick_Flags
4053                     	xref	_UART2_GetFlagStatus
4054                     	xref	_UART2_SendData8
4055                     	xref	_UART2_ReceiveData8
4056                     	xref	_UART2_Init
4057                     	xref	_GPIO_ReadInputPin
4058                     	xref	_GPIO_WriteReverse
4059                     	xref	_GPIO_WriteLow
4060                     	xref	_GPIO_WriteHigh
4061                     	xref	_GPIO_Init
4062                     	xref	_GPIO_DeInit
4063                     	xref	_CLK_HSIPrescalerConfig
4064                     	xdef	_toggle_io
4065                     	xdef	_toggle_EN_pin
4066                     	xdef	_LCD_goto
4067                     	xdef	_LCD_clear_home
4068                     	xdef	_LCD_putchar
4069                     	xdef	_LCD_putstr
4070                     	xdef	_LCD_4bit_send
4071                     	xdef	_LCD_send
4072                     	xdef	_LCD_init
4073                     	xdef	_LCD_GPIO_init
4074                     	xref.b	c_x
4075                     	xref.b	c_y
4095                     	xref	c_lcmp
4096                     	xref	c_ltor
4097                     	xref	c_lgadc
4098                     	xref	c_xymov
4099                     	xref	c_lzmp
4100                     	xref	c_lgsbc
4101                     	end
