   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
   4                     ; Optimizer V4.5.3 - 16 Jun 2021
  85                     ; 53 void TSL_SetStructPointer(void)
  85                     ; 54 {
  87                     	switch	.text
  88  0000               _TSL_SetStructPointer:
  92                     ; 55   pKeyStruct = &sSCKeyInfo[KeyIndex];
  94  0000 b600          	ld	a,_KeyIndex
  95  0002 97            	ld	xl,a
  96  0003 a60f          	ld	a,#15
  97  0005 42            	mul	x,a
  98  0006 01            	rrwa	x,a
  99  0007 ab00          	add	a,#_sSCKeyInfo
 100  0009 5f            	clrw	x
 101  000a 97            	ld	xl,a
 102  000b bf00          	ldw	_pKeyStruct,x
 103                     ; 56 }
 106  000d 81            	ret	
 132                     ; 69 void TSL_DeltaCalculation(void)
 132                     ; 70 {
 133                     	switch	.text
 134  000e               _TSL_DeltaCalculation:
 138                     ; 83   Delta = (s16)(pKeyStruct->Channel.LastMeas - pKeyStruct->Channel.Reference);
 140  000e be00          	ldw	x,_pKeyStruct
 141  0010 90be00        	ldw	y,_pKeyStruct
 142  0013 ee05          	ldw	x,(5,x)
 143  0015 01            	rrwa	x,a
 144  0016 90e009        	sub	a,(9,y)
 145  0019 01            	rrwa	x,a
 146  001a 90e208        	sbc	a,(8,y)
 147  001d 01            	rrwa	x,a
 148  001e bf00          	ldw	_Delta,x
 149                     ; 85 }
 152  0020 81            	ret	
 178                     ; 99 void TSL_SCKey_SetIdleState(void)
 178                     ; 100 {
 179                     	switch	.text
 180  0021               _TSL_SCKey_SetIdleState:
 184                     ; 101   pKeyStruct->Setting.b.CHANGED = 1;
 186  0021 be00          	ldw	x,_pKeyStruct
 187  0023 e602          	ld	a,(2,x)
 188  0025 aa08          	or	a,#8
 189  0027 e702          	ld	(2,x),a
 190                     ; 102   TSL_SCKey_BackToIdleState();
 193                     ; 103 }
 196  0029 2000          	jp	_TSL_SCKey_BackToIdleState
 221                     ; 117 void TSL_SCKey_BackToIdleState(void)
 221                     ; 118 {
 222                     	switch	.text
 223  002b               _TSL_SCKey_BackToIdleState:
 227                     ; 119   pKeyStruct->State.whole = IDLE_STATE;
 229  002b be00          	ldw	x,_pKeyStruct
 230  002d a602          	ld	a,#2
 231  002f f7            	ld	(x),a
 232                     ; 120   pKeyStruct->Setting.b.DETECTED = 0;
 234  0030 e602          	ld	a,(2,x)
 235                     ; 121   pKeyStruct->Setting.b.LOCKED = 0;
 237                     ; 122   pKeyStruct->Setting.b.ERROR = 0;
 239  0032 a45b          	and	a,#91
 240  0034 e702          	ld	(2,x),a
 241                     ; 123 }
 244  0036 81            	ret	
 270                     ; 137 void TSL_SCKey_SetPreDetectState(void)
 270                     ; 138 {
 271                     	switch	.text
 272  0037               _TSL_SCKey_SetPreDetectState:
 276                     ; 139   pKeyStruct->State.whole = PRE_DETECTED_STATE;
 278  0037 be00          	ldw	x,_pKeyStruct
 279  0039 a614          	ld	a,#20
 280  003b f7            	ld	(x),a
 281                     ; 140   pKeyStruct->Channel.IntegratorCounter = DetectionIntegrator;
 283  003c b600          	ld	a,_DetectionIntegrator
 284  003e e70a          	ld	(10,x),a
 285                     ; 141 }
 288  0040 81            	ret	
 314                     ; 155 void TSL_SCKey_SetDetectedState(void)
 314                     ; 156 {
 315                     	switch	.text
 316  0041               _TSL_SCKey_SetDetectedState:
 320                     ; 157   pKeyStruct->State.whole = DETECTED_STATE;
 322  0041 be00          	ldw	x,_pKeyStruct
 323  0043 a604          	ld	a,#4
 324  0045 f7            	ld	(x),a
 325                     ; 158   pKeyStruct->Setting.b.DETECTED = 1;
 327  0046 e602          	ld	a,(2,x)
 328                     ; 159   pKeyStruct->Setting.b.CHANGED = 1;
 330  0048 aa0c          	or	a,#12
 331  004a e702          	ld	(2,x),a
 332                     ; 160   pKeyStruct->Counter = DetectionTimeout;
 334  004c b600          	ld	a,_DetectionTimeout
 335  004e e703          	ld	(3,x),a
 336                     ; 161 }
 339  0050 81            	ret	
 365                     ; 175 void TSL_SCKey_SetPostDetectState(void)
 365                     ; 176 {
 366                     	switch	.text
 367  0051               _TSL_SCKey_SetPostDetectState:
 371                     ; 177   pKeyStruct->State.whole = POST_DETECTED_STATE;
 373  0051 be00          	ldw	x,_pKeyStruct
 374  0053 a624          	ld	a,#36
 375  0055 f7            	ld	(x),a
 376                     ; 178   pKeyStruct->Channel.IntegratorCounter = EndDetectionIntegrator;
 378  0056 b600          	ld	a,_EndDetectionIntegrator
 379  0058 e70a          	ld	(10,x),a
 380                     ; 179 }
 383  005a 81            	ret	
 408                     ; 193 void TSL_SCKey_BackToDetectedState(void)
 408                     ; 194 {
 409                     	switch	.text
 410  005b               _TSL_SCKey_BackToDetectedState:
 414                     ; 195   pKeyStruct->State.whole = DETECTED_STATE;
 416  005b a604          	ld	a,#4
 417  005d 92c700        	ld	[_pKeyStruct.w],a
 418                     ; 196 }
 421  0060 81            	ret	
 447                     ; 210 void TSL_SCKey_SetPreRecalibrationState(void)
 447                     ; 211 {
 448                     	switch	.text
 449  0061               _TSL_SCKey_SetPreRecalibrationState:
 453                     ; 212   pKeyStruct->State.whole = PRE_CALIBRATION_STATE;
 455  0061 be00          	ldw	x,_pKeyStruct
 456  0063 a611          	ld	a,#17
 457  0065 f7            	ld	(x),a
 458                     ; 213   pKeyStruct->Channel.IntegratorCounter = RecalibrationIntegrator;
 460  0066 b600          	ld	a,_RecalibrationIntegrator
 461  0068 e70a          	ld	(10,x),a
 462                     ; 214 }
 465  006a 81            	ret	
 490                     ; 228 void TSL_SCKey_SetCalibrationState(void)
 490                     ; 229 {
 491                     	switch	.text
 492  006b               _TSL_SCKey_SetCalibrationState:
 496                     ; 230   pKeyStruct->State.whole = CALIBRATION_STATE;
 498  006b be00          	ldw	x,_pKeyStruct
 499  006d a601          	ld	a,#1
 500  006f f7            	ld	(x),a
 501                     ; 231   pKeyStruct->Setting.b.DETECTED = 0;
 503  0070 e602          	ld	a,(2,x)
 504                     ; 232   pKeyStruct->Setting.b.CHANGED = 1;
 506  0072 a45b          	and	a,#91
 507  0074 aa08          	or	a,#8
 508                     ; 233   pKeyStruct->Setting.b.LOCKED = 0;
 510                     ; 234   pKeyStruct->Setting.b.ERROR = 0;
 512  0076 e702          	ld	(2,x),a
 513                     ; 235   pKeyStruct->Counter = SCKEY_CALIBRATION_COUNT_DEFAULT;
 515  0078 a608          	ld	a,#8
 516  007a e703          	ld	(3,x),a
 517                     ; 236   pKeyStruct->Channel.Reference = 0;
 519  007c 905f          	clrw	y
 520  007e ef08          	ldw	(8,x),y
 521                     ; 237 }
 524  0080 81            	ret	
 549                     ; 251 void TSL_SCKey_SetErrorState(void)
 549                     ; 252 {
 550                     	switch	.text
 551  0081               _TSL_SCKey_SetErrorState:
 555                     ; 253   pKeyStruct->State.whole = ERROR_STATE;
 557  0081 be00          	ldw	x,_pKeyStruct
 558  0083 a608          	ld	a,#8
 559  0085 f7            	ld	(x),a
 560                     ; 254   pKeyStruct->Setting.b.DETECTED = 0;
 562  0086 e602          	ld	a,(2,x)
 563                     ; 255   pKeyStruct->Setting.b.CHANGED = 1;
 565  0088 a47b          	and	a,#123
 566                     ; 256   pKeyStruct->Setting.b.LOCKED = 0;
 568                     ; 257   pKeyStruct->Setting.b.ERROR = 1;
 570  008a aa28          	or	a,#40
 571  008c e702          	ld	(2,x),a
 572                     ; 258 }
 575  008e 81            	ret	
 600                     ; 272 void TSL_SCKey_SetDisabledState(void)
 600                     ; 273 {
 601                     	switch	.text
 602  008f               _TSL_SCKey_SetDisabledState:
 606                     ; 274   pKeyStruct->State.whole = DISABLED_STATE;
 608  008f be00          	ldw	x,_pKeyStruct
 609  0091 a680          	ld	a,#128
 610  0093 f7            	ld	(x),a
 611                     ; 275   pKeyStruct->Setting.b.DETECTED = 0;
 613  0094 e602          	ld	a,(2,x)
 614                     ; 276   pKeyStruct->Setting.b.CHANGED = 1;
 616  0096 a45b          	and	a,#91
 617  0098 aa08          	or	a,#8
 618                     ; 277   pKeyStruct->Setting.b.LOCKED = 0;
 620                     ; 278   pKeyStruct->Setting.b.ERROR = 0;
 622  009a e702          	ld	(2,x),a
 623                     ; 279 }
 626  009c 81            	ret	
 713                     ; 295 void TSL_ECS(void)
 713                     ; 296 {
 714                     	switch	.text
 715  009d               _TSL_ECS:
 717  009d 520b          	subw	sp,#11
 718       0000000b      OFST:	set	11
 721                     ; 302   disableInterrupts();
 724  009f 9b            	sim	
 726                     ; 303   Local_TickECS10ms = TSL_TickCount_ECS_10ms;
 729  00a0 450000        	mov	_Local_TickECS10ms,_TSL_TickCount_ECS_10ms
 730                     ; 304   TSL_TickCount_ECS_10ms = 0;
 732  00a3 3f00          	clr	_TSL_TickCount_ECS_10ms
 733                     ; 305   enableInterrupts();
 736  00a5 9a            	rim	
 740  00a6 cc0185        	jra	L522
 741  00a9               L322:
 742                     ; 309     ECSTimeStepCounter--;
 744  00a9 3a00          	dec	_ECSTimeStepCounter
 745                     ; 310     ECSTempoPrescaler--;
 747  00ab 3a00          	dec	_ECSTempoPrescaler
 748                     ; 311     if (!ECSTempoPrescaler)
 750  00ad 260a          	jrne	L132
 751                     ; 313       ECSTempoPrescaler = 10;
 753  00af 350a0000      	mov	_ECSTempoPrescaler,#10
 754                     ; 314       if (ECSTempoCounter)
 756  00b3 b600          	ld	a,_ECSTempoCounter
 757  00b5 2702          	jreq	L132
 758                     ; 315         ECSTempoCounter--;
 760  00b7 3a00          	dec	_ECSTempoCounter
 761  00b9               L132:
 762                     ; 318     K_Filter = ECS_K_Slow;   // Default case !
 764  00b9 b600          	ld	a,_ECS_K_Slow
 765  00bb 6b05          	ld	(OFST-6,sp),a
 767                     ; 319     ECS_Fast_Enable = 1;
 769  00bd a601          	ld	a,#1
 770  00bf 6b07          	ld	(OFST-4,sp),a
 772                     ; 320     ECS_Fast_Direction = 0;
 774  00c1 0f06          	clr	(OFST-5,sp)
 776                     ; 322     for (KeyIndex = 0; KeyIndex < NUMBER_OF_SINGLE_CHANNEL_KEYS; KeyIndex++)
 778  00c3 3f00          	clr	_KeyIndex
 779  00c5               L532:
 780                     ; 324       TSL_SetStructPointer();
 782  00c5 cd0000        	call	_TSL_SetStructPointer
 784                     ; 326       if ((pKeyStruct->State.whole == PRE_DETECTED_STATE) || (pKeyStruct->State.whole == DETECTED_STATE) || (pKeyStruct->State.whole == POST_DETECTED_STATE))
 786  00c8 92c600        	ld	a,[_pKeyStruct.w]
 787  00cb a114          	cp	a,#20
 788  00cd 2708          	jreq	L542
 790  00cf a104          	cp	a,#4
 791  00d1 2704          	jreq	L542
 793  00d3 a124          	cp	a,#36
 794  00d5 2618          	jrne	L342
 795  00d7               L542:
 796                     ; 328         ECSTempoCounter = ECSTemporization;    // Restart temporization counter ...
 798  00d7 450000        	mov	_ECSTempoCounter,_ECSTemporization
 799                     ; 329         break;           // Out from the for loop
 800  00da               L142:
 801                     ; 401     if (!ECSTimeStepCounter && !ECSTempoCounter)
 803  00da b600          	ld	a,_ECSTimeStepCounter
 804  00dc 26c8          	jrne	L522
 806  00de b600          	ld	a,_ECSTempoCounter
 807  00e0 26c4          	jrne	L522
 808                     ; 403       ECSTimeStepCounter = ECSTimeStep;
 810  00e2 450000        	mov	_ECSTimeStepCounter,_ECSTimeStep
 811                     ; 405       if (ECS_Fast_Enable)
 813  00e5 7b07          	ld	a,(OFST-4,sp)
 814  00e7 272e          	jreq	L572
 815                     ; 407         K_Filter = ECS_K_Fast;
 817  00e9 b600          	ld	a,_ECS_K_Fast
 818  00eb 6b05          	ld	(OFST-6,sp),a
 820  00ed 2028          	jra	L572
 821  00ef               L342:
 822                     ; 331       if (pKeyStruct->State.whole == IDLE_STATE)
 824  00ef a102          	cp	a,#2
 825  00f1 261e          	jrne	L152
 826                     ; 333         TSL_DeltaCalculation();
 828  00f3 cd000e        	call	_TSL_DeltaCalculation
 830                     ; 334         if (Delta == 0)    // No Fast ECS !
 832  00f6 be00          	ldw	x,_Delta
 833                     ; 335           ECS_Fast_Enable = 0;
 835  00f8 270f          	jreq	LC002
 836                     ; 338           if (Delta < 0)
 838  00fa 2a09          	jrpl	L752
 839                     ; 340             if (ECS_Fast_Direction > 0)    // No Fast ECS !
 841  00fc 7b06          	ld	a,(OFST-5,sp)
 842  00fe 9c            	rvf	
 843                     ; 341               ECS_Fast_Enable = 0;
 845  00ff 2c08          	jrsgt	LC002
 846                     ; 343               ECS_Fast_Direction = -1;
 848  0101 a6ff          	ld	a,#255
 849  0103 200a          	jp	LC001
 850  0105               L752:
 851                     ; 347             if (ECS_Fast_Direction < 0)    // No Fast ECS !
 853  0105 7b06          	ld	a,(OFST-5,sp)
 854  0107 2a04          	jrpl	L762
 855                     ; 348               ECS_Fast_Enable = 0;
 857  0109               LC002:
 860  0109 0f07          	clr	(OFST-4,sp)
 863  010b 2004          	jra	L152
 864  010d               L762:
 865                     ; 350               ECS_Fast_Direction = + 1;
 867  010d a601          	ld	a,#1
 868  010f               LC001:
 869  010f 6b06          	ld	(OFST-5,sp),a
 871  0111               L152:
 872                     ; 322     for (KeyIndex = 0; KeyIndex < NUMBER_OF_SINGLE_CHANNEL_KEYS; KeyIndex++)
 874  0111 3c00          	inc	_KeyIndex
 877  0113 27b0          	jreq	L532
 878  0115 20c3          	jra	L142
 879  0117               L572:
 880                     ; 410       K_Filter_Complement = (u8)((0xFF ^ K_Filter) + 1);
 882  0117 7b05          	ld	a,(OFST-6,sp)
 883  0119 43            	cpl	a
 884  011a 4c            	inc	a
 885  011b 6b07          	ld	(OFST-4,sp),a
 887                     ; 412       if (K_Filter)
 889  011d 7b05          	ld	a,(OFST-6,sp)
 890  011f 2764          	jreq	L522
 891                     ; 416         for (KeyIndex = 0; KeyIndex < NUMBER_OF_SINGLE_CHANNEL_KEYS; KeyIndex++)
 893  0121 3f00          	clr	_KeyIndex
 894  0123               L103:
 895                     ; 418           TSL_SetStructPointer();
 897  0123 cd0000        	call	_TSL_SetStructPointer
 899                     ; 419           if (pKeyStruct->State.whole == IDLE_STATE)
 901  0126 be00          	ldw	x,_pKeyStruct
 902  0128 f6            	ld	a,(x)
 903  0129 a102          	cp	a,#2
 904  012b 2654          	jrne	L703
 905                     ; 421             IIR_Result = ((u32)(pKeyStruct->Channel.Reference) << 8) + pKeyStruct->Channel.ECSRefRest;
 907  012d ee08          	ldw	x,(8,x)
 908  012f 90ae0100      	ldw	y,#256
 909  0133 cd0000        	call	c_umul
 911  0136 be00          	ldw	x,_pKeyStruct
 912  0138 e60b          	ld	a,(11,x)
 913  013a cd0000        	call	c_ladc
 915  013d 96            	ldw	x,sp
 916  013e 1c0008        	addw	x,#OFST-3
 917  0141 cd0000        	call	c_rtol
 920                     ; 422             IIR_Result = K_Filter_Complement * IIR_Result;
 922  0144 7b07          	ld	a,(OFST-4,sp)
 923  0146 b703          	ld	c_lreg+3,a
 924  0148 3f02          	clr	c_lreg+2
 925  014a 3f01          	clr	c_lreg+1
 926  014c 3f00          	clr	c_lreg
 927  014e 96            	ldw	x,sp
 928  014f 1c0008        	addw	x,#OFST-3
 929  0152 cd0000        	call	c_lgmul
 932                     ; 423             IIR_Result += K_Filter * ((u32)(pKeyStruct->Channel.LastMeas) << 8);
 934  0155 7b05          	ld	a,(OFST-6,sp)
 935  0157 b703          	ld	c_lreg+3,a
 936  0159 3f02          	clr	c_lreg+2
 937  015b 3f01          	clr	c_lreg+1
 938  015d 3f00          	clr	c_lreg
 939  015f 96            	ldw	x,sp
 940  0160 5c            	incw	x
 941  0161 cd0000        	call	c_rtol
 944  0164 be00          	ldw	x,_pKeyStruct
 945  0166 ee05          	ldw	x,(5,x)
 946  0168 cd0000        	call	c_umul
 948  016b 96            	ldw	x,sp
 949  016c 5c            	incw	x
 950  016d cd0000        	call	c_lmul
 952  0170 96            	ldw	x,sp
 953  0171 1c0008        	addw	x,#OFST-3
 954  0174 cd0000        	call	c_lgadd
 957                     ; 424             pKeyStruct->Channel.Reference = (u16)(IIR_Result >> 16);
 959  0177 be00          	ldw	x,_pKeyStruct
 960  0179 1608          	ldw	y,(OFST-3,sp)
 961  017b ef08          	ldw	(8,x),y
 962                     ; 425             pKeyStruct->Channel.ECSRefRest = (u8)(IIR_Result >> 8);
 964  017d 7b0a          	ld	a,(OFST-1,sp)
 965  017f e70b          	ld	(11,x),a
 966  0181               L703:
 967                     ; 416         for (KeyIndex = 0; KeyIndex < NUMBER_OF_SINGLE_CHANNEL_KEYS; KeyIndex++)
 969  0181 3c00          	inc	_KeyIndex
 972  0183 279e          	jreq	L103
 973  0185               L522:
 974                     ; 307   while (Local_TickECS10ms--)
 976  0185 b600          	ld	a,_Local_TickECS10ms
 977  0187 3a00          	dec	_Local_TickECS10ms
 978  0189 4d            	tnz	a
 979  018a 2703cc00a9    	jrne	L322
 980                     ; 449 }
 983  018f 5b0b          	addw	sp,#11
 984  0191 81            	ret	
1030                     ; 464 void TSL_SCKey_DxS(void)
1030                     ; 465 {
1031                     	switch	.text
1032  0192               _TSL_SCKey_DxS:
1034  0192 89            	pushw	x
1035       00000002      OFST:	set	2
1038                     ; 468   if (pKeyStruct->Setting.b.LOCKED)
1040  0193 be00          	ldw	x,_pKeyStruct
1041  0195 e602          	ld	a,(2,x)
1042  0197 2b1e          	jrmi	L25
1043                     ; 469     return;
1045                     ; 471   DxSGroupMask = pKeyStruct->DxSGroup;
1047  0199 e604          	ld	a,(4,x)
1048  019b 6b01          	ld	(OFST-1,sp),a
1050                     ; 473   for (KeyToCheck = 0; KeyToCheck < NUMBER_OF_SINGLE_CHANNEL_KEYS; KeyToCheck++)
1052  019d 0f02          	clr	(OFST+0,sp)
1054  019f               L733:
1055                     ; 475     if (KeyToCheck != KeyIndex)
1057  019f 7b02          	ld	a,(OFST+0,sp)
1058  01a1 b100          	cp	a,_KeyIndex
1059  01a3 2714          	jreq	L543
1060                     ; 478       if (sSCKeyInfo[KeyToCheck].DxSGroup & DxSGroupMask)
1062  01a5 97            	ld	xl,a
1063  01a6 a60f          	ld	a,#15
1064  01a8 42            	mul	x,a
1065  01a9 e604          	ld	a,(_sSCKeyInfo+4,x)
1066  01ab 1501          	bcp	a,(OFST-1,sp)
1067  01ad 270a          	jreq	L543
1068                     ; 480         if (sSCKeyInfo[KeyToCheck].Setting.b.LOCKED)
1070  01af e602          	ld	a,(_sSCKeyInfo+2,x)
1071  01b1 2a06          	jrpl	L543
1072                     ; 482           goto ExitToIdle;
1073                     ; 505 ExitToIdle:   // The DxS is verified at PRE DETECT state only !
1073                     ; 506   pKeyStruct->Channel.IntegratorCounter++;  // Increment integrator to never allow DETECT state
1075  01b3 be00          	ldw	x,_pKeyStruct
1076  01b5 6c0a          	inc	(10,x)
1077                     ; 507   return;
1078  01b7               L25:
1081  01b7 85            	popw	x
1082  01b8 81            	ret	
1083  01b9               L543:
1084                     ; 473   for (KeyToCheck = 0; KeyToCheck < NUMBER_OF_SINGLE_CHANNEL_KEYS; KeyToCheck++)
1086  01b9 0c02          	inc	(OFST+0,sp)
1090  01bb 27e2          	jreq	L733
1091                     ; 502   pKeyStruct->Setting.b.LOCKED = 1;
1093  01bd be00          	ldw	x,_pKeyStruct
1094  01bf e602          	ld	a,(2,x)
1095  01c1 aa80          	or	a,#128
1096  01c3 e702          	ld	(2,x),a
1097                     ; 503   return;
1099  01c5 20f0          	jra	L25
1127                     ; 521 void TSL_SCKey_DetectionTimeout(void)
1127                     ; 522 {
1128                     	switch	.text
1129  01c7               _TSL_SCKey_DetectionTimeout:
1133                     ; 523   if (Local_TickFlag.b.DTO_1sec)
1135  01c7 720100000d    	btjf	_Local_TickFlag,#0,L363
1136                     ; 525     if (DetectionTimeout)
1138  01cc b600          	ld	a,_DetectionTimeout
1139  01ce 2709          	jreq	L363
1140                     ; 527       pKeyStruct->Counter--;
1142  01d0 be00          	ldw	x,_pKeyStruct
1143  01d2 6a03          	dec	(3,x)
1144                     ; 528       if (!pKeyStruct->Counter)
1146  01d4 2603          	jrne	L363
1147                     ; 530         TSL_SCKey_SetCalibrationState();
1149  01d6 cd006b        	call	_TSL_SCKey_SetCalibrationState
1151  01d9               L363:
1152                     ; 534 }
1155  01d9 81            	ret	
1168                     	xdef	_TSL_SCKey_DetectionTimeout
1169                     	xdef	_TSL_SCKey_DxS
1170                     	xdef	_TSL_ECS
1171                     	xdef	_TSL_SCKey_SetDisabledState
1172                     	xdef	_TSL_SCKey_SetErrorState
1173                     	xdef	_TSL_SCKey_SetCalibrationState
1174                     	xdef	_TSL_SCKey_SetPreRecalibrationState
1175                     	xdef	_TSL_SCKey_BackToDetectedState
1176                     	xdef	_TSL_SCKey_SetPostDetectState
1177                     	xdef	_TSL_SCKey_SetDetectedState
1178                     	xdef	_TSL_SCKey_SetPreDetectState
1179                     	xdef	_TSL_SCKey_BackToIdleState
1180                     	xdef	_TSL_SCKey_SetIdleState
1181                     	xdef	_TSL_DeltaCalculation
1182                     	xdef	_TSL_SetStructPointer
1183                     	xref.b	_ECSTempoPrescaler
1184                     	xref.b	_ECSTempoCounter
1185                     	xref.b	_ECSTimeStepCounter
1186                     	xref.b	_Local_TickFlag
1187                     	xref.b	_Local_TickECS10ms
1188                     	xref.b	_Delta
1189                     	xref.b	_KeyIndex
1190                     	xref.b	_ECS_K_Slow
1191                     	xref.b	_ECS_K_Fast
1192                     	xref.b	_ECSTemporization
1193                     	xref.b	_ECSTimeStep
1194                     	xref.b	_RecalibrationIntegrator
1195                     	xref.b	_EndDetectionIntegrator
1196                     	xref.b	_DetectionIntegrator
1197                     	xref.b	_DetectionTimeout
1198                     	xref.b	_sSCKeyInfo
1199                     	xref.b	_pKeyStruct
1200                     	xref.b	_TSL_TickCount_ECS_10ms
1201                     	xref.b	c_lreg
1202                     	xref.b	c_x
1203                     	xref.b	c_y
1222                     	xref	c_lgadd
1223                     	xref	c_lmul
1224                     	xref	c_lgmul
1225                     	xref	c_rtol
1226                     	xref	c_ladc
1227                     	xref	c_umul
1228                     	end
