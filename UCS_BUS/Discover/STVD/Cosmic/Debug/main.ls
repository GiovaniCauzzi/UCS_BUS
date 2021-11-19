   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
   4                     ; Optimizer V4.5.3 - 16 Jun 2021
  19                     	bsct
  20  0000               _BlinkSpeed:
  21  0000 06            	dc.b	6
  22  0001               _CheckFlag:
  23  0001 0001          	dc.w	1
  65                     ; 111 void enviaSerial(char dado)
  65                     ; 112 {
  67                     	switch	.text
  68  0000               _enviaSerial:
  72                     ; 113   UART2_SendData8(dado);
  74  0000 cd0000        	call	_UART2_SendData8
  77  0003               L13:
  78                     ; 114   while (UART2_GetFlagStatus(UART2_FLAG_TC) == FALSE)
  80  0003 ae0040        	ldw	x,#64
  81  0006 cd0000        	call	_UART2_GetFlagStatus
  83  0009 4d            	tnz	a
  84  000a 27f7          	jreq	L13
  85                     ; 116 }
  88  000c 81            	ret	
 141                     ; 118 void limpaVetor(char vetor[], char tamanho)
 141                     ; 119 {
 142                     	switch	.text
 143  000d               _limpaVetor:
 145  000d 89            	pushw	x
 146  000e 88            	push	a
 147       00000001      OFST:	set	1
 150                     ; 120   char varre = 0;
 152                     ; 121   for (varre = 0; varre < tamanho; varre++)
 154  000f 0f01          	clr	(OFST+0,sp)
 157  0011 2008          	jra	L76
 158  0013               L36:
 159                     ; 123     vetor[varre] = '\0';
 161  0013 5f            	clrw	x
 162  0014 97            	ld	xl,a
 163  0015 72fb02        	addw	x,(OFST+1,sp)
 164  0018 7f            	clr	(x)
 165                     ; 121   for (varre = 0; varre < tamanho; varre++)
 167  0019 0c01          	inc	(OFST+0,sp)
 169  001b               L76:
 172  001b 7b01          	ld	a,(OFST+0,sp)
 173  001d 1106          	cp	a,(OFST+5,sp)
 174  001f 25f2          	jrult	L36
 175                     ; 125 }
 178  0021 5b03          	addw	sp,#3
 179  0023 81            	ret	
 233                     ; 127 void enviaTodoBuffer(char msg[], char tamanhoMsg)
 233                     ; 128 {
 234                     	switch	.text
 235  0024               _enviaTodoBuffer:
 237  0024 89            	pushw	x
 238  0025 88            	push	a
 239       00000001      OFST:	set	1
 242                     ; 129   char varre = 0;
 244                     ; 130   for (varre = 0; varre < tamanhoMsg; varre++)
 246  0026 0f01          	clr	(OFST+0,sp)
 249  0028 200a          	jra	L521
 250  002a               L121:
 251                     ; 132     enviaSerial(msg[varre]);
 253  002a 5f            	clrw	x
 254  002b 97            	ld	xl,a
 255  002c 72fb02        	addw	x,(OFST+1,sp)
 256  002f f6            	ld	a,(x)
 257  0030 adce          	call	_enviaSerial
 259                     ; 130   for (varre = 0; varre < tamanhoMsg; varre++)
 261  0032 0c01          	inc	(OFST+0,sp)
 263  0034               L521:
 266  0034 7b01          	ld	a,(OFST+0,sp)
 267  0036 1106          	cp	a,(OFST+5,sp)
 268  0038 25f0          	jrult	L121
 269                     ; 136 }
 272  003a 5b03          	addw	sp,#3
 273  003c 81            	ret	
 335                     ; 138 char calculateBCC_RX(char msg[], char tamanhoMsg)
 335                     ; 139 {
 336                     	switch	.text
 337  003d               _calculateBCC_RX:
 339  003d 89            	pushw	x
 340  003e 89            	pushw	x
 341       00000002      OFST:	set	2
 344                     ; 140   char varre = 0, BCC_RX = 0x00;
 348  003f 0f01          	clr	(OFST-1,sp)
 350                     ; 142   for (varre = 0; varre <= tamanhoMsg - 2; varre++)
 352  0041 0f02          	clr	(OFST+0,sp)
 355  0043 200c          	jra	L761
 356  0045               L361:
 357                     ; 144     BCC_RX = msg[varre] ^ BCC_RX;
 359  0045 5f            	clrw	x
 360  0046 97            	ld	xl,a
 361  0047 72fb03        	addw	x,(OFST+1,sp)
 362  004a 7b01          	ld	a,(OFST-1,sp)
 363  004c f8            	xor	a,(x)
 364  004d 6b01          	ld	(OFST-1,sp),a
 366                     ; 142   for (varre = 0; varre <= tamanhoMsg - 2; varre++)
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
 383                     ; 146   return BCC_RX;
 385  0065 7b01          	ld	a,(OFST-1,sp)
 388  0067 5b04          	addw	sp,#4
 389  0069 81            	ret	
 459                     ; 149 char calculateBCC_Param(char enderecoDestino, char comando, char dados1, char dados2)
 459                     ; 150 {
 460                     	switch	.text
 461  006a               _calculateBCC_Param:
 463  006a 89            	pushw	x
 464  006b 88            	push	a
 465       00000001      OFST:	set	1
 468                     ; 151   char BCC = 0x00;
 470  006c 0f01          	clr	(OFST+0,sp)
 472                     ; 153   if (dados1 == '\0' && dados2 == '\0') //Tamanho = 0x05
 474  006e 7b06          	ld	a,(OFST+5,sp)
 475  0070 260d          	jrne	L132
 477  0072 7b07          	ld	a,(OFST+6,sp)
 478  0074 2609          	jrne	L132
 479                     ; 155     BCC = STX ^ BCC;
 481                     ; 156     BCC = 0x05 ^ BCC;
 483                     ; 157     BCC = enderecoDestino ^ BCC;
 485  0076 9e            	ld	a,xh
 486  0077 a807          	xor	a,#7
 488                     ; 158     BCC = ENDERECO_DISP ^ BCC;
 490  0079 a805          	xor	a,#5
 492                     ; 159     BCC = comando ^ BCC;
 494  007b 1803          	xor	a,(OFST+2,sp)
 496  007d 2028          	jp	LC001
 497  007f               L132:
 498                     ; 161   else if (!dados1 == '\0' && dados2 == '\0') //Tamanho = 0x06
 500  007f 7b06          	ld	a,(OFST+5,sp)
 501  0081 2710          	jreq	L532
 503  0083 7b07          	ld	a,(OFST+6,sp)
 504  0085 260c          	jrne	L532
 505                     ; 163     BCC = STX ^ BCC;
 507                     ; 164     BCC = 0x06 ^ BCC;
 509                     ; 165     BCC = enderecoDestino ^ BCC;
 511  0087 7b02          	ld	a,(OFST+1,sp)
 512  0089 a804          	xor	a,#4
 514                     ; 166     BCC = ENDERECO_DISP ^ BCC;
 516  008b a805          	xor	a,#5
 518                     ; 167     BCC = comando ^ BCC;
 520  008d 1803          	xor	a,(OFST+2,sp)
 522                     ; 168     BCC = dados1 ^ BCC;
 524  008f 1806          	xor	a,(OFST+5,sp)
 526  0091 2014          	jp	LC001
 527  0093               L532:
 528                     ; 170   else if (!dados1 == '\0' && !dados2 == '\0') //Tamanho = 0x07
 530  0093 7b06          	ld	a,(OFST+5,sp)
 531  0095 2712          	jreq	L332
 533  0097 7b07          	ld	a,(OFST+6,sp)
 534  0099 270e          	jreq	L332
 535                     ; 172     BCC = STX ^ BCC;
 537                     ; 173     BCC = 0x07 ^ BCC;
 539                     ; 174     BCC = enderecoDestino ^ BCC;
 541  009b 7b02          	ld	a,(OFST+1,sp)
 542  009d a805          	xor	a,#5
 544                     ; 175     BCC = ENDERECO_DISP ^ BCC;
 546  009f a805          	xor	a,#5
 548                     ; 176     BCC = comando ^ BCC;
 550  00a1 1803          	xor	a,(OFST+2,sp)
 552                     ; 177     BCC = dados1 ^ BCC;
 554  00a3 1806          	xor	a,(OFST+5,sp)
 556                     ; 178     BCC = dados2 ^ BCC;
 558  00a5 1807          	xor	a,(OFST+6,sp)
 559  00a7               LC001:
 560  00a7 6b01          	ld	(OFST+0,sp),a
 562  00a9               L332:
 563                     ; 180   return BCC;
 565  00a9 7b01          	ld	a,(OFST+0,sp)
 568  00ab 5b03          	addw	sp,#3
 569  00ad 81            	ret	
 640                     ; 183 void piscaLED(char LED, char qtdePiscadas, char intervalo)
 640                     ; 184 {
 641                     	switch	.text
 642  00ae               _piscaLED:
 644  00ae 89            	pushw	x
 645  00af 5203          	subw	sp,#3
 646       00000003      OFST:	set	3
 649                     ; 185   char varre = 0x00, flagAUX = 0x00, varre2;
 653  00b1 0f02          	clr	(OFST-1,sp)
 655                     ; 187   for (varre = 0; varre <= qtdePiscadas; varre++)
 657  00b3 0f01          	clr	(OFST-2,sp)
 660  00b5 2025          	jra	L503
 661  00b7               L103:
 662                     ; 190     if (flagAUX == 0x00)
 664  00b7 7b02          	ld	a,(OFST-1,sp)
 665  00b9 261b          	jrne	L113
 666                     ; 192       if (LED == 0x01)
 668  00bb 7b04          	ld	a,(OFST+1,sp)
 669  00bd a101          	cp	a,#1
 670  00bf 2604          	jrne	L313
 671                     ; 194         GPIO_WriteHigh(GPIOD, GPIO_PIN_2);
 673  00c1 4b04          	push	#4
 676  00c3 2006          	jp	LC002
 677  00c5               L313:
 678                     ; 196       else if (LED == 0x02)
 680  00c5 a102          	cp	a,#2
 681  00c7 2609          	jrne	L513
 682                     ; 198         GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
 684  00c9 4b08          	push	#8
 686  00cb               LC002:
 687  00cb ae500f        	ldw	x,#20495
 688  00ce cd0000        	call	_GPIO_WriteHigh
 689  00d1 84            	pop	a
 690  00d2               L513:
 691                     ; 200       flagAUX = 0x01;
 693  00d2 a601          	ld	a,#1
 694  00d4 6b02          	ld	(OFST-1,sp),a
 696  00d6               L113:
 697                     ; 203     for (varre2 = 0; varre2 < 0xffff; varre2++)
 699  00d6 0f03          	clr	(OFST+0,sp)
 701  00d8               L523:
 704  00d8 0c03          	inc	(OFST+0,sp)
 707  00da 20fc          	jra	L523
 708  00dc               L503:
 709                     ; 187   for (varre = 0; varre <= qtdePiscadas; varre++)
 712  00dc 7b01          	ld	a,(OFST-2,sp)
 713  00de 1105          	cp	a,(OFST+2,sp)
 714  00e0 23d5          	jrule	L103
 715                     ; 223 }
 718  00e2 5b05          	addw	sp,#5
 719  00e4 81            	ret	
 835                     ; 225 void debugCOM(char STX_RX, char tamanhoPacote_RX, char enderecoDestino_RX, char enderecoOrigem_RX, char comando_RX, char dadosPacote1_RX, char dadosPacote2_RX, char BCC_RX, char tamanhoMsg, char flagCOM_RX)
 835                     ; 226 {
 836                     	switch	.text
 837  00e5               _debugCOM:
 839  00e5 89            	pushw	x
 840       00000000      OFST:	set	0
 843                     ; 228   enviaSerial(0x00);
 845  00e6 4f            	clr	a
 846  00e7 cd0000        	call	_enviaSerial
 848                     ; 229   enviaSerial(STX_RX);
 850  00ea 7b01          	ld	a,(OFST+1,sp)
 851  00ec cd0000        	call	_enviaSerial
 853                     ; 230   enviaSerial(0x01);
 855  00ef a601          	ld	a,#1
 856  00f1 cd0000        	call	_enviaSerial
 858                     ; 231   enviaSerial(tamanhoPacote_RX);
 860  00f4 7b02          	ld	a,(OFST+2,sp)
 861  00f6 cd0000        	call	_enviaSerial
 863                     ; 232   enviaSerial(0x02);
 865  00f9 a602          	ld	a,#2
 866  00fb cd0000        	call	_enviaSerial
 868                     ; 233   enviaSerial(enderecoDestino_RX);
 870  00fe 7b05          	ld	a,(OFST+5,sp)
 871  0100 cd0000        	call	_enviaSerial
 873                     ; 234   enviaSerial(0x03);
 875  0103 a603          	ld	a,#3
 876  0105 cd0000        	call	_enviaSerial
 878                     ; 235   enviaSerial(enderecoOrigem_RX);
 880  0108 7b06          	ld	a,(OFST+6,sp)
 881  010a cd0000        	call	_enviaSerial
 883                     ; 236   enviaSerial(0x04);
 885  010d a604          	ld	a,#4
 886  010f cd0000        	call	_enviaSerial
 888                     ; 237   enviaSerial(comando_RX);
 890  0112 7b07          	ld	a,(OFST+7,sp)
 891  0114 cd0000        	call	_enviaSerial
 893                     ; 238   enviaSerial(0x05);
 895  0117 a605          	ld	a,#5
 896  0119 cd0000        	call	_enviaSerial
 898                     ; 239   enviaSerial(dadosPacote1_RX);
 900  011c 7b08          	ld	a,(OFST+8,sp)
 901  011e cd0000        	call	_enviaSerial
 903                     ; 240   enviaSerial(0x06);
 905  0121 a606          	ld	a,#6
 906  0123 cd0000        	call	_enviaSerial
 908                     ; 241   enviaSerial(dadosPacote2_RX);
 910  0126 7b09          	ld	a,(OFST+9,sp)
 911  0128 cd0000        	call	_enviaSerial
 913                     ; 242   enviaSerial(0x07);
 915  012b a607          	ld	a,#7
 916  012d cd0000        	call	_enviaSerial
 918                     ; 243   enviaSerial(BCC_RX);
 920  0130 7b0a          	ld	a,(OFST+10,sp)
 921  0132 cd0000        	call	_enviaSerial
 923                     ; 244   enviaSerial(0x08);
 925  0135 a608          	ld	a,#8
 926  0137 cd0000        	call	_enviaSerial
 928                     ; 245   enviaSerial(tamanhoMsg);
 930  013a 7b0b          	ld	a,(OFST+11,sp)
 931  013c cd0000        	call	_enviaSerial
 933                     ; 246   enviaSerial(0x09);
 935  013f a609          	ld	a,#9
 936  0141 cd0000        	call	_enviaSerial
 938                     ; 247   enviaSerial(flagCOM_RX);
 940  0144 7b0c          	ld	a,(OFST+12,sp)
 941  0146 cd0000        	call	_enviaSerial
 943                     ; 248 }
 946  0149 85            	popw	x
 947  014a 81            	ret	
1002                     ; 250 char coletaBuffer(char buffer[])
1002                     ; 251 {
1003                     	switch	.text
1004  014b               _coletaBuffer:
1006  014b 89            	pushw	x
1007  014c 5205          	subw	sp,#5
1008       00000005      OFST:	set	5
1011                     ; 252   unsigned long tempo_RX = 0xFFFF;
1013  014e aeffff        	ldw	x,#65535
1014  0151 1f04          	ldw	(OFST-1,sp),x
1015  0153 5f            	clrw	x
1016  0154 1f02          	ldw	(OFST-3,sp),x
1018                     ; 253   char tamanhoMsg = 0;
1020  0156 0f01          	clr	(OFST-4,sp)
1023  0158 2029          	jra	L344
1024  015a               L734:
1025                     ; 257     if (UART2_GetFlagStatus(UART2_FLAG_RXNE) == TRUE)
1027  015a ae0020        	ldw	x,#32
1028  015d cd0000        	call	_UART2_GetFlagStatus
1030  0160 4a            	dec	a
1031  0161 2617          	jrne	L744
1032                     ; 259       buffer[tamanhoMsg] = UART2_ReceiveData8();
1034  0163 7b01          	ld	a,(OFST-4,sp)
1035  0165 5f            	clrw	x
1036  0166 97            	ld	xl,a
1037  0167 72fb06        	addw	x,(OFST+1,sp)
1038  016a 89            	pushw	x
1039  016b cd0000        	call	_UART2_ReceiveData8
1041  016e 85            	popw	x
1042  016f f7            	ld	(x),a
1043                     ; 260       tempo_RX = 0xFFF;
1045  0170 ae0fff        	ldw	x,#4095
1046  0173 1f04          	ldw	(OFST-1,sp),x
1047  0175 5f            	clrw	x
1048  0176 1f02          	ldw	(OFST-3,sp),x
1050                     ; 261       tamanhoMsg++;
1052  0178 0c01          	inc	(OFST-4,sp)
1054  017a               L744:
1055                     ; 263     tempo_RX--;
1057  017a 96            	ldw	x,sp
1058  017b 1c0002        	addw	x,#OFST-3
1059  017e a601          	ld	a,#1
1060  0180 cd0000        	call	c_lgsbc
1063  0183               L344:
1064                     ; 255   while (tempo_RX > 0)
1066  0183 96            	ldw	x,sp
1067  0184 1c0002        	addw	x,#OFST-3
1068  0187 cd0000        	call	c_lzmp
1070  018a 26ce          	jrne	L734
1071                     ; 265   return tamanhoMsg;
1073  018c 7b01          	ld	a,(OFST-4,sp)
1076  018e 5b07          	addw	sp,#7
1077  0190 81            	ret	
1183                     ; 268 void zeraRegistradoresRX(char *STX_RX, char *tamanhoPacote_RX, char *enderecoDestino_RX, char *enderecoOrigem_RX, char *comando_RX, char *dadosPacote1_RX, char *dadosPacote2_RX, char *BCC_RX, char *tamanhoMsg, char *flagCOM_RX)
1183                     ; 269 {
1184                     	switch	.text
1185  0191               _zeraRegistradoresRX:
1187       fffffffe      OFST: set -2
1190                     ; 270   *STX_RX = '\0';
1192  0191 7f            	clr	(x)
1193                     ; 271   *tamanhoPacote_RX = '\0';
1195  0192 1e03          	ldw	x,(OFST+5,sp)
1196  0194 7f            	clr	(x)
1197                     ; 272   *enderecoDestino_RX = '\0';
1199  0195 1e05          	ldw	x,(OFST+7,sp)
1200  0197 7f            	clr	(x)
1201                     ; 273   *enderecoOrigem_RX = '\0';
1203  0198 1e07          	ldw	x,(OFST+9,sp)
1204  019a 7f            	clr	(x)
1205                     ; 274   *comando_RX = '\0';
1207  019b 1e09          	ldw	x,(OFST+11,sp)
1208  019d 7f            	clr	(x)
1209                     ; 275   *dadosPacote1_RX = '\0';
1211  019e 1e0b          	ldw	x,(OFST+13,sp)
1212  01a0 7f            	clr	(x)
1213                     ; 276   *dadosPacote2_RX = '\0';
1215  01a1 1e0d          	ldw	x,(OFST+15,sp)
1216  01a3 7f            	clr	(x)
1217                     ; 277   *BCC_RX = '\0';
1219  01a4 1e0f          	ldw	x,(OFST+17,sp)
1220  01a6 7f            	clr	(x)
1221                     ; 280 }
1224  01a7 81            	ret	
1305                     ; 282 void enviaPacote(char enderecoDestino, char comando, char dados1, char dados2)
1305                     ; 283 {
1306                     	switch	.text
1307  01a8               _enviaPacote:
1309  01a8 89            	pushw	x
1310  01a9 89            	pushw	x
1311       00000002      OFST:	set	2
1314                     ; 285   char BCC = 0x00, tamanhoPacote = 0x00;
1318                     ; 287   if (dados1 == '\0' && dados2 == '\0') //Tamanho = 0x05
1320  01aa 7b07          	ld	a,(OFST+5,sp)
1321  01ac 2629          	jrne	L565
1323  01ae 7b08          	ld	a,(OFST+6,sp)
1324  01b0 2625          	jrne	L565
1325                     ; 289     tamanhoPacote = 0x05;
1327  01b2 a605          	ld	a,#5
1328  01b4 6b02          	ld	(OFST+0,sp),a
1330                     ; 290     BCC = calculateBCC_Param(enderecoDestino, comando, dados1, dados2);
1332  01b6 7b08          	ld	a,(OFST+6,sp)
1333  01b8 88            	push	a
1334  01b9 7b08          	ld	a,(OFST+6,sp)
1335  01bb 88            	push	a
1336  01bc 7b05          	ld	a,(OFST+3,sp)
1337  01be 95            	ld	xh,a
1338  01bf cd006a        	call	_calculateBCC_Param
1340  01c2 85            	popw	x
1341  01c3 6b01          	ld	(OFST-1,sp),a
1343                     ; 291     enviaSerial(STX);
1345  01c5 a602          	ld	a,#2
1346  01c7 cd0000        	call	_enviaSerial
1348                     ; 292     enviaSerial(tamanhoPacote); //tamanho
1350  01ca 7b02          	ld	a,(OFST+0,sp)
1351  01cc cd0000        	call	_enviaSerial
1353                     ; 293     enviaSerial(enderecoDestino);
1355  01cf 7b03          	ld	a,(OFST+1,sp)
1356  01d1 ad7c          	call	LC004
1358                     ; 295     enviaSerial(comando);
1360  01d3 7b04          	ld	a,(OFST+2,sp)
1362                     ; 296     enviaSerial(BCC);
1365  01d5 206d          	jp	LC003
1366  01d7               L565:
1367                     ; 298   else if (!dados1 == '\0' && dados2 == '\0') //Tamanho = 0x06
1369  01d7 7b07          	ld	a,(OFST+5,sp)
1370  01d9 2731          	jreq	L175
1372  01db 7b08          	ld	a,(OFST+6,sp)
1373  01dd 262d          	jrne	L175
1374                     ; 300     tamanhoPacote = 0x06;
1376  01df a606          	ld	a,#6
1377  01e1 6b02          	ld	(OFST+0,sp),a
1379                     ; 301     BCC = calculateBCC_Param(enderecoDestino, comando, dados1, dados2);
1381  01e3 7b08          	ld	a,(OFST+6,sp)
1382  01e5 88            	push	a
1383  01e6 7b08          	ld	a,(OFST+6,sp)
1384  01e8 88            	push	a
1385  01e9 7b06          	ld	a,(OFST+4,sp)
1386  01eb 97            	ld	xl,a
1387  01ec 7b05          	ld	a,(OFST+3,sp)
1388  01ee 95            	ld	xh,a
1389  01ef cd006a        	call	_calculateBCC_Param
1391  01f2 85            	popw	x
1392  01f3 6b01          	ld	(OFST-1,sp),a
1394                     ; 302     enviaSerial(STX);
1396  01f5 a602          	ld	a,#2
1397  01f7 cd0000        	call	_enviaSerial
1399                     ; 303     enviaSerial(tamanhoPacote); //tamanho
1401  01fa 7b02          	ld	a,(OFST+0,sp)
1402  01fc cd0000        	call	_enviaSerial
1404                     ; 304     enviaSerial(enderecoDestino);
1406  01ff 7b03          	ld	a,(OFST+1,sp)
1407  0201 ad4c          	call	LC004
1409                     ; 306     enviaSerial(comando);
1411  0203 7b04          	ld	a,(OFST+2,sp)
1412  0205 cd0000        	call	_enviaSerial
1414                     ; 307     enviaSerial(dados1);
1416  0208 7b07          	ld	a,(OFST+5,sp)
1418                     ; 308     enviaSerial(BCC);
1421  020a 2038          	jp	LC003
1422  020c               L175:
1423                     ; 310   else if (!dados1 == '\0' && !dados2 == '\0') //Tamanho = 0x07
1425  020c 7b07          	ld	a,(OFST+5,sp)
1426  020e 273c          	jreq	L765
1428  0210 7b08          	ld	a,(OFST+6,sp)
1429  0212 2738          	jreq	L765
1430                     ; 312     tamanhoPacote = 0x07;
1432  0214 a607          	ld	a,#7
1433  0216 6b02          	ld	(OFST+0,sp),a
1435                     ; 313     BCC = calculateBCC_Param(enderecoDestino, comando, dados1, dados2);
1437  0218 7b08          	ld	a,(OFST+6,sp)
1438  021a 88            	push	a
1439  021b 7b08          	ld	a,(OFST+6,sp)
1440  021d 88            	push	a
1441  021e 7b06          	ld	a,(OFST+4,sp)
1442  0220 97            	ld	xl,a
1443  0221 7b05          	ld	a,(OFST+3,sp)
1444  0223 95            	ld	xh,a
1445  0224 cd006a        	call	_calculateBCC_Param
1447  0227 85            	popw	x
1448  0228 6b01          	ld	(OFST-1,sp),a
1450                     ; 314     enviaSerial(STX);
1452  022a a602          	ld	a,#2
1453  022c cd0000        	call	_enviaSerial
1455                     ; 315     enviaSerial(tamanhoPacote); //tamanho
1457  022f 7b02          	ld	a,(OFST+0,sp)
1458  0231 cd0000        	call	_enviaSerial
1460                     ; 316     enviaSerial(enderecoDestino);
1462  0234 7b03          	ld	a,(OFST+1,sp)
1463  0236 ad17          	call	LC004
1465                     ; 318     enviaSerial(comando);
1467  0238 7b04          	ld	a,(OFST+2,sp)
1468  023a cd0000        	call	_enviaSerial
1470                     ; 319     enviaSerial(dados1);
1472  023d 7b07          	ld	a,(OFST+5,sp)
1473  023f cd0000        	call	_enviaSerial
1475                     ; 320     enviaSerial(dados2);
1477  0242 7b08          	ld	a,(OFST+6,sp)
1479                     ; 321     enviaSerial(BCC);
1481  0244               LC003:
1482  0244 cd0000        	call	_enviaSerial
1485  0247 7b01          	ld	a,(OFST-1,sp)
1486  0249 cd0000        	call	_enviaSerial
1488  024c               L765:
1489                     ; 323 }
1492  024c 5b04          	addw	sp,#4
1493  024e 81            	ret	
1494  024f               LC004:
1495  024f cd0000        	call	_enviaSerial
1497                     ; 317     enviaSerial(ENDERECO_DISP);
1499  0252 a605          	ld	a,#5
1500  0254 cc0000        	jp	_enviaSerial
1586                     ; 325 void processaPacoteRX(char STX_RX, char tamanhoPacote_RX, char enderecoDestino_RX, char enderecoOrigem_RX, char comando_RX, char dadosPacote1_RX, char dadosPacote2_RX, char BCC_RX, char flagCOM_RX)
1586                     ; 326 { //função para tomar a decisão do que fazer a partir dos dados recebidos
1587                     	switch	.text
1588  0257               _processaPacoteRX:
1590  0257 89            	pushw	x
1591       00000000      OFST:	set	0
1594                     ; 327   switch (flagCOM_RX)
1596  0258 7b0b          	ld	a,(OFST+11,sp)
1598                     ; 397     break;
1599  025a 2709          	jreq	L775
1600  025c 4a            	dec	a
1601  025d 2603cc0303    	jreq	L716
1602  0262 cc0311        	jra	L566
1603  0265               L775:
1604                     ; 329   case 0x00:
1604                     ; 330     switch (comando_RX)
1606  0265 7b07          	ld	a,(OFST+7,sp)
1608                     ; 389       break;
1609  0267 4a            	dec	a
1610  0268 2715          	jreq	L106
1611  026a 4a            	dec	a
1612  026b 2721          	jreq	L306
1613  026d 4a            	dec	a
1614  026e 273a          	jreq	L506
1615  0270 4a            	dec	a
1616  0271 274e          	jreq	L706
1617  0273 4a            	dec	a
1618  0274 2763          	jreq	L116
1619  0276 4a            	dec	a
1620  0277 276e          	jreq	L316
1621  0279 4a            	dec	a
1622  027a 2779          	jreq	L516
1623  027c cc0311        	jra	L566
1624  027f               L106:
1625                     ; 332     case 0x01: //0x1: Leitura do status do botão 1, 0 quando não estiver acionado e 1 quando estiver acionado
1625                     ; 333       if (GPIO_ReadInputPin(GPIOD, GPIO_PIN_4) == 0)
1627  027f 4b10          	push	#16
1628  0281 ae500f        	ldw	x,#20495
1629  0284 cd0000        	call	_GPIO_ReadInputPin
1631  0287 5b01          	addw	sp,#1
1632  0289 4d            	tnz	a
1633  028a 2613          	jrne	L776
1634                     ; 335         enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x00);
1637  028c 200d          	jp	LC008
1638                     ; 339         enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x01);
1640  028e               L306:
1641                     ; 343     case 0x02: //0x2: Leitura do status do botão 2, 0 quando não estiver acionado e 1 quando estiver acionado
1641                     ; 344       if (GPIO_ReadInputPin(GPIOD, GPIO_PIN_7) == 0)
1643  028e 4b80          	push	#128
1644  0290 ae500f        	ldw	x,#20495
1645  0293 cd0000        	call	_GPIO_ReadInputPin
1647  0296 5b01          	addw	sp,#1
1648  0298 4d            	tnz	a
1649  0299 2604          	jrne	L776
1650                     ; 346         enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x00);
1652  029b               LC008:
1654  029b 4b00          	push	#0
1657  029d 2002          	jp	LC006
1658  029f               L776:
1659                     ; 350         enviaPacote(enderecoOrigem_RX, 0x01, 0x06, 0x01);
1662  029f 4b01          	push	#1
1663  02a1               LC006:
1664  02a1 4b06          	push	#6
1665  02a3 7b08          	ld	a,(OFST+8,sp)
1666  02a5 ae0001        	ldw	x,#1
1668  02a8 2062          	jp	LC005
1669  02aa               L506:
1670                     ; 355     case 0x03: //0x3: Escrita no Led 1, 0 para desligar o LED e 1 para ligar o LED
1670                     ; 356       if (dadosPacote1_RX == 0x01)
1672  02aa 7b08          	ld	a,(OFST+8,sp)
1673  02ac 4a            	dec	a
1674  02ad 2604          	jrne	L307
1675                     ; 358         GPIO_WriteHigh(GPIOD, GPIO_PIN_2);
1677  02af 4b04          	push	#4
1680  02b1 2015          	jp	LC010
1681  02b3               L307:
1682                     ; 360       else if (dadosPacote1_RX == 0x00)
1684  02b3 7b08          	ld	a,(OFST+8,sp)
1685  02b5 265a          	jrne	L566
1686                     ; 362         GPIO_WriteLow(GPIOD, GPIO_PIN_2);
1688  02b7 4b04          	push	#4
1689  02b9               LC011:
1690  02b9 ae500f        	ldw	x,#20495
1691  02bc cd0000        	call	_GPIO_WriteLow
1693  02bf 200d          	jp	LC009
1694  02c1               L706:
1695                     ; 366     case 0x04: //0x4: Escrita no Led 2, 0 para desligar o LED e 1 para ligar o LED
1695                     ; 367       if (dadosPacote1_RX == 0x01)
1697  02c1 7b08          	ld	a,(OFST+8,sp)
1698  02c3 4a            	dec	a
1699  02c4 260b          	jrne	L117
1700                     ; 369         GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
1702  02c6 4b08          	push	#8
1703  02c8               LC010:
1704  02c8 ae500f        	ldw	x,#20495
1705  02cb cd0000        	call	_GPIO_WriteHigh
1707  02ce               LC009:
1708  02ce 84            	pop	a
1710  02cf 2040          	jra	L566
1711  02d1               L117:
1712                     ; 371       else if (dadosPacote1_RX == 0x00)
1714  02d1 7b08          	ld	a,(OFST+8,sp)
1715  02d3 263c          	jrne	L566
1716                     ; 373         GPIO_WriteLow(GPIOD, GPIO_PIN_3);
1718  02d5 4b08          	push	#8
1720  02d7 20e0          	jp	LC011
1721  02d9               L116:
1722                     ; 377     case 0x05: //0x5: Pisca Led1, primeiro byte o número de piscadas e o segundo byte o tempo de cada piscada
1722                     ; 378       piscaLED(0x01, dadosPacote1_RX, dadosPacote2_RX);
1724  02d9 7b09          	ld	a,(OFST+9,sp)
1725  02db 88            	push	a
1726  02dc 7b09          	ld	a,(OFST+9,sp)
1727  02de ae0100        	ldw	x,#256
1728  02e1 97            	ld	xl,a
1729  02e2 cd00ae        	call	_piscaLED
1731                     ; 379       break;
1733  02e5 20e7          	jp	LC009
1734  02e7               L316:
1735                     ; 381     case 0x06: //0x6: Pisca Led2, primeiro byte o número de piscadas e o segundo byte o tempo de cada piscada
1735                     ; 382       piscaLED(0x02, dadosPacote1_RX, dadosPacote2_RX);
1737  02e7 7b09          	ld	a,(OFST+9,sp)
1738  02e9 88            	push	a
1739  02ea 7b09          	ld	a,(OFST+9,sp)
1740  02ec ae0200        	ldw	x,#512
1741  02ef 97            	ld	xl,a
1742  02f0 cd00ae        	call	_piscaLED
1744                     ; 383       break;
1746  02f3 20d9          	jp	LC009
1747  02f5               L516:
1748                     ; 385     case 0x07: //0x7 : Escreve uma mensagem do display, onde o primeiro dado é a posição do display (0x80 para a primeira posição) e os demais dados a mensagem (em ASCII)
1748                     ; 386       
1748                     ; 387       LCD_goto(dadosPacote1_RX, 0);                              
1750  02f5 7b08          	ld	a,(OFST+8,sp)
1751  02f7 5f            	clrw	x
1752  02f8 95            	ld	xh,a
1753  02f9 cd06f7        	call	_LCD_goto
1755                     ; 388       LCD_putchar(dadosPacote2_RX);
1757  02fc 7b09          	ld	a,(OFST+9,sp)
1758  02fe cd06e4        	call	_LCD_putchar
1760                     ; 389       break;
1762  0301 200e          	jra	L566
1763                     ; 392     break;
1765  0303               L716:
1766                     ; 394   case 0x01:
1766                     ; 395     //ENVIA NAK
1766                     ; 396     enviaPacote(enderecoOrigem_RX, 0x20, 0x15, '\0');
1768  0303 4b00          	push	#0
1769  0305 4b15          	push	#21
1770  0307 7b08          	ld	a,(OFST+8,sp)
1771  0309 ae0020        	ldw	x,#32
1773  030c               LC005:
1774  030c 95            	ld	xh,a
1775  030d cd01a8        	call	_enviaPacote
1776  0310 85            	popw	x
1777                     ; 397     break;
1779  0311               L566:
1780                     ; 399 }
1783  0311 85            	popw	x
1784  0312 81            	ret	
1787                     .const:	section	.text
1788  0000               L717_maqEstados:
1789  0000 01            	dc.b	1
1790  0001 02            	dc.b	2
1791  0002 03            	dc.b	3
1792  0003 04            	dc.b	4
1793  0004 05            	dc.b	5
1794  0005 06            	dc.b	6
1795  0006 000000000000  	ds.b	9
1993                     ; 401 void main(void)
1993                     ; 402 {
1994                     	switch	.text
1995  0313               _main:
1997  0313 5288          	subw	sp,#136
1998       00000088      OFST:	set	136
2001                     ; 403   char indiceMaqEstados = 0x00;
2003                     ; 404   unsigned long tempo, tempo_RX = 0xFFF;
2005                     ; 405   char delay = 0xFFFFF, tamanhoMsg = 0, varredura = 0,
2009  0315 0f21          	clr	(OFST-103,sp)
2013                     ; 406        Dado_RX_buffer[TAMANHO_MAX], BCC_RX = 0x00, STX_RX = 0x00,
2015  0317 0f1f          	clr	(OFST-105,sp)
2019  0319 0f1a          	clr	(OFST-110,sp)
2021                     ; 407        tamanhoPacote_RX = 0x00, enderecoDestino_RX = 0x00, enderecoOrigem_RX = 0x00,
2023  031b 0f22          	clr	(OFST-102,sp)
2027  031d 0f1b          	clr	(OFST-109,sp)
2031  031f 0f1c          	clr	(OFST-108,sp)
2033                     ; 408        comando_RX = 0x00, dadosPacote1_RX = 0x00, dadosPacote2_RX = 0x00;
2035  0321 0f1d          	clr	(OFST-107,sp)
2039  0323 0f20          	clr	(OFST-104,sp)
2043  0325 0f1e          	clr	(OFST-106,sp)
2045                     ; 410   char flagDados = '\0'; //Se 0 -> um byte de dados. Se 1 -> dois bytes de daods.
2047                     ; 411   char flagCOM_RX = '\0';
2049  0327 0f24          	clr	(OFST-100,sp)
2051                     ; 419   char estado = 0x00;
2053                     ; 429   char maqEstados[15] = {
2053                     ; 430       0x01,
2053                     ; 431       0x02,
2053                     ; 432       0x03,
2053                     ; 433       0x04,
2053                     ; 434       0x05,
2053                     ; 435       0x06};
2055  0329 96            	ldw	x,sp
2056  032a 1c000a        	addw	x,#OFST-126
2057  032d 90ae0000      	ldw	y,#L717_maqEstados
2058  0331 a60f          	ld	a,#15
2059  0333 cd0000        	call	c_xymov
2061                     ; 438   CLK_Configuration();
2063  0336 cd04f9        	call	_CLK_Configuration
2065                     ; 441   GPIO_Configuration();
2067  0339 cd04fd        	call	_GPIO_Configuration
2069                     ; 443   UART2_Init(9600, UART2_WORDLENGTH_8D, UART2_STOPBITS_1,
2069                     ; 444              UART2_PARITY_NO, UART2_SYNCMODE_CLOCK_DISABLE,
2069                     ; 445              UART2_MODE_TXRX_ENABLE);
2071  033c 4b0c          	push	#12
2072  033e 4b80          	push	#128
2073  0340 4b00          	push	#0
2074  0342 4b00          	push	#0
2075  0344 4b00          	push	#0
2076  0346 ae2580        	ldw	x,#9600
2077  0349 89            	pushw	x
2078  034a 5f            	clrw	x
2079  034b 89            	pushw	x
2080  034c cd0000        	call	_UART2_Init
2082  034f 5b09          	addw	sp,#9
2083                     ; 447   LCD_init();
2085  0351 cd05eb        	call	_LCD_init
2087                     ; 448   LCD_clear_home();
2089  0354 cd06eb        	call	_LCD_clear_home
2091  0357               L7501:
2092                     ; 453     limpaVetor(Dado_RX_buffer, TAMANHO_MAX);
2094  0357 4b64          	push	#100
2095  0359 96            	ldw	x,sp
2096  035a 1c0026        	addw	x,#OFST-98
2097  035d cd000d        	call	_limpaVetor
2099  0360 84            	pop	a
2100                     ; 454     tamanhoMsg = coletaBuffer(Dado_RX_buffer); //Abre o buffer e recebe dados
2102  0361 96            	ldw	x,sp
2103  0362 1c0025        	addw	x,#OFST-99
2104  0365 cd014b        	call	_coletaBuffer
2106  0368 6b21          	ld	(OFST-103,sp),a
2108                     ; 456     if (tamanhoMsg > 0)
2110  036a 27eb          	jreq	L7501
2111                     ; 458       flagCOM_RX = 0x04; // Processamento em andamento
2113  036c a604          	ld	a,#4
2114  036e 6b24          	ld	(OFST-100,sp),a
2116                     ; 459       indiceMaqEstados = 0x00;
2118  0370 0f23          	clr	(OFST-101,sp)
2121  0372 cc0439        	jra	L7601
2122  0375               L5601:
2123                     ; 464         estado = maqEstados[indiceMaqEstados];
2125  0375 96            	ldw	x,sp
2126  0376 1c000a        	addw	x,#OFST-126
2127  0379 9f            	ld	a,xl
2128  037a 5e            	swapw	x
2129  037b 1b23          	add	a,(OFST-101,sp)
2130  037d 2401          	jrnc	L652
2131  037f 5c            	incw	x
2132  0380               L652:
2133  0380 02            	rlwa	x,a
2134  0381 f6            	ld	a,(x)
2135  0382 6b19          	ld	(OFST-111,sp),a
2137                     ; 466         switch (estado)
2140                     ; 540           break;
2141  0384 4a            	dec	a
2142  0385 2712          	jreq	L127
2143  0387 4a            	dec	a
2144  0388 2738          	jreq	L327
2145  038a 4a            	dec	a
2146  038b 2743          	jreq	L527
2147  038d 4a            	dec	a
2148  038e 2765          	jreq	L727
2149  0390 4a            	dec	a
2150  0391 2770          	jreq	L137
2151  0393 4a            	dec	a
2152  0394 2775          	jreq	L337
2153  0396 cc0439        	jra	L7601
2154  0399               L127:
2155                     ; 469         case 0x01: //LIMPA REGISTRADORES
2155                     ; 470           zeraRegistradoresRX(&STX_RX, &tamanhoPacote_RX, &enderecoDestino_RX, &enderecoOrigem_RX, &comando_RX, &dadosPacote1_RX, &dadosPacote2_RX, &BCC_RX, &tamanhoMsg, &flagCOM_RX);
2157  0399 96            	ldw	x,sp
2158  039a 1c0024        	addw	x,#OFST-100
2159  039d 89            	pushw	x
2160  039e 1d0003        	subw	x,#3
2161  03a1 89            	pushw	x
2162  03a2 1d0002        	subw	x,#2
2163  03a5 89            	pushw	x
2164  03a6 5a            	decw	x
2165  03a7 89            	pushw	x
2166  03a8 1c0002        	addw	x,#2
2167  03ab 89            	pushw	x
2168  03ac 1d0003        	subw	x,#3
2169  03af 89            	pushw	x
2170  03b0 5a            	decw	x
2171  03b1 89            	pushw	x
2172  03b2 5a            	decw	x
2173  03b3 89            	pushw	x
2174  03b4 1c0007        	addw	x,#7
2175  03b7 89            	pushw	x
2176  03b8 1d0008        	subw	x,#8
2177  03bb cd0191        	call	_zeraRegistradoresRX
2179  03be 5b12          	addw	sp,#18
2180                     ; 471           indiceMaqEstados++;
2181                     ; 472           break;
2183  03c0 2045          	jp	LC013
2184  03c2               L327:
2185                     ; 474         case 0x02: //VALIDA STX_RX
2185                     ; 475           if (Dado_RX_buffer[0] == 0x02)
2187  03c2 7b25          	ld	a,(OFST-99,sp)
2188  03c4 a102          	cp	a,#2
2189  03c6 2604          	jrne	L7701
2190                     ; 477             STX_RX = Dado_RX_buffer[0];
2192  03c8 6b1a          	ld	(OFST-110,sp),a
2194                     ; 478             indiceMaqEstados++;
2196  03ca 203b          	jp	LC013
2197  03cc               L7701:
2198                     ; 482             flagCOM_RX = 0x03;
2200  03cc a603          	ld	a,#3
2201  03ce 2067          	jp	LC012
2202  03d0               L527:
2203                     ; 486         case 0x03: //CALCULA E VALIDA BCC_RX
2203                     ; 487           BCC_RX = calculateBCC_RX(Dado_RX_buffer, tamanhoMsg);
2205  03d0 7b21          	ld	a,(OFST-103,sp)
2206  03d2 88            	push	a
2207  03d3 96            	ldw	x,sp
2208  03d4 1c0026        	addw	x,#OFST-98
2209  03d7 cd003d        	call	_calculateBCC_RX
2211  03da 5b01          	addw	sp,#1
2212  03dc 6b1f          	ld	(OFST-105,sp),a
2214                     ; 488           if (BCC_RX == Dado_RX_buffer[tamanhoMsg - 1])
2216  03de 96            	ldw	x,sp
2217  03df 1c0025        	addw	x,#OFST-99
2218  03e2 1f01          	ldw	(OFST-135,sp),x
2220  03e4 5f            	clrw	x
2221  03e5 7b21          	ld	a,(OFST-103,sp)
2222  03e7 97            	ld	xl,a
2223  03e8 5a            	decw	x
2224  03e9 72fb01        	addw	x,(OFST-135,sp)
2225  03ec f6            	ld	a,(x)
2226  03ed 111f          	cp	a,(OFST-105,sp)
2227                     ; 490             indiceMaqEstados++;
2229  03ef 2716          	jreq	LC013
2230                     ; 494             flagCOM_RX = 0x01;
2232  03f1 a601          	ld	a,#1
2233  03f3 2042          	jp	LC012
2234  03f5               L727:
2235                     ; 498         case 0x04: //VALIDA ENDERE�O DE DESTINO
2235                     ; 499           if (ENDERECO_DISP == Dado_RX_buffer[2])
2237  03f5 7b27          	ld	a,(OFST-97,sp)
2238  03f7 a105          	cp	a,#5
2239  03f9 2604          	jrne	L7011
2240                     ; 501             enderecoDestino_RX = Dado_RX_buffer[2];
2242  03fb 6b1b          	ld	(OFST-109,sp),a
2244                     ; 502             indiceMaqEstados++;
2246  03fd 2008          	jp	LC013
2247  03ff               L7011:
2248                     ; 506             flagCOM_RX = 0x02;
2250  03ff a602          	ld	a,#2
2251  0401 2034          	jp	LC012
2252  0403               L137:
2253                     ; 510         case 0x05: //VERIFICA TAMANHO DO PACOTE
2253                     ; 511           tamanhoPacote_RX = Dado_RX_buffer[1];
2255  0403 7b26          	ld	a,(OFST-98,sp)
2256  0405 6b22          	ld	(OFST-102,sp),a
2258                     ; 512           indiceMaqEstados++;
2260  0407               LC013:
2265  0407 0c23          	inc	(OFST-101,sp)
2267                     ; 513           break;
2269  0409 202e          	jra	L7601
2270  040b               L337:
2271                     ; 515         case 0x06: //ALOCA enderecoOrigem_RX / comando_RX / dadosPacote1_RX / dadosPacote2_RX
2271                     ; 516           enderecoOrigem_RX = Dado_RX_buffer[3];
2273  040b 7b28          	ld	a,(OFST-96,sp)
2274  040d 6b1c          	ld	(OFST-108,sp),a
2276                     ; 517           comando_RX = Dado_RX_buffer[4];
2278  040f 7b29          	ld	a,(OFST-95,sp)
2279  0411 6b1d          	ld	(OFST-107,sp),a
2281                     ; 518           if (tamanhoPacote_RX == 0x05)
2283  0413 7b22          	ld	a,(OFST-102,sp)
2284  0415 a105          	cp	a,#5
2285                     ; 520             indiceMaqEstados++;
2286                     ; 521             flagCOM_RX = 0x00;
2288  0417 2708          	jreq	LC014
2289                     ; 523           else if (tamanhoPacote_RX == 0x06)
2291  0419 a106          	cp	a,#6
2292  041b 260a          	jrne	L7111
2293                     ; 525             dadosPacote1_RX = Dado_RX_buffer[5];
2295  041d 7b2a          	ld	a,(OFST-94,sp)
2296  041f 6b20          	ld	(OFST-104,sp),a
2298                     ; 526             indiceMaqEstados++;
2300                     ; 527             flagCOM_RX = 0x00;
2302  0421               LC014:
2305  0421 0c23          	inc	(OFST-101,sp)
2309  0423 0f24          	clr	(OFST-100,sp)
2312  0425 2012          	jra	L7601
2313  0427               L7111:
2314                     ; 529           else if (tamanhoPacote_RX == 0x07)
2316  0427 a107          	cp	a,#7
2317  0429 260a          	jrne	L3211
2318                     ; 531             dadosPacote1_RX = Dado_RX_buffer[5];
2320  042b 7b2a          	ld	a,(OFST-94,sp)
2321  042d 6b20          	ld	(OFST-104,sp),a
2323                     ; 532             dadosPacote2_RX = Dado_RX_buffer[6];
2325  042f 7b2b          	ld	a,(OFST-93,sp)
2326  0431 6b1e          	ld	(OFST-106,sp),a
2328                     ; 533             indiceMaqEstados++;
2329                     ; 534             flagCOM_RX = 0x00;
2331  0433 20ec          	jp	LC014
2332  0435               L3211:
2333                     ; 538             flagCOM_RX = 0x05;
2335  0435 a605          	ld	a,#5
2336  0437               LC012:
2337  0437 6b24          	ld	(OFST-100,sp),a
2339  0439               L7601:
2340                     ; 461       while (flagCOM_RX == 0x04)
2342  0439 7b24          	ld	a,(OFST-100,sp)
2343  043b a104          	cp	a,#4
2344  043d 2603cc0375    	jreq	L5601
2345                     ; 546       debugCOM(STX_RX, tamanhoPacote_RX, enderecoDestino_RX, enderecoOrigem_RX, comando_RX, dadosPacote1_RX, dadosPacote2_RX, BCC_RX, tamanhoMsg, flagCOM_RX);
2347  0442 88            	push	a
2348  0443 7b22          	ld	a,(OFST-102,sp)
2349  0445 88            	push	a
2350  0446 7b21          	ld	a,(OFST-103,sp)
2351  0448 88            	push	a
2352  0449 7b21          	ld	a,(OFST-103,sp)
2353  044b 88            	push	a
2354  044c 7b24          	ld	a,(OFST-100,sp)
2355  044e 88            	push	a
2356  044f 7b22          	ld	a,(OFST-102,sp)
2357  0451 88            	push	a
2358  0452 7b22          	ld	a,(OFST-102,sp)
2359  0454 88            	push	a
2360  0455 7b22          	ld	a,(OFST-102,sp)
2361  0457 88            	push	a
2362  0458 7b2a          	ld	a,(OFST-94,sp)
2363  045a 97            	ld	xl,a
2364  045b 7b22          	ld	a,(OFST-102,sp)
2365  045d 95            	ld	xh,a
2366  045e cd00e5        	call	_debugCOM
2368  0461 5b08          	addw	sp,#8
2369                     ; 547       processaPacoteRX(STX_RX, tamanhoPacote_RX, enderecoDestino_RX, enderecoOrigem_RX, comando_RX, dadosPacote1_RX, dadosPacote2_RX, BCC_RX, flagCOM_RX);
2371  0463 7b24          	ld	a,(OFST-100,sp)
2372  0465 88            	push	a
2373  0466 7b20          	ld	a,(OFST-104,sp)
2374  0468 88            	push	a
2375  0469 7b20          	ld	a,(OFST-104,sp)
2376  046b 88            	push	a
2377  046c 7b23          	ld	a,(OFST-101,sp)
2378  046e 88            	push	a
2379  046f 7b21          	ld	a,(OFST-103,sp)
2380  0471 88            	push	a
2381  0472 7b21          	ld	a,(OFST-103,sp)
2382  0474 88            	push	a
2383  0475 7b21          	ld	a,(OFST-103,sp)
2384  0477 88            	push	a
2385  0478 7b29          	ld	a,(OFST-95,sp)
2386  047a 97            	ld	xl,a
2387  047b 7b21          	ld	a,(OFST-103,sp)
2388  047d 95            	ld	xh,a
2389  047e cd0257        	call	_processaPacoteRX
2391  0481 5b07          	addw	sp,#7
2392  0483 cc0357        	jra	L7501
2428                     ; 596 void ExtraCode_Init(void)
2428                     ; 597 {
2429                     	switch	.text
2430  0486               _ExtraCode_Init:
2432  0486 88            	push	a
2433       00000001      OFST:	set	1
2436                     ; 603   for (i = 0; i < NUMBER_OF_SINGLE_CHANNEL_KEYS; i++)
2438  0487 0f01          	clr	(OFST+0,sp)
2440  0489               L5411:
2441                     ; 605     sSCKeyInfo[i].Setting.b.IMPLEMENTED = 1;
2443  0489 7b01          	ld	a,(OFST+0,sp)
2444  048b 97            	ld	xl,a
2445  048c a60f          	ld	a,#15
2446  048e 42            	mul	x,a
2447  048f e602          	ld	a,(_sSCKeyInfo+2,x)
2448                     ; 606     sSCKeyInfo[i].Setting.b.ENABLED = 1;
2450  0491 aa03          	or	a,#3
2451  0493 e702          	ld	(_sSCKeyInfo+2,x),a
2452                     ; 607     sSCKeyInfo[i].DxSGroup = 0x01; /* Put 0x00 to disable the DES on these pins */
2454  0495 a601          	ld	a,#1
2455  0497 e704          	ld	(_sSCKeyInfo+4,x),a
2456                     ; 603   for (i = 0; i < NUMBER_OF_SINGLE_CHANNEL_KEYS; i++)
2458  0499 0c01          	inc	(OFST+0,sp)
2462  049b 27ec          	jreq	L5411
2463                     ; 619   enableInterrupts();
2466  049d 9a            	rim	
2468                     ; 620 }
2472  049e 84            	pop	a
2473  049f 81            	ret	
2508                     ; 635 void ExtraCode_StateMachine(void)
2508                     ; 636 {
2509                     	switch	.text
2510  04a0               _ExtraCode_StateMachine:
2514                     ; 637   if ((TSL_GlobalSetting.b.CHANGED) && (TSLState == TSL_IDLE_STATE))
2516  04a0 720700011c    	btjf	_TSL_GlobalSetting+1,#3,L3711
2518  04a5 b600          	ld	a,_TSLState
2519  04a7 4a            	dec	a
2520  04a8 2617          	jrne	L3711
2521                     ; 639     TSL_GlobalSetting.b.CHANGED = 0;
2523  04aa 72170001      	bres	_TSL_GlobalSetting+1,#3
2524                     ; 641     if (sSCKeyInfo[0].Setting.b.DETECTED) /* KEY 1 touched */
2526  04ae 720500020e    	btjf	_sSCKeyInfo+2,#2,L3711
2527                     ; 643       BlinkSpeed++;
2529  04b3 3c00          	inc	_BlinkSpeed
2530                     ; 644       BlinkSpeed = BlinkSpeed % 3;
2532  04b5 5f            	clrw	x
2533  04b6 b600          	ld	a,_BlinkSpeed
2534  04b8 97            	ld	xl,a
2535  04b9 a603          	ld	a,#3
2536  04bb 62            	div	x,a
2537  04bc 5f            	clrw	x
2538  04bd 97            	ld	xl,a
2539  04be 01            	rrwa	x,a
2540  04bf b700          	ld	_BlinkSpeed,a
2541  04c1               L3711:
2542                     ; 648   switch (BlinkSpeed)
2544  04c1 b600          	ld	a,_BlinkSpeed
2546                     ; 671       Delay(&Toggle, 1 * Sec);
2547  04c3 2710          	jreq	L3511
2548  04c5 4a            	dec	a
2549  04c6 2717          	jreq	L5511
2550  04c8 4a            	dec	a
2551  04c9 271e          	jreq	L7511
2552                     ; 668   default:
2552                     ; 669     if (TSL_Tick_Flags.b.User1_Flag_100ms == 1)
2554  04cb 7205000028    	btjf	_TSL_Tick_Flags,#2,L1021
2555                     ; 671       Delay(&Toggle, 1 * Sec);
2557  04d0 ae000a        	ldw	x,#10
2559  04d3 201c          	jp	LC015
2560  04d5               L3511:
2561                     ; 650   case 0:
2561                     ; 651     GPIO_WriteHigh(GPIOD, GPIO_PIN_0);
2563  04d5 4b01          	push	#1
2564  04d7 ae500f        	ldw	x,#20495
2565  04da cd0000        	call	_GPIO_WriteHigh
2567  04dd 84            	pop	a
2568                     ; 652     break;
2571  04de 81            	ret	
2572  04df               L5511:
2573                     ; 654   case 1:
2573                     ; 655     if (TSL_Tick_Flags.b.User1_Flag_100ms == 1)
2575  04df 7205000014    	btjf	_TSL_Tick_Flags,#2,L1021
2576                     ; 657       Delay(&Toggle, 2 * MilliSec);
2578  04e4 ae0002        	ldw	x,#2
2580  04e7 2008          	jp	LC015
2581  04e9               L7511:
2582                     ; 661   case 2:
2582                     ; 662     if (TSL_Tick_Flags.b.User1_Flag_100ms == 1)
2584  04e9 720500000a    	btjf	_TSL_Tick_Flags,#2,L1021
2585                     ; 664       Delay(&Toggle, 1 * MilliSec);
2587  04ee ae0001        	ldw	x,#1
2589  04f1               LC015:
2590  04f1 89            	pushw	x
2591  04f2 ae0581        	ldw	x,#_Toggle
2592  04f5 ad5a          	call	_Delay
2593  04f7 85            	popw	x
2594  04f8               L1021:
2595                     ; 674 }
2598  04f8 81            	ret	
2622                     ; 686 void CLK_Configuration(void)
2622                     ; 687 {
2623                     	switch	.text
2624  04f9               _CLK_Configuration:
2628                     ; 690   CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
2630  04f9 4f            	clr	a
2632                     ; 691 }
2635  04fa cc0000        	jp	_CLK_HSIPrescalerConfig
2660                     ; 703 void GPIO_Configuration(void)
2660                     ; 704 {
2661                     	switch	.text
2662  04fd               _GPIO_Configuration:
2666                     ; 706   GPIO_DeInit(GPIOD);
2668  04fd ae500f        	ldw	x,#20495
2669  0500 cd0000        	call	_GPIO_DeInit
2671                     ; 709   GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST);
2673  0503 4be0          	push	#224
2674  0505 4b01          	push	#1
2675  0507 ae500f        	ldw	x,#20495
2676  050a cd0000        	call	_GPIO_Init
2678  050d 85            	popw	x
2679                     ; 711   GPIO_Init(GPIOD, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); //led1
2681  050e 4be0          	push	#224
2682  0510 4b04          	push	#4
2683  0512 ae500f        	ldw	x,#20495
2684  0515 cd0000        	call	_GPIO_Init
2686  0518 85            	popw	x
2687                     ; 712   GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); //led2
2689  0519 4be0          	push	#224
2690  051b 4b08          	push	#8
2691  051d ae500f        	ldw	x,#20495
2692  0520 cd0000        	call	_GPIO_Init
2694  0523 85            	popw	x
2695                     ; 714   GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT); //BT1
2697  0524 4b00          	push	#0
2698  0526 4b10          	push	#16
2699  0528 ae500f        	ldw	x,#20495
2700  052b cd0000        	call	_GPIO_Init
2702  052e 85            	popw	x
2703                     ; 715   GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_IN_FL_NO_IT); //BT2
2705  052f 4b00          	push	#0
2706  0531 4b80          	push	#128
2707  0533 ae500f        	ldw	x,#20495
2708  0536 cd0000        	call	_GPIO_Init
2710  0539 85            	popw	x
2711                     ; 718   GPIO_Init(GPIOD, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); //TX
2713  053a 4be0          	push	#224
2714  053c 4b20          	push	#32
2715  053e ae500f        	ldw	x,#20495
2716  0541 cd0000        	call	_GPIO_Init
2718  0544 85            	popw	x
2719                     ; 719   GPIO_Init(GPIOD, GPIO_PIN_6, GPIO_MODE_IN_FL_NO_IT);     //rX
2721  0545 4b00          	push	#0
2722  0547 4b40          	push	#64
2723  0549 ae500f        	ldw	x,#20495
2724  054c cd0000        	call	_GPIO_Init
2726  054f 85            	popw	x
2727                     ; 720 }
2730  0550 81            	ret	
2778                     ; 733 void Delay(void action(void), int NumberofTIMCycles)
2778                     ; 734 {
2779                     	switch	.text
2780  0551               _Delay:
2782  0551 89            	pushw	x
2783       00000000      OFST:	set	0
2786                     ; 735   if ((CheckFlag) != 0)
2788  0552 be01          	ldw	x,_CheckFlag
2789  0554 2704          	jreq	L3521
2790                     ; 736     NumberOfStart = NumberofTIMCycles;
2792  0556 1e05          	ldw	x,(OFST+5,sp)
2793  0558 bf00          	ldw	_NumberOfStart,x
2794  055a               L3521:
2795                     ; 737   if (NumberOfStart != 0)
2797  055a be00          	ldw	x,_NumberOfStart
2798  055c 2707          	jreq	L5521
2799                     ; 739     TSL_Tick_Flags.b.User1_Start_100ms = 1;
2801  055e 72120000      	bset	_TSL_Tick_Flags,#1
2802                     ; 740     CheckFlag = 0;
2804  0562 5f            	clrw	x
2805  0563 bf01          	ldw	_CheckFlag,x
2806  0565               L5521:
2807                     ; 742   if (TSL_Tick_Flags.b.User1_Flag_100ms)
2809  0565 7205000009    	btjf	_TSL_Tick_Flags,#2,L7521
2810                     ; 744     TSL_Tick_Flags.b.User1_Flag_100ms = 0;
2812  056a 72150000      	bres	_TSL_Tick_Flags,#2
2813                     ; 745     NumberOfStart--;
2815  056e be00          	ldw	x,_NumberOfStart
2816  0570 5a            	decw	x
2817  0571 bf00          	ldw	_NumberOfStart,x
2818  0573               L7521:
2819                     ; 747   if (NumberOfStart == 0)
2821  0573 be00          	ldw	x,_NumberOfStart
2822  0575 2608          	jrne	L1621
2823                     ; 749     action();
2825  0577 1e01          	ldw	x,(OFST+1,sp)
2826  0579 fd            	call	(x)
2828                     ; 750     CheckFlag = 1;
2830  057a ae0001        	ldw	x,#1
2831  057d bf01          	ldw	_CheckFlag,x
2832  057f               L1621:
2833                     ; 752 }
2836  057f 85            	popw	x
2837  0580 81            	ret	
2861                     ; 764 void Toggle(void)
2861                     ; 765 {
2862                     	switch	.text
2863  0581               _Toggle:
2867                     ; 766   GPIO_WriteReverse(GPIOD, GPIO_PIN_0);
2869  0581 4b01          	push	#1
2870  0583 ae500f        	ldw	x,#20495
2871  0586 cd0000        	call	_GPIO_WriteReverse
2873  0589 84            	pop	a
2874                     ; 767 }
2877  058a 81            	ret	
2912                     	switch	.const
2913  000f               L263:
2914  000f 0000ffff      	dc.l	65535
2915                     ; 782 void LCD_GPIO_init(void)
2915                     ; 783 {
2916                     	switch	.text
2917  058b               _LCD_GPIO_init:
2919  058b 5204          	subw	sp,#4
2920       00000004      OFST:	set	4
2923                     ; 785   GPIO_Init(LCD_PORT, LCD_RS, GPIO_MODE_OUT_PP_HIGH_FAST);
2925  058d 4bf0          	push	#240
2926  058f 4b01          	push	#1
2927  0591 ae5005        	ldw	x,#20485
2928  0594 cd0000        	call	_GPIO_Init
2930  0597 85            	popw	x
2931                     ; 786   GPIO_Init(LCD_PORT, LCD_EN, GPIO_MODE_OUT_PP_HIGH_FAST);
2933  0598 4bf0          	push	#240
2934  059a 4b02          	push	#2
2935  059c ae5005        	ldw	x,#20485
2936  059f cd0000        	call	_GPIO_Init
2938  05a2 85            	popw	x
2939                     ; 787   GPIO_Init(LCD_PORT, LCD_DB4, GPIO_MODE_OUT_PP_HIGH_FAST);
2941  05a3 4bf0          	push	#240
2942  05a5 4b04          	push	#4
2943  05a7 ae5005        	ldw	x,#20485
2944  05aa cd0000        	call	_GPIO_Init
2946  05ad 85            	popw	x
2947                     ; 788   GPIO_Init(LCD_PORT, LCD_DB5, GPIO_MODE_OUT_PP_HIGH_FAST);
2949  05ae 4bf0          	push	#240
2950  05b0 4b08          	push	#8
2951  05b2 ae5005        	ldw	x,#20485
2952  05b5 cd0000        	call	_GPIO_Init
2954  05b8 85            	popw	x
2955                     ; 789   GPIO_Init(LCD_PORT, LCD_DB6, GPIO_MODE_OUT_PP_HIGH_FAST);
2957  05b9 4bf0          	push	#240
2958  05bb 4b10          	push	#16
2959  05bd ae5005        	ldw	x,#20485
2960  05c0 cd0000        	call	_GPIO_Init
2962  05c3 85            	popw	x
2963                     ; 790   GPIO_Init(LCD_PORT, LCD_DB7, GPIO_MODE_OUT_PP_HIGH_FAST);
2965  05c4 4bf0          	push	#240
2966  05c6 4b20          	push	#32
2967  05c8 ae5005        	ldw	x,#20485
2968  05cb cd0000        	call	_GPIO_Init
2970  05ce 85            	popw	x
2971                     ; 792   for (Tempo_Aux = 0; Tempo_Aux < 0xFFFF; Tempo_Aux++)
2973  05cf 5f            	clrw	x
2974  05d0 1f03          	ldw	(OFST-1,sp),x
2975  05d2 1f01          	ldw	(OFST-3,sp),x
2977  05d4               L3131:
2980  05d4 96            	ldw	x,sp
2981  05d5 5c            	incw	x
2982  05d6 a601          	ld	a,#1
2983  05d8 cd0000        	call	c_lgadc
2988  05db 96            	ldw	x,sp
2989  05dc 5c            	incw	x
2990  05dd cd0000        	call	c_ltor
2992  05e0 ae000f        	ldw	x,#L263
2993  05e3 cd0000        	call	c_lcmp
2995  05e6 25ec          	jrult	L3131
2996                     ; 794 }
2999  05e8 5b04          	addw	sp,#4
3000  05ea 81            	ret	
3028                     ; 796 void LCD_init(void)
3028                     ; 797 {
3029                     	switch	.text
3030  05eb               _LCD_init:
3034                     ; 798   LCD_GPIO_init();
3036  05eb ad9e          	call	_LCD_GPIO_init
3038                     ; 799   toggle_EN_pin();
3040  05ed cd070c        	call	_toggle_EN_pin
3042                     ; 801   GPIO_WriteLow(LCD_PORT, LCD_RS);
3044  05f0 4b01          	push	#1
3045  05f2 ae5005        	ldw	x,#20485
3046  05f5 cd0000        	call	_GPIO_WriteLow
3048  05f8 84            	pop	a
3049                     ; 802   GPIO_WriteLow(LCD_PORT, LCD_DB7);
3051  05f9 ad2c          	call	LC016
3052                     ; 805   GPIO_WriteHigh(LCD_PORT, LCD_DB4);
3054  05fb ad46          	call	LC017
3056                     ; 808   GPIO_WriteLow(LCD_PORT, LCD_DB7);
3058  05fd ad28          	call	LC016
3059                     ; 811   GPIO_WriteHigh(LCD_PORT, LCD_DB4);
3061  05ff ad42          	call	LC017
3063                     ; 814   GPIO_WriteLow(LCD_PORT, LCD_DB7);
3065  0601 ad24          	call	LC016
3066                     ; 817   GPIO_WriteHigh(LCD_PORT, LCD_DB4);
3068  0603 ad3e          	call	LC017
3070                     ; 820   GPIO_WriteLow(LCD_PORT, LCD_DB7);
3072  0605 ad20          	call	LC016
3073                     ; 823   GPIO_WriteLow(LCD_PORT, LCD_DB4);
3075  0607 4b04          	push	#4
3076  0609 ae5005        	ldw	x,#20485
3077  060c cd0000        	call	_GPIO_WriteLow
3079  060f 84            	pop	a
3080                     ; 824   toggle_EN_pin();
3082  0610 cd070c        	call	_toggle_EN_pin
3084                     ; 826   LCD_send((_4_pin_interface | _2_row_display | _5x7_dots), CMD);
3086  0613 ae2800        	ldw	x,#10240
3087  0616 ad37          	call	_LCD_send
3089                     ; 827   LCD_send((display_on | cursor_off | blink_off), CMD);
3091  0618 ae0c00        	ldw	x,#3072
3092  061b ad32          	call	_LCD_send
3094                     ; 828   LCD_send(clear_display, CMD);
3096  061d ae0100        	ldw	x,#256
3097  0620 ad2d          	call	_LCD_send
3099                     ; 829   LCD_send((cursor_direction_inc | display_no_shift), CMD);
3101  0622 ae0600        	ldw	x,#1536
3103                     ; 830 }
3106  0625 2028          	jp	_LCD_send
3107  0627               LC016:
3108  0627 4b20          	push	#32
3109  0629 ae5005        	ldw	x,#20485
3110  062c cd0000        	call	_GPIO_WriteLow
3112  062f 84            	pop	a
3113                     ; 803   GPIO_WriteLow(LCD_PORT, LCD_DB6);
3115  0630 4b10          	push	#16
3116  0632 ae5005        	ldw	x,#20485
3117  0635 cd0000        	call	_GPIO_WriteLow
3119  0638 84            	pop	a
3120                     ; 804   GPIO_WriteHigh(LCD_PORT, LCD_DB5);
3122  0639 4b08          	push	#8
3123  063b ae5005        	ldw	x,#20485
3124  063e cd0000        	call	_GPIO_WriteHigh
3126  0641 84            	pop	a
3127  0642 81            	ret	
3128  0643               LC017:
3129  0643 4b04          	push	#4
3130  0645 ae5005        	ldw	x,#20485
3131  0648 cd0000        	call	_GPIO_WriteHigh
3133  064b 84            	pop	a
3134                     ; 818   toggle_EN_pin();
3136  064c cc070c        	jp	_toggle_EN_pin
3182                     ; 832 void LCD_send(unsigned char value, unsigned char mode)
3182                     ; 833 {
3183                     	switch	.text
3184  064f               _LCD_send:
3186  064f 89            	pushw	x
3187       00000000      OFST:	set	0
3190                     ; 834   switch (mode)
3192  0650 9f            	ld	a,xl
3194                     ; 844     break;
3195  0651 4d            	tnz	a
3196  0652 270d          	jreq	L1331
3197  0654 4a            	dec	a
3198  0655 2613          	jrne	L7531
3199                     ; 838     GPIO_WriteHigh(LCD_PORT, LCD_RS);
3201  0657 4b01          	push	#1
3202  0659 ae5005        	ldw	x,#20485
3203  065c cd0000        	call	_GPIO_WriteHigh
3205                     ; 839     break;
3207  065f 2008          	jp	LC018
3208  0661               L1331:
3209                     ; 843     GPIO_WriteLow(LCD_PORT, LCD_RS);
3211  0661 4b01          	push	#1
3212  0663 ae5005        	ldw	x,#20485
3213  0666 cd0000        	call	_GPIO_WriteLow
3215  0669               LC018:
3216  0669 84            	pop	a
3217                     ; 844     break;
3219  066a               L7531:
3220                     ; 848   LCD_4bit_send(value);
3222  066a 7b01          	ld	a,(OFST+1,sp)
3223  066c ad02          	call	_LCD_4bit_send
3225                     ; 849 }
3228  066e 85            	popw	x
3229  066f 81            	ret	
3265                     ; 851 void LCD_4bit_send(unsigned char lcd_data)
3265                     ; 852 {
3266                     	switch	.text
3267  0670               _LCD_4bit_send:
3269  0670 88            	push	a
3270       00000000      OFST:	set	0
3273                     ; 853   toggle_io(lcd_data, 7, LCD_DB7);
3275  0671 4b20          	push	#32
3276  0673 ae0007        	ldw	x,#7
3277  0676 95            	ld	xh,a
3278  0677 cd073c        	call	_toggle_io
3280  067a 84            	pop	a
3281                     ; 854   toggle_io(lcd_data, 6, LCD_DB6);
3283  067b 4b10          	push	#16
3284  067d 7b02          	ld	a,(OFST+2,sp)
3285  067f ae0006        	ldw	x,#6
3286  0682 95            	ld	xh,a
3287  0683 cd073c        	call	_toggle_io
3289  0686 84            	pop	a
3290                     ; 855   toggle_io(lcd_data, 5, LCD_DB5);
3292  0687 4b08          	push	#8
3293  0689 7b02          	ld	a,(OFST+2,sp)
3294  068b ae0005        	ldw	x,#5
3295  068e 95            	ld	xh,a
3296  068f cd073c        	call	_toggle_io
3298  0692 84            	pop	a
3299                     ; 856   toggle_io(lcd_data, 4, LCD_DB4);
3301  0693 4b04          	push	#4
3302  0695 7b02          	ld	a,(OFST+2,sp)
3303  0697 ae0004        	ldw	x,#4
3304  069a 95            	ld	xh,a
3305  069b cd073c        	call	_toggle_io
3307  069e 84            	pop	a
3308                     ; 857   toggle_EN_pin();
3310  069f ad6b          	call	_toggle_EN_pin
3312                     ; 858   toggle_io(lcd_data, 3, LCD_DB7);
3314  06a1 4b20          	push	#32
3315  06a3 7b02          	ld	a,(OFST+2,sp)
3316  06a5 ae0003        	ldw	x,#3
3317  06a8 95            	ld	xh,a
3318  06a9 cd073c        	call	_toggle_io
3320  06ac 84            	pop	a
3321                     ; 859   toggle_io(lcd_data, 2, LCD_DB6);
3323  06ad 4b10          	push	#16
3324  06af 7b02          	ld	a,(OFST+2,sp)
3325  06b1 ae0002        	ldw	x,#2
3326  06b4 95            	ld	xh,a
3327  06b5 cd073c        	call	_toggle_io
3329  06b8 84            	pop	a
3330                     ; 860   toggle_io(lcd_data, 1, LCD_DB5);
3332  06b9 4b08          	push	#8
3333  06bb 7b02          	ld	a,(OFST+2,sp)
3334  06bd ae0001        	ldw	x,#1
3335  06c0 95            	ld	xh,a
3336  06c1 ad79          	call	_toggle_io
3338  06c3 84            	pop	a
3339                     ; 861   toggle_io(lcd_data, 0, LCD_DB4);
3341  06c4 4b04          	push	#4
3342  06c6 7b02          	ld	a,(OFST+2,sp)
3343  06c8 5f            	clrw	x
3344  06c9 95            	ld	xh,a
3345  06ca ad70          	call	_toggle_io
3347  06cc 84            	pop	a
3348                     ; 862   toggle_EN_pin();
3350  06cd ad3d          	call	_toggle_EN_pin
3352                     ; 863 }
3355  06cf 84            	pop	a
3356  06d0 81            	ret	
3392                     ; 865 void LCD_putstr(char *lcd_string)
3392                     ; 866 {
3393                     	switch	.text
3394  06d1               _LCD_putstr:
3396  06d1 89            	pushw	x
3397       00000000      OFST:	set	0
3400  06d2 f6            	ld	a,(x)
3401  06d3               L5141:
3402                     ; 869     LCD_send(*lcd_string++, DAT);
3404  06d3 5c            	incw	x
3405  06d4 1f01          	ldw	(OFST+1,sp),x
3406  06d6 ae0001        	ldw	x,#1
3407  06d9 95            	ld	xh,a
3408  06da cd064f        	call	_LCD_send
3410                     ; 870   } while (*lcd_string != '\0');
3412  06dd 1e01          	ldw	x,(OFST+1,sp)
3413  06df f6            	ld	a,(x)
3414  06e0 26f1          	jrne	L5141
3415                     ; 871 }
3418  06e2 85            	popw	x
3419  06e3 81            	ret	
3454                     ; 873 void LCD_putchar(char char_data)
3454                     ; 874 {
3455                     	switch	.text
3456  06e4               _LCD_putchar:
3460                     ; 875   LCD_send(char_data, DAT);
3462  06e4 ae0001        	ldw	x,#1
3463  06e7 95            	ld	xh,a
3465                     ; 876 }
3468  06e8 cc064f        	jp	_LCD_send
3492                     ; 878 void LCD_clear_home(void)
3492                     ; 879 {
3493                     	switch	.text
3494  06eb               _LCD_clear_home:
3498                     ; 880   LCD_send(clear_display, CMD);
3500  06eb ae0100        	ldw	x,#256
3501  06ee cd064f        	call	_LCD_send
3503                     ; 881   LCD_send(goto_home, CMD);
3505  06f1 ae0200        	ldw	x,#512
3507                     ; 882 }
3510  06f4 cc064f        	jp	_LCD_send
3554                     ; 884 void LCD_goto(unsigned char x_pos, unsigned char y_pos)
3554                     ; 885 {
3555                     	switch	.text
3556  06f7               _LCD_goto:
3558  06f7 89            	pushw	x
3559       00000000      OFST:	set	0
3562                     ; 886   if (y_pos == 0)
3564  06f8 9f            	ld	a,xl
3565  06f9 4d            	tnz	a
3566  06fa 2605          	jrne	L3741
3567                     ; 888     LCD_send((0x80 | x_pos), CMD);
3569  06fc 9e            	ld	a,xh
3570  06fd aa80          	or	a,#128
3573  06ff 2004          	jra	L5741
3574  0701               L3741:
3575                     ; 892     LCD_send((0x80 | 0x40 | x_pos), CMD);
3577  0701 7b01          	ld	a,(OFST+1,sp)
3578  0703 aac0          	or	a,#192
3580  0705               L5741:
3581  0705 5f            	clrw	x
3582  0706 95            	ld	xh,a
3583  0707 cd064f        	call	_LCD_send
3584                     ; 894 }
3587  070a 85            	popw	x
3588  070b 81            	ret	
3624                     ; 896 void toggle_EN_pin(void)
3624                     ; 897 {
3625                     	switch	.text
3626  070c               _toggle_EN_pin:
3628  070c 5204          	subw	sp,#4
3629       00000004      OFST:	set	4
3632                     ; 899   GPIO_WriteHigh(LCD_PORT, LCD_EN);
3634  070e 4b02          	push	#2
3635  0710 ae5005        	ldw	x,#20485
3636  0713 cd0000        	call	_GPIO_WriteHigh
3638  0716 5f            	clrw	x
3639  0717 84            	pop	a
3640                     ; 901   for (Tempo_Aux = 0; Tempo_Aux < 0xFFFF; Tempo_Aux++)
3642  0718 1f03          	ldw	(OFST-1,sp),x
3643  071a 1f01          	ldw	(OFST-3,sp),x
3645  071c               L7151:
3648  071c 96            	ldw	x,sp
3649  071d 5c            	incw	x
3650  071e a601          	ld	a,#1
3651  0720 cd0000        	call	c_lgadc
3656  0723 96            	ldw	x,sp
3657  0724 5c            	incw	x
3658  0725 cd0000        	call	c_ltor
3660  0728 ae000f        	ldw	x,#L263
3661  072b cd0000        	call	c_lcmp
3663  072e 25ec          	jrult	L7151
3664                     ; 903   GPIO_WriteLow(LCD_PORT, LCD_EN);
3666  0730 4b02          	push	#2
3667  0732 ae5005        	ldw	x,#20485
3668  0735 cd0000        	call	_GPIO_WriteLow
3670  0738 84            	pop	a
3671                     ; 904 }
3674  0739 5b04          	addw	sp,#4
3675  073b 81            	ret	
3759                     ; 906 void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num)
3759                     ; 907 {
3760                     	switch	.text
3761  073c               _toggle_io:
3763  073c 89            	pushw	x
3764  073d 88            	push	a
3765       00000001      OFST:	set	1
3768                     ; 908   bool temp = FALSE;
3770                     ; 910   temp = (0x01 & (lcd_data >> bit_pos));
3772  073e 9f            	ld	a,xl
3773  073f 5f            	clrw	x
3774  0740 97            	ld	xl,a
3775  0741 7b02          	ld	a,(OFST+1,sp)
3776  0743 5d            	tnzw	x
3777  0744 2704          	jreq	L645
3778  0746               L055:
3779  0746 44            	srl	a
3780  0747 5a            	decw	x
3781  0748 26fc          	jrne	L055
3782  074a               L645:
3783  074a a401          	and	a,#1
3784  074c 6b01          	ld	(OFST+0,sp),a
3786                     ; 912   switch (temp)
3788  074e 4a            	dec	a
3789  074f 260b          	jrne	L5251
3792                     ; 916     GPIO_WriteHigh(LCD_PORT, pin_num);
3794  0751 7b06          	ld	a,(OFST+5,sp)
3795  0753 88            	push	a
3796  0754 ae5005        	ldw	x,#20485
3797  0757 cd0000        	call	_GPIO_WriteHigh
3799                     ; 917     break;
3801  075a 2009          	jra	L3751
3802  075c               L5251:
3803                     ; 922     GPIO_WriteLow(LCD_PORT, pin_num);
3805  075c 7b06          	ld	a,(OFST+5,sp)
3806  075e 88            	push	a
3807  075f ae5005        	ldw	x,#20485
3808  0762 cd0000        	call	_GPIO_WriteLow
3810                     ; 923     break;
3811  0765               L3751:
3812  0765 84            	pop	a
3813                     ; 926 }
3816  0766 5b03          	addw	sp,#3
3817  0768 81            	ret	
3859                     	xdef	_main
3860                     	xdef	_processaPacoteRX
3861                     	xdef	_enviaPacote
3862                     	xdef	_zeraRegistradoresRX
3863                     	xdef	_coletaBuffer
3864                     	xdef	_debugCOM
3865                     	xdef	_piscaLED
3866                     	xdef	_calculateBCC_Param
3867                     	xdef	_calculateBCC_RX
3868                     	xdef	_enviaTodoBuffer
3869                     	xdef	_limpaVetor
3870                     	xdef	_enviaSerial
3871                     	xdef	_CheckFlag
3872                     	switch	.ubsct
3873  0000               _NumberOfStart:
3874  0000 0000          	ds.b	2
3875                     	xdef	_NumberOfStart
3876                     	xdef	_BlinkSpeed
3877                     	xdef	_Toggle
3878                     	xdef	_Delay
3879                     	xdef	_ExtraCode_StateMachine
3880                     	xdef	_ExtraCode_Init
3881                     	xdef	_GPIO_Configuration
3882                     	xdef	_CLK_Configuration
3883                     	xref.b	_sSCKeyInfo
3884                     	xref.b	_TSL_GlobalSetting
3885                     	xref.b	_TSLState
3886                     	xref.b	_TSL_Tick_Flags
3887                     	xref	_UART2_GetFlagStatus
3888                     	xref	_UART2_SendData8
3889                     	xref	_UART2_ReceiveData8
3890                     	xref	_UART2_Init
3891                     	xref	_GPIO_ReadInputPin
3892                     	xref	_GPIO_WriteReverse
3893                     	xref	_GPIO_WriteLow
3894                     	xref	_GPIO_WriteHigh
3895                     	xref	_GPIO_Init
3896                     	xref	_GPIO_DeInit
3897                     	xref	_CLK_HSIPrescalerConfig
3898                     	xdef	_toggle_io
3899                     	xdef	_toggle_EN_pin
3900                     	xdef	_LCD_goto
3901                     	xdef	_LCD_clear_home
3902                     	xdef	_LCD_putchar
3903                     	xdef	_LCD_putstr
3904                     	xdef	_LCD_4bit_send
3905                     	xdef	_LCD_send
3906                     	xdef	_LCD_init
3907                     	xdef	_LCD_GPIO_init
3908                     	xref.b	c_x
3909                     	xref.b	c_y
3929                     	xref	c_lcmp
3930                     	xref	c_ltor
3931                     	xref	c_lgadc
3932                     	xref	c_xymov
3933                     	xref	c_lzmp
3934                     	xref	c_lgsbc
3935                     	end
