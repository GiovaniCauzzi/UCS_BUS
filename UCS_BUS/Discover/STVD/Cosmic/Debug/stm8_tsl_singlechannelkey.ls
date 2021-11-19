   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
   4                     ; Optimizer V4.5.3 - 16 Jun 2021
  84                     ; 53 void TSL_SCKey_Init(void)
  84                     ; 54 {
  86                     	switch	.text
  87  0000               _TSL_SCKey_Init:
  91                     ; 55   for (KeyIndex = 0; KeyIndex < NUMBER_OF_SINGLE_CHANNEL_KEYS; KeyIndex++)
  93  0000 3f00          	clr	_KeyIndex
  94  0002               L53:
  95                     ; 57     TSL_SetStructPointer();
  97  0002 cd0000        	call	_TSL_SetStructPointer
  99                     ; 58     pKeyStruct->State.whole = DISABLED_STATE;
 101  0005 be00          	ldw	x,_pKeyStruct
 102  0007 a680          	ld	a,#128
 103  0009 f7            	ld	(x),a
 104                     ; 59     pKeyStruct->DetectThreshold = SCKEY_DETECTTHRESHOLD_DEFAULT;
 106  000a a60f          	ld	a,#15
 107  000c e70c          	ld	(12,x),a
 108                     ; 60     pKeyStruct->EndDetectThreshold = SCKEY_ENDDETECTTHRESHOLD_DEFAULT;
 110  000e a606          	ld	a,#6
 111  0010 e70d          	ld	(13,x),a
 112                     ; 61     pKeyStruct->RecalibrationThreshold = SCKEY_RECALIBRATIONTHRESHOLD_DEFAULT;
 114  0012 a6fa          	ld	a,#250
 115  0014 e70e          	ld	(14,x),a
 116                     ; 55   for (KeyIndex = 0; KeyIndex < NUMBER_OF_SINGLE_CHANNEL_KEYS; KeyIndex++)
 118  0016 3c00          	inc	_KeyIndex
 121  0018 27e8          	jreq	L53
 122                     ; 63 }
 125  001a 81            	ret	
 156                     ; 76 void TSL_SCKEY_P1_Acquisition(void)
 156                     ; 77 {
 157                     	switch	.text
 158  001b               _TSL_SCKEY_P1_Acquisition:
 162                     ; 120   sTouchIO.PORT_ADDR = (GPIO_TypeDef *)(SCKEY_P1_PORT_ADDR);
 164  001b ae500a        	ldw	x,#20490
 165  001e bf00          	ldw	_sTouchIO,x
 166                     ; 121   for (KeyIndex = 0; KeyIndex < SCKEY_P1_KEY_COUNT; KeyIndex++)
 168  0020 3f00          	clr	_KeyIndex
 169  0022               L35:
 170                     ; 123     TSL_SetStructPointer();
 172  0022 cd0000        	call	_TSL_SetStructPointer
 174                     ; 124     if ((pKeyStruct->State.whole != ERROR_STATE) && (pKeyStruct->State.whole != DISABLED_STATE))
 176  0025 92c600        	ld	a,[_pKeyStruct.w]
 177  0028 a108          	cp	a,#8
 178  002a 2733          	jreq	L16
 180  002c a180          	cp	a,#128
 181  002e 272f          	jreq	L16
 182                     ; 126       sTouchIO.AcqMask = Table_SCKEY_BITS[KeyIndex];
 184  0030 b600          	ld	a,_KeyIndex
 185  0032 5f            	clrw	x
 186  0033 97            	ld	xl,a
 187  0034 d60000        	ld	a,(_Table_SCKEY_BITS,x)
 188  0037 b702          	ld	_sTouchIO+2,a
 189                     ; 127       sTouchIO.DriveMask = (u8)(sTouchIO.AcqMask | SCKEY_P1_DRIVEN_SHIELD_MASK);
 191  0039 aa08          	or	a,#8
 192  003b b703          	ld	_sTouchIO+3,a
 193                     ; 128       sTouchIO.Measurement = &sSCKeyInfo[KeyIndex].Channel.LastMeas;
 195  003d b600          	ld	a,_KeyIndex
 196  003f 97            	ld	xl,a
 197  0040 a60f          	ld	a,#15
 198  0042 42            	mul	x,a
 199  0043 01            	rrwa	x,a
 200  0044 ab05          	add	a,#_sSCKeyInfo+5
 201  0046 5f            	clrw	x
 202  0047 97            	ld	xl,a
 203  0048 bf04          	ldw	_sTouchIO+4,x
 204                     ; 129       sTouchIO.RejectedNb = &sSCKeyInfo[KeyIndex].Channel.LastMeasRejectNb;
 206  004a b600          	ld	a,_KeyIndex
 207  004c 97            	ld	xl,a
 208  004d a60f          	ld	a,#15
 209  004f 42            	mul	x,a
 210  0050 01            	rrwa	x,a
 211  0051 ab07          	add	a,#_sSCKeyInfo+7
 212  0053 5f            	clrw	x
 213  0054 97            	ld	xl,a
 214  0055 bf06          	ldw	_sTouchIO+6,x
 215                     ; 130       sTouchIO.Type = SCKEY_TYPE;
 217  0057 3f08          	clr	_sTouchIO+8
 218                     ; 131       TSL_IO_Acquisition(SCKEY_ACQ_NUM, SCKEY_ADJUST_LEVEL);
 220  0059 ae0301        	ldw	x,#769
 221  005c cd0000        	call	_TSL_IO_Acquisition
 223  005f               L16:
 224                     ; 121   for (KeyIndex = 0; KeyIndex < SCKEY_P1_KEY_COUNT; KeyIndex++)
 226  005f 3c00          	inc	_KeyIndex
 229  0061 27bf          	jreq	L35
 230                     ; 135 }
 233  0063 81            	ret	
 271                     ; 296 void TSL_SCKey_Process(void)
 271                     ; 297 {
 272                     	switch	.text
 273  0064               _TSL_SCKey_Process:
 277                     ; 298   TSL_SetStructPointer();
 279  0064 cd0000        	call	_TSL_SetStructPointer
 281                     ; 300   TSL_DeltaCalculation();
 283  0067 cd0000        	call	_TSL_DeltaCalculation
 285                     ; 302   switch (pKeyStruct->State.whole)
 287  006a 92c600        	ld	a,[_pKeyStruct.w]
 289                     ; 353       break;
 290  006d 4a            	dec	a
 291  006e 274a          	jreq	L57
 292  0070 4a            	dec	a
 293  0071 271a          	jreq	L36
 294  0073 a002          	sub	a,#2
 295  0075 2729          	jreq	L76
 296  0077 a004          	sub	a,#4
 297  0079 274d          	jreq	L77
 298  007b a009          	sub	a,#9
 299  007d 2736          	jreq	L37
 300  007f a003          	sub	a,#3
 301  0081 2719          	jreq	L56
 302  0083 a010          	sub	a,#16
 303  0085 2729          	jreq	L17
 304  0087 a05c          	sub	a,#92
 305  0089 2742          	jreq	L101
 306  008b               L721:
 308  008b 20fe          	jra	L721
 309  008d               L36:
 310                     ; 305     case IDLE_STATE:
 310                     ; 306       if (TSL_SCKey_CheckErrorCondition())
 312  008d cd0224        	call	_TSL_SCKey_CheckErrorCondition
 314  0090 4d            	tnz	a
 315  0091 2705          	jreq	L121
 316                     ; 308         TSL_SCKey_SetErrorState();
 318  0093 cd0000        	call	_TSL_SCKey_SetErrorState
 320                     ; 309         break;
 322  0096 2038          	jra	L711
 323  0098               L121:
 324                     ; 311       TSL_SCKey_IdleTreatment();
 326  0098 ad51          	call	_TSL_SCKey_IdleTreatment
 328                     ; 312       TSL_SCKey_CheckDisabled();
 330                     ; 313       break;
 332  009a 202c          	jp	L77
 333  009c               L56:
 334                     ; 315     case PRE_DETECTED_STATE:
 334                     ; 316       TSL_SCKey_PreDetectTreatment();
 336  009c ad7e          	call	_TSL_SCKey_PreDetectTreatment
 338                     ; 317       break;
 340  009e 2030          	jra	L711
 341  00a0               L76:
 342                     ; 319     case DETECTED_STATE:
 342                     ; 320       if (TSL_SCKey_CheckErrorCondition())
 344  00a0 cd0224        	call	_TSL_SCKey_CheckErrorCondition
 346  00a3 4d            	tnz	a
 347  00a4 2705          	jreq	L321
 348                     ; 322         TSL_SCKey_SetErrorState();
 350  00a6 cd0000        	call	_TSL_SCKey_SetErrorState
 352                     ; 323         break;
 354  00a9 2025          	jra	L711
 355  00ab               L321:
 356                     ; 325       TSL_SCKey_DetectedTreatment();
 358  00ab cd014e        	call	_TSL_SCKey_DetectedTreatment
 360                     ; 326       TSL_SCKey_CheckDisabled();
 362                     ; 327       break;
 364  00ae 2018          	jp	L77
 365  00b0               L17:
 366                     ; 329     case POST_DETECTED_STATE:
 366                     ; 330       TSL_SCKey_PostDetectTreatment();
 368  00b0 cd018a        	call	_TSL_SCKey_PostDetectTreatment
 370                     ; 331       break;
 372  00b3 201b          	jra	L711
 373  00b5               L37:
 374                     ; 333     case PRE_CALIBRATION_STATE:
 374                     ; 334       TSL_SCKey_PreRecalibrationTreatment();
 376  00b5 cd01c2        	call	_TSL_SCKey_PreRecalibrationTreatment
 378                     ; 335       break;
 380  00b8 2016          	jra	L711
 381  00ba               L57:
 382                     ; 337     case CALIBRATION_STATE:
 382                     ; 338       if (TSL_SCKey_CheckErrorCondition())
 384  00ba cd0224        	call	_TSL_SCKey_CheckErrorCondition
 386  00bd 4d            	tnz	a
 387  00be 2705          	jreq	L521
 388                     ; 340         TSL_SCKey_SetErrorState();
 390  00c0 cd0000        	call	_TSL_SCKey_SetErrorState
 392                     ; 341         break;
 394  00c3 200b          	jra	L711
 395  00c5               L521:
 396                     ; 343       TSL_SCKey_CalibrationTreatment();
 398  00c5 cd01e3        	call	_TSL_SCKey_CalibrationTreatment
 400                     ; 344       TSL_SCKey_CheckDisabled();
 402                     ; 345       break;
 404  00c8               L77:
 405                     ; 347     case ERROR_STATE:
 405                     ; 348       TSL_SCKey_CheckDisabled();
 410  00c8 cd0208        	call	_TSL_SCKey_CheckDisabled
 412                     ; 349       break;
 414  00cb 2003          	jra	L711
 415  00cd               L101:
 416                     ; 351     case DISABLED_STATE:
 416                     ; 352       TSL_SCKey_CheckEnabled();
 418  00cd cd0214        	call	_TSL_SCKey_CheckEnabled
 420                     ; 353       break;
 422  00d0               L711:
 423                     ; 363   TSL_TempGlobalSetting.whole |= pKeyStruct->Setting.whole;
 425  00d0 be00          	ldw	x,_pKeyStruct
 426  00d2 ee01          	ldw	x,(1,x)
 427  00d4 01            	rrwa	x,a
 428  00d5 ba01          	or	a,_TSL_TempGlobalSetting+1
 429  00d7 01            	rrwa	x,a
 430  00d8 ba00          	or	a,_TSL_TempGlobalSetting
 431  00da 01            	rrwa	x,a
 432  00db bf00          	ldw	_TSL_TempGlobalSetting,x
 433                     ; 364   TSL_TempGlobalState.whole |= pKeyStruct->State.whole;
 435  00dd be00          	ldw	x,_pKeyStruct
 436  00df b600          	ld	a,_TSL_TempGlobalState
 437  00e1 fa            	or	a,(x)
 438  00e2 b700          	ld	_TSL_TempGlobalState,a
 439                     ; 365   pKeyStruct->Setting.b.CHANGED = 0;
 441  00e4 e602          	ld	a,(2,x)
 442  00e6 a4f7          	and	a,#247
 443  00e8 e702          	ld	(2,x),a
 444                     ; 366 }
 447  00ea 81            	ret	
 476                     ; 379 void TSL_SCKey_IdleTreatment(void)
 476                     ; 380 {
 477                     	switch	.text
 478  00eb               _TSL_SCKey_IdleTreatment:
 482                     ; 383   if (pKeyStruct->Channel.LastMeasRejectNb > MAX_REJECTED_MEASUREMENTS)
 484  00eb be00          	ldw	x,_pKeyStruct
 485  00ed e607          	ld	a,(7,x)
 486  00ef a115          	cp	a,#21
 487  00f1 2501          	jrult	L341
 488                     ; 385     return;
 491  00f3 81            	ret	
 492  00f4               L341:
 493                     ; 400   if ((Delta >= pKeyStruct->DetectThreshold) || (Delta <= pKeyStruct->RecalibrationThreshold))
 495  00f4 e60c          	ld	a,(12,x)
 496  00f6 5f            	clrw	x
 497  00f7 4d            	tnz	a
 498  00f8 2a01          	jrpl	L47
 499  00fa 53            	cplw	x
 500  00fb               L47:
 501  00fb 97            	ld	xl,a
 502  00fc b300          	cpw	x,_Delta
 503  00fe 2d0e          	jrsle	L741
 505  0100 be00          	ldw	x,_pKeyStruct
 506  0102 e60e          	ld	a,(14,x)
 507  0104 5f            	clrw	x
 508  0105 4d            	tnz	a
 509  0106 2a01          	jrpl	L67
 510  0108 53            	cplw	x
 511  0109               L67:
 512  0109 97            	ld	xl,a
 513  010a b300          	cpw	x,_Delta
 514  010c 2f0d          	jrslt	L541
 515  010e               L741:
 516                     ; 403     TSL_SCKey_SetPreDetectState();
 518  010e cd0000        	call	_TSL_SCKey_SetPreDetectState
 520                     ; 404     if (!DetectionIntegrator)
 522  0111 b600          	ld	a,_DetectionIntegrator
 523  0113 2606          	jrne	L541
 524                     ; 406       pKeyStruct->Channel.IntegratorCounter++;
 526  0115 be00          	ldw	x,_pKeyStruct
 527  0117 6c0a          	inc	(10,x)
 528                     ; 407       TSL_SCKey_PreDetectTreatment();
 530  0119 ad01          	call	_TSL_SCKey_PreDetectTreatment
 532  011b               L541:
 533                     ; 410 }
 536  011b 81            	ret	
 565                     ; 423 void TSL_SCKey_PreDetectTreatment(void)
 565                     ; 424 {
 566                     	switch	.text
 567  011c               _TSL_SCKey_PreDetectTreatment:
 571                     ; 435   if ((pKeyStruct->Channel.LastMeasRejectNb <= MAX_REJECTED_MEASUREMENTS) &&
 571                     ; 436       ((Delta >= pKeyStruct->DetectThreshold) || (Delta <= pKeyStruct->RecalibrationThreshold)))
 573  011c be00          	ldw	x,_pKeyStruct
 574  011e e607          	ld	a,(7,x)
 575  0120 a115          	cp	a,#21
 576  0122 2426          	jruge	L361
 578  0124 e60c          	ld	a,(12,x)
 579  0126 5f            	clrw	x
 580  0127 4d            	tnz	a
 581  0128 2a01          	jrpl	L601
 582  012a 53            	cplw	x
 583  012b               L601:
 584  012b 97            	ld	xl,a
 585  012c b300          	cpw	x,_Delta
 586  012e 2d0e          	jrsle	L561
 588  0130 be00          	ldw	x,_pKeyStruct
 589  0132 e60e          	ld	a,(14,x)
 590  0134 5f            	clrw	x
 591  0135 4d            	tnz	a
 592  0136 2a01          	jrpl	L011
 593  0138 53            	cplw	x
 594  0139               L011:
 595  0139 97            	ld	xl,a
 596  013a b300          	cpw	x,_Delta
 597  013c 2f0c          	jrslt	L361
 598  013e               L561:
 599                     ; 442     TSL_SCKey_DxS();
 601  013e cd0000        	call	_TSL_SCKey_DxS
 603                     ; 443     pKeyStruct->Channel.IntegratorCounter--;
 605  0141 be00          	ldw	x,_pKeyStruct
 606  0143 6a0a          	dec	(10,x)
 607                     ; 444     if (!pKeyStruct->Channel.IntegratorCounter)
 609  0145 2606          	jrne	L171
 610                     ; 446       TSL_SCKey_SetDetectedState();
 614  0147 cc0000        	jp	_TSL_SCKey_SetDetectedState
 615  014a               L361:
 616                     ; 451     TSL_SCKey_BackToIdleState();
 618  014a cd0000        	call	_TSL_SCKey_BackToIdleState
 620                     ; 452     return;
 623  014d               L171:
 624                     ; 454 }
 627  014d 81            	ret	
 657                     ; 467 void TSL_SCKey_DetectedTreatment(void)
 657                     ; 468 {
 658                     	switch	.text
 659  014e               _TSL_SCKey_DetectedTreatment:
 663                     ; 478   if ((pKeyStruct->Channel.LastMeasRejectNb <= MAX_REJECTED_MEASUREMENTS) &&
 663                     ; 479       (((Delta <= pKeyStruct->EndDetectThreshold) && (Delta > 0)) ||
 663                     ; 480        ((Delta >= pKeyStruct->RecalibrationThreshold) && (Delta < 0))))
 665  014e be00          	ldw	x,_pKeyStruct
 666  0150 e607          	ld	a,(7,x)
 667  0152 a115          	cp	a,#21
 668  0154 2431          	jruge	L302
 670  0156 e60d          	ld	a,(13,x)
 671  0158 5f            	clrw	x
 672  0159 4d            	tnz	a
 673  015a 2a01          	jrpl	L221
 674  015c 53            	cplw	x
 675  015d               L221:
 676  015d 97            	ld	xl,a
 677  015e b300          	cpw	x,_Delta
 678  0160 2f05          	jrslt	L702
 680  0162 9c            	rvf	
 681  0163 be00          	ldw	x,_Delta
 682  0165 2c12          	jrsgt	L502
 683  0167               L702:
 685  0167 be00          	ldw	x,_pKeyStruct
 686  0169 e60e          	ld	a,(14,x)
 687  016b 5f            	clrw	x
 688  016c 4d            	tnz	a
 689  016d 2a01          	jrpl	L421
 690  016f 53            	cplw	x
 691  0170               L421:
 692  0170 97            	ld	xl,a
 693  0171 b300          	cpw	x,_Delta
 694  0173 2c12          	jrsgt	L302
 696  0175 be00          	ldw	x,_Delta
 697  0177 2a0e          	jrpl	L302
 698  0179               L502:
 699                     ; 487     TSL_SCKey_SetPostDetectState();
 701  0179 cd0000        	call	_TSL_SCKey_SetPostDetectState
 703                     ; 488     if (!EndDetectionIntegrator)
 705  017c b600          	ld	a,_EndDetectionIntegrator
 706  017e 2606          	jrne	L112
 707                     ; 490       pKeyStruct->Channel.IntegratorCounter++;
 709  0180 be00          	ldw	x,_pKeyStruct
 710  0182 6c0a          	inc	(10,x)
 711                     ; 491       TSL_SCKey_PostDetectTreatment();
 713  0184 ad04          	call	_TSL_SCKey_PostDetectTreatment
 715  0186               L112:
 716                     ; 493     return;
 719  0186 81            	ret	
 720  0187               L302:
 721                     ; 496   TSL_SCKey_DetectionTimeout();
 724                     ; 497 }
 727  0187 cc0000        	jp	_TSL_SCKey_DetectionTimeout
 755                     ; 510 void TSL_SCKey_PostDetectTreatment(void)
 755                     ; 511 {
 756                     	switch	.text
 757  018a               _TSL_SCKey_PostDetectTreatment:
 761                     ; 521   if ((pKeyStruct->Channel.LastMeasRejectNb <= MAX_REJECTED_MEASUREMENTS) &&
 761                     ; 522       (((Delta <= pKeyStruct->EndDetectThreshold) && (Delta > 0)) ||
 761                     ; 523        ((Delta >= pKeyStruct->RecalibrationThreshold) && (Delta < 0))))
 763  018a be00          	ldw	x,_pKeyStruct
 764  018c e607          	ld	a,(7,x)
 765  018e a115          	cp	a,#21
 766  0190 242c          	jruge	L322
 768  0192 e60d          	ld	a,(13,x)
 769  0194 5f            	clrw	x
 770  0195 4d            	tnz	a
 771  0196 2a01          	jrpl	L631
 772  0198 53            	cplw	x
 773  0199               L631:
 774  0199 97            	ld	xl,a
 775  019a b300          	cpw	x,_Delta
 776  019c 2f05          	jrslt	L722
 778  019e 9c            	rvf	
 779  019f be00          	ldw	x,_Delta
 780  01a1 2c12          	jrsgt	L522
 781  01a3               L722:
 783  01a3 be00          	ldw	x,_pKeyStruct
 784  01a5 e60e          	ld	a,(14,x)
 785  01a7 5f            	clrw	x
 786  01a8 4d            	tnz	a
 787  01a9 2a01          	jrpl	L041
 788  01ab 53            	cplw	x
 789  01ac               L041:
 790  01ac 97            	ld	xl,a
 791  01ad b300          	cpw	x,_Delta
 792  01af 2c0d          	jrsgt	L322
 794  01b1 be00          	ldw	x,_Delta
 795  01b3 2a09          	jrpl	L322
 796  01b5               L522:
 797                     ; 530     pKeyStruct->Channel.IntegratorCounter--;
 799  01b5 be00          	ldw	x,_pKeyStruct
 800  01b7 6a0a          	dec	(10,x)
 801                     ; 531     if (!pKeyStruct->Channel.IntegratorCounter)
 803  01b9 2606          	jrne	L332
 804                     ; 533       TSL_SCKey_SetIdleState();
 808  01bb cc0000        	jp	_TSL_SCKey_SetIdleState
 809  01be               L322:
 810                     ; 539     TSL_SCKey_BackToDetectedState();
 812  01be cd0000        	call	_TSL_SCKey_BackToDetectedState
 814  01c1               L332:
 815                     ; 541 }
 818  01c1 81            	ret	
 846                     ; 554 void TSL_SCKey_PreRecalibrationTreatment(void)
 846                     ; 555 {
 847                     	switch	.text
 848  01c2               _TSL_SCKey_PreRecalibrationTreatment:
 852                     ; 557   if ((pKeyStruct->Channel.LastMeasRejectNb <= MAX_REJECTED_MEASUREMENTS) &&
 852                     ; 558       (Delta <= pKeyStruct->RecalibrationThreshold))
 854  01c2 be00          	ldw	x,_pKeyStruct
 855  01c4 e607          	ld	a,(7,x)
 856  01c6 a115          	cp	a,#21
 857  01c8 2415          	jruge	L542
 859  01ca e60e          	ld	a,(14,x)
 860  01cc 5f            	clrw	x
 861  01cd 4d            	tnz	a
 862  01ce 2a01          	jrpl	L051
 863  01d0 53            	cplw	x
 864  01d1               L051:
 865  01d1 97            	ld	xl,a
 866  01d2 b300          	cpw	x,_Delta
 867  01d4 2f09          	jrslt	L542
 868                     ; 563     pKeyStruct->Channel.IntegratorCounter--;
 870  01d6 be00          	ldw	x,_pKeyStruct
 871  01d8 6a0a          	dec	(10,x)
 872                     ; 564     if (!pKeyStruct->Channel.IntegratorCounter)
 874  01da 2606          	jrne	L152
 875                     ; 566       TSL_SCKey_SetCalibrationState();
 879  01dc cc0000        	jp	_TSL_SCKey_SetCalibrationState
 880  01df               L542:
 881                     ; 571     TSL_SCKey_BackToIdleState();
 883  01df cd0000        	call	_TSL_SCKey_BackToIdleState
 885  01e2               L152:
 886                     ; 573 }
 889  01e2 81            	ret	
 915                     ; 586 void TSL_SCKey_CalibrationTreatment(void)
 915                     ; 587 {
 916                     	switch	.text
 917  01e3               _TSL_SCKey_CalibrationTreatment:
 921                     ; 589   if (pKeyStruct->Channel.LastMeasRejectNb <= MAX_REJECTED_MEASUREMENTS)
 923  01e3 be00          	ldw	x,_pKeyStruct
 924  01e5 e607          	ld	a,(7,x)
 925  01e7 a115          	cp	a,#21
 926  01e9 241c          	jruge	L362
 927                     ; 592     pKeyStruct->Channel.Reference += pKeyStruct->Channel.LastMeas;
 929  01eb e609          	ld	a,(9,x)
 930  01ed eb06          	add	a,(6,x)
 931  01ef e709          	ld	(9,x),a
 932  01f1 e608          	ld	a,(8,x)
 933  01f3 e905          	adc	a,(5,x)
 934  01f5 e708          	ld	(8,x),a
 935                     ; 593     pKeyStruct->Counter--;
 937  01f7 6a03          	dec	(3,x)
 938                     ; 594     if (!pKeyStruct->Counter)
 940  01f9 260c          	jrne	L362
 941                     ; 597       pKeyStruct->Channel.Reference = (pKeyStruct->Channel.Reference >> 3);
 943  01fb a603          	ld	a,#3
 944  01fd               L061:
 945  01fd 6408          	srl	(8,x)
 946  01ff 6609          	rrc	(9,x)
 947  0201 4a            	dec	a
 948  0202 26f9          	jrne	L061
 949                     ; 598       TSL_SCKey_SetIdleState();
 951  0204 cd0000        	call	_TSL_SCKey_SetIdleState
 953  0207               L362:
 954                     ; 601 }
 957  0207 81            	ret	
 983                     ; 614 void TSL_SCKey_CheckDisabled(void)
 983                     ; 615 {
 984                     	switch	.text
 985  0208               _TSL_SCKey_CheckDisabled:
 989                     ; 616   if (!pKeyStruct->Setting.b.ENABLED)
 991  0208 be00          	ldw	x,_pKeyStruct
 992  020a e602          	ld	a,(2,x)
 993  020c a502          	bcp	a,#2
 994  020e 2603          	jrne	L772
 995                     ; 618     TSL_SCKey_SetDisabledState();
 997  0210 cd0000        	call	_TSL_SCKey_SetDisabledState
 999  0213               L772:
1000                     ; 620 }
1003  0213 81            	ret	
1029                     ; 633 void TSL_SCKey_CheckEnabled(void)
1029                     ; 634 {
1030                     	switch	.text
1031  0214               _TSL_SCKey_CheckEnabled:
1035                     ; 635   if (pKeyStruct->Setting.b.ENABLED && pKeyStruct->Setting.b.IMPLEMENTED)
1037  0214 be00          	ldw	x,_pKeyStruct
1038  0216 e602          	ld	a,(2,x)
1039  0218 a502          	bcp	a,#2
1040  021a 2707          	jreq	L113
1042  021c a501          	bcp	a,#1
1043  021e 2703          	jreq	L113
1044                     ; 637     TSL_SCKey_SetCalibrationState();
1046  0220 cd0000        	call	_TSL_SCKey_SetCalibrationState
1048  0223               L113:
1049                     ; 639 }
1052  0223 81            	ret	
1077                     ; 652 u8 TSL_SCKey_CheckErrorCondition(void)
1077                     ; 653 {
1078                     	switch	.text
1079  0224               _TSL_SCKey_CheckErrorCondition:
1083                     ; 654   if ((pKeyStruct->Channel.LastMeas < SCKEY_MIN_ACQUISITION)
1083                     ; 655       || (pKeyStruct->Channel.LastMeas > SCKEY_MAX_ACQUISITION))
1085  0224 90be00        	ldw	y,_pKeyStruct
1086  0227 90ee05        	ldw	y,(5,y)
1087  022a 90a30096      	cpw	y,#150
1088  022e 250c          	jrult	L523
1090  0230 90be00        	ldw	y,_pKeyStruct
1091  0233 90ee05        	ldw	y,(5,y)
1092  0236 90a30bb9      	cpw	y,#3001
1093  023a 2503          	jrult	L323
1094  023c               L523:
1095                     ; 657     return 0xFF;  // Error case !
1097  023c a6ff          	ld	a,#255
1100  023e 81            	ret	
1101  023f               L323:
1102                     ; 660   return 0;
1104  023f 4f            	clr	a
1107  0240 81            	ret	
1120                     	xref	_TSL_SCKey_DetectionTimeout
1121                     	xref	_TSL_SCKey_DxS
1122                     	xref	_TSL_SCKey_SetDisabledState
1123                     	xref	_TSL_SCKey_SetErrorState
1124                     	xref	_TSL_SCKey_SetCalibrationState
1125                     	xref	_TSL_SCKey_BackToDetectedState
1126                     	xref	_TSL_SCKey_SetPostDetectState
1127                     	xref	_TSL_SCKey_SetDetectedState
1128                     	xref	_TSL_SCKey_SetPreDetectState
1129                     	xref	_TSL_SCKey_BackToIdleState
1130                     	xref	_TSL_SCKey_SetIdleState
1131                     	xref	_TSL_DeltaCalculation
1132                     	xref	_TSL_SetStructPointer
1133                     	xref.b	_TSL_TempGlobalState
1134                     	xref.b	_TSL_TempGlobalSetting
1135                     	xref.b	_Delta
1136                     	xref.b	_KeyIndex
1137                     	xref	_TSL_IO_Acquisition
1138                     	xref	_Table_SCKEY_BITS
1139                     	xref.b	_sTouchIO
1140                     	xref.b	_EndDetectionIntegrator
1141                     	xref.b	_DetectionIntegrator
1142                     	xref.b	_sSCKeyInfo
1143                     	xref.b	_pKeyStruct
1144                     	xdef	_TSL_SCKey_CheckErrorCondition
1145                     	xdef	_TSL_SCKey_CheckEnabled
1146                     	xdef	_TSL_SCKey_CheckDisabled
1147                     	xdef	_TSL_SCKey_CalibrationTreatment
1148                     	xdef	_TSL_SCKey_PreRecalibrationTreatment
1149                     	xdef	_TSL_SCKey_PostDetectTreatment
1150                     	xdef	_TSL_SCKey_DetectedTreatment
1151                     	xdef	_TSL_SCKey_PreDetectTreatment
1152                     	xdef	_TSL_SCKey_IdleTreatment
1153                     	xdef	_TSL_SCKey_Process
1154                     	xdef	_TSL_SCKEY_P1_Acquisition
1155                     	xdef	_TSL_SCKey_Init
1174                     	end
