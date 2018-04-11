SECTION "r1", ROM0[$0000]

INCBIN "baserom.gb", $0000, $0610

func_0610:
	call $218f				; 0610 : cd 8f 21
	
	ldh a, [$fd]				; Save and change memory bank to $03
	ldh [$e1], a				; 0618 : e0 e1   
	ld a, $01				; 
	ldh [$fd], a				; 
	ld [$2000], a				; 061e : ea 00 20
	
	;
	; The only available space for custom function is in BANK[1]
	; but this routine calls BANK[3]. I have to reaarange code to
	; squeeze in BANK swap with call to the cusotm code 
	;

	call call_jump_hack_3db0				; 062a : cd 0d 49
	
	ldh [$fd], a ; 
	ld [$2000], a ; Switch back to bank $03, a set inside call_jump_hack_3db0 to save space
	
	call call_mario_jump_490d
	
	call $48fc				;0621 : cd fc 48

	nop

	;ld bc, $c208				; 0624 : 01 08 c2
	;ld hl, data_jump_array				; pointer to data_2164
	;call call_mario_jump_490d					;  0633 : cd 0d 49	
	
	ld bc, $c218						;  062d : 01 18 c2
	ld hl, $2164						;  pointer to data_2164
	call call_mario_jump_490d					;  0633 : cd 0d 49
	
	ld bc, $c228						;  0636 : 01 28 c2
	ld hl, $2164						;  pointer to data_2164
	call call_mario_jump_490d						;  063c : cd 0d 49
	
	ld bc, $c238						;  063f : 01 38 c2
	ld hl, $2164						;  pointer to data_2164
	call call_mario_jump_490d						;  0645 : cd 0d 49
	
	ld bc, $c248						;  0648 : 01 48 c2
	ld hl, $2164						;  pointer to data_2164
	call call_mario_jump_490d						;  064e : cd 0d 49
	
	call $4a94						;  0651 : cd 94 4a
	call $498b						;  0654 : cd 8b 49
	call $4aea						;  0657 : cd ea 4a
	call $4b3c						;  065a : cd 3c 4b
	call $4b6f						;  065d : cd 6f 4b
	call $4b8a						;  0660 : cd 8a 4b
	call $4bb5						;  0663 : cd b5 4b
	ldh a, [$e1]						;  0666 : f0 e1
	ldh [$fd], a						;  0668 : e0 fd
	ld [$2000], a						;  066a : ea 00 20
	call $1f24						;  066d : cd 24 1f
	call $2488						;  0670 : cd 88 24
	ldh a, [$fd]						;  0673 : f0 fd
	ldh [$e1], a						;  0675 : e0 e1
	ld a, $02						;  0677 : 3e 02
	ldh [$fd], a						;  0679 : e0 fd
	ld [$2000], a						;  067b : ea 00 20
	call $5844						;  067e : cd 44 58
	ldh a, [$e1]						;  0681 : f0 e1
	ldh [$fd], a						;  0683 : e0 fd
	ld [$2000], a						;  0685 : ea 00 20
	call $1983						;  0688 : cd 83 19
	call $16ec						;  068b : cd ec 16
	call $17b3						;  068e : cd b3 17
	call $0ae1						;  0691 : cd e1 0a
	call $0a24						;  0694 : cd 24 0a
	call $1efa						;  0697 : cd fa 1e
	ld hl, $c0ce						;  069a : 21 ce c0
	ld a, [hl]						;  069d : 7e
	and a, a						;  069e : a7
	ret z						;  069f : c8

INCBIN "baserom.gb", $06A0, $2164 - $06A0

data_2164:
	db $04, $04, $03, $03, $02, $02, $02, $02, $02, $02, $02, $02, $02, $01, $01, $01 
	db $01, $01, $01, $01, $00, $01, $00, $01, $00, $00, $7F


INCBIN "baserom.gb", $217F, $21a8 - $217F
;
; called before 082f

; void func_21a8 {

;	uint8_t *ptr;
;	uint8_t *ptr_de;
;
;	uint8_t *var_e4 = 0xffe4;
;	uint8_t *var_e5 = 0xffe5;
;	uint8_t *var_e6 = 0xffe6;
;
;	// pointer uint16_t
;	uint8_t *var_e7 = 0xffe7;
;	uint8_t *var_e8 = 0xffe8;
;
;	uint8_t *var_ea = 0xffea;
;	uint8_t *var_a4 = 0xffa4;
;
;
;	ptr = $c0b0;
;	for(uint8_t b = $10 ; b > 0 ; b--) {
;		*ptr = $2c;
;		ptr++;
;	}
;
;	if(*var_e6 == 0) {
;		ptr = 0x4000;
;		ptr += (*var_e4) * 2;
;
;		ptr = (uint16_t) *ptr; 
;		ptr += (*var_e5) * 2; // 0x4018 <-- the first level is game menu
;		if(*ptr & 0xFF == 0) { // if the address if >= 0xFF00
;			ptr = 0xc0d2;
;			(*ptr)++;
;			return;
;		}
;
;		ptr = (uint16_t) *ptr;
;
;		uint8_t block = *ptr;
;		ptr++;
;		if(*ptr == 0xFE) {
;			*var_e7 = (ptr & 0xFF00)>>8;
;			*var_e8 = ptr & 0xFF;
;			uint8_t i = *var_e6;
;			if(i == 0x14) {
;				(*var_e5)++;
;				i = 0;
;			}
;			*var_e6 = i;
;			ptr = 0xc0aa;
;			*ptr = *var_a4;
;			*var_ea = $01;
;			return;
;		}
;
;		ptr_de = 0xc0b0;
;		ptr += (block 0xF0) >> 4; // y - coordinate
;		if(block & 0xF == 0) {
;			block = $10;
;		}
;
;		uint8_t block2 = *ptr;
;		ptr++;
;		if(block2 == 0xfd) {
;			// do something, end of function .jmp_2245
;		}
;		
;		(0x22a0)();
;
;
;	}
; }


;
;
;
;
;
;------------------------------------------------------
; 								Fill [$c0b0..$c0c0] with $2c (44)
func_21a8:
	ld b, $10					;21a8 : 06 10   
	ld hl, $c0b0				;21aa : 21 b0 c0
	ld a, $2c					;21ad : 3e 2c   

.jmp_21af
	ldi [hl], a					;21af : 22      
	dec b						;21b0 : 05      
	jr nz, .jmp_21af			;21b1 : 20 fc    
;------------------------------------------------------
	ldh a, [$e6]				;21b3 : f0 e6   
	and a, a					;21b5 : a7      
	jr z, .jmp_21c0				;21b6 : 28 08   
	ldh a, [$e7]				;21b8 : f0 e7   
	ld h, a						;21ba : 67      
	ldh a, [$e8]				;21bb : f0 e8   
	ld l, a						;21bd : 6f      
	jr .jmp_21df				;21be : 18 1f   

;------------------------------------------------------
.jmp_21c0
	ld hl, $4000				;21c0 : 21 00 40 Level pointers are stored at this addr
	ldh a, [$e4]				;21c3 : f0 e4   
	add a, a					;21c5 : 87      
	ld e, a						;21c6 : 5f      
	ld d, $00					;21c7 : 16 00   
	add hl, de					;21c9 : 19     

;								Double value at $ffe4 and add it to level pointer
;								It will be $4018 for the menu screen
;------------------------------------------------------
	ld e, [hl]					;21ca : 5e      
	inc hl						;21cb : 23      
	ld d, [hl]					;21cc : 56      
	push de						;21cd : d5      
	pop hl						;21ce : e1      

;								Load pointer value and stor it in HL
;								Its $6190 for the menu screen
;------------------------------------------------------
	ldh a, [$e5]				;21cf : f0 e5   
	add a, a					;21d1 : 87      
	ld e, a						;21d2 : 5f      
	ld d, $00					;21d3 : 16 00   
	add hl, de					;21d5 : 19    

;								Double value from $ffe5 and add it to HL 
;								(doesnt change for the first screen)
;------------------------------------------------------  
	ldi a, [hl]					;21d6 : 2a      
	cp a, $ff					;21d7 : fe ff   
	jr z, .jmp_2222				;21d9 : 28 47 
	ld e, a						;21db : 5f     
	ld d, [hl]					;21dc : 56      
	push de						;21dd : d5      
	pop hl						;21de : e1   

;								Follow the pointer under HL to get another pointer
;								Set HL to the new pointer
;------------------------------------------------------  
;
;
;
;
; Reading level data ($5f15 for the first screen)
; 

.jmp_21df
	ldi a, [hl]					;21df : 2a      
	cp a, $fe					;21e0 : fe fe   
	jr z, .jmp_2227				;21e2 : 28 43
	ld de, $c0b0				;21e4 : 11 b0 c0 <--- pointer to the 16 blocks column
	ld b, a						;21e7 : 47      
	and a, $f0					;21e8 : e6 f0   Take the Higher 4 bits 
	swap a						;21ea : cb 37   and add them to $c0b0 pointer
	add a, e					;21ec : 83      
	ld e, a						;21ed : 5f      store results in e
	ld a, b						;21ee : 78      
	and a, $0f					;21ef : e6 0f   
	jr nz, .jmp_21f5			;21f1 : 20 02   jump if lower 4 bits != 0 
	ld a, $10					;21f3 : 3e 10  

.jmp_21f5
	ld b, a						;21f5 : 47  

.jmp_21f6
	ldi a, [hl]					;21f6 : 2a     Load next byte from the pointer to a 
	cp a, $fd					;21f7 : fe fd   
	jr z, .jmp_2245				;21f9 : 28 4a  Jump to .jmp_2245 if $fd
	ld [de], a					;21fb : 12     Copy byte value under $c0b0 + (a & $f0)>>4 position
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

	ret							;2226 : c9 
.jmp_2227
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

INCBIN "baserom.gb", $224f, $3FD0 - $224f

data_jump_array:
 	db 3, 2, 3, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 1, 1, 2, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, $7F


SECTION "r2", ROMX, BANK[1]

;INCBIN "baserom.gb", $4008, $24 

INCBIN "baserom.gb", $4000, $32

INCBIN "gfx/sprites0.bin", $0000, $F00 

INCBIN "baserom.gb", $4F32, $3DB0 - $0F32

call_jump_hack_3db0:
	call $0837				; 0613 : cd 37 08
	ld bc, $c208				; 0624 : 01 08 c2
	ld hl, data_jump_array				; pointer to data_2164

	ld a, [$FF99]
	and a, a
	jr z, .jmp_leave
	ld hl, data_2164
.jmp_leave
	ld a, $03							
	ret


SECTION "r3", ROMX, BANK[2]

LevelPointers:

dw $61da ; $6192 -> $62be (A2be real address)
dw $61b7 
dw $61da
dw $6192 
dw $61b7
dw $61da
dw $6192 
dw $61b7
dw $61da
dw $6192 
dw $61b7
dw $61da
dw $6190 ; start screen  -> $5f15

INCBIN "baserom.gb", $801A, $391A - $001A

INCBIN "gfx/sprites3.bin", $0000, $500 

INCBIN "baserom.gb", $BE1A, $3FFF - $3E1A

SECTION "r4", ROMX, BANK[3]

INCBIN "baserom.gb", $C000, $090d

; $C201 - Y pos
; $C202 - X pos
; $C203 - Animation index
; $C204 - ?
; $C205 - Mario directionf acing
; $C206 - ?
; $C207 - Jump status. 0=no jump, 1=move Mario up, 2=move Mario down
; $C208 - ?

;
;
; Mario Jump Function
;
; Called 5x in a row with. Only the first call ($c208) is relevant to Mario
; bc = [$c208, $c218, $c228, $c238, $c248]
; hl = $2164
;
;
;
;
;

call_mario_jump_490d:
		ld a, [bc]				; 490d : 0a   
		ld e, a				; e = [bc] 

		ld d, $00				; 490f : 16 00
		dec c				; 4911 : 0d   
		ld a, [bc]				; a = [c2X8 - 1]
		dec c				; 4913 : 0d   
		dec c				; 4914 : 0d   
		dec c				; 4915 : 0d   
		dec c				; 4916 : 0d   
		dec c				; 4917 : 0d   
		dec c				; 4918 : 0d   ; bc = c2X8 - 7

		and a, a				; 4919 : a7   
		ret z				; if ( [c2X7] == 0 ) return // leave if there is no jump
		
		cp a, $02				; if([c2x7] == 2) then Move mario down
		jr z, .jmp_move_mario_down				

		add hl, de				; 491f : 19   
		ld a, [hl]				; 4920 : 7e   
		cp a, $7f				; 4921 : fe 7f
		jr z, .jmp_4948			; 4923 : 28 23
								; if [hl] == 127 goto .jmp_4948
								; When Mario is at the top of jump parabola 
								; change jump status to $02 (Mario goes down)

		ld a, [bc]				; 4925 : 0a   
		sub a, [hl]				; 4926 : 96 jumping hl = $2166 (3)
		ld [bc], a				; Update mario Y possition with Y - 3 ([$c208] -= [$2166]) 
		inc e				; 4928 : 1c   
.jmp_4929
		ld a, e				; 4929 : 7b   
		inc c				; 492a : 0c   
		inc c				; 492b : 0c   
		inc c				; 492c : 0c   
		inc c				; 492d : 0c   
		inc c				; 492e : 0c   
		inc c				; 492f : 0c   
		inc c				; 4930 : 0c   
		ld [bc], a				; 4931 : 02  
		ret					;	4932 : c9
.jmp_move_mario_down
		ld a, e				; 4933 : 7b   
		cp a, $ff				; 4934 : fe ff
		jr z, .jmp_495b				; 4936 : 28 23
		add hl, de				; 4938 : 19   
		ld a, [hl]				; 4939 : 7e   
		cp a, $7f				; 493a : fe 7f
		jr z, .jmp_4944			; 493c : 28 06

.jmp_decryment_mario_y_pos						
		ld a, [bc]				; 493e : 0a   
		add a, [hl]				; 493f : 86   
		ld [bc], a				; 4940 : 02   
		dec e				; 4941 : 1d   
		jr .jmp_4929				; 4942 : 18 e5
.jmp_4944
		dec hl				; 4944 : 2b   
		dec e				; 4945 : 1d   
		jr .jmp_decryment_mario_y_pos				; 4946 : 18 f6

.jmp_4948					; Change jump status to $$02 - Mario goes down
		dec de				; 4948 : 1b   
		dec hl				; 4949 : 2b   
		ld a, $02				; 494a : 3e 02
		inc c				; 494c : 0c   
		inc c				;  494d : 0c   
		inc c				;  494e : 0c   
		inc c				;  494f : 0c   
		inc c				;  4950 : 0c   
		inc c				;  4951 : 0c   
		ld [bc], a			;  4952 : 02   
		dec c				;  4953 : 0d   
		dec c				;  4954 : 0d   
		dec c				;  4955 : 0d   
		dec c				;  4956 : 0d   
		dec c				;  4957 : 0d   
		dec c				;  4958 : 0d   
		jr .jmp_decryment_mario_y_pos				;  4959 : 18 e3

.jmp_495b					;  Clean up and leave
		xor a, a			;  495b : af   
		inc c				;  495c : 0c   
		inc c				;  495d : 0c   
		inc c				;  495e : 0c   
		inc c				;  495f : 0c   
		inc c				;  4960 : 0c   
		inc c				;  4961 : 0c   
		ld [bc], a				;  4962 : 02   
		inc c				;  4963 : 0c   
		ld [bc], a				;  4964 : 02   
		ret 				;  4965 : c9          

INCBIN "baserom.gb", $C966, $3FFF - $0966
