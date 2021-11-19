   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
   4                     ; Optimizer V4.5.3 - 16 Jun 2021
  53                     	bsct
  54  0000               _TSL_Tick_Base:
  55  0000 00            	dc.b	0
  56  0001               _TSL_Tick_10ms:
  57  0001 00            	dc.b	0
  58  0002               _TSL_Tick_100ms:
  59  0002 00            	dc.b	0
  60  0003               _TSL_TickCount_ECS_10ms:
  61  0003 00            	dc.b	0
  62  0004               _TSL_Tick_User1:
  63  0004 00            	dc.b	0
  64  0005               _TSL_Tick_User2:
  65  0005 00            	dc.b	0
 100                     ; 63 void TSL_Timer_Init(void)
 100                     ; 64 {
 102                     	switch	.text
 103  0000               _TSL_Timer_Init:
 107                     ; 66   TSL_Tick_100ms = 0;
 109  0000 3f02          	clr	_TSL_Tick_100ms
 110                     ; 67   TSL_Tick_10ms = 0;
 112  0002 3f01          	clr	_TSL_Tick_10ms
 113                     ; 68   TSL_Tick_Base = 0;
 115  0004 3f00          	clr	_TSL_Tick_Base
 116                     ; 69   TSL_TickCount_ECS_10ms = 0;
 118  0006 3f03          	clr	_TSL_TickCount_ECS_10ms
 119                     ; 70   TSL_Tick_Flags.whole = 0;
 121  0008 3f00          	clr	_TSL_Tick_Flags
 122                     ; 81   TIMTICK->SR1 = 0;       // clear overflow flag
 124  000a 725f5342      	clr	21314
 125                     ; 83   if (CLK->CKDIVR == 0x00)   // Max CPU freq = 16 MHz
 127  000e 725d50c6      	tnz	20678
 128  0012 2606          	jrne	L53
 129                     ; 85     TIMTICK->PSCR = 6;     // Prescaler to divide Fcpu by 64: 4 us clock.
 131  0014 35065345      	mov	21317,#6
 133  0018 2004          	jra	L73
 134  001a               L53:
 135                     ; 89     TIMTICK->PSCR = 7;     // Prescaler to divide Fcpu by 128: x.xx us clock.
 137  001a 35075345      	mov	21317,#7
 138  001e               L73:
 139                     ; 92   TIMTICK->ARR = 124;      // 125 * 4 us = 500 us.
 141  001e 357c5346      	mov	21318,#124
 142                     ; 93   TIMTICK->IER = 0x01;     // Enable interrupt
 144  0022 35015341      	mov	21313,#1
 145                     ; 94   TIMTICK->CR1 = 0x01;     // Start timer
 147  0026 35015340      	mov	21312,#1
 148                     ; 96 }
 151  002a 81            	ret	
 177                     ; 109 void TSL_Timer_Check_1sec_Tick(void)
 177                     ; 110 {
 178                     	switch	.text
 179  002b               _TSL_Timer_Check_1sec_Tick:
 183                     ; 111   if (TSL_Tick_100ms >= 10)
 185  002b b602          	ld	a,_TSL_Tick_100ms
 186  002d a00a          	sub	a,#10
 187  002f 2506          	jrult	L15
 188                     ; 113     TSL_Tick_100ms -= 10;
 190  0031 b702          	ld	_TSL_Tick_100ms,a
 191                     ; 114     TSL_Tick_Flags.b.DTO_1sec = 1;  // Tick Flag for Max On Duration set every second.
 193  0033 72100000      	bset	_TSL_Tick_Flags,#0
 194  0037               L15:
 195                     ; 116 }
 198  0037 81            	ret	
 225                     ; 129 void TSL_Timer_Check_100ms_Tick(void)
 225                     ; 130 {
 226                     	switch	.text
 227  0038               _TSL_Timer_Check_100ms_Tick:
 231                     ; 131   if (TSL_Tick_10ms >= 10)
 233  0038 b601          	ld	a,_TSL_Tick_10ms
 234  003a a00a          	sub	a,#10
 235  003c 2506          	jrult	L36
 236                     ; 133     TSL_Tick_10ms -= 10;
 238  003e b701          	ld	_TSL_Tick_10ms,a
 239                     ; 134     TSL_Tick_100ms++;
 241  0040 3c02          	inc	_TSL_Tick_100ms
 242                     ; 135     TSL_Timer_Check_1sec_Tick();
 244  0042 ade7          	call	_TSL_Timer_Check_1sec_Tick
 246  0044               L36:
 247                     ; 137 }
 250  0044 81            	ret	
 278                     ; 150 void TSL_Timer_Check_10ms_Tick(void)
 278                     ; 151 {
 279                     	switch	.text
 280  0045               _TSL_Timer_Check_10ms_Tick:
 284                     ; 152   if (TSL_Tick_Base >= TICK_FACTOR_10MS)
 286  0045 b600          	ld	a,_TSL_Tick_Base
 287  0047 a014          	sub	a,#20
 288  0049 2508          	jrult	L57
 289                     ; 154     TSL_Tick_Base -= TICK_FACTOR_10MS;
 291  004b b700          	ld	_TSL_Tick_Base,a
 292                     ; 155     TSL_Tick_10ms++;
 294  004d 3c01          	inc	_TSL_Tick_10ms
 295                     ; 156     TSL_TickCount_ECS_10ms++;   // Tick Flag for Drift increment every 10 ms.
 297  004f 3c03          	inc	_TSL_TickCount_ECS_10ms
 298                     ; 157     TSL_Timer_Check_100ms_Tick();
 300  0051 ade5          	call	_TSL_Timer_Check_100ms_Tick
 302  0053               L57:
 303                     ; 159 }
 306  0053 81            	ret	
 334                     ; 181 INTERRUPT_HANDLER(TSL_Timer_ISR, 23)
 334                     ; 182 #endif
 334                     ; 183 #endif
 334                     ; 184 {
 336                     	switch	.text
 337  0054               f_TSL_Timer_ISR:
 339  0054 8a            	push	cc
 340  0055 84            	pop	a
 341  0056 a4bf          	and	a,#191
 342  0058 88            	push	a
 343  0059 86            	pop	cc
 344  005a 3b0002        	push	c_x+2
 345  005d be00          	ldw	x,c_x
 346  005f 89            	pushw	x
 347  0060 3b0002        	push	c_y+2
 348  0063 be00          	ldw	x,c_y
 349  0065 89            	pushw	x
 352                     ; 186   TIMTICK->SR1 = 0;      // clear overflow flag
 354  0066 725f5342      	clr	21314
 355                     ; 188   TSL_Tick_Base++;
 357  006a 3c00          	inc	_TSL_Tick_Base
 358                     ; 189   TSL_Timer_Check_10ms_Tick();
 360  006c add7          	call	_TSL_Timer_Check_10ms_Tick
 362                     ; 191   if (TSL_Tick_Flags.b.User1_Start_100ms) /* Application request */
 364  006e 720300000a    	btjf	_TSL_Tick_Flags,#1,L701
 365                     ; 193     TSL_Tick_Flags.b.User1_Start_100ms = 0;
 367                     ; 194     TSL_Tick_Flags.b.User1_Flag_100ms = 0;
 369                     ; 195     TSL_Tick_User1 = (TICK_FACTOR_10MS * 10);
 371  0073 b600          	ld	a,_TSL_Tick_Flags
 372  0075 a4f9          	and	a,#249
 373  0077 b700          	ld	_TSL_Tick_Flags,a
 374  0079 35c80004      	mov	_TSL_Tick_User1,#200
 375  007d               L701:
 376                     ; 198   if (TSL_Tick_Flags.b.User2_Start_100ms) /* Application request */
 378  007d 720700000a    	btjf	_TSL_Tick_Flags,#3,L111
 379                     ; 200     TSL_Tick_Flags.b.User2_Start_100ms = 0;
 381                     ; 201     TSL_Tick_Flags.b.User2_Flag_100ms = 0;
 383                     ; 202     TSL_Tick_User2 = (TICK_FACTOR_10MS * 10);
 385  0082 b600          	ld	a,_TSL_Tick_Flags
 386  0084 a4e7          	and	a,#231
 387  0086 b700          	ld	_TSL_Tick_Flags,a
 388  0088 35c80005      	mov	_TSL_Tick_User2,#200
 389  008c               L111:
 390                     ; 205   if (TSL_Tick_User1 > 0)
 392  008c b604          	ld	a,_TSL_Tick_User1
 393  008e 2708          	jreq	L311
 394                     ; 207     TSL_Tick_User1--;
 396  0090 3a04          	dec	_TSL_Tick_User1
 397                     ; 208     if (TSL_Tick_User1 == 0)
 399  0092 2604          	jrne	L311
 400                     ; 210       TSL_Tick_Flags.b.User1_Flag_100ms = 1; /* Give information to Application */
 402  0094 72140000      	bset	_TSL_Tick_Flags,#2
 403  0098               L311:
 404                     ; 214   if (TSL_Tick_User2 > 0)
 406  0098 b605          	ld	a,_TSL_Tick_User2
 407  009a 2708          	jreq	L711
 408                     ; 216     TSL_Tick_User2--;
 410  009c 3a05          	dec	_TSL_Tick_User2
 411                     ; 217     if (TSL_Tick_User2 == 0)
 413  009e 2604          	jrne	L711
 414                     ; 219       TSL_Tick_Flags.b.User2_Flag_100ms = 1; /* Give information to Application */
 416  00a0 72180000      	bset	_TSL_Tick_Flags,#4
 417  00a4               L711:
 418                     ; 225 }
 421  00a4 85            	popw	x
 422  00a5 bf00          	ldw	c_y,x
 423  00a7 320002        	pop	c_y+2
 424  00aa 85            	popw	x
 425  00ab bf00          	ldw	c_x,x
 426  00ad 320002        	pop	c_x+2
 427  00b0 80            	iret	
 464                     ; 238 void TSL_Timer_Adjust(u16 Delay)
 464                     ; 239 {
 466                     	switch	.text
 467  00b1               _TSL_Timer_Adjust:
 469  00b1 89            	pushw	x
 470       00000000      OFST:	set	0
 473                     ; 241   disableInterrupts();
 476  00b2 9b            	sim	
 478  00b3               L141:
 479                     ; 245     if (Delay > TICK_FACTOR_10MS) /* delay > 10ms */
 481  00b3 a30015        	cpw	x,#21
 482  00b6 250b          	jrult	L741
 483                     ; 247       TSL_Tick_Base += TICK_FACTOR_10MS;
 485  00b8 b600          	ld	a,_TSL_Tick_Base
 486  00ba ab14          	add	a,#20
 487  00bc b700          	ld	_TSL_Tick_Base,a
 488                     ; 248       Delay -= TICK_FACTOR_10MS;
 490  00be 1d0014        	subw	x,#20
 491                     ; 249       TSL_Timer_Check_10ms_Tick();
 494  00c1 2003          	jra	L341
 495  00c3               L741:
 496                     ; 253       TSL_Tick_Base++;
 498  00c3 3c00          	inc	_TSL_Tick_Base
 499                     ; 254       Delay--;
 501  00c5 5a            	decw	x
 502                     ; 255       TSL_Timer_Check_10ms_Tick();
 505  00c6               L341:
 506  00c6 1f01          	ldw	(OFST+1,sp),x
 508  00c8 cd0045        	call	_TSL_Timer_Check_10ms_Tick
 509                     ; 258   while (Delay);
 511  00cb 1e01          	ldw	x,(OFST+1,sp)
 512  00cd 26e4          	jrne	L141
 513                     ; 260   enableInterrupts();
 516  00cf 9a            	rim	
 518                     ; 262 }
 522  00d0 85            	popw	x
 523  00d1 81            	ret	
 714                     	xdef	_TSL_Tick_User2
 715                     	xdef	_TSL_Tick_User1
 716                     	xdef	_TSL_Timer_Check_10ms_Tick
 717                     	xdef	_TSL_Timer_Check_100ms_Tick
 718                     	xdef	_TSL_Timer_Check_1sec_Tick
 719                     	xdef	_TSL_Timer_Adjust
 720                     	xdef	_TSL_Timer_Init
 721                     	xdef	f_TSL_Timer_ISR
 722                     	switch	.ubsct
 723  0000               _TSL_Tick_Flags:
 724  0000 00            	ds.b	1
 725                     	xdef	_TSL_Tick_Flags
 726                     	xdef	_TSL_TickCount_ECS_10ms
 727                     	xdef	_TSL_Tick_100ms
 728                     	xdef	_TSL_Tick_10ms
 729                     	xdef	_TSL_Tick_Base
 730                     	xref.b	c_x
 731                     	xref.b	c_y
 751                     	end
