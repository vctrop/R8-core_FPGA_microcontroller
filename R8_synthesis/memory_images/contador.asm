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
    ldh r10, #00h             ; 
    ldl r10, #3fh             ; the outer loop runs 63 times
    ldh r9, #7fh              ; the inner loop runs 32767 times
    ldl r9, #ffh
    outer_loop:
        subi r10, #1
        jmpzd #fim_conta
        inner_loop:
            subi r9, #1
            jmpzd #outer_loop
            jmpd  #inner_loop
fim_conta:
    pop r9
    pop r10
    rts
.endcode




    