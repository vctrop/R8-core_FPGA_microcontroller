.org #0000h
.code
boot:
    
    ; Initiate stack pointer at 4095
	ldh r0, #0Fh
    ldl r0, #FFh
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
    
    addi r0, #1
    ldh r8, #swi_handlers
    ldl r8, #swi_handlers
    ldh r9, #string_to_integer
    ldl r9, #string_to_integer
    st r9, r8, r0
    
    addi r0, #1
    ldh r8, #swi_handlers
    ldl r8, #swi_handlers
    ldh r9, #read_buffer
    ldl r9, #read_buffer
    st r9, r8, r0
	
    ;interruption handlers for increment and decrement buttons
    xor r0, r0, r0
	ldh r8, #irq_handlers
	ldl r8, #irq_handlers
	ldh r9, #RX_handler
	ldl r9, #RX_handler
	addi r0, #1
	st r9, r8, r0 
    
	;set baud rate for USART comunications
    ;217  -- floor (25e6 / 115200)
    xor r0, r0, r0
    ldh r8, #80h
	ldl r8, #30h			; rx_baud address
	ldh r9, #00h
	ldl r9, #D9h
	st r9, r8, r0 
	
	ldh r8, #80h
	ldl r8, #21h			; tx_baud address
	ldh r9, #00h
	ldl r9, #D9h
	st r9, r8, r0 
    
    ; THIS MUST BE THE LAST THING BEFORE MAIN:
    ; set interruption mask
    xor r0, r0, r0
    ldh r8, #80h
	ldl r8, #12h			; sets PIC interruption mask
	ldh r9, #00h			
	ldl r9, #02h            ; only RX can interrupt
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

RX_handler:
; Objective: reads data from RX, echoes it to TX and received string in kernel buffer 
; Argument:NULL
; Return: NULL
    xor r0, r0, r0
    ldh r8, #80h       ; r8 <- &RX_data
    ldl r8, #30h
    ld r5, r8, r0     ; r5 <- RX data
    
    ; echo read data
    ldh r8, #80h
	ldl r8, #20h		                ; r9 <- TX address
    wait_for_ready_signal_rx:		
        ld r7, r8, r0					; read ready signal
        addi r7, #0						; while(ready != 1) {}
        jmpzd #wait_for_ready_signal_rx	
    st r5, r8, r0		                ; write to TX
    
    ; store received data in rx buffer
    ldh r8, #rx_buffer
    ldl r8, #rx_buffer                  
    ldh r7, #rx_buffer_index            ;
    ldl r7, #rx_buffer_index            ;
    ld r6, r7, r0                       ; r6 <- rx_buffer_index
    
    ldh r12, #rx_buffer_byte
    ldl r12, #rx_buffer_byte
    ld r13, r12, r0
    addi r13, #0
    jmpzd #store_upper_byte_rx
    ; store_lower_byte_rx:
        ldh r11, #00h
        ldl r11, #FFh
        and r5, r5, r11                 ; r5 <- lower byte of RX DATA
        ld r9, r8, r6                   ; r9 <- rx_buffer[index] (hi)
        or r9, r9, r5                   ; 
        st r9, r8, r6                   ; rx_buffer[index] <- rx_buffer[index](hi) OR TX_DATA(lo)
        
        addi r6, #1                     ;
        st r6, r7, r0                   ; rx_buffer_index++
        st r0, r12, r0                  ; rx_buffer_byte <- 0
    jmpd #store_end_rx
    store_upper_byte_rx:
        sl0, r9, r5
        sl0, r9, r9
        sl0, r9, r9
        sl0, r9, r9
        sl0, r9, r9
        sl0, r9, r9
        sl0, r9, r9
        sl0, r9, r9
        st r9, r8, r6                   ; rx_buffer[index] <- RX DATA
        addi r13, #1
        st r13, r12, r0                 ; rx_buffer_byte <- 1
    store_end_rx:
    
    ; Check for <enter>
    ldh r11, #0
    ldl r11, #10
    xor r11, r5, r11
    jmpzd #finish_buffer_rx             ;
    jmpd #handler_end_rx                ; If RX DATA is Line Feed, finish buffer and set flag
    finish_buffer_rx:
    st r0, r8, r6                       ; rx_buffer[index+1] <- 0
    st r0, r7, r0                       ; index <- 0
    ldh r8, #rx_buffer_ready
    ldl r8, #rx_buffer_ready
    addi r11, #1                         ;
    st r11, r8, r0                       ; rx_buffer_ready <- 1
    
    handler_end_rx:
    rts
; end RX_handler

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

; List of system calls:
; 0 - print_string
; 1 - integer_to_string
; 2 - integer_to_hexstring
; 3 - string_to_integer
; 4 - read_buffer

	ldh r5, #swi_handlers
	ldl r5, #swi_handlers
	ld r5, r14, r5
	jsr r5
	rts
;end tsr_swi

; ------------------- SYSTEM CALLS ---------------------
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
    
string_to_integer:
; Objective: converts string to unsigned integer value
; Argument: r1 <- &string
; Return: -1 on failure, converted value on sucess
	;find the size of the string, so that we read it from back to front
	push r10
	push r11
	jsrd #strlen
	addi r3, #0
	jmpzd #failure_si	;string size must be bigger than 0
	
	ldh r5, #0
	ldl r5, #1
	sub r5, r3, r5		; r5 <- last string character address
	
	ldh r10, #0			; r10 is the multiplier index
	ldl r10, #1
	ldh r11, #0
	ldl r11, #10		; r11 is the 10 constant
	xor r3, r3, r3		; r3 contains the sum from the converted string
	ldh r7, #0
	ldl r7, #48			; zero character value
	ldh r8, #0
	ldl r8, #57			; nine character value
	loop_si:
		ld r6, r1, r5		; r6 <- string[i]
		sub r9, r8, r6 		; if r6 > 57 character is not an integer 
		jmpnd #failure_si
		sub r9, r6, r7		; if r6 < 48 character is not an integer (else r9 <- character value)
		jmpnd #failure_si
		mul r9, r10			; 
		mfl r9
		add r3, r9, r3
		jmpvd #failure_si	; overflow should never occur here
		mul r10, r11
		mfl r10
		subi r5, #1			; check for the beggining of the string
		jmpnd #return_si
		jmpd #loop_si
		
	failure_si:
		ldh r3, #ffh
		ldl r3, #ffh
		jmpd #return_si
		
	return_si:
		pop r11
		pop r10
		rts
;end string_to_integer

read_buffer:
; Objective: tries to read from RX data buffer, returns 0 if ENTER was not pressed yet, else copies n bytes to indicated address
; Argument: r1 <- &buffer, r2 <- size
; Return: r3 <- [num of buffered characters] on success, 0 on failure.
    xor r0, r0, r0
    xor r3, r3, r3
    ldh r5, #rx_buffer_ready        ;
    ldl r5, #rx_buffer_ready        ;
    ld r6, r5, r0                   ;
    addi r6, #0                     ;
    jmpzd #return_rb                ; if rx_buffer_ready == 0, return 0
    st r0, r5, r0                   ; rx_buffer_ready <- 0
    
    add r11, r2, r0                 ; r11 <- size
    ; r3 (return value) will be used as cont, being incremented in the end independently of <enter> detection
    for_loop_rb:                        ; for(cont = 0, cont < size, cont ++)    
        xor r12, r12, r12               ; break flag <- 0
        xor r5, r3, r11                 ; 
        jmpzd #return_rb                ; if cont == r11, break
        ldh r5, #0
        ldl r5, #2
        div r3, r5
        mfl r6                          ; r6 <- cont%2 (byte)
        mfh r7                          ; r7 <- cont/2 (index)
        ldh r8, #rx_buffer              ;
        ldl r8, #rx_buffer              ;
        ld r8, r8, r7                   ; r8 <- rx_buffer[index]
        addi r6, #0
        jmpzd #mask_hi_rb
        ; mask_lo_rb:
            ldh r9, #00h
            ldl r9, #FFh
            and r8, r8, r9              ; r8 <- lo_mask(rx_buffer[index])
            
            ldh r9, #00h                ;
            ldl r9, #0Ah                ;    
            xor r9, r8, r9              ;    
            jmpzd #enter_detected_lo_rb ;
            ldh r9, #00h                ;
            ldl r9, #0Dh                ;
            xor r9, r8, r9              ;
            jmpzd #enter_detected_lo_rb ; if lo_mask(rx_buffer[index]) == 000Ah or lo_mask(rx_buffer[index]) == 000Dh
            jmpd #concatenate_lo_rb
            enter_detected_lo_rb:
                xor r8, r8, r8          ; reg{lo_mask(rx_buffer[index])} <- 0
                addi r12, #1            ; break_flag <- 1
            concatenate_lo_rb:
                ld r10, r1, r7              ; r10 <- usr_buffer[index]
                ldh r9, #FFh
                ldl r9, #00h
                and r10, r10, r9            ;    
                or r8, r10, r8              ; r8 <- hi_mask(usr_buffer[index]) OR lo_mask(rx_buffer[index])
                jmpd #store_data_rb
            
        mask_hi_rb:
            ldh r9, #FFh
            ldl r9, #00h
            and r8, r8, r9              ; r8 <- hi_mask(rx_buffer[index])
            
            ldh r9, #0Ah                ;
            ldl r9, #00h                ;    
            xor r9, r8, r9              ;    
            jmpzd #enter_detected_hi_rb ;
            ldh r9, #0Dh                ;
            ldl r9, #00h                ;
            xor r9, r8, r9              ;
            jmpzd #enter_detected_hi_rb ; if lo_mask(rx_buffer[index]) == 000Ah or lo_mask(rx_buffer[index]) == 000Dh
            jmpd #store_data_rb
            enter_detected_hi_rb:
                xor r8, r8, r8
                addi r12, #1
            
        store_data_rb:
            st r8, r1, r7               ; buffer[index] <- r8
            addi r3, #1                 ; r3++
            addi r12, #0                ;    
            jmpzd #for_loop_rb          ; if break_flag == 1, break
            add r11, r3, r0             ; r11 <- r3, breaks for loop in next cycle
            
        jmpd #for_loop_rb
    
    return_rb:
    
    rts
;end read_buffer

; THIS IS NOT A SYSCALL BUT INSTEAD A HELPER FUNCTION
strlen:
; Objective: counts number of characters in NULL TERMINATED string vector, excluding the terminator byte
; Argument: r1 <- &string
; Return: str_size
	xor r3, r3, r3
	loop_sl:
		ld r5, r1, r3
		addi r5, #0
		jmpzd #return_sl
		addi r3, #1
		jmpd #loop_sl
	return_sl:
		rts
;end strlen
;--------------- END KERNEL FUNCTIONS AND DRIVERS ---------------------------

print_array:
; Objective: runs through array, converting each number to ascii and printing the result
; Argument: r1 <- &array, r2 <- size
; Return: NULL
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    
    xor r0, r0, r0
    xor r12, r12, r12                   ; index (r12) <- 0
    add r10, r1, r0                     ; r10 <- &array
    add r11, r2, r0                     ; r11 <- size
    
    do_while_pa:
        ld r1, r10, r12                 ; r1 <- array[r12]
        ldh r2, #string
        ldl r2, #string
		ldh r14, #0
		ldl r14, #1
		swi 			; integer_to_string
        ldh r1, #string
        ldl r1, #string
        ldh r14, #0
		ldl r14, #0
		swi 			; print_string
        
		; print space after number
		ldh r1, #space
		ldl r1, #space
		ldh r14, #0
		ldl r14, #0
		swi 			; print_string
		
        addi r12, #1
        sub r6, r12, r11
        jmpzd #do_while_end
        jmpd #do_while_pa
	
    do_while_end:
	
	; print new line
    ldh r1, #new_line
	ldl r1, #new_line
	ldh r14, #0
	ldl r14, #0
	swi 			; print_string
	
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    rts
; end print_array


BubbleSort:
; Objective: sorts vector based on order variable (vector address is hardcoded)
; Argument: r1 <- order, r2 <- size
; Return: NULL   
    ; Initialization code
	push r10
    xor r0, r0, r0          ; r0 <- 0
	add r10, r1, r0			; r10 <- order
	ldh r1, #vector
	ldl r1, #vector
    ld r2, r2, r0           ; r2 <- size
    add r3, r2, r1          ; r3 points the end of array (right after the last element)
    
    ldl r4, #0              ;
    ldh r4, #1              ; r4 <- 1
    
    
; Main code
scan_bs:
    addi r4, #0             ; Verifies if there was element swaping
    jmpzd #end_bs              ; If r4 = 0 then no element swaping
    
    xor r4, r4, r4          ; r4 <- 0 before each pass
    
    add r5, r1, r0          ; r5 points the first arrar element
    
    add r6, r1, r0          ;
    addi r6, #1             ; r6 points the second array element
    
; Read two consecutive elements and compares them    
loop_bs:
    ld r7, r5, r0           ; r7 <- array[r5]
    ld r8, r6, r0           ; r8 <- array[r6]
	addi r10, #0				; check order
	jmpzd #crescent_order_bs
	sub r2, r7, r8
	jmpnd #swap_bs
	jmpd #continue_bs
	crescent_order_bs:
    sub r2, r8, r7          ; If r8 > r7, negative flag is set
    jmpnd #swap_bs             ; (if array[r5] > array[r6] jump)
    
; Increments the index registers and verifies is the pass is concluded
continue_bs:
    addi r5, #1             ; r5++
    addi r6, #1             ; r6++
    
    sub r2, r6, r3          ; Verifies if the end of array was reached (r6 = r3)
    jmpzd #scan_bs             ; If r6 = r3 jump
    jmpd #loop_bs              ; else, the next two elements are compared

; Swaps two array elements (memory)
swap_bs:
    st r7, r6, r0           ; array[r6] <- r7
    st r8, r5, r0           ; array[r5] <- r8
    ldl r4, #1              ; Set the element swaping (r4 <- 1)
    jmpd #continue_bs
end_bs:
	pop r10
	rts
;end bublesort



main:
	; read string
	
	; print in inverse order
	
	main_sort:
	;read size of vector
	;read order
	
	;read vector elements
	
	;sort vector
	
	jmpd #main_sort  
.endcode


; Data area (variables)
.org #1000
.data
    ; KERNEL MEMORY SPACE
        ; interrupt vector arrays
	irq_handlers: 	        db #0, #0, #0, #0, #0, #0, #0, #0
	tsr_handlers:		    db #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
	swi_handlers: 		    db #0, #0, #0, #0, #0
        ; input buffer
    rx_buffer:              db #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0,
    rx_buffer_ready:        db #0
    rx_buffer_index:        db #0
    rx_buffer_byte:         db #0    
        ; error message strings
	inv_instruction_msg:    db #49h, #6eh, #76h, #61h, #6ch, #69h, #64h, #20h, #69h, #6eh, #73h, #74h, #72h, #75h, #63h, #74h, #69h, #6fh, #6eh, #20h, #66h, #6fh, #75h, #6eh, #64h, #20h, #6fh, #6eh, #20h, #61h, #64h, #64h, #72h, #65h, #73h, #73h, #20h, #32, #0     
    ov_msg:				    db #4fh, #76h, #65h, #72h, #66h, #6ch, #6fh, #77h, #20h, #6fh, #63h, #63h, #75h, #72h, #65h, #64h, #20h, #61h, #74h, #20h, #61h, #64h, #64h, #72h, #65h, #73h, #73h, #20h, #32, #0     
	div_zero_msg:		    db #44h, #69h, #76h, #69h, #73h, #69h, #6fh, #6eh, #20h, #62h, #79h, #20h, #7ah, #65h, #72h, #6fh, #20h, #6fh, #63h, #63h, #75h, #72h, #65h, #64h, #20h, #6fh, #6eh, #20h, #61h, #64h, #64h, #72h, #65h, #73h, #73h, #20h, #32, #0     
		; temporary strings 
	kernel_hex_string: 	    db #0, #0, #0, #0, #0, #0, #0, #0
	new_line:		        db #13, #10, #0
	space:				    db #20h, #0
	
    ; USER MEMORY SPACE
    user_buffer:            db #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
    string:                 db #0, #0, #0, #0, #0, #0, #0
    vector:     		    db #50 , #49 , #48 , #47 , #46 , #45 , #44 , #43 , #42 , #41 ,#40 , #39 , #38 , #37 , #36 , #35 , #34 , #33 , #32 , #31 , #30 , #29 , #28 , #27 , #26 , #25 , #24 , #23 , #22 , #21 , #20 , #19 , #18 , #17 , #16 , #15 , #14 , #13 , #12 , #11 , #10 , #9 , #8 , #7 , #6 , #5 , #4 , #3 , #2 , #1 
.enddata