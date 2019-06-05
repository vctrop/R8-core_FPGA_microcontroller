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
    
    xor r0, r0, r0
	
    ldh r8, #80h            ;
    ldl r8, #01h            ; r8 <= PortA regConfig address
    ldh r9, #C0h            ;
    ldl r9, #00h            ; r9 <= PortA regConfig content
    st r9, r8, r0           ; Write regConfig content on its address
    
    ldh r8, #80h            ;
    ldl r8, #03h            ; r8 <= PortA irqEnable address
    ldh r9, #C0h            ; only two most significant bits interrupt the processor
    ldl r9, #00h            ; r8 <= PortA irqEnable content
    st r9, r8, r0           ; Write irqEnable content on its address

    ldh r8, #80h            ;
    ldl r8, #00h            ; r8 <= PortA regEnable address
    ldh r9, #C0h            ;
    ldl r9, #00h            ; r9 <= PortA regEnable content
    st r9, r8, r0           ; Write regEnable content on its address

	xor r0, r0, r0
	ldh r8, #isr_handlers
	ldl r8, #isr_handlers
	ldh r9, #isr_handler_0
	ldl r9, #isr_handler_0
	addi r0, #4
	st r9, r8, r0 
	
	ldh r9, #isr_handler_1
	ldl r9, #isr_handler_1
	addi r0, #1
	st r9, r8, r0
    
    ; 
    xor r0, r0, r0
    ldh r8, #tsr_handlers
	ldl r8, #tsr_handlers
	ldh r9, #tsr_invalid_handler
	ldl r9, #tsr_invalid_handler
	addi r0, #1
	st r9, r8, r0 
    
    ldh r9, #tsr_syscall_handler
	ldl r9, #tsr_syscall_handler
	addi r0, #7
	st r9, r8, r0 
    
    ldh r9, #tsr_overflow_handler
	ldl r9, #tsr_overflow_handler
	addi r0, #4
	st r9, r8, r0 
    
    ldh r9, #tsr_divzero_handler
	ldl r9, #tsr_divzero_handler
	addi r0, #3
	st r9, r8, r0 
	
    ;interruption enabling should be the last thing before main
    xor r0, r0, r0
    ldh r8, #80h
	ldl r8, #12h			; sets PIC interruption mask
	ldh r9, #00h			
	ldl r9, #C0h
	st r9, r8, r0
    
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
	ldh r8, #isr_handlers
	ldl r8, #isr_handlers
	add r8, r10, r8
    ld r8, r8, r0
	jsr r8					; jumps to appropriate handler 
	xor r0, r0, r0 
	ldh r8, #80h
	ldl r8, #11h
	st r10, r8, r0
	
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
   
; Interruption handlers
isr_handler_0:
	ldh r1, #0                      ;
	ldl r1, #5                      ;
	rts

isr_handler_1:          
	ldh r1, #0                      ;
	ldl r1, #3                      ;
	rts

TSR:
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
    mfc r10                 ; reads trap number
	ldh r8, #tsr_handlers
	ldl r8, #tsr_handlers
    ld r8, r8, r10
	jsr r8					; jumps to appropriate handler 

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
   
tsr_invalid_handler:
    ldh r1, #0
    ldl r1, #10
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
rts

tsr_syscall_handler:
    ldh r1, #0
    ldl r1, #11
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
rts

tsr_overflow_handler:
    ldh r1, #0
    ldl r1, #12
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
rts

tsr_divzero_handler:
    ldh r1, #0
    ldl r1, #13
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
rts
   
main:
    ; invalid tsr
    inv
    ; syscall
    swi
    ; overflow
    ldh r0, #ffh
    ldl r0, #ffh
    addi r0, #1
    ; 0-div
    xor r5, r5, r5
    div r0, r5
    
    halt
   
   
.endcode


; Data area (variables)
.org #1000
.data
    ; 
	isr_handlers: 	    db #0, #0, #0, #0, #0, #0, #0, #0
    tsr_handlers:       db #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
.enddata
