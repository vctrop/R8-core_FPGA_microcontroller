.code
integer_to_string:
; Objective: converts an 16 bit signed integer number to a string
; Argument: r1 <- n
; Return: &string on success, 0 on failure.
	push r10
	push r11
	push r12 
	ldh r9, #0
	ldl r9, #2bh			; sign is '+'
	ldh r10, #string
	ldl r10, #string
	ldh r11, #0
	ldl r11, #5 		; r11 is string index
	ldh r12, #0
	ldl r12, #10			; 10 constant
	ldh r13, #0
	ldl r13, #30			; 30 constant ( '0' ascii caracter code)
	
	xor r0, r0, r0
	addi r1, #0
	jmpnd #negative_sign
	jmpd #loop_is
	negative_sign:
		not r1, r1
		addi r1, #1			; convert number to positive
		addi r9, #2			; sign receives '-'
	loop_is:
		div r1, r12
		mfh r5
		add r6, r5, r13 	; '0' + n % 10
		st r6, r10, r11 	;
		addi r11, #1		; i++
		
	pop r12
	pop r11
	pop r10
	rts
.endcode

.data
	string: db #0 #0 #0 #0 #0 #0 #0
.enddata