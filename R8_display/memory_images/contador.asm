; contador que atualiza o valor no display a cada 1 s (clk de 50 MHz)
;registradores r11 é usada para passar argumentos a funções

.org #00h
.code
main:
    ldh r0, #7Fh
    ldl r0, #FFh            ; stack pointer starts at end of memory for no reason
    ldsp r0
    xor r11, r11, r11       ;r11 is the count variable
    xor r12, r12, r12
    ldh r8, #80h
    ldl r8, #00h
loop:
    st   r11, r8, r12       ;write on the display
    addi r11, #1
    jsrd #espera
    jmpd #loop
    
    
;função que espera por 50e6 ciclos  (1 segundo)
espera:
    push r9
    push r10
    ldh r10, #00h                   ; 
    ldl r10, #6dh                   ; the outer loop runs 109 times (error of 81.54 us, not considering true outter loop jumps)
    outer_loop:
        subi r10, #1
        jmpzd #fim_conta
        ldh r9, #7fh              
        ldl r9, #ffh                ; the inner loop runs 32767 times
        inner_loop:
            subi r9, #1
			nop
            jmpzd #outer_loop
            jmpd  #inner_loop
fim_conta:
    pop r10
    pop r9
    rts
.endcode

