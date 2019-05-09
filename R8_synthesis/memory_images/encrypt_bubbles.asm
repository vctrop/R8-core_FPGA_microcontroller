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
    ldh r9, #20h            ; only key_exg interrupts the processor
    ldl r9, #00h            ; r8 <= PortA irqEnable content
    st r9, r8, r0           ; Write irqEnable content on its address
	

    ldh r8, #80h            ;
    ldl r8, #00h            ; r8 <= PortA regEnable address
    ldh r9, #F8h            ;
    ldl r9, #FFh            ; r9 <= PortA regEnable content
    st r9, r8, r0           ; Write regEnable content on its address
    
	ldh r8, #random_x
	ldl r8, #random_x
	ldh r9, #0
	ldl r9, #250
	st r9, r8, r0			; resets random_x to 250
	
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
    
    xor r0, r0, r0
    ldh r6, #80h            ;
    ldl r6, #02h            ; r6 <= PortA Data address
	ld r5, r6, r0
    
    ldh r7, #20h            ; mask to check if the interruption happens due to key_exg
    ldl r7, #00h            ; 
    and r8, r7, r5
    jmpzd #end_interruption_handler
    jsrd #handler_key_exchange
    
    end_interruption_handler:
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
; Objective: handles message exchange between the R8 and the cryptomessage
; Argument: NULL
; Return: NULL
	push r10
	push r11
	push r12
    jsrd #read_crypto
    xor r0, r0, r0
    add r10, r3, r0         ; r10 contains cryptomessage magic number
    jsrd #calc_magic_number
    add r1, r3, r0          ; r1 <- magic_number
    jsrd #write_crypto
    jsrd #ack_pulse
	    
	;calculate key
	xor r0, r0, r0
	ldh r5, #00h
	ldl r5, #ffh
	and r1, r10, r5 	 	; a = crypto's magic number and cleans upper byte
	ldh r5, #random_x
	ldl r5, #random_x
	ld r2, r5, r0			; b = x
	jsrd #exp_mod			; 
	ldh r5, #crypto_key
	ldl r5, #crypto_key
	st r3, r5, r0			; crypto_key <- magic_number_B ^ x % q
	
	xor r0, r0, r0
	ldh r5, #index
	ldl r5, #index
	st r0, r5, r0 			; reset index
	ldh r11, #10h
	ldl r11, #00h		; data_av mask (must save between calls!!)
	ldh r12, #08h
	ldl r12, #00h		; eof mask (must save between calls!!)
    pooling:
		jsrd #read_crypto
		and r6, r11, r3 		; if(data_av = '1') decrypt_data
		;talvez considerar mais condições
		jmpzd #pooling			; else pool again
		
		xor r0, r0, r0
		add r1, r0, r3			; decrypt_and_store(portData)
		add r10, r0, r3			; portData must be save between calls
		jsrd #decrypt_and_store
		jsrd #ack_pulse			; data was read and is in memory
		
		and r7, r10, r12 		; check if this was the oef
		jmpzd #pooling			; if(!eof), else end key exchange
    end_of_message:
	pop r12
	pop r11
	pop r10
    rts
;end handler_key_exchange

read_crypto:
; Objective: reads data_in bus from cryptomessage
; Argument: NULL
; Return: r3 <= data_out of cryptomessage
	xor r0, r0, r0          ; 
    ldh r6, #80h            ;
    ldl r6, #01h            ; r6 <- PortA regConfig address
	ldh r5, #38h
	ldl r5, #FFh
	st r5, r6, r0			; Sets regConfig so portData receives data from cryptomessage
	
	ldh r6, #80h            ;
    ldl r6, #02h            ; r6 <- PortA Data address
	ldh r5, #80h
	ldl r5, #00h
	st r5, r6, r0			; activates tristate
	     
	ld r3, r6, r0	 		; r7 <- portData
	rts
;end read_crypto

write_crypto:
; Objective: writes to data_in bus of cryptomessage
; Argument: r1 <= data to be written
; Return: NULL
	xor r0, r0, r0
    ldh r6, #80h            ;
    ldl r6, #01h            ; r6 <- PortA regConfig address
	ldh r5, #38h
	ldl r5, #00h
	st r5, r6, r0			; Sets regConfig so portData sends data to cryptomessage
	
	ldh r6, #80h            ;
    ldl r6, #02h            ; r6 <- PortA Data address
	ldh r5, #00h            ; r5 contains mask to set tristate to '0'    
	ldl r5, #FFh
    and r7, r1, r5
    
	st r7, r6, r0			; portData sends x"00" & r1(7 downto 0) - (sets tristate to '0')
	rts
;end write_crypto

ack_pulse:
; Objective: sends a pulse to the ack bit, without interfering in the rest of the regData of PortA
; Argument: NULL
; Return: NULL
    xor r0, r0, r0
    ldh r5, #80h            ;
    ldl r5, #02h            ; r5 <- PortA regData address
    ld r7, r5, r0           ; r7 <- PortA regData content
    
    ldh r6, #40h            ;
    ldl r6, #00h            ; r6 <- mask to activate ack
    or r7, r7, r6           ;
    st r7, r5, r0           ; regData <- masked regData (ack = '1', others => unchanged)
    
    not r6, r6              ; r6 <- mask to deactivate ack
    and r7, r7, r6          ; 
    st r7, r5, r0           ; regData <- masked regData (ack = '0', others => unchanged)
	rts
;end ack_pulse

calc_magic_number:
; Objective: calculates R8's magic number = a exp x % q
; Argument: NULL
; Return: r3 <= magic_number
	;decrementar random_x (e verificar x < q e x > 0 ) 
	push r10
	xor r0, r0, r0
	ldh r8, #random_x
	ldl r8, #random_x
	ld r10, r8, r0
	addi r10, #0
	jmpzd #reset_random_cmn
	jmpnd #reset_random_cmn
	ldh r5, #0
	ldl r5, #251
	sub r5, r10, r5				; 0 < random_x < 251
	jmpnd #decrement_random_cmn
	reset_random_cmn:
	xor r10, r10, r10
	addi r10, #251
	decrement_random_cmn:
	subi r10, #1
	st r10, r8, r0 			; random_x--
	add r2, r10, r0
	ldh r1, #0
	ldl r1, #6				; a = 6      
	jsrd #exp_mod 			; return exp_mod(6, random_x) (6 ^ x % 251)
	pop r10
	rts
;end calc_magic_number:

exp_mod:
; Objective: calculates f = a exp b % q, using q = 251 and a = 6
; Argument: r1 <- a , r2 <- b 
; Return: r3 <- f
	push r10
	push r11
	ldh r10, #00h
	ldl r10, #80h   ; r10 <= bit mask to check if b(i) = '1'
	ldh r11, #00h
	ldl r11, #251  ; r11 = q 
	ldh r3, #00h
	ldl r3, #01h 	; r3 <- 1 (f)
	loop_exp:
		mul r3, r3   ;
		mfl r3       ; r3 <- f * f (assuming it must be at most 16 bits long)
		div r3, r11   
		mfh r3       ; r3 <- (f*f) % q 
		and r6, r2, r10   ; checks if b(i) = '1'
		jmpzd #continue_exp
			mul r3, r1   ;
			mfl r3       ; r3 <- f * a (assuming it must be at most 16 bits long)
			div r3, r11   
			mfh r3       ; r3 <- (f*a) % q 
		continue_exp:
		sr0 r10, r10     ; mask >>= 1
		jmpzd #end_loop_exp		; if mask = 0 then we have checked every bit of b
		jmpd #loop_exp
	end_loop_exp:
	pop r11
	pop r10
	rts
;end exp_mod

decrypt_and_store:
; Objective: decrypts data and stores in the apropriate memory location
; Argument: r1 <=  encrypted data
; Return: NULL
	push r10
	push r11
	push r12
	push r13
	push r14
	
	xor r0, r0, r0
	ldh r5, #00h
	ldl r5, #ffh
	and r1, r1, r5			; cleans upper byte 
	ldh r5, #crypto_key
	ldl r5, #crypto_key
	ld r11, r5, r0 
	xor r12, r11, r1 		; r12 <- decrypted data
	
	;store
	ldh r5, #index
	ldl r5, #index
	ld r10, r5, r0			; r10 <- index
    add r8, r10, r0         ; r8 <- index
    addi r8, #1             ;
    st r8, r5, r0           ; index++
	ldh r5, #0
	ldl r5, #2 
	div r10, r5 			; index/2  = adress offset  | index % 2 = lower or upper byte
	mfh r6				; mod
	mfl r7 				; div
	ldh r13, #msg
	ldl r13, #msg
	ld r14, r13, r7 	; msg[index/2]
	addi r6, #0
	jmpzd #upper_byte_ds
		or r12, r12, r14		; puts data to lower byte 
		st r12, r13, r7
		jmpd #end_ds
	upper_byte_ds:
		sl0 r12, r12
		sl0 r12, r12
		sl0 r12, r12
		sl0 r12, r12
		sl0 r12, r12
		sl0 r12, r12
		sl0 r12, r12
		sl0 r12, r12			;shifts to upper byte
		st r12, r13, r7			; stores upper byte
		
	end_ds:
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	rts
			
	
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

    array:     		db #50h, #49h, #48h, #47h, #46h, #45h, #44h, #43h, #42h, #41h,#40h, #39h, #38h, #37h, #36h, #35h, #34h, #33h, #32h, #31h, #30h, #29h, #28h, #27h, #26h, #25h, #24h, #23h, #22h, #21h, #20h, #19h, #18h, #17h, #16h, #15h, #14h, #13h, #12h, #11h, #10h, #9h, #8h, #7h, #6h, #5h, #4h, #3h, #2h, #1h
    size:      		db #50    ; 'array' size  
	random_x:   	db #250 	 ; first random number b to calculate crypto key; is decremented each exchange
	crypto_key:	 	db #0
	index:			db #0
	msg: 	   		db #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
.enddata
