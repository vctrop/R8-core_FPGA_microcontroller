
.org #00h
.code

main:
    ldh r0, #7Fh
    ldl r0, #FFh            
    ldsp r0                 ; Initiate stack pointer at the end of memory
    
    
    
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
    
    xor rIt, rIt, rIt       ; rX is the independent tens counter
    xor rIu, rIu, rIu       ; rX is the independent units counter
    xor rDt, rDt, rDt       ; rX is the dependent tens counter
    xor rDu, rDu, rDu       ; rX is the dependent units counter
    

loop: 

    ; Decimal increment
    xor r0, r0, r0          
    addi r0, #9             ; r0 <= 9
 
    sub temp, rIu, r0       ; if rIu == r0
    jmpzd #if1
    jmp #else1_begin
    if1:
        xor rIu, rIu, rIu       ; riU <= 0
        sub temp, rId, r0       ; if rId == 9
        jmpzd #if11
        jmp else11:
        if11:
            xor rId, rId, rId       ; rId <= 0
        else11:
            addi rId, #1            ; rId++
            jmp #else1_end
    else1_begin:
        addi rIu, #1
    else1_end:
    
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