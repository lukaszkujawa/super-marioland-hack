#!/bin/bash
./extractor -x 16434 -m 240 -w 16 -h 15 -o sprites0.png
./extractor -x 20274 -m 8 -w 8 -h 1 -o sprites1.png
./extractor -x 32818 -m 384 -w 16 -h 24 -o sprites2.png
./extractor -x 47386 -m 80 -w 16 -h 5 -o sprites3.png
./extractor -x 49202 -m 112 -w 16 -h 7 -o sprites4.png


func_21a8:
	ld b, $0					;21a8 : 06 10   
	ld hl, $c0b0				;21aa : 21 b0 c0
	ld a, $2c					;21ad : 3e 2c   

.jmp_21af
	ldi [hl], a					;21af : 22      
	dec b						;21b0 : 05      
	jr nz, .jmp_21af			;21b1 : 20 fc   
	ldh a, [$e6]				;21b3 : f0 e6   
	and a, a					;21b5 : a7      
	jr z, .jmp_21c0				;21b6 : 28 08   
	ldh a, [$e7]				;21b8 : f0 e7   
	ld h, a						;21ba : 67      
	ldh a, [$e8]				;21bb : f0 e8   
	ld l, a						;21bd : 6f      
	jr .jmp_21df				;21be : 18 1f   

.jmp_21c0
	ld hl, $4000				;21c0 : 21 00 40
	ldh a, [$e4]				;21c3 : f0 e4   
	add a, a					;21c5 : 87      
	ld e, a						;21c6 : 5f      
	ld d, $00					;21c7 : 16 00   
	add hl, de					;21c9 : 19      
	ld e, [hl]					;21ca : 5e      
	inc hl						;21cb : 23      
	ld d, [hl]					;21cc : 56      
	push de						;21cd : d5      
	pop hl						;21ce : e1      
	ldh a, [$e5]				;21cf : f0 e5   
	add a, a					;21d1 : 87      
	ld e, a						;21d2 : 5f      
	ld d, $00					;21d3 : 16 00   
	add hl, de					;21d5 : 19      
	ldi a, [hl]					;21d6 : 2a      
	cp a, $ff					;21d7 : fe ff   
	jr z, .jmp_2222				;21d9 : 28 47 	 
	ld e, a						;21db : 5f     
	ld d, [hl]					;21dc : 56      
	push de						;21dd : d5      
	pop hl						;21de : e1   

.jmp_21df
	ldi a, [hl]					;21df : 2a      
	cp a, $fe					;21e0 : fe fe   
	jr z, .jmp_2226				;21e2 : 28 43
	ld de, $c0b0				;21e4 : 11 b0 c0
	ld b, a						;21e7 : 47      
	and a, $f0					;21e8 : e6 f0   
	swap a						;21ea : cb 37   
	scf							;21eb : 37      
	add a, e					;21ec : 83      
	ld e, a						;21ed : 5f      
	ld a, b						;21ee : 78      
	and a, $0f					;21ef : e6 0f   
	jr nz, .jmp_21f5			;21f1 : 20 02   
	ld a, $10					;21f3 : 3e 10  

.jmp_21f5
	ld b, a						;21f5 : 47  

.jmp_21f6
	ldi a, [hl]					;21f6 : 2a      
	cp a, $fd					;21f7 : fe fd   
	
	jr z, .jmp_2245				;21f9 : 28 4a 
	ld [de], a					;21fb : 12      
	cp a, $70					;21fc : fe 70   
	jr nz, .jmp_2205			;21fe : 20 05   
	call $22a0					;2200 : cd a0 22
	jr .jmp_221c				;2203 : 18 17   

.jmp_2205
	cp a, $80					;2205 : fe 80   
	jr nz, .jmp_220e			;2207 : 20 05   
	call $2318					;2209 : cd 18 23
	jr .jmp_221c				;220c : 18 0e   

.jmp_220e
	cp a, $5f					;220e : fe 5f   
	jr nz, .jmp_2217			;2210 : 20 05   
	call $2318					;2212 : cd 18 23
	jr .jmp_221c				;2215 : 18 05 

.jmp_2217
	cp a, $81					;2217 : fe 81   
	call z, $2318				;2219 : cc 18 23

.jmp_221c
	inc e						;221c : 1c      
	dec b						;221d : 05      
	jr nz, .jmp_21f6			;221e : 20 d6   
	jr .jmp_21df		    	;2220 : 18 bd  

.jmp_2222
	ld hl, $c0d2				;2222 : 21 d2 c0
	inc [hl]					;2225 : 34    

.jmp_2226
	ret							;2226 : c9 
	ld a, h					;2227 : 7c      
	ldh [$e7], a			;2228 : e0 e7   
	ld a, l					;222a : 7d      
	ldh [$e8], a			;222b : e0 e8   
	ldh a, [$e6]			;222d : f0 e6   
	inc a					;222f : 3c      
	cp a, $14				;2230 : fe 14   
	jr nz, .jmp_2239 		;2232 : 20 05   
	ld hl, $ffe5			;2234 : 21 e5 ff
	inc [hl]				;2237 : 34      
	xor a, a				;2238 : af  

.jmp_2239    
	ldh [$e6], a			;2239 : e0 e6   
	ldh a, [$a4]			;223b : f0 a4   
	ld [$c0aa], a			;223d : ea aa c0
	ld a, $01				;2240 : 3e 01   
	ldh [$ea], a			;2242 : e0 ea   
	ret						;2244 : c9      

.jmp_2245
	ld a, [hl]				;2245 : 7e  
	
.jmp_2246
	ld [de], a				;2246 : 12      
	inc e					;2247 : 1c      
	dec b					;2248 : 05      
	jr nz, .jmp_2246 		;2249 : 20 fb   
	inc hl					;224b : 23      
	jp $21df				;224c : c3 df 21  