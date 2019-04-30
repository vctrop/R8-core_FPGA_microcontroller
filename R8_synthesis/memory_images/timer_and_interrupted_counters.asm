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
	
	ldh r8, #four_ms_counter
	ldl r8, #four_ms_counter
	ldh r6, #C5h
	ldl r6, #30h
	st  r6, r8, r0			;four_ms_counter <- 50e3
	
	
	ldh r8, #four_ms_counter
	ldl r8, #four_ms_counter
	ldh r6, #00h
	ldl r6, #FAh
	st  r6, r8, r0			;one_s_counter <- 250
	
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
    jsr #increment_handler
    isr_increment_false:
    
    ldh r5, #00h
    ldl r5, #04h            ; r5 <- decrement interruption mask
    and r7, r6, r5
    jmpzd #isr_decrement_false
    jsr #decrement_handler
    isr_decrement_false:
    
    popf
    pop r7
    pop r6
    pop r5
    pop r0
    rti
;end interruption_handler


increment_handler:
    

decrement_handler:
    

update_timer_counters:


write_display:

main:
    
    jmpd #main
.endcode


.data
	seg_codes:  			db #0300h, #9F00h, #2500h, #0D00h, #9900h, #4900h, #4100h, #1F00h, #0100h, #0900h
	display: 				db #0000h, #0000h, #0000h, #0000h						;display[0] = units timer, display[3] = tens counter
	enable_display_mask: 	db #00E0h, #00D0h, #00B0h, #0070h                       ;display enable active at 0
	display_index: 			db #0000h												;selects witch display is enabled	
	debounce_flag:			db #0000h												;
	four_ms_counter:		db #C530h												;50e3 instructions result in 4ms
	one_s_counter:			db #00FAh												;250 times of 4 ms counter resets results in a second
.enddata