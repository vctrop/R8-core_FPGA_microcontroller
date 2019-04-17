
.org #00h
.code

main:
    ldh r0, #7Fh
    ldl r0, #FFh            
    ldsp r0                 ; Initiate stack pointer at the end of memory
    
    xor r0, r0, r0          ; r0 <= x"0000"
    
    ldh r8, #80h            ;
    ldl r8, #01h            ; r8 <= PortA regConfig address
    ldh r9, #00h            ;
    ldl r9, #0Fh            ; r9 <= PortA regConfig content
    st r9, r8, r0           ; Write regConfig
    
    ldh r8, #80h            ;
    ldl r8, #00h            ; r8 <= PortA regEnable address
    ldh r9, #FFh            ;
    ldl r9, #F8h            ; r9 <= PortA regEnable content
    st r9, r8, r0           ; Write regEnable content on regEnable address
   
    ldh r10, #80h           ;
    ldl r10, #02h           ; r10 <= PortA regData address
    
    xor rX, rX, rX       ; rX is the independent counter
    xor rY, rY, rY       ; rY is the dependent counter
    xor rZ, rZ, rZ       ; rZ is the display selector

loop:
    ; Split independent counter in decimal digits
    ; Use decimal digit to index the seg_codes array and write it to regData
    
    addi rX, #1            ; increment independent counter
    jsrd #wait_sr
    jmpd #loop
    
; 
wait_sr:
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    
    ldh r5, #XXh            ;
    ldl r5, #XXh            ; number of outter loop runs
    outter_loop:
        subi r5, #1
        jmpzd #wait_end
        ldh r6, #XXh        ;
        ldl r6, #XXh        ; number of inner loop runs
        
        ; read bit 3 from regData (button)
        ; if button is pressed, increment dependent counter and decrement r6 according to time used 
        
        inner_loop:
            subi r6, #1
            jmpzd #outter_loop
            
            ; update display selector
            
            jmpd  #inner_loop
    
wait_end:
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    rts

.endcode

.data
    seg_codes:  db  #03h, #9Fh, #25h, #0Dh, #99h, #49h, #41h, #1Fh, #01h, #09h
.enddata