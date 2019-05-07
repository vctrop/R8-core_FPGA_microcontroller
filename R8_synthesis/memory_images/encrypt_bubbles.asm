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
    ldh r9, #38h            ;
    ldl r9, #FFh            ; r9 <= PortA regConfig content
    st r9, r8, r0           ; Write regConfig content on its address
    
    
    ldh r8, #80h            ;
    ldl r8, #03h            ; r8 <= PortA irqEnable address
    ldh r9, #20h            ;only key_exg interrupts the processor
    ldl r9, #00h            ; r8 <= PortA irqEnable content
    st r9, r8, r0           ; Write irqEnable content on its address
	

    ldh r8, #80h            ;
    ldl r8, #00h            ; r8 <= PortA regEnable address
    ldh r9, #F8h            ;
    ldl r9, #FFh            ; r9 <= PortA regEnable content
    st r9, r8, r0           ; Write regEnable content on its address
    
    jmpd #BubbleSort
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
   
   
handler_key_exchange:
; Objective: reads cryptomessage magic number, calculates r8's magicnumber and sends it back
; Argument: NULL
; Return: NULL

;end

read_crypto:
; Objective: reads bus from data_out of cryptomessage 
; Argument: NULL
; Return: r3 <= data_out of cryptomessage
	xor r0, r0, r0
    ldh r6, #80h            ;
    ldl r6, #01h            ; r6 <= PortA regConfig address
	ldh r5, #38h
	ldl r5, #FFh
	st r5, r6, r0			; portData receives data from cryptomessage
	
	ldh r6, #80h            ;
    ldl r6, #02h            ; r6 <= PortA Data address
	ldh r5, #80h
	ldl r5, #00h
	st r5, r6, r0			;activates tristate
	
	ld r3, r6, r0	 		; r3 <= portData
	rts
;end read_crypto

write_crypto:
; Objective: writes to data_in bus of cryptomessage 
; Argument: r1 <= data to be written
; Return: NULL
	xor r0, r0, r0
    ldh r6, #80h            ;
    ldl r6, #01h            ; r6 <= PortA regConfig address
	ldh r5, #38h
	ldl r5, #00h
	st r5, r6, r0			; portData receives data from cryptomessage
	
	ldh r6, #80h            ;
    ldl r6, #02h            ; r6 <= PortA Data address
	ldh r5, #00h
	ldl r5, #00h
	st r5, r6, r0			; portData sends data to cryptomessage
	
	st r1, r6, r0	 		; data_in <= r1
	rts
;end write_crypto


BubbleSort:
   
    ; Initialization code
    xor r0, r0, r0          ; r0 <- 0
    
    ldh r1, #array          ;
    ldl r1, #array          ; r1 <- &array
    
    ldh r2, #size           ;
    ldl r2, #size           ; r2 <- &size
    ld r2, r2, r0           ; r2 <- size
    
    add r3, r2, r1          ; r3 points the end of array (right after the last element)
    
    ldl r4, #0              ;
    ldh r4, #1              ; r4 <- 1
   
   
; Main code
scan:
    addi r4, #0             ; Verifies if there was element swaping
    jmpzd #end              ; If r4 = 0 then no element swaping
    
    xor r4, r4, r4          ; r4 <- 0 before each pass
    
    add r5, r1, r0          ; r5 points the first arrar element
    
    add r6, r1, r0          ;
    addi r6, #1             ; r6 points the second array element
    
; Read two consecutive elements and compares them    
loop:
    ld r7, r5, r0           ; r7 <- array[r5]
    ld r8, r6, r0           ; r8 <- array[r6]
    sub r2, r8, r7          ; If r8 > r7, negative flag is set
    jmpnd #swap             ; (if array[r5] > array[r6] jump)
    
; Increments the index registers and verifies is the pass is concluded
continue:
    addi r5, #1             ; r5++
    addi r6, #1             ; r6++
    
    sub r2, r6, r3          ; Verifies if the end of array was reached (r6 = r3)
    jmpzd #scan             ; If r6 = r3 jump
    jmpd #loop              ; else, the next two elements are compared


; Swaps two array elements (memory)
swap:
    st r7, r6, r0           ; array[r6] <- r7
    st r8, r5, r0           ; array[r5] <- r8
    ldl r4, #1              ; Set the element swaping (r4 <- 1)
    jmpd #continue
    
    
end:    
    halt                    ; Suspend the execution
             
.endcode

; Data area (variables)
.data

    array:     db #50h, #49h, #48h, #47h, #46h, #45h, #44h, #43h, #42h, #41h,#40h, #39h, #38h, #37h, #36h, #35h, #34h, #33h, #32h, #31h, #30h, #29h, #28h, #27h, #26h, #25h, #24h, #23h, #22h, #21h, #20h, #19h, #18h, #17h, #16h, #15h, #14h, #13h, #12h, #11h, #10h, #9h, #8h, #7h, #6h, #5h, #4h, #3h, #2h, #1h
    size:      db #50    ; 'array' size  
	msg: 	   db #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
.enddata
