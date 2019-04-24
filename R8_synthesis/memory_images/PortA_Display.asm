;register usage:
;r0
;r1
;r2
;r3
;r4
;r5
;r6
;r7
;r8
;r9
;r10
;r11
;r12
;r13
;r14
;r15
;       PortA config:
;   bits 15:8 => 7 seg display
;   bits 7:4  => display enables, 7 being the leftmost and 4 the rightmost
;   bits 3:2  => push buttons, 3 being increment and 2 decrement

.org #00h
.code

main:
    ldh r0, #7Fh
    ldl r0, #FFh            
    ldsp r0                 ; Initiate stack pointer at the end of memory
    
    
    
    ldh r8, #80h            ;
    ldl r8, #01h            ; r8 <= PortA regConfig address
    ldh r9, #00h            ;
    ldl r9, #0Ch            ; r9 <= PortA regConfig content
    st r9, r8, r0           ; Write regConfig
    
    ldh r8, #80h            ;
    ldl r8, #00h            ; r8 <= PortA regEnable address
    ldh r9, #FFh            ;
    ldl r9, #FCh            ; r9 <= PortA regEnable content
    st r9, r8, r0           ; Write regEnable content on regEnable address
   
    ldh r10, #80h           ;
    ldl r10, #02h           ; r10 <= PortA regData address

loop: 
    jsrd #wait_sr			;waits a second while pooling and multiplexing displays	
	xor r1, r1, r1			;decimal_increment to timer
	jsrd #decimal_increment
    jmpd #loop
;end main


wait_sr:
	push r1
	push r2
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    
	xor r13, r13, r13		 ; r13 is button_flag counter
	
    ldh r15, #00h            ;
    ldl r15, #03h            ; number of outer loop runs
	
    wait_sr_outer_loop:
        subi r15, #1
        jmpzd   #wait_end
		
        ldh r14, #00h        ;
        ldl r14, #03h        ; number of inner loop runs
		
        addi r13, #0
		jmpzd #wait_sr_read_button
			subi r13, #1
		
        ; read bit 3 and 2 from regData (button_inc and button_dec)
		wait_sr_read_button:
        xor r0, r0, r0
		ldh r7, #80h            ;address to regData
		ldl r7, #02h
        ld r10, r7, r0			;r10 <= regData
        ldh r5, #00h
        ldl r5, #08h
        ldh r6, #00h
        ldl r6, #04h
		
		;checks for increment
        and r8, r10, r5            ; if button_inc is pressed, flag z = 0
        jmpzd #wait_sr_check_decrement
			addi r13, #0				;increment only if dubounce flag is not set
			jmpzd #wait_sr_increment
			jmpd #wait_sr_use_time_continue
			wait_sr_increment:
				addi r13, #4 			;flag to disable button_inc for 16 ms
				ldh r1, #00h
				ldl r1, #02h
				jsrd #decimal_increment
				jmpd #wait_sr_inner_loop
				
		;checks for decrement, only if increment was not pressed	
		wait_sr_check_decrement:
        and r9, r10, r6               
        jmpzd #wait_sr_use_time_continue
			addi r13, #0
			jmpzd #wait_sr_decrement
			jmpd #wait_sr_use_time_continue
			wait_sr_decrement:
				addi r13, #4 			;flag to disable button_inc for 16 ms
				ldh r1, #00h
				ldl r1, #02h
				jsrd #decimal_decrement
				jmpd #wait_sr_inner_loop
		
		;increments time to compensate the time not spent incrementing or decrementing
        wait_sr_use_time_continue:
			addi r14, #02h 		
		
		;waits 4ms = 200e6 cycles @ 50 MHz
        wait_sr_inner_loop:
            subi r14, #1			
            jmpzd #wait_sr_write_display			
            jmpd  #wait_sr_inner_loop
			
		wait_sr_write_display:
		;writes display and chooses the enable
		xor r0, r0, r0
		ldh r6, #00h
		ldl r6, #04h			;4 constant
		ldh r7, #display_index
		ldl r7, #display_index
		ld r5, r7, r0
		addi r5, #1				;display_index++
		sub r6, r6, r5			;if display_index >= 4, reset it to zero
		jmpnd  #wait_sr_reset_to_zero	;display_index >= 4
		jmpzd  #wait_sr_reset_to_zero
		jmpd   #wait_sr_store_index
		wait_sr_reset_to_zero:
			xor r5, r5, r5		; display_index = 0
		wait_sr_store_index:
		st r5, r7, r0
		
		ldh r8, #enable_display_mask
		ldl r8, #enable_display_mask
		ld r10, r8, r5		; loads the apropriate display_mask	
		
		ldh r9, #display
		ldl r9, #display
		ld r11, r9, r5		; loads the apropriate display 
		
		;7seg decoding:
		ldh r7, #seg_codes
		ldl r7, #seg_codes
		ld r12, r7, r11		; loads the decoded display
		
		or r13, r12, r10 	;sets both enable and seg_code
		
		ldh r7, #80h            ;
		ldl r7, #02h        	; r7 <= PortA regData address
		st r13, r7, r0			;writes to display
		jmpd #wait_sr_outer_loop

wait_end:
    ;select display to be output and print on displays here:
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
	pop r2
	pop r1
    rts
;end wait_sr


decimal_decrement:
    xor r0, r0, r0          
	
	ldh r5, #display		;
	ldl r5, #display
	ldh r6, #00h
	ldl r6, #00h
	add r6, r6, r1	
	
	ld r7, r5, r6				; r7 <= display[0]
	; r9 is temp
    sub r9, r7, r0       		; if r7 == 0
    jmpzd #decrement_if1
    jmpd #decrement_else1_begin
    decrement_if1:
		ldh r7, #00h		       		
		ldl r7, #09h				; r7 <= 9
		
		ldh r6, #00h
		ldl r6, #01h
		add r6, r6, r1
		ld r8, r5, r6				; r8 <= display[1]
		
        sub r9, r8, r0       		; if r8 == 0
        jmpzd #decrement_if11
        jmpd #decrement_else11_begin
        decrement_if11:
            ldh r8, #00h
			ldl r8, #09h			; r8 <= 9
			
			jmpd #decrement_else11_end
        decrement_else11_begin:				; else
            subi r8, #1            	; r8--
		decrement_else11_end:
			
		st r8, r5, r6				; display[1] <= r8  
					
		jmpd #decrement_else1_end
    decrement_else1_begin:				; else
        subi r7, #1				; r7--
    decrement_else1_end:
    
	ldh r6, #00h
	ldl r6, #00h
	add r6, r6, r1
	st r7, r5, r6				; display[0] <= r7
	
	rts
;end decimal_decrement


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
    jmpzd #increment_if1
    jmpd #increment_else1_begin
    increment_if1:
        xor r7, r7, r7       		; r7 <= 0
		ldh r6, #00h
		ldl r6, #01h
		add r6, r6, r1
		ld r8, r5, r6				; r8 <= display[1]
		
        sub r9, r8, r0       		; if r8 == 9
        jmpzd #increment_if11
        jmpd #increment_else11_begin
        increment_if11:
            xor r8, r8, r8       		; r8 <= 0
			jmpd #increment_else11_end
        increment_else11_begin:				; else
            addi r8, #1            		; r8++
		increment_else11_end:
			
		st r8, r5, r6				; display[1] <= r8  
		
			
		jmpd #increment_else1_end
    increment_else1_begin:				; else
        addi r7, #1					; r7++
    increment_else1_end:
    
	ldh r6, #00h
	ldl r6, #00h
	add r6, r6, r1
	
	st r7, r5, r6				; display[0] <= r7
	rts
;decimal_increment

.endcode

.data
    seg_codes:  			db #0300h, #9F00h, #2500h, #0D00h, #9900h, #4900h, #4100h, #1F00h, #0100h, #0900h
	display: 				db #0000h, #0000h, #0000h, #0000h						;display[0] = units timer, display[3] = tens counter
	enable_display_mask: 	db #0010h, #0020h, #0040h, #0080h
	display_index: 			db #0000h												;selects witch display is enabled	
.enddata

.org #8002h
	data: db #0007h