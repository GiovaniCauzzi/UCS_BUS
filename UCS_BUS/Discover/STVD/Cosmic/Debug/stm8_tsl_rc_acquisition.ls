   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
   4                     ; Optimizer V4.5.3 - 16 Jun 2021
  53                     .const:	section	.text
  54  0000               _Table_SCKEY_BITS:
  55  0000 02            	dc.b	2
  86                     ; 235 void TSL_IO_SW_Burst_TestSyncShift(void)
  86                     ; 236 {
  88                     	switch	.text
  89  0000               _TSL_IO_SW_Burst_TestSyncShift:
  93                     ; 240   ld a, _SamplingShifter
  96  0000 b602          	ld	a,_SamplingShifter
  98                     ; 242 ShiftLoopVih:
 101  0002               ShiftLoopVih:
 103                     ; 243   dec a       // 1 cycle
 106  0002 4a            	dec	a//1cycle
 108                     ; 244   jrne ShiftLoopVih
 111  0003 26fd          	jrne	ShiftLoopVih
 113                     ; 261 }
 116  0005 81            	ret	
 140                     ; 272 void TSL_IO_SW_Burst_Wait_Vil(void)
 140                     ; 273 {
 141                     	switch	.text
 142  0006               _TSL_IO_SW_Burst_Wait_Vil:
 146                     ; 277   ld a, _AcquisitionBitMask
 149  0006 b601          	ld	a,_AcquisitionBitMask
 151                     ; 278   ldw x, _sTouchIO   // Input data register ...
 154  0008 be09          	ldw	x,_sTouchIO//Inputdataregister...
 156                     ; 279   incw x
 159  000a 5c            	incw	x
 161                     ; 281 WaitForVil:
 164  000b               WaitForVil:
 166                     ; 285   bcp a, (x)  // 1 cycles
 169  000b f5            	bcp	a,(x)//1cycles
 171                     ; 286   jreq EndWaitForVil
 174  000c 270a          	jreq	EndWaitForVil
 176                     ; 287   ldw y, _TIMACQ_CNTR // 2 cycles; hw counter also used for timeout ...
 179  000e 90ce5328      	ldw	y,_TIMACQ_CNTR//2cycles
 181                     ; 288   cpw y, #0x0E00    // 2 cycles; Timeout compare
 184  0012 90a30e00      	cpw	y,#0x0E00//2cycles
 186                     ; 289   jrult WaitForVil
 189  0016 25f3          	jrult	WaitForVil
 191                     ; 290 EndWaitForVil:
 194  0018               EndWaitForVil:
 196                     ; 326 }
 199  0018 81            	ret	
 223                     ; 337 void TSL_IO_SW_Burst_Wait_Vih(void)
 223                     ; 338 {
 224                     	switch	.text
 225  0019               _TSL_IO_SW_Burst_Wait_Vih:
 229                     ; 341   ld a, _AcquisitionBitMask
 232  0019 b601          	ld	a,_AcquisitionBitMask
 234                     ; 342   ldw x, _sTouchIO   // Input data register ...
 237  001b be09          	ldw	x,_sTouchIO//Inputdataregister...
 239                     ; 343   incw x
 242  001d 5c            	incw	x
 244                     ; 345 WaitForVih:
 247  001e               WaitForVih:
 249                     ; 349   bcp a, (x)  // 1 cycles
 252  001e f5            	bcp	a,(x)//1cycles
 254                     ; 350   jrne EndWaitForVih
 257  001f 260a          	jrne	EndWaitForVih
 259                     ; 351   ldw y, _TIMACQ_CNTR // 2 cycles; hw counter also used for timeout ...
 262  0021 90ce5328      	ldw	y,_TIMACQ_CNTR//2cycles
 264                     ; 352   cpw y, #0x0E00    // 2 cycles; Timeout compare
 267  0025 90a30e00      	cpw	y,#0x0E00//2cycles
 269                     ; 353   jrult WaitForVih
 272  0029 25f3          	jrult	WaitForVih
 274                     ; 354 EndWaitForVih:
 277  002b               EndWaitForVih:
 279                     ; 391 }
 282  002b 81            	ret	
 318                     ; 411 void TSL_IO_SW_Spread_Spectrum(void)
 318                     ; 412 {
 319                     	switch	.text
 320  002c               _TSL_IO_SW_Spread_Spectrum:
 322       00000001      OFST:	set	1
 325                     ; 415   SpreadCounter++;
 327  002c 3c00          	inc	L71_SpreadCounter
 328  002e 88            	push	a
 329                     ; 417   if (SpreadCounter == SPREAD_COUNTER_MAX)
 331  002f b600          	ld	a,L71_SpreadCounter
 332  0031 a114          	cp	a,#20
 333  0033 2603          	jrne	L57
 334                     ; 419     SpreadCounter = SPREAD_COUNTER_MIN;
 336  0035 4f            	clr	a
 337  0036 b700          	ld	L71_SpreadCounter,a
 338  0038               L57:
 339                     ; 422   for (i = SpreadCounter; i; i--) {}}
 341  0038 6b01          	ld	(OFST+0,sp),a
 344  003a 2002          	jra	L301
 345  003c               L77:
 348  003c 0a01          	dec	(OFST+0,sp)
 350  003e               L301:
 353  003e 26fc          	jrne	L77
 357  0040 84            	pop	a
 358  0041 81            	ret	
 382                     ; 438 void TSL_IO_Init(void)
 382                     ; 439 {
 383                     	switch	.text
 384  0042               _TSL_IO_Init:
 388                     ; 442   ((GPIO_TypeDef *)(LOADREF_PORT_ADDR))->CR1 |= LOADREF_BIT;
 390  0042 7214500d      	bset	20493,#2
 391                     ; 443   ((GPIO_TypeDef *)(LOADREF_PORT_ADDR))->DDR |= LOADREF_BIT;
 393  0046 7214500c      	bset	20492,#2
 394                     ; 444   ((GPIO_TypeDef *)(LOADREF_PORT_ADDR))->ODR &= (u8)(~LOADREF_BIT);
 396  004a 7215500a      	bres	20490,#2
 397                     ; 454   ((GPIO_TypeDef *)(GPIOC_BaseAddress))->CR1 |= GPIOC_ELECTRODES_MASK;
 399  004e c6500d        	ld	a,20493
 400  0051 aa0a          	or	a,#10
 401  0053 c7500d        	ld	20493,a
 402                     ; 475   TSL_IO_Clamp();
 404  0056 ad09          	call	_TSL_IO_Clamp
 406                     ; 478   TIMACQ->PSCR = 0;
 408  0058 725f532a      	clr	21290
 409                     ; 479   TIMACQ->CR1 = 0x01;
 411  005c 35015320      	mov	21280,#1
 412                     ; 481 }
 415  0060 81            	ret	
 438                     ; 494 void TSL_IO_Clamp(void)
 438                     ; 495 {
 439                     	switch	.text
 440  0061               _TSL_IO_Clamp:
 444                     ; 498   ((GPIO_TypeDef *)(LOADREF_PORT_ADDR))->ODR &= (u8)(~LOADREF_BIT);
 446  0061 7215500a      	bres	20490,#2
 447                     ; 510   ((GPIO_TypeDef *)(GPIOC_BaseAddress))->ODR &= (u8)(~GPIOC_ELECTRODES_MASK);
 449  0065 c6500a        	ld	a,20490
 450  0068 a4f5          	and	a,#245
 451  006a c7500a        	ld	20490,a
 452                     ; 511   ((GPIO_TypeDef *)(GPIOC_BaseAddress))->DDR |= GPIOC_ELECTRODES_MASK;
 454  006d c6500c        	ld	a,20492
 455  0070 aa0a          	or	a,#10
 456  0072 c7500c        	ld	20492,a
 457                     ; 538 }
 460  0075 81            	ret	
 484                     ; 551 void TSL_IO_SW_Burst_Start_Timer(void)
 484                     ; 552 {
 485                     	switch	.text
 486  0076               _TSL_IO_SW_Burst_Start_Timer:
 490                     ; 554   TIMACQ->EGR |= 0x01;
 492  0076 72105324      	bset	21284,#0
 493                     ; 556 }
 496  007a 81            	ret	
 520                     ; 569 void TSL_IO_SW_Burst_Stop_Timer(void)
 520                     ; 570 {
 521                     	switch	.text
 522  007b               _TSL_IO_SW_Burst_Stop_Timer:
 526                     ; 573   ld a, _TIMACQ_CNTR
 529  007b c65328        	ld	a,_TIMACQ_CNTR
 531                     ; 574   ld _CounterStop, a
 534  007e b703          	ld	_CounterStop,a
 536                     ; 575   ld a, _TIMACQ_CNTR + 1
 539  0080 c65329        	ld	a,_TIMACQ_CNTR+1
 541                     ; 576   ld _CounterStop + 1, a
 544  0083 b704          	ld	_CounterStop+1,a
 546                     ; 594 }
 549  0085 81            	ret	
 685                     ; 607 void TSL_IO_Acquisition(u8 AcqNumber, u8 AdjustmentLevel)
 685                     ; 608 {
 686                     	switch	.text
 687  0086               _TSL_IO_Acquisition:
 689  0086 89            	pushw	x
 690  0087 520f          	subw	sp,#15
 691       0000000f      OFST:	set	15
 694                     ; 615   AcquisitionBitMask = sTouchIO.AcqMask;
 696  0089 450b01        	mov	_AcquisitionBitMask,_sTouchIO+2
 697                     ; 617   MinMeasurement = 0;
 699  008c 5f            	clrw	x
 700  008d 1f04          	ldw	(OFST-11,sp),x
 702                     ; 618   MaxMeasurement = 0;
 704  008f 1f02          	ldw	(OFST-13,sp),x
 706                     ; 619   FinalMeasurementValue = 0;
 708  0091 bf07          	ldw	_FinalMeasurementValue+2,x
 709  0093 bf05          	ldw	_FinalMeasurementValue,x
 710                     ; 620   RejectionCounter = 0;
 712  0095 0f08          	clr	(OFST-7,sp)
 714                     ; 625   if (IT_Sync_Flags.one_acquisition_sync_enable)
 716  0097 7201000009    	btjf	_IT_Sync_Flags,#0,L132
 717                     ; 627     IT_Sync_Flags.start = 0;
 719  009c 72170000      	bres	_IT_Sync_Flags,#3
 721  00a0               L732:
 722                     ; 628     while (IT_Sync_Flags.start == 0);
 724  00a0 72070000fb    	btjf	_IT_Sync_Flags,#3,L732
 725  00a5               L132:
 726                     ; 633   for (AcqLoopIndex = 0; AcqLoopIndex < AcqNumber; AcqLoopIndex++)
 728  00a5 0f01          	clr	(OFST-14,sp)
 731  00a7 cc01ab        	jra	L742
 732  00aa               L342:
 733                     ; 638     if (IT_Sync_Flags.one_measure_sync_enable)
 735  00aa 7203000009    	btjf	_IT_Sync_Flags,#1,L562
 736                     ; 640       IT_Sync_Flags.start = 0;
 738  00af 72170000      	bres	_IT_Sync_Flags,#3
 740  00b3               L162:
 741                     ; 641       while (IT_Sync_Flags.start == 0);
 743  00b3 72070000fb    	btjf	_IT_Sync_Flags,#3,L162
 744  00b8               L562:
 745                     ; 648       MeasRejected = 0;
 747  00b8 0f09          	clr	(OFST-6,sp)
 749                     ; 649       CumulatedMeasurement = 0;
 751  00ba 5f            	clrw	x
 752  00bb 1f06          	ldw	(OFST-9,sp),x
 754                     ; 651       for (SamplingShifter = SAMPLING_SHIFTER_LOOP_START;
 756  00bd 35010002      	mov	_SamplingShifter,#1
 757  00c1               L372:
 758                     ; 656         disableInterrupts();
 761  00c1 9b            	sim	
 763                     ; 657         sTouchIO.PORT_ADDR->ODR &= (u8)(~sTouchIO.DriveMask);
 766  00c2 b60c          	ld	a,_sTouchIO+3
 767  00c4 43            	cpl	a
 768  00c5 92c409        	and	a,[_sTouchIO.w]
 769  00c8 cd01f9        	call	LC002
 770                     ; 659         sTouchIO.PORT_ADDR->CR1 &= (u8)(~sTouchIO.DriveMask);
 772  00cb b60c          	ld	a,_sTouchIO+3
 773  00cd 43            	cpl	a
 774  00ce e403          	and	a,(3,x)
 775  00d0 e703          	ld	(3,x),a
 776                     ; 660         ((GPIO_TypeDef *)(LOADREF_PORT_ADDR))->ODR |= LOADREF_BIT;
 778  00d2 7214500a      	bset	20490,#2
 779                     ; 661         enableInterrupts();
 782  00d6 9a            	rim	
 784                     ; 666         if (IT_Sync_Flags.one_charge_sync_enable)
 787  00d7 7205000009    	btjf	_IT_Sync_Flags,#2,L103
 788                     ; 668           IT_Sync_Flags.start = 0;
 790  00dc 72170000      	bres	_IT_Sync_Flags,#3
 792  00e0               L703:
 793                     ; 669           while (IT_Sync_Flags.start == 0);
 795  00e0 72070000fb    	btjf	_IT_Sync_Flags,#3,L703
 796  00e5               L103:
 797                     ; 674         TSL_IO_SW_Spread_Spectrum();
 799  00e5 cd01ec        	call	LC001
 800  00e8 e402          	and	a,(2,x)
 801  00ea e702          	ld	(2,x),a
 802                     ; 680         TSL_IO_SW_Burst_TestSyncShift();
 804  00ec cd0000        	call	_TSL_IO_SW_Burst_TestSyncShift
 806                     ; 681         TSL_IO_SW_Burst_Wait_Vih();
 808  00ef cd0019        	call	_TSL_IO_SW_Burst_Wait_Vih
 810                     ; 682         TSL_IO_SW_Burst_Stop_Timer();
 812  00f2 ad87          	call	_TSL_IO_SW_Burst_Stop_Timer
 814                     ; 684         Measurement = CounterStop;
 816  00f4 be03          	ldw	x,_CounterStop
 817  00f6 1f0e          	ldw	(OFST-1,sp),x
 819                     ; 687         sTouchIO.PORT_ADDR->ODR |= sTouchIO.DriveMask;
 821  00f8 92c609        	ld	a,[_sTouchIO.w]
 822  00fb ba0c          	or	a,_sTouchIO+3
 823  00fd cd01f9        	call	LC002
 824                     ; 689         sTouchIO.PORT_ADDR->CR1 |= sTouchIO.DriveMask;
 826  0100 e603          	ld	a,(3,x)
 827  0102 ba0c          	or	a,_sTouchIO+3
 828  0104 e703          	ld	(3,x),a
 829                     ; 690         ((GPIO_TypeDef *)(LOADREF_PORT_ADDR))->ODR &= (u8)(~LOADREF_BIT);
 831  0106 7215500a      	bres	20490,#2
 832                     ; 691         enableInterrupts();
 835  010a 9a            	rim	
 837                     ; 696         if (IT_Sync_Flags.one_charge_sync_enable)
 840  010b 7205000009    	btjf	_IT_Sync_Flags,#2,L313
 841                     ; 698           IT_Sync_Flags.start = 0;
 843  0110 72170000      	bres	_IT_Sync_Flags,#3
 845  0114               L123:
 846                     ; 699           while (IT_Sync_Flags.start == 0);
 848  0114 72070000fb    	btjf	_IT_Sync_Flags,#3,L123
 849  0119               L313:
 850                     ; 704         TSL_IO_SW_Spread_Spectrum();
 852  0119 cd01ec        	call	LC001
 853  011c e403          	and	a,(3,x)
 854  011e e703          	ld	(3,x),a
 855                     ; 710         sTouchIO.PORT_ADDR->DDR &= (u8)(~sTouchIO.DriveMask);
 857  0120 b60c          	ld	a,_sTouchIO+3
 858  0122 43            	cpl	a
 859  0123 e402          	and	a,(2,x)
 860  0125 e702          	ld	(2,x),a
 861                     ; 711         TSL_IO_SW_Burst_TestSyncShift();
 863  0127 cd0000        	call	_TSL_IO_SW_Burst_TestSyncShift
 865                     ; 712         TSL_IO_SW_Burst_Wait_Vil();
 867  012a cd0006        	call	_TSL_IO_SW_Burst_Wait_Vil
 869                     ; 713         TSL_IO_SW_Burst_Stop_Timer();
 871  012d cd007b        	call	_TSL_IO_SW_Burst_Stop_Timer
 873                     ; 715         Measurement += CounterStop;
 875  0130 1e0e          	ldw	x,(OFST-1,sp)
 876  0132 72bb0003      	addw	x,_CounterStop
 877  0136 1f0e          	ldw	(OFST-1,sp),x
 879                     ; 717         CumulatedMeasurement += Measurement;
 881  0138 72fb06        	addw	x,(OFST-9,sp)
 882  013b 1f06          	ldw	(OFST-9,sp),x
 884                     ; 720         if (SamplingShifter == SAMPLING_SHIFTER_LOOP_START)
 886  013d b602          	ld	a,_SamplingShifter
 887  013f 4a            	dec	a
 888  0140 262e          	jrne	L523
 889                     ; 722           tmpval = (u32)((u32)Measurement * MAX_MEAS_COEFF);
 891  0142 1e0e          	ldw	x,(OFST-1,sp)
 892  0144 90ae011a      	ldw	y,#282
 893  0148 cd0000        	call	c_umul
 895  014b 96            	ldw	x,sp
 896  014c 1c000a        	addw	x,#OFST-5
 897  014f cd0000        	call	c_rtol
 900                     ; 723           MaxMeasurement = (u16)((u16)(tmpval >> 8) + NB_CYCLES_VIHVIL_LOOP);
 902  0152 1e0b          	ldw	x,(OFST-4,sp)
 903  0154 1c0008        	addw	x,#8
 904  0157 1f02          	ldw	(OFST-13,sp),x
 906                     ; 724           tmpval = (u32)((u32)Measurement * MIN_MEAS_COEFF);
 908  0159 a6e6          	ld	a,#230
 909  015b 1e0e          	ldw	x,(OFST-1,sp)
 910  015d cd0000        	call	c_cmulx
 912  0160 96            	ldw	x,sp
 913  0161 1c000a        	addw	x,#OFST-5
 914  0164 cd0000        	call	c_rtol
 917                     ; 725           MinMeasurement = (u16)((u16)(tmpval >> 8) - NB_CYCLES_VIHVIL_LOOP);
 919  0167 1e0b          	ldw	x,(OFST-4,sp)
 920  0169 1d0008        	subw	x,#8
 921  016c 1f04          	ldw	(OFST-11,sp),x
 924  016e 201d          	jra	L723
 925  0170               L523:
 926                     ; 729           if ((Measurement < MinMeasurement) || (Measurement > MaxMeasurement))
 928  0170 1e0e          	ldw	x,(OFST-1,sp)
 929  0172 1304          	cpw	x,(OFST-11,sp)
 930  0174 2504          	jrult	L333
 932  0176 1302          	cpw	x,(OFST-13,sp)
 933  0178 2313          	jrule	L723
 934  017a               L333:
 935                     ; 731             MeasRejected++;
 937  017a 0c09          	inc	(OFST-6,sp)
 939                     ; 732             RejectionCounter++;
 941  017c 0c08          	inc	(OFST-7,sp)
 943                     ; 733             break; // Out from 'for SamplingShifter' loop !!!
 944  017e               L762:
 945                     ; 740     while (MeasRejected && (RejectionCounter <= MAX_REJECTED_MEASUREMENTS));
 947  017e 7b09          	ld	a,(OFST-6,sp)
 948  0180 2718          	jreq	L533
 950  0182 7b08          	ld	a,(OFST-7,sp)
 951  0184 a115          	cp	a,#21
 952  0186 2403cc00b8    	jrult	L562
 953  018b 200d          	jra	L533
 954  018d               L723:
 955                     ; 652            SamplingShifter < (SAMPLING_SHIFTER_NB_LOOPS + SAMPLING_SHIFTER_LOOP_START);
 955                     ; 653            SamplingShifter++)
 957  018d 3c02          	inc	_SamplingShifter
 958                     ; 651       for (SamplingShifter = SAMPLING_SHIFTER_LOOP_START;
 958                     ; 652            SamplingShifter < (SAMPLING_SHIFTER_NB_LOOPS + SAMPLING_SHIFTER_LOOP_START);
 960  018f b602          	ld	a,_SamplingShifter
 961  0191 a109          	cp	a,#9
 962  0193 2403cc00c1    	jrult	L372
 963  0198 20e4          	jra	L762
 964  019a               L533:
 965                     ; 742     if (MeasRejected == 0)
 967  019a 7b09          	ld	a,(OFST-6,sp)
 968  019c 2616          	jrne	L152
 969                     ; 744       FinalMeasurementValue += CumulatedMeasurement;
 971  019e 1e06          	ldw	x,(OFST-9,sp)
 972  01a0 cd0000        	call	c_uitolx
 974  01a3 ae0005        	ldw	x,#_FinalMeasurementValue
 975  01a6 cd0000        	call	c_lgadd
 978                     ; 633   for (AcqLoopIndex = 0; AcqLoopIndex < AcqNumber; AcqLoopIndex++)
 980  01a9 0c01          	inc	(OFST-14,sp)
 982  01ab               L742:
 985  01ab 7b01          	ld	a,(OFST-14,sp)
 986  01ad 1110          	cp	a,(OFST+1,sp)
 987  01af 2403cc00aa    	jrult	L342
 988  01b4               L152:
 989                     ; 753   TSL_IO_Clamp(); // To avoid consumption
 991  01b4 cd0061        	call	_TSL_IO_Clamp
 993                     ; 754   enableInterrupts();
 996  01b7 9a            	rim	
 998                     ; 756   *sTouchIO.RejectedNb = RejectionCounter;
1001  01b8 7b08          	ld	a,(OFST-7,sp)
1002  01ba 92c70f        	ld	[_sTouchIO+6.w],a
1003                     ; 758   if (RejectionCounter <= MAX_REJECTED_MEASUREMENTS)
1005  01bd a115          	cp	a,#21
1006  01bf 2420          	jruge	L343
1007                     ; 760     FinalMeasurementValue = (u32)(FinalMeasurementValue >> 3); /* Division by SAMPLING_SHIFTER_NB_LOOPS */
1009  01c1 ae0005        	ldw	x,#_FinalMeasurementValue
1010  01c4 a603          	ld	a,#3
1011  01c6 cd0000        	call	c_lgursh
1014  01c9 2008          	jra	L743
1015  01cb               L543:
1016                     ; 763       FinalMeasurementValue = (u32)(FinalMeasurementValue >> 1);
1018  01cb 3405          	srl	_FinalMeasurementValue
1019  01cd 3606          	rrc	_FinalMeasurementValue+1
1020  01cf 3607          	rrc	_FinalMeasurementValue+2
1021  01d1 3608          	rrc	_FinalMeasurementValue+3
1022  01d3               L743:
1023                     ; 761     while (AdjustmentLevel--)
1025  01d3 7b11          	ld	a,(OFST+2,sp)
1026  01d5 0a11          	dec	(OFST+2,sp)
1027  01d7 4d            	tnz	a
1028  01d8 26f1          	jrne	L543
1029                     ; 765     *sTouchIO.Measurement = (u16)FinalMeasurementValue;
1031  01da be07          	ldw	x,_FinalMeasurementValue+2
1032  01dc 92cf0d        	ldw	[_sTouchIO+4.w],x
1034  01df 2008          	jra	L353
1035  01e1               L343:
1036                     ; 773       pKeyStruct->Setting.b.NOISE = 1; /* Warning: Application layer must reset this flag */
1038  01e1 be00          	ldw	x,_pKeyStruct
1039  01e3 e602          	ld	a,(2,x)
1040  01e5 aa40          	or	a,#64
1041  01e7 e702          	ld	(2,x),a
1042  01e9               L353:
1043                     ; 783 }
1046  01e9 5b11          	addw	sp,#17
1047  01eb 81            	ret	
1048  01ec               LC001:
1049  01ec cd002c        	call	_TSL_IO_SW_Spread_Spectrum
1051                     ; 677         disableInterrupts();
1054  01ef 9b            	sim	
1056                     ; 678         TSL_IO_SW_Burst_Start_Timer();
1059  01f0 cd0076        	call	_TSL_IO_SW_Burst_Start_Timer
1061                     ; 679         sTouchIO.PORT_ADDR->DDR &= (u8)(~sTouchIO.DriveMask);
1063  01f3 be09          	ldw	x,_sTouchIO
1064  01f5 b60c          	ld	a,_sTouchIO+3
1065  01f7 43            	cpl	a
1066  01f8 81            	ret	
1067  01f9               LC002:
1068  01f9 92c709        	ld	[_sTouchIO.w],a
1069                     ; 688         sTouchIO.PORT_ADDR->DDR |= sTouchIO.DriveMask;
1071  01fc be09          	ldw	x,_sTouchIO
1072  01fe e602          	ld	a,(2,x)
1073  0200 ba0c          	or	a,_sTouchIO+3
1074  0202 e702          	ld	(2,x),a
1075  0204 81            	ret	
1291                     	switch	.ubsct
1292  0000               L71_SpreadCounter:
1293  0000 00            	ds.b	1
1294  0001               _AcquisitionBitMask:
1295  0001 00            	ds.b	1
1296                     	xdef	_AcquisitionBitMask
1297  0002               _SamplingShifter:
1298  0002 00            	ds.b	1
1299                     	xdef	_SamplingShifter
1300  0003               _CounterStop:
1301  0003 0000          	ds.b	2
1302                     	xdef	_CounterStop
1303  0005               _FinalMeasurementValue:
1304  0005 00000000      	ds.b	4
1305                     	xdef	_FinalMeasurementValue
1306                     	xref.b	_IT_Sync_Flags
1307                     	xref.b	_pKeyStruct
1308                     	xdef	_TSL_IO_SW_Spread_Spectrum
1309                     	xdef	_TSL_IO_SW_Burst_Stop_Timer
1310                     	xdef	_TSL_IO_SW_Burst_Start_Timer
1311                     	xdef	_TSL_IO_SW_Burst_Wait_Vih
1312                     	xdef	_TSL_IO_SW_Burst_Wait_Vil
1313                     	xdef	_TSL_IO_SW_Burst_TestSyncShift
1314                     	xdef	_TSL_IO_Acquisition
1315                     	xdef	_TSL_IO_Clamp
1316                     	xdef	_TSL_IO_Init
1317                     	xdef	_Table_SCKEY_BITS
1318  0009               _sTouchIO:
1319  0009 000000000000  	ds.b	9
1320                     	xdef	_sTouchIO
1321                     	xref.b	c_x
1322                     	xref.b	c_y
1342                     	xref	c_lgursh
1343                     	xref	c_lgadd
1344                     	xref	c_uitolx
1345                     	xref	c_cmulx
1346                     	xref	c_rtol
1347                     	xref	c_umul
1348                     	end
