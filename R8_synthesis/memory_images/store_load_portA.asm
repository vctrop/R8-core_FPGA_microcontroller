.org #00h
.code
main:
    
    xor r0, r0, r0          ; r0 <= x"0000"
    
    ; TEST STORES
    ; r8 <= PortA regConfig address
    ldh r8, #88h
    ldl r8, #01h
    ; r9 <= PortA regConfig content
    ldh r9, #55h            ; dont care with current regEnable setting
    ldl r9, #0Fh
    ; Write regConfig
    st r9, r8, r0 
    
    ; r8 <= PortA regEnable address
    ldh r8, #80h
    ldl r8, #00h
    ; r9 <= PortA regEnable content
    ldh r9, #00h
    ldl r9, #FFh
    ; Write regEnable content on regEnable address
    st r9, r8, r0
   
    ; r8 <= PortA regData address
    ldh r8, #FFh
    ldl r8, #02h
    ; r9 <= PortA regData content
    ldh r9, #00h
    ldl r9, #00h
    st r9, r8, r0
    
    ; TEST LOADS
    ; r8 <= PortA regConfig address
    ldh r8, #88h
    ldl r8, #01h
    ; r1 <= PortA regConfig content
    ld r1, r8, r0
    
    ; r8 <= PortA regEnable address
    ldh r8, #80h
    ldl r8, #00h
    ; r2 <= PortA regConfig content
    ld r2, r8, r0
    
    ; r8 <= PortA regData address
    ldh r8, #FFh
    ldl r8, #02h
    ; r3 <= PortA regConfig content
    ld r3, r8, r0
    
    halt
.endcode

