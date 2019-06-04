.org #0000h
.code
boot:
    ; Initiate stack pointer at 2000
    ldh r0, #07h
    ldl r0, #d0h
    ldsp r0
    
    ldh r0, #ISR
    ldl r0, #ISR
    ldisra r0
	
	ldh r0, #TSR
	ldl r0, #TSR
	ldtsra r0
	
	; set exception handlers
	ldh r8, #tsr_handler
	ldl r8, #tsr_handler
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
	ldh r8, #swi_handler
	ldl r8, #swi_handler
	ldh r9, #print_string
	ldl r9, #print_string
	st r9, r8, r0					; swi[0] = print_string
	
	addi r0, #1
	ldh r8, #swi_handler
	ldl r8, #swi_handler
	ldh r9, #integer_to_string
	ldl r9, #integer_to_string
	st r9, r8, r0					; swi[1] = integer_to_string
	
	addi r0, #1
	ldh r8, #swi_handler
	ldl r8, #swi_handler
	ldh r9, #integer_to_hexstring
	ldl r9, #integer_to_hexstring
	st r9, r8, r0					; swi[2] = integer_to_hexstring
	
    ;interruption enabling should be the last thing before main
    ; no interruptions are enable for this application
    jmpd #main
;end boot


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
    
	; we should never reach this point
    xor r0, r0, r0
    ldh r8, #80h
	ldl r8, #10h
	ld r10, r8, r0			; reads interruption number
	; ldh r8, #irq_handlers
	; ldl r8, #irq_handlers
    ; ld r8, r8, r10
	; jsr r8					; jumps to appropriate handler 
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
	ldh r8, #trs_handlers
	ldl r8, #trs_handlers
    ld r8, r8, r5		; r8 <- handler address
	jsr r8
	
    popf
	push r14
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
	
	ldh r1, #carriage_return
	ldl r1, #carriage_return
	jsrd #print_string		; print '\n'
	
	rts
;end tsr_invalid_instruction

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
	
	ldh r1, #carriage_return
	ldl r1, #carriage_return
	jsrd #print_string		; print '\n'
	
	rts
;end tsr_signed_overflow

tsr_div_by_zero:
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
	
	ldh r1, #carriage_return
	ldl r1, #carriage_return
	jsrd #print_string		; print '\n'
	
	rts
;end tsr_div_by_zero


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

;--------------- END KERNEL FUNCTIONS AND DRIVERS ---------------------------


delay:
; Objective: busy wait from an undetermined amount of time
; Argument: NULL 
; Return: NULL
	ldh r5, #7Fh
	ldl r5, #ffh
	delay_loop:
		subi r5, #1
		nop 
		nop
		nop
		nop
		jmpzd #delay_end
		jmpd #delay_loop
	delay_end
	rts
;end delay

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
		ldl r14, #1
		swi 			; print_string
        
        addi r12, #1
        sub r6, r12, r11
        jmpzd #do_while_end
        jmpd #do_while_pa
        
    do_while_end:
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    rts
; end print_array


BubbleSort:
; Objective: sorts vector based on order (0 for crescent and 1 for descrent)
; Argument: r1 <- &vector, r2 <- size, on stack: order
; Return: NULL
    ; Initialization code
	pop r9		
	pop r10    				; r10 <- argument 3 (order)
	push r9
    xor r0, r0, r0          ; r0 <- 0
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
    rts
;end bubblesort


main:
	;prints unsorted array:
	xor r5, r5, r5 ; order regirster
	main_loop:
		xor r0, r0, r0
		ldh r1, #array
		ldl r1, #array
		ldh r8, #size
		ldl r8, #size
		ld r2, r8, r0
		jsrd #print_array
		
		xor r0, r0, r0
		ldh r1, #array
		ldl r1, #array
		ldh r8, #size
		ldl r8, #size
		ld r2, r8, r0
		push r5	
		jsrd #bubblesort		
		
		jsrd #delay	
		
		ldh r1, #array
		ldl r1, #array
		ldh r8, #size
		ldl r8, #size
		ld r2, r8, r0
		jsrd #print_array
		
		jsrd #delay
		
		ldh r6, #7fh
		ldl r6, #ffh
		add r6, r6, r6		; overflow with add
		
		jsrd #delay
		
		addi r6, #250		; overflow with addi
		
		jsrd #delay
		
		ldh r7, #80h
		ldl r7, #00h
		add r7, r7, r7	   ; overflow with sub
		
		addi r7, #1 	   ; overflow with subi 
		
		not r5, r5			; reverse sorting order
		jmpd #main_loop
.endcode

; Data area (variables)
.org #750
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
	kernel_hex_string   db #0, #0, #0, #0, #0, #0, #0, #0
	carriage_return:    db #32, #0     
	; USER MEMORY SPACE
	; Bubble sort
    array:     		    db #50 , #49 , #48 , #47 , #46 , #45 , #44 , #43 , #42 , #41 ,#40 , #39 , #38 , #37 , #36 , #35 , #34 , #33 , #32 , #31 , #30 , #29 , #28 , #27 , #26 , #25 , #24 , #23 , #22 , #21 , #20 , #19 , #18 , #17 , #16 , #15 , #14 , #13 , #12 , #11 , #10 , #9 , #8 , #7 , #6 , #5 , #4 , #3 , #2 , #1 
	size:      		    db #50                                  ; 'array' size  
    ; Strings
    string:             db #0, #0, #0, #0, #0, #0, #0
    init_arr_str:       db #49h, #6eh, #69h, #74h, #69h, #61h, #6ch, #20h, #61h, #72h, #72h, #61h, #79h, #3ah, #20h, #32, #0   ; "Initial array: \n"
    end_arr_str:        db #53h, #6fh, #72h, #74h, #65h, #64h, #20h, #61h, #72h, #72h, #61h, #79h, #3ah, #20h, #32, #0         ; "Sorted array: \n"
                                                                                  ; "\n"
.enddata
