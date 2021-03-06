.org #0000h
.code
boot:
    
    ; Initiate stack pointer at 1500
    ldh r0, #0fh
    ldl r0, #ffh
    ldsp r0
    
    ldh r0, #ISR
    ldl r0, #ISR
    ldisra r0
	
	ldh r0, #TSR
	ldl r0, #TSR
	ldtsra r0
    
    ;interruption handlers for increment and decrement buttons
    xor r0, r0, r0
	ldh r8, #irq_handlers
	ldl r8, #irq_handlers
	ldh r9, #increment_handler
	ldl r9, #increment_handler
	addi r0, #6
	st r9, r8, r0 
	
	ldh r9, #decrement_handler
	ldl r9, #decrement_handler
	addi r0, #1
	st r9, r8, r0
    
    xor r0, r0, r0
	xor r5, r5, r5
	
    ;reset variables:
	ldh r8, #display
	ldl r8, #display
	st  r0, r8, r5 				;display[0] <- 0
	addi r5, #1
	st  r0, r8, r5 				;display[1] <- 0
	addi r5, #1
	st  r0, r8, r5 				;display[2] <- 0
	addi r5, #1
	st  r0, r8, r5				;display[3] <- 0
	
	ldh r8, #display_index
	ldl r8, #display_index
	st  r0, r8, r0				;display_index <- 0
	
	ldh r8, #debounce_flag
	ldl r8, #debounce_flag
	st  r0, r8, r0				;debounce_flag <- 0
	
	ldh r8, #one_ms_timer
	ldl r8, #one_ms_timer
	ldh r6, #24h
	ldl r6, #9fh
	st  r6, r8, r0			    ; one_ms_timer <- 9,375e3
	
	
	ldh r8, #one_s_timer
	ldl r8, #one_s_timer
	ldh r6, #03h
	ldl r6, #E8h
	st  r6, r8, r0			;one_s_timer <- 1000
	
    ldh r8, #80h            ;
    ldl r8, #01h            ; r8 <= PortA regConfig address
    ldh r9, #00h            ;
    ldl r9, #0Ch            ; r9 <= PortA regConfig content
    st r9, r8, r0           ; Write regConfig content on its address
    
    
    ldh r8, #80h            ;
    ldl r8, #03h            ; r8 <= PortA irqEnable address
    ldh r9, #00h            ;
    ldl r9, #0Ch            ; r8 <= PortA irqEnable content
    st r9, r8, r0           ; Write irqEnable content on its address
	

    ldh r8, #80h            ;
    ldl r8, #00h            ; r8 <= PortA regEnable address
    ldh r9, #FFh            ;
    ldl r9, #FCh            ; r9 <= PortA regEnable content
    st r9, r8, r0           ; Write regEnable content on its address
    
    ; ldh r8, #80h            ;
    ; ldl r8, #03h            ; r8 <= PortA irqEnable address
    ; ldh r9, #00h            ; only the push buttons can interrupt
    ; ldl r9, #0Ch            ; r8 <= PortA irqEnable content
    ; st r9, r8, r0           ; Write irqEnable content on its address
    
    ; THIS SHOULD BE THE LAST THING BEFORE MAIN:
    ; set interruption mask
    xor r0, r0, r0
    ldh r8, #80h
	ldl r8, #12h			; sets PIC interruption mask
	ldh r9, #00h			
	ldl r9, #C0h			; mask allows the two lower prioriry interruptions pass
	st r9, r8, r0
    
    jmpd #main

; UCF for this program is:
; //Rightmost display is 0
; net "port_io[4]" loc = P17;
; net "port_io[5]" loc = P18;
; net "port_io[6]" loc = N15;
; net "port_io[7]" loc = N16;

; //PINS are ABCDEFG.
; net "port_io[8]" loc = M13;
; net "port_io[9]" loc = L14;
; net "port_io[10]" loc = N14;
; net "port_io[11]" loc = M14;
; net "port_io[12]" loc = U18;
; net "port_io[13]" loc = U17;
; net "port_io[14]" loc = T18;
; net "port_io[15]" loc = T17;

; net "port_io[3]" loc = a8;
; net "port_io[2]" loc = c9;
; //ignore
; net "port_io[1]" loc = v16;
; net "port_io[0]" loc = u16;

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
;end ISR


TSR:
    rti                 ; we don't execute any handlers for traps in this program
;end TSR


; Specific interruption handlers
increment_handler:
; Objective: checks for debounce flag, if available, increment debounce flag and increment counter
; Argument: NULL
; Return: NULL
	push r10
    xor r0, r0, r0
	xor r10, r10, r10
	
	ldh r7, #debounce_flag
	ldl r7, #debounce_flag
	ld r8, r7, r0						; r8 <- debounce_flag
	
	addi r10, #23
	addi r8, #0							;
	jmpzd #debounce_zero_ih				; if debounce_flag == 0:
	jmpd #check_time_ih			        ; (else, skip button checking)
	debounce_zero_ih:
	xor r8, r8, r8
	addi r8, #220
	st r8, r7, r0						; 	debounce_flag <- debounce_flag + 220	 (ms)
    
    ; call subroutine to increment counter
	ldh r1, #00h						;
	ldl r1, #02h						;
	jsrd #srt_decimal_increment			; decimal_increment(counter)
    
    check_time_ih:
	xor r0, r0, r0
	addi r10, #21
	add r1, r10, r0
	jsrd #srt_check_time				; check_time(r1)
	pop r10
	rts

decrement_handler:
; Objective: checks for debounce flag, if available, increment debounce flag and decrement counter
; Argument: NULL
; Return: NULL
	push r10
    xor r0, r0, r0
	xor r10, r10, r10
	
	ldh r7, #debounce_flag
	ldl r7, #debounce_flag
	ld r8, r7, r0						; r8 <- debounce_flag
	
	addi r10, #23
	addi r8, #0							;
	jmpzd #debounce_zero_dh				; if debounce_flag == 0:
	jmpd #check_time_dh			        ; (else, skip button checking)
	debounce_zero_dh:
	xor r8, r8, r8
	addi r8, #220
	st r8, r7, r0						; 	debounce_flag <- debounce_flag + 300	 (ms)
    
    ; call subroutine to decrement counter
    ldh r1, #00h						;
	ldl r1, #02h						;
	jsrd #srt_decimal_decrement			; decimal_decrement(counter)

    check_time_dh:
	xor r0, r0, r0
	addi r10, #21
	add r1, r10, r0
	jsrd #srt_check_time				; check_time(r1)
	pop r10
	rts
; interruption handling end   
   

	
; Subroutines
srt_check_time:
; Objective: to check if the ms and sec timers have been zeroed
; Argument: r1 as number of instructions used
; Return: NULL
	push r1
	
	xor r0, r0, r0
	addi r1, #8
    jsrd #srt_refresh_timers    	; srt_refresh_timers(r1)
    addi r3, #0
    jmpzd #r3_zero_check_time   	; if r3 == 0 (one_ms_timer <= 0)
    jmpd #r3_not_zero_check_time
    r3_zero_check_time:
	ldh r7, #debounce_flag
	ldl r7, #debounce_flag
	ld r8, r7, r0					; 	r8 <- debounce_flag
    addi r8, #0
    jmpzd #r8_zero              	; 	if(debounce_flag != 0)
	subi r8, #1						;
	st r8, r7, r0					;		debounce_flag--	
    r8_zero:
    jsrd #srt_write_display     	; 	write_display()
	
    addi r4, #0
    jmpzd #r4_zero_main         	;   if r4 == 0 (one_s_timer <= 0)
    jmpd #r4_not_zero_check_time
    r4_zero_main:
    xor r1, r1, r1              	;
    jsrd #srt_decimal_increment 	;       decimal_increment(timer)
    
    r4_not_zero_check_time:         ;   else   
    r3_not_zero_check_time:         ; else
	
	pop r1
	rts

srt_refresh_timers:
; Objective: to decrement one_ms and one_s timers according to processor usage
; Argument: r1 as number of instructions used
; Return: r3 as one_ms_timer state and r4 as one_s_timer state (1 if still positive)
    push r0
    
    xor r0, r0, r0
    xor r3, r3, r3                  ; ret0 <- 0
    xor r4, r4, r4                  ; ret1 <- 0

    sl0 r5, r1                      ; r5 <- r1*2 (instructions to pseudocycles conversion)
                                    ; a pseudocycle is equivalent to 2 cycles                      
    ldh r6, #one_ms_timer           ;
    ldl r6, #one_ms_timer           ;
    ld r7, r6, r0                   ; r7 <- mem[one_ms_timer]
    subi r7, #28                    ; compensate for the 14 instructions of the subroutine
    sub r7, r7, r5                  ; r7 <- mem[one_ms_timer] - arg*2
    jmpzd #ms_zero_or_neg           ;
    jmpnd #ms_zero_or_neg           ; if one_ms_timer is positive:
    addi r3, #1                     ;   ret0 <- 1
    addi r4, #1                     ;   ret1 <- 1
    st r7, r6, r0                   ;   mem[one_ms_timer] <- mem[one_ms_timer] - arg*2
    jmpd #condition_end_rt     
    ms_zero_or_neg:                 ; else
    ldh r7, #24h                    ;
    ldl r7, #9fh                    ;
    st r7, r6, r0                   ;   reset one_ms_timer
        
    ldh r6, #one_s_timer            ;
    ldl r6, #one_s_timer            ;
    ld r7, r6, r0                   ; 
    subi r7, #1                     ;   r7 <- mem[one_s_timer] - 1
    jmpzd #sec_zero_or_neg          ;       
    jmpnd #sec_zero_or_neg          ;   if one_s_timer is positive:
    addi r4, #1                     ;       ret1 <- 1
    st r7, r6, r0                   ;       mem[one_s_timer] <- mem[one_s_timer] - 1
    jmpd #condition_end_rt     
    sec_zero_or_neg:                ;   else
    ldh r7, #03h                    ;
    ldl r7, #E8h                    ;
    st r7, r6, r0                   ;       reset one_s_timer
    condition_end_rt:
    
    pop r0
    rts
; end srt_refresh_timers
    
srt_write_display:
; Objective: to choose the right enable and write on the display
; Argument: NULL
; Return: NULL
    push r0
    push r10
    push r11
    push r12
    
    xor r0, r0, r0
    ldh r6, #00h
    ldl r6, #04h
    ldh r7, #display_index
    ldl r7, #display_index
    ld r5, r7, r0
    addi r5, #1				        ; display_index++
    sub r6, r6, r5			        ; 
    jmpnd  #reset_to_zero_wd	    ; 
    jmpzd  #reset_to_zero_wd        ; if display_index >= 4
    jmpd   #store_index_wd      
    reset_to_zero_wd:               ;
    xor r5, r5, r5		            ;   display_index = 0
    store_index_wd:
    st r5, r7, r0                   ; mem[display_index] <- (display_index+1)%4
    
    ldh r8, #enable_display_mask
    ldl r8, #enable_display_mask
    ld r10, r8, r5		            ; loads the appropriate display_mask	
    
    ldh r9, #display
    ldl r9, #display
    ld r11, r9, r5		            ; loads the appropriate display 
    
    ; 7seg decoding
    ldh r7, #seg_codes
    ldl r7, #seg_codes
    ld r12, r7, r11		            ; loads the decoded display
    
    or r8, r12, r10 	            ; join enable mask and seg_code
    
    ldh r7, #80h                    ;
    ldl r7, #02h        	        ; r7 <= PortA regData address
    st r8, r7, r0			        ; writes to display
    
    pop r12
    pop r11
    pop r10
    pop r0
    rts
; end srt_write_display

srt_decimal_increment:
; Objective: to perform decimal increment on timer or counter
; Argument: r1 (0 to increment timer, 2 to increment counter)
; Return: NULL
    push r0

    ldh r0, #00h          
	ldl r0, #09h                    ; r0 <= 9
	ldh r5, #display		
	ldl r5, #display
	ldh r6, #00h
	ldl r6, #00h
	add r6, r6, r1	
	
	ld r7, r5, r6				    ; r7 <= display[r1]
    sub r9, r7, r0       		    ; if r7 == 9
    jmpzd #if1_di
    jmpd #else1_begin_di
    if1_di:
    xor r7, r7, r7       		    ;   r7 <= 0
    ldh r6, #00h
    ldl r6, #01h
    add r6, r6, r1
    ld r8, r5, r6				    ;   r8 <= display[r1+1]
    sub r9, r8, r0       		    ;       if r8 == 9
    jmpzd #if11_di
    jmpd #else11_begin_di
    if11_di:                        
    xor r8, r8, r8       	        ;           r8 <= 0
    jmpd #else11_end_di             ;
    else11_begin_di:		        ;       else
    addi r8, #1                     ;           r8++
    else11_end_di:
        
    st r8, r5, r6				    ;   display[r1+1] <= r8  
			
    jmpd #else1_end_di
    else1_begin_di:				    ; else
    addi r7, #1					    ;   r7++
    else1_end_di:
    
	ldh r6, #00h
	ldl r6, #00h
	add r6, r6, r1
	
	st r7, r5, r6				    ; display[r1] <= r7
    
    pop r0
	rts
;srt_decimal_increment


srt_decimal_decrement:
; Objective: to perform decimal decrement on timer or counter
; Argument: r1 (0 to decrement timer, 2 to decrement counter)
; Return: NULL
    push r0

    xor r0, r0, r0          
	ldh r5, #display		
	ldl r5, #display
	ldh r6, #00h
	ldl r6, #00h
	add r6, r6, r1	
	
	ld r7, r5, r6				    ; r7 <= display[r1]
    sub r9, r7, r0       		    ; if r7 == 0
    jmpzd #if1_dd
    jmpd #else1_begin_dd
    if1_dd:
    ldh r7, #00h		       		
    ldl r7, #09h				    ;   r7 <= 9
    ldh r6, #00h
    ldl r6, #01h
    add r6, r6, r1
    ld r8, r5, r6				    ;   r8 <= display[r1+1]
    sub r9, r8, r0       		    ;   if r8 == 0
    jmpzd #if11_dd
    jmpd #else11_begin_dd
    if11_dd:
    ldh r8, #00h
    ldl r8, #09h			        ;       r8 <= 9
    jmpd #else11_end_dd
    else11_begin_dd:			    ;   else
    subi r8, #1            	        ;       r8--
    else11_end_dd:
			
    st r8, r5, r6				    ;   display[r1+1] <= r8  
					
    jmpd #else1_end_dd
    else1_begin_dd:				    ; else
    subi r7, #1				        ;   r7--
    else1_end_dd:
    
	ldh r6, #00h
	ldl r6, #00h
	add r6, r6, r1
	st r7, r5, r6				    ; display[0] <= r7
	
    pop r0
	rts
;end srt_decimal_decrement


main:
	xor r1, r1, r1
    jsrd #srt_check_time
	
    jmpd #main
;end main

.endcode


.data
    ;KERNEL MEMORY SPACE
    irq_handlers: 	    db #0, #0, #0, #0, #0, #0, #0, #0
    ;USER MEMORY SPACE
	seg_codes:  			db #0300h, #9F00h, #2500h, #0D00h, #9900h, #4900h, #4100h, #1F00h, #0100h, #0900h
	display: 				db #0000h, #0000h, #0000h, #0000h						;display[0] = units timer, display[3] = tens counter
	enable_display_mask: 	db #00E0h, #00D0h, #00B0h, #0070h                       ;display enable active at 0
	display_index: 			db #0000h												;selects witch display is enabled	
	debounce_flag:			db #0000h												;
	one_ms_timer:		    db #61A8h												; 25e3 instructions result in 4ms
	one_s_timer:			db #03E8h												; 1000 times of 1 ms counter resets results in a second
.enddata