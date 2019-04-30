.org #0000h
boot:
    
    ; Initiate stack pointer at 7FFFh
    ldh r0, #7fh
    ldl r0, #ffh
    ldsp r0
    
    xor r0, r0, r0
    
    ldh r8, #80h            ;
    ldl r8, #01h            ; r8 <= PortA regConfig address
    ldh r9, #00h            ;
    ldl r9, #0Ch            ; r9 <= PortA regConfig content
    st r9, r8, r0           ; Write regConfig content on its address
    
    ldh r8, #80h            ;
    ldl r8, #00h            ; r8 <= PortA regEnable address
    ldh r9, #FFh            ;
    ldl r9, #FCh            ; r9 <= PortA regEnable content
    st r9, r8, r0           ; Write regEnable content on its address
    
    ldh r8, #80h            ;
    ldl r8, #03h            ; r8 <= PortA irqEnable address
    ldh r9, #00h            ;
    ldl r9, #C0h            ; r8 <= PortA irqEnable content
    st r9, r8, r0           ; Write irqEnable content on its address
    
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

increment_handler:
    

decrement_handler:
    
    
main:
    
    jmpd #main