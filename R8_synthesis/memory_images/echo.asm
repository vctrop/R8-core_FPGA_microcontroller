.org #0000h
.code
boot:
    
    ; Initiate stack pointer at 7FFFh
    ldh r0, #7fh
    ldl r0, #ffh
    ldsp r0
    
    ldh r0, #ISR
    ldl r0, #ISR
    ldisra r0
	
	ldh r0, #TSR
	ldl r0, #TSR
	ldtsra r0
    
    ; set exception handlers
	ldh r8, #tsr_handlers
	ldl r8, #tsr_handlers
	ldh r9, #tsr_invalid_instruction
	ldl r9, #tsr_invalid_instruction
	ldh r0, #0
	ldl r0, #1
	st r9, r8, r0 
	
	ldh r9, #tsr_swi
	ldl r9, #tsr_swi
	ldh r0, #0
	ldl r0, #8
	st r9, r8, r0
	
	ldh r9, #tsr_signed_overflow
	ldl r9, #tsr_signed_overflow
	ldh r0, #0
	ldl r0, #12
	st r9, r8, r0
	
	ldh r9, #tsr_div_by_zero
	ldl r9, #tsr_div_by_zero
	ldh r0, #0
	ldl r0, #15
	st r9, r8, r0
	

	; set software interruption handlers
	xor r0, r0, r0
	ldh r8, #swi_handlers
	ldl r8, #swi_handlers
	ldh r9, #print_string
	ldl r9, #print_string
	st r9, r8, r0					; swi[0] = print_string
	
	addi r0, #1
	ldh r8, #swi_handlers
	ldl r8, #swi_handlers
	ldh r9, #integer_to_string
	ldl r9, #integer_to_string
	st r9, r8, r0					; swi[1] = integer_to_string
	
	addi r0, #1
	ldh r8, #swi_handlers
	ldl r8, #swi_handlers
	ldh r9, #integer_to_hexstring
	ldl r9, #integer_to_hexstring
	st r9, r8, r0					; swi[2] = integer_to_hexstring
	
    ;interruption handlers for increment and decrement buttons
    xor r0, r0, r0
	ldh r8, #irq_handlers
	ldl r8, #irq_handlers
	ldh r9, #RX_handler
	ldl r9, #RX_handler
	addi r0, #1
	st r9, r8, r0 
    
	;set baud rate for USART comunications
    ;434  -- floor (25e6 / 57600)
    xor r0, r0, r0
    ldh r8, #80h
	ldl r8, #30h			; rx_baud address
	ldh r9, #0
	ldl r9, #434
	st r9, r8, r0 
	
	ldh r8, #80h
	ldl r8, #21h			; tx_baud address
	ldh r9, #0
	ldl r9, #434
	st r9, r8, r0 
    
    ; THIS SHOULD BE THE LAST THING BEFORE MAIN:
    ; set interruption mask
    xor r0, r0, r0
    ldh r8, #80h
	ldl r8, #12h			; sets PIC interruption mask
	ldh r9, #00h			
	ldl r9, #01h            ; only RX can interrupt
	st r9, r8, r0
    
    jmpd #main
    
ISR:
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
    pushf

    
    xor r0, r0, r0
    ldh r8, #80h
	ldl r8, #10h
	ld r10, r8, r0			; reads interruption number
	ldh r8, #irq_handlers
	ldl r8, #irq_handlers
    ld r8, r8, r10
	jsr r8					; jumps to appropriate handler 
	xor r0, r0, r0 
	ldh r8, #80h
	ldl r8, #11h
	st r10, r8, r0		  ; clears interruption
	
    end_interruption_handler:
    popf
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
    rti
;end interruption_handler


TSR:
; ATTENTION!! R15 IS NOT PRESERVED BETWEEN TRAP CALLS AND IS CONSIDERED KERNEL REGISTERS
; IT CAN BE USED FOR OTHERWISE TEMPORARY REGISTERS WHEN YOU CAN BE ASSURED THAT NO TRAP CAN OCCUR BETWEEN INSTRUCTIONS
; R14 is always the swi call number, indexing which software interrupt call you want to make 
	pop r15
	push r15 		; r15 <- trap instruction address  ; r14 is swi argument
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
    pushf
	
    mfc	r5		; reads trap cause
	ldh r8, #tsr_handlers
	ldl r8, #tsr_handlers
    ld r8, r8, r5		; r8 <- handler address
	jsr r8
	
    popf
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
    rti
;end trap_handler

    
tsr_invalid_instruction:
; Objective: prints error message with instruction address that caused trap
; Argument: r15 <- instruction address
; Return: NULL
	ldh r1, #inv_instruction_msg
	ldl r1, #inv_instruction_msg
	jsrd #print_string		; print error message
	
	xor r0, r0, r0
	add r1, r15, r0			; pc address number
	ldh r2, #kernel_hex_string
	ldl r2, #kernel_hex_string
	jsrd #integer_to_hexstring	
	xor r0, r0, r0 
	add r1, r3, r0
	jsrd #print_string		; print error address
	
	ldh r1, #new_line
	ldl r1, #new_line
	jsrd #print_string	; print '\n'
	
	rts
;end tsr_invalid_instruction

tsr_signed_overflow:
; Objective: prints error message with instruction address that caused trap
; Argument: r15 <- instruction address
; Return: NULL
	ldh r1, #ov_msg	
	ldl r1, #ov_msg
	jsrd #print_string		; print error message
	
	xor r0, r0, r0
	add r1, r15, r0			; pc address number
	ldh r2, #kernel_hex_string
	ldl r2, #kernel_hex_string
	jsrd #integer_to_hexstring	
	xor r0, r0, r0 
	add r1, r3, r0
	jsrd #print_string		; print error address
	
	ldh r1, #new_line
	ldl r1, #new_line
	jsrd #print_string	; print '\n'
	
	rts
;end tsr_signed_overflow

tsr_div_by_zero:
; Objective: prints error message with instruction address that caused trap
; Argument: r15 <- instruction address
; Return: NULL
	ldh r1, #div_zero_msg	
	ldl r1, #div_zero_msg
	jsrd #print_string		; print error message
	
	xor r0, r0, r0
	add r1, r15, r0			; pc address number
	ldh r2, #kernel_hex_string
	ldl r2, #kernel_hex_string
	jsrd #integer_to_hexstring	
	xor r0, r0, r0 
	add r1, r3, r0
	jsrd #print_string		; print error address

	ldh r1, #new_line
	ldl r1, #new_line
	jsrd #print_string		; print '\n'
	
	rts
;end tsr_div_by_zero

tsr_swi:
; Objective: jumps to handler based on value from r14, set before system call
; Argument: r14 <- handler number, r1 <- first argument of called function, r2 <- second argument of called function
; Return: NULL
	ldh r5, #swi_handlers
	ldl r5, #swi_handlers
	ld r5, r14, r5
	jsr r5
	rts
;end tsr_swi

print_string:
; Objective: sends a NULL TERMINATED STRING to serial port
; Argument: r1 <- &string
; Return: NULL
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
	rts 
;end print_string


integer_to_string:
; Objective: converts an 16 bit signed integer to ascii, storing the result in &string 
; Argument: r1 <- n, r2 <- &string
; Return: r3 <- &string TODO: (on success, 0 on failure)
	push r10
	push r11
	push r12 
    push r13
    
    xor r0, r0, r0
	ldh r9, #0
	ldl r9, #2bh			            ; sign is '+'
	add r10, r2, r0
    ldh r11, #0
	ldl r11, #0 			            ; r11 is size
	ldh r12, #0
	ldl r12, #10			            ; 10 constant
	ldh r13, #0
	ldl r13, #48			            ; 48 constant ('0' ascii caracter code)
	
	add r3, r0, r10 		            ; r3 <- &string
	
	addi r1, #0
	jmpnd #negative_sign_is
	jmpzd #zero_is
	jmpd #loop_is
	; if n is zero, write only '0' + '\0' 
	zero_is:
		st r13, r10, r0		            ; write '0' on first byte
		addi r10, #1
		st r0, r10, r0		            ; write '\0' on last byte
		jmpd #return_is
		
	negative_sign_is:
		not r1, r1
		addi r1, #1			            ; convert number to positive
		addi r9, #2			            ; sign receives '-'
	
	loop_is:
		div r1, r12
		mfh r5				            ; r5 <- n % 10
		add r6, r5, r13 	            ; r6 <- '0' + n % 10
		push r6 			            ; store character on stack
		addi r11, #1		            ; size++
		mfl r1				            ; r1 <- n / 10
		addi r1, #0			            ; if(n == 0) break
		jmpzd #write_is
		jmpd #loop_is
	
	write_is:
		st r9, r10, r0 		            ;write sign in string[0] 
		addi r10, #1
		write_loop_is:
			pop r6 
			st r6, r10, r0		        ; write string
			addi r10, #1 
			subi r11, #1		        ; if (size == 0) break
			jmpzd #write_terminator_is
			jmpd #write_loop_is
	write_terminator_is:
		st r0, r10, r0			        ; write '\0' 
	return_is:
	
    pop r13
    pop r12
	pop r11
	pop r10
	rts
; end integer_to_string

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


RX_handler:
; Objective: reads from RX data port and sends it back through TX data port
; Argument:NULL
; Return: NULL
    xor r0, r0, r0
    ldh r8, #80h       ; r8 <- &RX_data
    ldl r8, #30h
    ld r5, r8, r0     ; r5 <- RX data
    
    ; echo read data
    ldh r8, #80h
	ldl r8, #20h		                    ; r9 <- TX address
    wait_for_ready_signal_rx:		
        ld r7, r8, r0					; read ready signal
        addi r7, #0						; while(ready != 1) {}
        jmpzd #wait_for_ready_signal_rx	
    st r5, r8, r0		                ; write to TX
rts
; end RX_handler
    
;--------------- END KERNEL FUNCTIONS AND DRIVERS ---------------------------



; infinite busy wait
main:
	jmpd #main  
.endcode


; Data area (variables)
.org #1000
.data
    ; KERNEL MEMORY SPACE
	irq_handlers: 	    db #0, #0, #0, #0, #0, #0, #0, #0
	tsr_handlers:		db #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
	swi_handlers: 		db #0, #0, #0, #0
		;error message strings
	inv_instruction_msg: db #49h, #6eh, #76h, #61h, #6ch, #69h, #64h, #20h, #69h, #6eh, #73h, #74h, #72h, #75h, #63h, #74h, #69h, #6fh, #6eh, #20h, #66h, #6fh, #75h, #6eh, #64h, #20h, #6fh, #6eh, #20h, #61h, #64h, #64h, #72h, #65h, #73h, #73h, #20h, #32, #0     
    ov_msg:				db #4fh, #76h, #65h, #72h, #66h, #6ch, #6fh, #77h, #20h, #6fh, #63h, #63h, #75h, #72h, #65h, #64h, #20h, #61h, #74h, #20h, #61h, #64h, #64h, #72h, #65h, #73h, #73h, #20h, #32, #0     
	div_zero_msg:		db #44h, #69h, #76h, #69h, #73h, #69h, #6fh, #6eh, #20h, #62h, #79h, #20h, #7ah, #65h, #72h, #6fh, #20h, #6fh, #63h, #63h, #75h, #72h, #65h, #64h, #20h, #6fh, #6eh, #20h, #61h, #64h, #64h, #72h, #65h, #73h, #73h, #20h, #32, #0     
		; temporary strings 
	kernel_hex_string: 	db #0, #0, #0, #0, #0, #0, #0, #0
	new_line:		    db #13, #10, #0
	space:				db #20h, #0
	; USER MEMORY SPACE
                                          
.enddata