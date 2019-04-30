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
    
    ; call srt_refresh_timers
    ; if r3 == 0
    ;   refresh displays
    ;   if r1 == 0
    ;       update timer
    
    ldh r1, #00h
    ldl r1, #0Ah
    
    jsrd #srt_refresh_timers
    
    jmpd #main

; Subroutines
srt_refresh_timers:
    ; Objective: to decrement one_ms and one_s timers according to processor usage
    ; Argument: r1 as number of instructions used
    ; Return: r3 as one_ms_timer state and r4 as one_s_timer state (1 if still positive)
    push r0
    
    xor r0, r0, r0
    xor r3, r3, r3          ; ret0 <- 0
    xor r4, r4, r4          ; ret1 <- 0

    sl0 r5, r1                      ; r5 <- r1*2 (instructions to pseudocycles conversion)
                                    ; a pseudocycle is equivalent to 2 cycles                      
    ldh r6, #one_ms_timer    ;
    ldl r6, #one_ms_timer    ;
    ld r7, r6, r0                   ; r7 <- mem[one_ms_timer]
    subi r7, #28                    ; compensate for the 14 instructions of the subroutine
    sub r7, r7, r5                  ; r7 <- mem[one_ms_timer] - arg*2
    jmpzd #cyc_zero_or_neg          ;
    jmpnd #cyc_zero_or_neg          ; if one_ms_timer is positive:
    addi r3, #1                     ;   ret0 <- 1
    st r7, r6, r0                   ;   mem[one_ms_timer] <- mem[one_ms_timer] - arg*2
    jmpd #condition_end     
    cyc_zero_or_neg:                ; else
    ldh r7, #61h                    ;
    ldl r7, #A8h                    ;
    st r7, r6, r0                   ;   reset one_ms_timer
        
    ldh r6, #one_s_timer           ;
    ldl r6, #one_s_timer           ;
    ld r7, r6, r0                   ; 
    subi r7, #1                     ;   r7 <- mem[one_s_timer] - 1
    jmpzd #mili_zero_or_neg         ;       
    jmpnd #mili_zero_or_neg         ;   if one_s_timer is positive:
    addi r4, #1                     ;       ret1 <- 1
    st r7, r6, r0                   ;       mem[one_s_timer] <- mem[one_s_timer] - 1
    jmpd #condition_end     
    mili_zero_or_neg:               ;   else
    ldh r7, #03h                    ;
    ldl r7, #E8h                    ;
    st r7, r6, r0                   ;       reset one_s_timer
    condition_end:
    
    pop r0
    rts

    
srt_write_display:   
    rts
    
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