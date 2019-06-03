.code
boot:
	ldh r5, #0
	ldl r5, #ffh
	ldsp r5
	jmpd #main
	
;-------------------------------------------------------
integer_to_string:
; Objective: converts an 16 bit signed integer to ascii, storing the result in &string 
; Argument: r1 <- n, r2 <- &string
; Return: &string on success, 0 on failure.
	push r10
	push r11
	push r12 
    push r13
    
    xor r0, r0, r0
	ldh r9, #0
	ldl r9, #2bh			; sign is '+'
	add r10, r2, r0
    ldh r11, #0
	ldl r11, #0 			; r11 is size
	ldh r12, #0
	ldl r12, #10			; 10 constant
	ldh r13, #0
	ldl r13, #48			; 48 constant ('0' ascii caracter code)
	
	add r3, r0, r10 		; r3 <- &string
	
	addi r1, #0
	jmpnd #negative_sign
	jmpzd #zero_is
	jmpd #loop_is
	;if n is zero, write only '0' + '\0' 
	zero_is:
		st r13, r10, r0		; write '0' on first byte
		addi r10, #1
		st r0, r10, r0		; write '\0' on last byte
		jmpd #return_is
		
	negative_sign:
		not r1, r1
		addi r1, #1			; convert number to positive
		addi r9, #2			; sign receives '-'
	
	loop_is:
		div r1, r12
		mfh r5				; r5 <- n % 10
		add r6, r5, r13 	; r6 <- '0' + n % 10
		push r6 			; store character on stack
		addi r11, #1		; size++
		mfl r1				; r1 <- n / 10
		addi r1, #0			; if(n == 0) break
		jmpzd #write_is
		jmpd #loop_is
	
	write_is:
		st r9, r10, r0 		;write sign in string[0] 
		addi r10, #1
		write_loop_is:
			pop r6 
			st r6, r10, r0		; write string
			addi r10, #1 
			subi r11, #1		; if (size == 0) break
			jmpzd #write_terminator_is
			jmpd #write_loop_is
	write_terminator_is:
		st r0, r10, r0			; write '\0' 
	return_is:
	
    pop r13
    pop r12
	pop r11
	pop r10
	rts
; end integer_to_string
;-------------------------------------------------------

;-----------------
print_string:
; Objective: sends a NULL TERMINATED STRING to serial port
; Argument: r1 <- &string
; Return: NULL
	xor r0, r0, r0 
	xor r6, r6, r6 		; string index
	ldh r9, #80h
	ldl r9, #20h		; r9 <- TX address
	loop_ps:
		ld r5, r1, r6		; r5 <- string[r6]
		addi r5, #0			; check for null termination
		jmpzd #return_ps
		wait_for_ready_signal_ps:		
			ld r7, r9, r0					; read ready signal
			addi r7, #0						; while(ready != 1) {}
			jmpzd #wait_for_ready_signal_ps	
		st r5, r9, r0		; write to TX
		addi r6, #1
		jmpd #loop_ps
	return_ps:
	rts 
;end print_string

integer_to_hexstring:
; Objective: converts an 16 bit integer to a hexadecimal ascii string, storing the result in &string 
; Argument: r1 <- n, r2 <- &string
; Return: &string on success, 0 on failure.
	push r10
	push r11
	push r12 
    push r13
    
    xor r0, r0, r0
	ldh r13, #0
	ldl r13, #48			; 48 constant ('0' ascii character code)
	ldh r14, #0
	ldl r14, #65			; 65 constant ('A' ascii character code)
	ldh r7, #0h
	ldl r7, #0fh			; mask to clean the 12 upper bits
	add r10, r2, r0			; r10 <- & string
	add r3, r2, r0 		    ; r3 <- &string
	

	st r13, r10, r0 	;write '0' in string[0]
	ldh r5, #0
	ldl r5, #120
	addi r10, #1
	st r5, r10, r0 		;write 'x' in string[1]
	
	xor r11, r11, r11
	addi r11, #5 				; this is a reverse index
	st r0, r10, r11			; write '\0' at the last character
	subi r11, #1
	
	add r6, r1, r0			; r6 <- n

	loop_hs:
		and r8, r6, r7  ; clean upper bits
		add r9, r8, r0 	; r9 <- r8 (r9 is temp register for comparison)
		subi r9, #10
		jmpnd #decimal_character_loop_hs	; if(r8 < 10) 
			add r9, r9, r14 				; if(r8 > 10) r6 <- 'A' + (n % 16) - 10
			jmpd #loop_compare_hs
		decimal_character_loop_hs:
			add r9, r8, r13 	; if(r8 < 10)  r6 <- '0' + n % 16
	loop_compare_hs:	
		st r9, r10, r11
		sr0 r6, r6
		sr0 r6, r6
		sr0 r6, r6
		sr0 r6, r6		; r6 <- r6 >> 4
		subi r11, #1
		jmpzd #return_hs
		jmpd #loop_hs
	return_hs:
    pop r13
    pop r12
	pop r11
	pop r10
	rts
;end integer_to_hexstring
	
main:
	;these must be restored between calls
	ldh r10, #0
	ldl r10, #10
	ldh r11, #0
	ldl r11, #11
	ldh r12, #0
	ldl r12, #12
	
    xor r0, r0, r0
    ldh r2, #string
    ldl r2, #string
	ldh r1, #7fh
	ldl r1, #ffh
	jsrd #integer_to_hexstring

	halt
	
.endcode

.org #150
.data
	string: db #FFFFh #FFFFh #FFFFh #FFFFh #FFFFh #FFFFh #FFFFh
.enddata