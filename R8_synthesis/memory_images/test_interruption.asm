.org #0000h
boot:
    ldh r0, #7fh
    ldl r0, #ffh
    ldsp r0
    xor r0, r0, r0
    jmpd #main


.org #0040h
interruption_handler:
    push r0
    pushf
    addi r0, #1
    popf
    pop r0
    rti


main:
    addi r0, #1
    jmpd #main