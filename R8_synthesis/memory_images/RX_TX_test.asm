.code
boot:
    xor r0, r0, r0          ;
    ldh r0, #07h
    ldl r0, #d0h
    ldsp r0                 ; Initiate stack pointer at 2000
    
    ldh r0, #ISR
    ldl r0, #ISR
    ldisra r0
    
    ldh r8, #irq_handlers
    ldl r8, #irq_handlers
    ldh r9, #handler_rx
    ldl r9, #handler_rx
    addi r0, #1
    st r9, r8, r0
    
    xor r0, r0, r0
    ldh r8, #80h
    ldl r8, #20h
    ldh r9, #01h
    ldl r9, #B2h
    st r9, r8, r0          ; TX(freq_baud) <- 50000000/115200 
    
    ldh r8, #80h            ;
    ldl r8, #30h            ;
    ldh r9, #01h            ;
    ldl r9, #B2h            ;
    st r9, r8, r0           ; RX(freq_baud) <- 50000000/115200 
    

    
    ldh r8, #80h            ;
    ldl r8, #12h            ;
    ldh r9, #00h            ;
    ldl r9, #01h            ;
    st r9, r8, r0           ; Set PIC interruption mask
    
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
    
    xor r0, r0, r0
    ldh r8, #80h
	ldl r8, #10h
	ld r10, r8, r0			; reads interruption number
    
	ldh r8, #irq_handlers
	ldl r8, #irq_handlers
	add r8, r10, r8
    ld r8, r8, r0
	jsr r8					; jumps to appropriate handler 
	
    xor r0, r0, r0          ;
	ldh r8, #80h            ;
	ldl r8, #11h            ;
	st r10, r8, r0          ; Write interruption number to PIC ack reg
	
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
    
handler_rx:
    xor r0, r0, r0
    ldh r8, #80
    ldl r8, #30
    ld r9, r8, r0
    
    push r9
    pop r9
; end_handler_rx

main:
    ldh r8, #80h
    ldl r8, #21h
    ldh r9, #00h
    ldl r9, #66h
    st r9, r8, r0          ; TX <- decrypted char
    
    main_loop:
        jmpd #main_loop
    ;halt

.endcode


.org #1000
.data
    irq_handlers: 	    db #0, #0, #0, #0, #0, #0, #0, #0
    
.enddata