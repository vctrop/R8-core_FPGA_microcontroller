.org #0000h
.code
boot:
    
    ; Initiate stack pointer at 7FFFh
    ldh r0, #7fh
    ldl r0, #ffh
    ldsp r0
    
    xor r0, r0, r0

    ldh r8, #80h            ;
    ldl r8, #01h            ; r8 <= PortA regConfig address
    ldh r9, #00h            ;
    ldl r9, #01h            ; r9 <= PortA regConfig content
    st r9, r8, r0           ; Write regConfig content on its address
    
    
    ldh r8, #80h            ;
    ldl r8, #03h            ; r8 <= PortA irqEnable address
    ldh r9, #00h            ;
    ldl r9, #01h            ; r8 <= PortA irqEnable content
    st r9, r8, r0           ; Write irqEnable content on its address
	

    ldh r8, #80h            ;
    ldl r8, #00h            ; r8 <= PortA regEnable address
    ldh r9, #00h            ;
    ldl r9, #03h            ; r9 <= PortA regEnable content
    st r9, r8, r0           ; Write regEnable content on its address
    
    
    xor r0, r0, r0
    jmpd #main
;end boot


.org #0040h
interruption_handler:
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
    
    ldh r10, #80h
    ldl r10, #02h
    ld  r11, r10, r0        ; r11 <- portData
    
    ldh r5, #00h
    ldl r5, #01h
    and r6, r5, r11
    jmpzd #end_ih
    not r11, r11                 ; inverts led status
    st r11, r10, r0
    
    ;busy wait for a while before returning:
    ldh r13, #00h
    ldl r13, #ffh
    loop:
        subi r13, #1
        jmpzd #end_ih
        jmpd #loop
        
	end_ih:
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

main:
    jmpd #main  ;do nothing
   