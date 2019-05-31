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
	add r10, r2, r0
	add r3, r0, r10 		; r3 <- &string
	

	st r13, r10, r0 	;write '0' in string[0]
	ldh r5, #0
	ldl r5, #120
	addi r10, #1
	st r5, r10, r0 		;write 'x' in string[1]
	addi r10, #1
	
	;first character
	ldh r5, #0
	ldl r5, #12			; 12 constant	
	add r6, r1, r0
	shift_12_ix:
		sr0 r6, r6
		subi r5, #1
		jmpzd #store_first_ch_ix
		jmpd #shift_12_ix
		
	store_first_ch_ix:
	add r7, r6, r0
	subi r6, #10		; if( (n % 16) > 9) 
	jmpnd #decimal_character_ix_1
		add r6, r6, r14 	; r6 <- 'A' + (n % 16) - 10
		jmpd #write_first_ix:
	decimal_character_ix_1:
		add r6, r7, r13 	; r6 <- '0' + n % 16
	write_first_ix:
		st r6, r10, r0
		addi r10, #1
		
	;second caracter
	ldh r5, #0
	ldl r5, #8			; 12 constant	
	ldh r7, #00h
	ldl r7, #0fh
	add r6, r1, r0
	shift_8_ix:
		sr0 r6, r6
		subi r5, #1
		jmpzd #store_second_ch_ix
		jmpd #shift_8_ix
		
	store_second_ch_ix:
	and r6, r6, r7		;mask rest of the number
	add r7, r6, r0
	subi r6, #10		; if( (n % 16) > 9) 
	jmpnd #decimal_character_ix_2
		add r6, r6, r14 	; r6 <- 'A' + (n % 16) - 10
		jmpd #write_second_ix:
	decimal_character_ix_2:
		add r6, r7, r13 	; r6 <- '0' + n % 16
	write_second_ix:
		st r6, r10, r0
		addi r10, #1
		
	; do the same for the rest of the characters
	write_terminator_ix:
		st r0, r10, r0			; write '\0' 
    pop r13
    pop r12
	pop r11
	pop r10
	rts
	
; integer_to_hexstring:
; ; Objective: converts an 16 bit integer to a hexadecimal ascii string, storing the result in &string 
; ; Argument: r1 <- n, r2 <- &string
; ; Return: &string on success, 0 on failure.
	; push r10
	; push r11
	; push r12 
    ; push r13
    
    ; xor r0, r0, r0
	; add r10, r2, r0
    ; xor r11, r11, r11			; r11 is size
	; ldh r12, #0
	; ldl r12, #16			; 16 constant
	; ldh r13, #0
	; ldl r13, #48			; 48 constant ('0' ascii character code)
	; ldh r14, #0
	; ldl r14, #65			; 65 constant ('A' ascii character code)
	; add r3, r0, r10 		; r3 <- &string
	
	; addi r1, #0
	; jmpnd #negative_sign_ix
	; jmpd #loop_ix
	
	; negative_sign_ix:
		; not r12, r12
		; addi r12, #1
	; loop_ix:
		; div r1, r12			; n / 16
		; mfh r5				; r5 <- n % 16
		; mfh r6				; temporary compare register 
		; subi r6, #10		; if( (n % 16) > 9) 
		; jmpnd #decimal_character_ix
			; add r6, r6, r14 	; r6 <- 'A' + (n % 16) - 10
			; push r6
			; jmpd #loop_compare_ix
		; decimal_character_ix:
			; add r6, r5, r13 	; r6 <- '0' + n % 16
			; push r6 			; store character on stack
		; loop_compare_ix:
		; addi r11, #1		; size++
		; mfl r1				; r1 <- n / 16
		; addi r1, #0			; if(n == 0) break
		; jmpzd #write_ix
		; jmpd #loop_ix
	
	; write_ix:
		; st r13, r10, r0 	;write '0' in string[0]
		; ldh r5, #0
		; ldl r5, #120
		; addi r10, #1
		; st r5, r10, r0 		;write 'x' in string[1]
		; addi r10, #1
		; ldh r5, #0
		; ldl r5, #4
		
		; sub r5, r11, r5 	; r5 <- number of zeros to be filled in 
		; jmpzd #write_loop_ix
		; fill_zeros_ix:
			; st r13, r10, r0		;write '0'
			; addi r10, #1
			; subi r5, #1		
			; jmpzd #write_loop_ix
			; jmpd #fill_zeros_ix
		
		; write_loop_ix:
			; pop r6 
			; st r6, r10, r0		; write string
			; addi r10, #1 
			; subi r11, #1		; if (size == 0) break
			; jmpzd #write_terminator_ix
			; jmpd #write_loop_ix
	; write_terminator_ix:
		; st r0, r10, r0			; write '\0' 
    ; pop r13
    ; pop r12
	; pop r11
	; pop r10
	; rts
; ; end integer_to_hexstring
	
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
	ldh r1, #f0h
	ldl r1, #00h
	jsrd #integer_to_hexstring
	add r1, r2, r0
	jsrd #print_string
	halt
	
.endcode

.org #150
.data
	string: db #0 #0 #0 #0 #0 #0 #0
.enddata