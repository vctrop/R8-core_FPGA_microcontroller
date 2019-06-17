.code
main:
	ldh r0, #05h
	ldl r0, #dch
	ldsp r0
	xor r0, r0, r0
	
	ldh r8, #80h
	ldl r8, #21h			
	ldh r9, #00h
	ldl r9, #D9h
	st r9, r8, r0						; set TX baud rate as 115200
	
	xor r6, r6, r6						; index
	;xor r5, r5, r5
	ldh r5, #buffer
	ldl r5, #buffer
	ldh r7, #01h			
	ldl r7, #f4h							; index limit of 500
	ldh r8, #80h
	ldl r8, #20h						; Tx address (w -> data, r -> ready)
		
	loop:
		ld r1, r5, r6					; r9 <- mem[100 + r6]
		ldh r2, #string
		ldl r2, #string
		jsrd #integer_to_hexstring
		add r1, r3, r0
		jsrd #print_string
		;ld r9, r5, r6					; r9 <- mem[100 + r6]
		
		
		; sr0 r10, r9
		; sr0 r10, r10
		; sr0 r10, r10
		; sr0 r10, r10
		; sr0 r10, r10
		; sr0 r10, r10
		; sr0 r10, r10
		; sr0 r10, r10					; r10 <- upper byte
		
		; ; print upper byte
		; wait_for_ready_up:
			; ld r3, r8, r0				; read ready signal
			; addi r3, #0					; while(ready != 1) {}
			; jmpzd #wait_for_ready_up
		
		; st r10, r8, r0					; write to TX
		; ; print lower byte
		; wait_for_ready_lo:
			; ld r3, r8, r0				; read ready signal
			; addi r3, #0					; while(ready != 1) {}
			; jmpzd #wait_for_ready_lo
		; st r9, r8, r0					; write to TX
		
		addi r6, #1						; index++
		sub r3, r6, r7
		jmpzd #end_loop
		jmpd #loop
	
	end_loop:
	jmpd #buffer
	
integer_to_hexstring:
; Objective: converts an 16 bit integer to a hexadecimal ascii string, storing the result in &string 
; Argument: r1 <- n, r2 <- &string
; Return: &string on success, 0 on failure.
	push r0
    push r1
    push r2
    push r4
    push r5
    push r6
    push r7
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    
    xor r0, r0, r0
	ldh r13, #0
	ldl r13, #48			; 48 constant ('0' ascii character code)
	ldh r14, #0
	ldl r14, #65			; 65 constant ('A' ascii character code)
	ldh r7, #0h
	ldl r7, #0fh			; mask to clean the 12 upper bits
	add r10, r2, r0			; r10 <- & string
	add r3, r2, r0 		    ; r3 <- &string
	
	ldh r5, #0
	ldl r5, #32
	st r5, r10, r0 	;write '0' in string[0]
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
	pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop r7
    pop r6
    pop r5
    pop r4  
    pop r2
    pop r1
    pop r0
	rts

print_string:
; Objective: sends a NULL TERMINATED STRING to serial port
; Argument: r1 <- &string
; Return: NULL
	push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
	xor r0, r0, r0 
	xor r6, r6, r6 		                    ; string index
	ldh r9, #80h
	ldl r9, #20h		                    ; r9 <- TX address
	loop_ps:
		ld r5, r1, r6		                ; r5 <- string[r6]
		addi r5, #0			                ; check for null termination
		jmpzd #return_ps
		wait_for_ready_signal_ps:		
			ld r7, r9, r0					; read ready signal
			addi r7, #0						; while(ready != 1) {}
			jmpzd #wait_for_ready_signal_ps	
		st r5, r9, r0		                ; write to TX
		addi r6, #1
		jmpd #loop_ps
	return_ps:
	pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop r7
    pop r6
    pop r5
    pop r4 
    pop r3 
    pop r2
    pop r1
    pop r0
	rts 

.endcode


.data
	string: db #0, #0, #0, #0, #0, #0, #0 
.org #300
	buffer: 	db 	#80
.enddata