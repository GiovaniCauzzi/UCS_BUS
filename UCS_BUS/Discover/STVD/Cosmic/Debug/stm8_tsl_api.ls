   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
   4                     ; Optimizer V4.5.3 - 16 Jun 2021
  97                     ; 144 void TSL_Init(void)
  97                     ; 145 {
  99                     	switch	.text
 100  0000               _TSL_Init:
 104                     ; 147   disableInterrupts();
 107  0000 9b            	sim	
 109                     ; 149   DetectionIntegrator = DETECTION_INTEGRATOR_DEFAULT;
 112  0001 35020012      	mov	_DetectionIntegrator,#2
 113                     ; 150   EndDetectionIntegrator = END_DETECTION_INTEGRATOR_DEFAULT;
 115  0005 35020011      	mov	_EndDetectionIntegrator,#2
 116                     ; 151   ECSTimeStep = ECS_TIME_STEP_DEFAULT;
 118  0009 3514000f      	mov	_ECSTimeStep,#20
 119                     ; 152   ECSTemporization = ECS_TEMPO_DEFAULT;
 121  000d 3514000e      	mov	_ECSTemporization,#20
 122                     ; 153   RecalibrationIntegrator = RECALIBRATION_INTEGRATOR_DEFAULT;
 124  0011 350a0010      	mov	_RecalibrationIntegrator,#10
 125                     ; 154   DetectionTimeout = DTO_DEFAULT;
 127  0015 3f13          	clr	_DetectionTimeout
 128                     ; 156   ECS_K_Fast = ECS_IIR_KFAST_DEFAULT;
 130  0017 3514000d      	mov	_ECS_K_Fast,#20
 131                     ; 157   ECS_K_Slow = ECS_IIR_KSLOW_DEFAULT;
 133  001b 350a000c      	mov	_ECS_K_Slow,#10
 134                     ; 158   ECSTimeStepCounter = ECSTimeStep;
 136  001f 35140002      	mov	_ECSTimeStepCounter,#20
 137                     ; 159   ECSTempoCounter = 0;
 139  0023 3f01          	clr	_ECSTempoCounter
 140                     ; 160   ECSTempoPrescaler = 0;
 142  0025 3f00          	clr	_ECSTempoPrescaler
 143                     ; 162   TSL_IO_Init();
 145  0027 cd0000        	call	_TSL_IO_Init
 147                     ; 165   TSL_Timer_Init();
 149  002a cd0000        	call	_TSL_Timer_Init
 151                     ; 169   TSL_SCKey_Init();
 153  002d cd0000        	call	_TSL_SCKey_Init
 155                     ; 175   enableInterrupts();
 158  0030 9a            	rim	
 160                     ; 177   TSLState = TSL_IDLE_STATE;
 163  0031 35010028      	mov	_TSLState,#1
 164                     ; 179 }
 167  0035 81            	ret	
 203                     ; 192 void TSL_Action(void)
 203                     ; 193 {
 204                     	switch	.text
 205  0036               _TSL_Action:
 209                     ; 195   switch (TSLState)
 211  0036 b628          	ld	a,_TSLState
 213                     ; 311       break;
 214  0038 4a            	dec	a
 215  0039 270c          	jreq	L53
 216  003b 4a            	dec	a
 217  003c 271d          	jreq	L73
 218  003e 4a            	dec	a
 219  003f 2722          	jreq	L14
 220  0041 a008          	sub	a,#8
 221  0043 272c          	jreq	L34
 222  0045               L17:
 224  0045 20fe          	jra	L17
 225  0047               L53:
 226                     ; 199       disableInterrupts();
 229  0047 9b            	sim	
 231                     ; 200       Local_TickFlag.b.DTO_1sec = TSL_Tick_Flags.b.DTO_1sec;
 234                     	btst	_TSL_Tick_Flags,#0
 235  004d 90110003      	bccm	_Local_TickFlag,#0
 236                     ; 201       TSL_Tick_Flags.b.DTO_1sec = 0;
 238  0051 72110000      	bres	_TSL_Tick_Flags,#0
 239                     ; 202       enableInterrupts();
 242  0055 9a            	rim	
 244                     ; 204       TSLState = TSL_SCKEY_P1_ACQ_STATE;
 247  0056 35020028      	mov	_TSLState,#2
 248                     ; 206       break;
 251  005a 81            	ret	
 252  005b               L73:
 253                     ; 208     case TSL_SCKEY_P1_ACQ_STATE:
 253                     ; 209       TSL_SCKEY_P1_Acquisition();
 255  005b cd0000        	call	_TSL_SCKEY_P1_Acquisition
 257                     ; 211       TSLState = TSL_SCKEY_P1_PROC_STATE;
 259  005e 35030028      	mov	_TSLState,#3
 260                     ; 212       break;
 263  0062 81            	ret	
 264  0063               L14:
 265                     ; 214     case TSL_SCKEY_P1_PROC_STATE:
 265                     ; 215       for (KeyIndex = 0; KeyIndex < SCKEY_P1_KEY_COUNT; KeyIndex++)
 267  0063 b70a          	ld	_KeyIndex,a
 268  0065               L36:
 269                     ; 217         TSL_SCKey_Process();
 271  0065 cd0000        	call	_TSL_SCKey_Process
 273                     ; 215       for (KeyIndex = 0; KeyIndex < SCKEY_P1_KEY_COUNT; KeyIndex++)
 275  0068 3c0a          	inc	_KeyIndex
 278  006a 27f9          	jreq	L36
 279                     ; 227       TSLState = TSL_ECS_STATE;
 281  006c 350b0028      	mov	_TSLState,#11
 282                     ; 230       break;
 285  0070 81            	ret	
 286  0071               L34:
 287                     ; 304     case TSL_ECS_STATE:
 287                     ; 305       TSL_ECS();
 289  0071 cd0000        	call	_TSL_ECS
 291                     ; 306       TSL_GlobalSetting.whole = TSL_TempGlobalSetting.whole;
 293  0074 be06          	ldw	x,_TSL_TempGlobalSetting
 294  0076 bf26          	ldw	_TSL_GlobalSetting,x
 295                     ; 307       TSL_TempGlobalSetting.whole = 0;
 297  0078 5f            	clrw	x
 298  0079 bf06          	ldw	_TSL_TempGlobalSetting,x
 299                     ; 308       TSL_GlobalState.whole = TSL_TempGlobalState.whole;
 301  007b 450525        	mov	_TSL_GlobalState,_TSL_TempGlobalState
 302                     ; 309       TSL_TempGlobalState.whole = 0;
 304  007e 3f05          	clr	_TSL_TempGlobalState
 305                     ; 310       TSLState = TSL_IDLE_STATE;
 307  0080 35010028      	mov	_TSLState,#1
 308                     ; 311       break;
 310                     ; 319 }
 313  0084 81            	ret	
1223                     	xref	_TSL_ECS
1224                     	switch	.ubsct
1225  0000               _ECSTempoPrescaler:
1226  0000 00            	ds.b	1
1227                     	xdef	_ECSTempoPrescaler
1228  0001               _ECSTempoCounter:
1229  0001 00            	ds.b	1
1230                     	xdef	_ECSTempoCounter
1231  0002               _ECSTimeStepCounter:
1232  0002 00            	ds.b	1
1233                     	xdef	_ECSTimeStepCounter
1234  0003               _Local_TickFlag:
1235  0003 00            	ds.b	1
1236                     	xdef	_Local_TickFlag
1237  0004               _Local_TickECS10ms:
1238  0004 00            	ds.b	1
1239                     	xdef	_Local_TickECS10ms
1240  0005               _TSL_TempGlobalState:
1241  0005 00            	ds.b	1
1242                     	xdef	_TSL_TempGlobalState
1243  0006               _TSL_TempGlobalSetting:
1244  0006 0000          	ds.b	2
1245                     	xdef	_TSL_TempGlobalSetting
1246  0008               _Delta:
1247  0008 0000          	ds.b	2
1248                     	xdef	_Delta
1249  000a               _KeyIndex:
1250  000a 00            	ds.b	1
1251                     	xdef	_KeyIndex
1252                     	xref	_TSL_IO_Init
1253                     	xref	_TSL_SCKey_Process
1254                     	xref	_TSL_SCKEY_P1_Acquisition
1255                     	xref	_TSL_SCKey_Init
1256                     	xdef	_TSL_Action
1257                     	xdef	_TSL_Init
1258  000b               _IT_Sync_Flags:
1259  000b 00            	ds.b	1
1260                     	xdef	_IT_Sync_Flags
1261  000c               _ECS_K_Slow:
1262  000c 00            	ds.b	1
1263                     	xdef	_ECS_K_Slow
1264  000d               _ECS_K_Fast:
1265  000d 00            	ds.b	1
1266                     	xdef	_ECS_K_Fast
1267  000e               _ECSTemporization:
1268  000e 00            	ds.b	1
1269                     	xdef	_ECSTemporization
1270  000f               _ECSTimeStep:
1271  000f 00            	ds.b	1
1272                     	xdef	_ECSTimeStep
1273  0010               _RecalibrationIntegrator:
1274  0010 00            	ds.b	1
1275                     	xdef	_RecalibrationIntegrator
1276  0011               _EndDetectionIntegrator:
1277  0011 00            	ds.b	1
1278                     	xdef	_EndDetectionIntegrator
1279  0012               _DetectionIntegrator:
1280  0012 00            	ds.b	1
1281                     	xdef	_DetectionIntegrator
1282  0013               _DetectionTimeout:
1283  0013 00            	ds.b	1
1284                     	xdef	_DetectionTimeout
1285  0014               _sSCKeyInfo:
1286  0014 000000000000  	ds.b	15
1287                     	xdef	_sSCKeyInfo
1288  0023               _pKeyStruct:
1289  0023 0000          	ds.b	2
1290                     	xdef	_pKeyStruct
1291  0025               _TSL_GlobalState:
1292  0025 00            	ds.b	1
1293                     	xdef	_TSL_GlobalState
1294  0026               _TSL_GlobalSetting:
1295  0026 0000          	ds.b	2
1296                     	xdef	_TSL_GlobalSetting
1297  0028               _TSLState:
1298  0028 00            	ds.b	1
1299                     	xdef	_TSLState
1300                     	xref	_TSL_Timer_Init
1301                     	xref.b	_TSL_Tick_Flags
1321                     	end
