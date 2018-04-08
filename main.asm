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

INCBIN "baserom.gb", $217F, $3FD0 - $217F

data_jump_array:
 	db 3, 2, 3, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 1, 1, 2, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, $7F


SECTION "r2", ROMX, BANK[1]

INCBIN "baserom.gb", $4000, $3DB0 

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

INCBIN "baserom.gb", $8000, $3FFF

;INCBIN "baserom.gb", $8000, $832
;HackTile01:
;	db $FF, $EE, $EE, $DD, $FF, $EE, $EE, $DD
;	db $00, $00, $00, $00, $00, $00, $00, $00
;HackTile02:
;	db $00, $00, $00, $00, $00, $00, $00, $00
;	db $00, $00, $00, $00, $00, $00, $00, $00
;HackTile03:
;	db $00, $00, $00, $00, $00, $00, $00, $00
;	db $00, $00, $00, $00, $00, $00, $00, $00
;INCBIN "baserom.gb", $8862, $379D






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
								; change jump status to 0x02 (Mario goes down)

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

.jmp_4948					; Change jump status to $0x02 - Mario goes down
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
