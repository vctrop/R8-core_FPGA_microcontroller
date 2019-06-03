.code
boot:
	ldh r5, #0fh
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
    halt
;end bubblesort
main:
	;these must be restored between calls
	ldh r10, #0
	ldl r10, #10
	ldh r11, #0
	ldl r11, #11
	ldh r12, #0
	ldl r12, #12
	
    xor r0, r0, r0
    ldh r1, #array
	ldl r1, #array
	ldh r2, #size
	ldl r2, #size
	ld r2, r2, r0
	push r0
	jsrd #bubblesort
	; xor r0, r0, r0
    ; ldh r1, #array
	; ldl r1, #array
	; ldh r2, #size
	; ldl r2, #size
	; ld r2, r2, r0
	; addi r0, #1
	; push r0 
	; jsrd #bubblesort
	halt
	
.endcode

.org #200
.data
	; string: db #FFFFh #FFFFh #FFFFh #FFFFh #FFFFh #FFFFh #FFFFh
	array:  db #50 , #49 , #48 , #47 , #46 , #45 , #44 , #43 , #42 , #41 ,#40 , #39 , #38 , #37 , #36 , #35 , #34 , #33 , #32 , #31 , #30 , #29 , #28 , #27 , #26 , #25 , #24 , #23 , #22 , #21 , #20 , #19 , #18 , #17 , #16 , #15 , #14 , #13 , #12 , #11 , #10 , #9 , #8 , #7 , #6 , #5 , #4 , #3 , #2 , #1 
	size:	db #50
.enddata