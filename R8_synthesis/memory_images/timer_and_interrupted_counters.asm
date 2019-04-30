.org #0000h
.code
boot:
    
    ; Initiate stack pointer at 7FFFh
    ldh r0, #7fh
    ldl r0, #ffh
    ldsp r0
    
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
	ldh r6, #61h
	ldl r6, #A8h
	st  r6, r8, r0			    ; one_ms_timer <- 25e3
	
	
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
    ldl r9, #C0h            ; r8 <= PortA irqEnable content
    st r9, r8, r0           ; Write irqEnable content on its address
	

    ldh r8, #80h            ;
    ldl r8, #00h            ; r8 <= PortA regEnable address
    ldh r9, #FFh            ;
    ldl r9, #FCh            ; r9 <= PortA regEnable content
    st r9, r8, r0           ; Write regEnable content on its address
    
    ;ldh r10, #80h           ;
    ;ldl r10, #02h           ; r10 <= PortA regData address
    
    xor r0, r0, r0
    jmpd #main


.org #0040h
interruption_handler:
    push r0
    push r5
    push r6
    push r7
    pushf
    
    xor r0, r0, r0
    ldh r5, #80h
    ldl r5, #02h
    ld r6, r5, r0           ; r6 <- regData
    
    ldh r5, #00h
    ldl r5, #08h            ; r5 <- increment interruption mask
    and r7, r6, r5          ;
    jmpzd #isr_increment_false
    jsrd #increment_handler
    isr_increment_false:
    
    ldh r5, #00h
    ldl r5, #04h            ; r5 <- decrement interruption mask
    and r7, r6, r5
    jmpzd #isr_decrement_false
    jsrd #decrement_handler
    isr_decrement_false:
    
    popf
    pop r7
    pop r6
    pop r5
    pop r0
    rti
;end interruption_handler


; Specific interruption handlers
increment_handler:
    
    rts

decrement_handler:
    
    rts
; Interruption handling end   
    
main:
    
    ldh r1, #00h
    ldl r1, #07h
    jsrd #srt_refresh_timers    ; srt_refresh_timers(7)
    addi r3, #0
    jmpzd #r3_zero_main         ; if r3 == 0 (one_ms_timer <= 0)
    jmpd #r3_not_zero_main
    r3_zero_main:
    jsrd #srt_write_display     ;   write_display()
    
    addi r4, #0
    jmpzd #r4_zero_main         ;   if r4 == 0 (one_s_timer <= 0)
    jmpd #r4_not_zero_main
    r4_zero_main:
    xor r1, r1, r1              ;
    jsrd #srt_decimal_increment ;       decimal_increment(timer)
    
    r4_not_zero_main:           ;   else   
    r3_not_zero_main:           ; else
    
    jmpd #main

; Subroutines
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
    ldh r7, #61h                    ;
    ldl r7, #A8h                    ;
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

.endcode


.data
	seg_codes:  			db #0300h, #9F00h, #2500h, #0D00h, #9900h, #4900h, #4100h, #1F00h, #0100h, #0900h
	display: 				db #0000h, #0000h, #0000h, #0000h						;display[0] = units timer, display[3] = tens counter
	enable_display_mask: 	db #00E0h, #00D0h, #00B0h, #0070h                       ;display enable active at 0
	display_index: 			db #0000h												;selects witch display is enabled	
	debounce_flag:			db #0000h												;
	one_ms_timer:		    db #61A8h												; 25e3 instructions result in 4ms
	one_s_timer:			db #03E8h												; 1000 times of 1 ms counter resets results in a second
.enddata