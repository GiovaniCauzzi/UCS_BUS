   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
   4                     ; Optimizer V4.5.3 - 16 Jun 2021
  47                     ; 43 void TIM4_DeInit(void)
  47                     ; 44 {
  49                     	switch	.text
  50  0000               _TIM4_DeInit:
  54                     ; 45     TIM4->CR1 = TIM4_CR1_RESET_VALUE;
  56  0000 725f5340      	clr	21312
  57                     ; 46     TIM4->IER = TIM4_IER_RESET_VALUE;
  59  0004 725f5341      	clr	21313
  60                     ; 47     TIM4->CNTR = TIM4_CNTR_RESET_VALUE;
  62  0008 725f5344      	clr	21316
  63                     ; 48     TIM4->PSCR = TIM4_PSCR_RESET_VALUE;
  65  000c 725f5345      	clr	21317
  66                     ; 49     TIM4->ARR = TIM4_ARR_RESET_VALUE;
  68  0010 35ff5346      	mov	21318,#255
  69                     ; 50     TIM4->SR1 = TIM4_SR1_RESET_VALUE;
  71  0014 725f5342      	clr	21314
  72                     ; 51 }
  75  0018 81            	ret	
 181                     ; 59 void TIM4_TimeBaseInit(TIM4_Prescaler_TypeDef TIM4_Prescaler, uint8_t TIM4_Period)
 181                     ; 60 {
 182                     	switch	.text
 183  0019               _TIM4_TimeBaseInit:
 187                     ; 62     assert_param(IS_TIM4_PRESCALER_OK(TIM4_Prescaler));
 189                     ; 64     TIM4->PSCR = (uint8_t)(TIM4_Prescaler);
 191  0019 9e            	ld	a,xh
 192  001a c75345        	ld	21317,a
 193                     ; 66     TIM4->ARR = (uint8_t)(TIM4_Period);
 195  001d 9f            	ld	a,xl
 196  001e c75346        	ld	21318,a
 197                     ; 67 }
 200  0021 81            	ret	
 255                     ; 77 void TIM4_Cmd(FunctionalState NewState)
 255                     ; 78 {
 256                     	switch	.text
 257  0022               _TIM4_Cmd:
 261                     ; 80     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 263                     ; 83     if (NewState != DISABLE)
 265  0022 4d            	tnz	a
 266  0023 2705          	jreq	L511
 267                     ; 85         TIM4->CR1 |= TIM4_CR1_CEN;
 269  0025 72105340      	bset	21312,#0
 272  0029 81            	ret	
 273  002a               L511:
 274                     ; 89         TIM4->CR1 &= (uint8_t)(~TIM4_CR1_CEN);
 276  002a 72115340      	bres	21312,#0
 277                     ; 91 }
 280  002e 81            	ret	
 338                     ; 103 void TIM4_ITConfig(TIM4_IT_TypeDef TIM4_IT, FunctionalState NewState)
 338                     ; 104 {
 339                     	switch	.text
 340  002f               _TIM4_ITConfig:
 342  002f 89            	pushw	x
 343       00000000      OFST:	set	0
 346                     ; 106     assert_param(IS_TIM4_IT_OK(TIM4_IT));
 348                     ; 107     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 350                     ; 109     if (NewState != DISABLE)
 352  0030 9f            	ld	a,xl
 353  0031 4d            	tnz	a
 354  0032 2706          	jreq	L151
 355                     ; 112         TIM4->IER |= (uint8_t)TIM4_IT;
 357  0034 9e            	ld	a,xh
 358  0035 ca5341        	or	a,21313
 360  0038 2006          	jra	L351
 361  003a               L151:
 362                     ; 117         TIM4->IER &= (uint8_t)(~TIM4_IT);
 364  003a 7b01          	ld	a,(OFST+1,sp)
 365  003c 43            	cpl	a
 366  003d c45341        	and	a,21313
 367  0040               L351:
 368  0040 c75341        	ld	21313,a
 369                     ; 119 }
 372  0043 85            	popw	x
 373  0044 81            	ret	
 409                     ; 127 void TIM4_UpdateDisableConfig(FunctionalState NewState)
 409                     ; 128 {
 410                     	switch	.text
 411  0045               _TIM4_UpdateDisableConfig:
 415                     ; 130     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 417                     ; 133     if (NewState != DISABLE)
 419  0045 4d            	tnz	a
 420  0046 2705          	jreq	L371
 421                     ; 135         TIM4->CR1 |= TIM4_CR1_UDIS;
 423  0048 72125340      	bset	21312,#1
 426  004c 81            	ret	
 427  004d               L371:
 428                     ; 139         TIM4->CR1 &= (uint8_t)(~TIM4_CR1_UDIS);
 430  004d 72135340      	bres	21312,#1
 431                     ; 141 }
 434  0051 81            	ret	
 492                     ; 151 void TIM4_UpdateRequestConfig(TIM4_UpdateSource_TypeDef TIM4_UpdateSource)
 492                     ; 152 {
 493                     	switch	.text
 494  0052               _TIM4_UpdateRequestConfig:
 498                     ; 154     assert_param(IS_TIM4_UPDATE_SOURCE_OK(TIM4_UpdateSource));
 500                     ; 157     if (TIM4_UpdateSource != TIM4_UPDATESOURCE_GLOBAL)
 502  0052 4d            	tnz	a
 503  0053 2705          	jreq	L522
 504                     ; 159         TIM4->CR1 |= TIM4_CR1_URS;
 506  0055 72145340      	bset	21312,#2
 509  0059 81            	ret	
 510  005a               L522:
 511                     ; 163         TIM4->CR1 &= (uint8_t)(~TIM4_CR1_URS);
 513  005a 72155340      	bres	21312,#2
 514                     ; 165 }
 517  005e 81            	ret	
 574                     ; 175 void TIM4_SelectOnePulseMode(TIM4_OPMode_TypeDef TIM4_OPMode)
 574                     ; 176 {
 575                     	switch	.text
 576  005f               _TIM4_SelectOnePulseMode:
 580                     ; 178     assert_param(IS_TIM4_OPM_MODE_OK(TIM4_OPMode));
 582                     ; 181     if (TIM4_OPMode != TIM4_OPMODE_REPETITIVE)
 584  005f 4d            	tnz	a
 585  0060 2705          	jreq	L752
 586                     ; 183         TIM4->CR1 |= TIM4_CR1_OPM;
 588  0062 72165340      	bset	21312,#3
 591  0066 81            	ret	
 592  0067               L752:
 593                     ; 187         TIM4->CR1 &= (uint8_t)(~TIM4_CR1_OPM);
 595  0067 72175340      	bres	21312,#3
 596                     ; 190 }
 599  006b 81            	ret	
 667                     ; 212 void TIM4_PrescalerConfig(TIM4_Prescaler_TypeDef Prescaler, TIM4_PSCReloadMode_TypeDef TIM4_PSCReloadMode)
 667                     ; 213 {
 668                     	switch	.text
 669  006c               _TIM4_PrescalerConfig:
 673                     ; 215     assert_param(IS_TIM4_PRESCALER_RELOAD_OK(TIM4_PSCReloadMode));
 675                     ; 216     assert_param(IS_TIM4_PRESCALER_OK(Prescaler));
 677                     ; 219     TIM4->PSCR = (uint8_t)Prescaler;
 679  006c 9e            	ld	a,xh
 680  006d c75345        	ld	21317,a
 681                     ; 222     TIM4->EGR = (uint8_t)TIM4_PSCReloadMode;
 683  0070 9f            	ld	a,xl
 684  0071 c75343        	ld	21315,a
 685                     ; 223 }
 688  0074 81            	ret	
 724                     ; 231 void TIM4_ARRPreloadConfig(FunctionalState NewState)
 724                     ; 232 {
 725                     	switch	.text
 726  0075               _TIM4_ARRPreloadConfig:
 730                     ; 234     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 732                     ; 237     if (NewState != DISABLE)
 734  0075 4d            	tnz	a
 735  0076 2705          	jreq	L333
 736                     ; 239         TIM4->CR1 |= TIM4_CR1_ARPE;
 738  0078 721e5340      	bset	21312,#7
 741  007c 81            	ret	
 742  007d               L333:
 743                     ; 243         TIM4->CR1 &= (uint8_t)(~TIM4_CR1_ARPE);
 745  007d 721f5340      	bres	21312,#7
 746                     ; 245 }
 749  0081 81            	ret	
 798                     ; 254 void TIM4_GenerateEvent(TIM4_EventSource_TypeDef TIM4_EventSource)
 798                     ; 255 {
 799                     	switch	.text
 800  0082               _TIM4_GenerateEvent:
 804                     ; 257     assert_param(IS_TIM4_EVENT_SOURCE_OK(TIM4_EventSource));
 806                     ; 260     TIM4->EGR = (uint8_t)(TIM4_EventSource);
 808  0082 c75343        	ld	21315,a
 809                     ; 261 }
 812  0085 81            	ret	
 846                     ; 270 void TIM4_SetCounter(uint8_t Counter)
 846                     ; 271 {
 847                     	switch	.text
 848  0086               _TIM4_SetCounter:
 852                     ; 273     TIM4->CNTR = (uint8_t)(Counter);
 854  0086 c75344        	ld	21316,a
 855                     ; 274 }
 858  0089 81            	ret	
 892                     ; 283 void TIM4_SetAutoreload(uint8_t Autoreload)
 892                     ; 284 {
 893                     	switch	.text
 894  008a               _TIM4_SetAutoreload:
 898                     ; 286     TIM4->ARR = (uint8_t)(Autoreload);
 900  008a c75346        	ld	21318,a
 901                     ; 287 }
 904  008d 81            	ret	
 927                     ; 294 uint8_t TIM4_GetCounter(void)
 927                     ; 295 {
 928                     	switch	.text
 929  008e               _TIM4_GetCounter:
 933                     ; 297     return (uint8_t)(TIM4->CNTR);
 935  008e c65344        	ld	a,21316
 938  0091 81            	ret	
 962                     ; 305 TIM4_Prescaler_TypeDef TIM4_GetPrescaler(void)
 962                     ; 306 {
 963                     	switch	.text
 964  0092               _TIM4_GetPrescaler:
 968                     ; 308     return (TIM4_Prescaler_TypeDef)(TIM4->PSCR);
 970  0092 c65345        	ld	a,21317
 973  0095 81            	ret	
1052                     ; 318 FlagStatus TIM4_GetFlagStatus(TIM4_FLAG_TypeDef TIM4_FLAG)
1052                     ; 319 {
1053                     	switch	.text
1054  0096               _TIM4_GetFlagStatus:
1056       00000001      OFST:	set	1
1059                     ; 320     FlagStatus bitstatus = RESET;
1061                     ; 323     assert_param(IS_TIM4_GET_FLAG_OK(TIM4_FLAG));
1063                     ; 325   if ((TIM4->SR1 & (uint8_t)TIM4_FLAG)  != 0)
1065  0096 c45342        	and	a,21314
1066  0099 2702          	jreq	L774
1067                     ; 327     bitstatus = SET;
1069  009b a601          	ld	a,#1
1072  009d               L774:
1073                     ; 331     bitstatus = RESET;
1076                     ; 333   return ((FlagStatus)bitstatus);
1080  009d 81            	ret	
1115                     ; 343 void TIM4_ClearFlag(TIM4_FLAG_TypeDef TIM4_FLAG)
1115                     ; 344 {
1116                     	switch	.text
1117  009e               _TIM4_ClearFlag:
1121                     ; 346     assert_param(IS_TIM4_GET_FLAG_OK(TIM4_FLAG));
1123                     ; 349     TIM4->SR1 = (uint8_t)(~TIM4_FLAG);
1125  009e 43            	cpl	a
1126  009f c75342        	ld	21314,a
1127                     ; 351 }
1130  00a2 81            	ret	
1194                     ; 360 ITStatus TIM4_GetITStatus(TIM4_IT_TypeDef TIM4_IT)
1194                     ; 361 {
1195                     	switch	.text
1196  00a3               _TIM4_GetITStatus:
1198  00a3 88            	push	a
1199  00a4 89            	pushw	x
1200       00000002      OFST:	set	2
1203                     ; 362     ITStatus bitstatus = RESET;
1205                     ; 364   uint8_t itstatus = 0x0, itenable = 0x0;
1209                     ; 367   assert_param(IS_TIM4_IT_OK(TIM4_IT));
1211                     ; 369   itstatus = (uint8_t)(TIM4->SR1 & (uint8_t)TIM4_IT);
1213  00a5 c45342        	and	a,21314
1214  00a8 6b01          	ld	(OFST-1,sp),a
1216                     ; 371   itenable = (uint8_t)(TIM4->IER & (uint8_t)TIM4_IT);
1218  00aa c65341        	ld	a,21313
1219  00ad 1403          	and	a,(OFST+1,sp)
1220  00af 6b02          	ld	(OFST+0,sp),a
1222                     ; 373   if ((itstatus != (uint8_t)RESET ) && (itenable != (uint8_t)RESET ))
1224  00b1 7b01          	ld	a,(OFST-1,sp)
1225  00b3 2708          	jreq	L355
1227  00b5 7b02          	ld	a,(OFST+0,sp)
1228  00b7 2704          	jreq	L355
1229                     ; 375     bitstatus = (ITStatus)SET;
1231  00b9 a601          	ld	a,#1
1234  00bb 2001          	jra	L555
1235  00bd               L355:
1236                     ; 379     bitstatus = (ITStatus)RESET;
1238  00bd 4f            	clr	a
1240  00be               L555:
1241                     ; 381   return ((ITStatus)bitstatus);
1245  00be 5b03          	addw	sp,#3
1246  00c0 81            	ret	
1282                     ; 391 void TIM4_ClearITPendingBit(TIM4_IT_TypeDef TIM4_IT)
1282                     ; 392 {
1283                     	switch	.text
1284  00c1               _TIM4_ClearITPendingBit:
1288                     ; 394     assert_param(IS_TIM4_IT_OK(TIM4_IT));
1290                     ; 397     TIM4->SR1 = (uint8_t)(~TIM4_IT);
1292  00c1 43            	cpl	a
1293  00c2 c75342        	ld	21314,a
1294                     ; 398 }
1297  00c5 81            	ret	
1310                     	xdef	_TIM4_ClearITPendingBit
1311                     	xdef	_TIM4_GetITStatus
1312                     	xdef	_TIM4_ClearFlag
1313                     	xdef	_TIM4_GetFlagStatus
1314                     	xdef	_TIM4_GetPrescaler
1315                     	xdef	_TIM4_GetCounter
1316                     	xdef	_TIM4_SetAutoreload
1317                     	xdef	_TIM4_SetCounter
1318                     	xdef	_TIM4_GenerateEvent
1319                     	xdef	_TIM4_ARRPreloadConfig
1320                     	xdef	_TIM4_PrescalerConfig
1321                     	xdef	_TIM4_SelectOnePulseMode
1322                     	xdef	_TIM4_UpdateRequestConfig
1323                     	xdef	_TIM4_UpdateDisableConfig
1324                     	xdef	_TIM4_ITConfig
1325                     	xdef	_TIM4_Cmd
1326                     	xdef	_TIM4_TimeBaseInit
1327                     	xdef	_TIM4_DeInit
1346                     	end
