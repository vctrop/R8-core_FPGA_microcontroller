; Continuously read from 

.org #00h
.code
main:
    
    xor r0, r0, r0          ; r0 <= x"0000"
    
    ; r8 <= PortA regConfig address
    ldh r8, #80h
    ldl r8, #01h
    ; r9 <= PortA regConfig content
    ldh r9, #00h            ;leds
    ldl r9, #00h            ;switches
    ; Write regConfig
    st r9, r8, r0 
    
    ; r8 <= PortA regEnable address
    ldh r8, #80h
    ldl r8, #00h
    ; r9 <= PortA regEnable content
    ldh r9, #FFh
    ldl r9, #00h
    ; Write regEnable content on regEnable address
    st r9, r8, r0
   
    ; r8 <= PortA regData address
    ldh r8, #80h
    ldl r8, #02h
	; r9 <= PortA regData content
	ldh r9, #FFh
	ldl r9, #FFh
	st r9, r8, r0   ;writes leds
	halt
    
.endcode

