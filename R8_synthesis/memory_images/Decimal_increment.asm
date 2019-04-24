; Decimal increment
; Arg: r1 (0 to increment the timer, 2 to increment the counter) 
; Behavior not defined for (r1 != 0 and r1 != 2)
;


.org #00h
.code

decimal_increment:
    ldh r0, #00h          
	ldl r0, #09h             ; r0 <= 9
	
	ldh r5, #display		;
	ldl r5, #display
	ldh r6, #00h
	ldl r6, #00h
	add r6, r6, r1	
	
	ld r7, r5, r6				; r7 <= display[0]
	; r9 is temp
    sub r9, r7, r0       		; if r7 == 9
    jmpzd #if1
    jmpd #else1_begin
    if1:
        xor r7, r7, r7       		; r7 <= 0
		ldh r6, #00h
		ldl r6, #01h
		add r6, r6, r1
		ld r8, r5, r6				; r8 <= display[1]
		
        sub r9, r8, r0       		; if r8 == 9
        jmpzd #if11
        jmpd #else11_begin
        if11:
            xor r8, r8, r8       		; r8 <= 0
			jmpd #else11_end
        else11_begin:				; else
            addi r8, #1            		; r8++
		else11_end:
			
		st r8, r5, r6				; display[1] <= r8  
		
			
		jmpd #else1_end
    else1_begin:				; else
        addi r7, #1					; r7++
    else1_end:
    
	ldh r6, #00h
	ldl r6, #00h
	add r6, r6, r1
	
	st r7, r5, r6				; display[0] <= r7
	
	halt
.endcode

.data
    seg_codes:  			db #0300h, #9F00h, #2500h, #0D00h, #9900h, #4900h, #4100h, #1F00h, #0100h, #0900h
	display: 				db #0000h, #0009h, #0009h, #0000h						;display[0] = units timer, display[3] = tens counter
	enable_display_mask: 	db #0010h, #0020h, #0040h, #0080h
	display_index: 		db #0000h												;selects witch display is enabled	
.enddata


















