.org #0000h
.code
boot:
    
    ; Initiate stack pointer at 2000
    ldh r0, #07h
    ldl r0, #d0h
    ldsp r0
    
    ldh r0, #ISR
    ldl r0, #ISR
    ldisra r0
    
    xor r0, r0, r0
	
    ldh r8, #80h            ;
    ldl r8, #01h            ; r8 <= PortA regConfig address
    ldh r9, #F0h            ;
    ldl r9, #FFh            ; r9 <= PortA regConfig content
    st r9, r8, r0           ; Write regConfig content on its address
    
    
    ldh r8, #80h            ;
    ldl r8, #03h            ; r8 <= PortA irqEnable address
    ldh r9, #F0h            ; only key_exg interrupts the processor
    ldl r9, #00h            ; r8 <= PortA irqEnable content
    st r9, r8, r0           ; Write irqEnable content on its address

    ldh r8, #80h            ;
    ldl r8, #00h            ; r8 <= PortA regEnable address
    ldh r9, #FFh            ;
    ldl r9, #FFh            ; r9 <= PortA regEnable content
    st r9, r8, r0           ; Write regEnable content on its address
	
	ldh r8, #random_x
	ldl r8, #random_x
	ldh r9, #0
	ldl r9, #250
	st r9, r8, r0			;random_x(0) <- 250
	addi r0, #1
	st r9, r8, r0			;random_x(1) <- 250
	addi r0, #1
	st r9, r8, r0			;random_x(2) <- 250
	addi r0, #1
	st r9, r8, r0			;random_x(3) <- 250

	xor r0, r0, r0
	ldh r8, #irq_handlers
	ldl r8, #irq_handlers
	ldh r9, #handler_key_exchange0
	ldl r9, #handler_key_exchange0
	addi r0, #4
	st r9, r8, r0 
	
	ldh r9, #handler_key_exchange1
	ldl r9, #handler_key_exchange1
	addi r0, #1
	st r9, r8, r0
	
	ldh r9, #handler_key_exchange2
	ldl r9, #handler_key_exchange2
	addi r0, #1
	st r9, r8, r0
	
	ldh r9, #handler_key_exchange3
	ldl r9, #handler_key_exchange3
	addi r0, #1
	st r9, r8, r0
	
    ;interruption enabling should be the last thing before main
    xor r0, r0, r0
    ldh r8, #80h
	ldl r8, #12h			; sets PIC interruption mask
	ldh r9, #00h			
	ldl r9, #F0h
	st r9, r8, r0
    
    jmpd #BubbleSort
;end boot


ISR:
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
    ldh r8, #80h
	ldl r8, #10h
	ld r10, r8, r0			; reads interruption number
	ldh r8, #irq_handlers
	ldl r8, #irq_handlers
	add r8, r10, r8
    ld r8, r8, r0
	jsr r8					; jumps to appropriate handler 
	xor r0, r0, r0 
	ldh r8, #80h
	ldl r8, #11h
	st r10, r8, r0
	
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
   
   
handler_key_exchange0:
;sets arg to 0 and jumps to crypto_message_handler
	ldh r1, #0
	ldl r1, #0
	jsrd #crypto_message_handler
	rts
;

handler_key_exchange1:
	ldh r1, #0
	ldl r1, #1
	jsrd #crypto_message_handler
	rts
;

handler_key_exchange2:
	ldh r1, #0
	ldl r1, #2
	jsrd #crypto_message_handler
	rts
;

handler_key_exchange3:
	ldh r1, #0
	ldl r1, #3
	jsrd #crypto_message_handler
	rts
;


crypto_message_handler:
; Objective: handles message exchange between the R8 and the cryptomessage(n)
; Argument: r1 <- crypto number (0, 1, 2 or 3)
; Return: NULL
	push r10
	push r11
	push r12
	push r14 
	push r15
	
	xor r0, r0, r0
	add r14, r1, r0			; r14 contains cripto_number
	xor r5, r5, r5    
	addi r5, #10
	shifter_mh:
		sl0 r1, r1
		subi r5, #1			; r5 <- r1 << 10
		jmpzd #shifter_end
        jmpd #shifter_mh
	shifter_end:
    add r15, r1, r0			; r15 contains cripto_id
    jsrd #read_crypto		; read_crypto(crypto_id)
	
    xor r0, r0, r0
    add r10, r3, r0         ; r10 contains cryptomessage magic number
    add r1, r14, r0
    jsrd #calc_magic_number ; calc_magic_number(crypto_number)
	
    add r1, r3, r0          ; r1 <- magic_number
	add r2, r15, r0			; r15 contains cripto_id
    jsrd #write_crypto		; write_crypto(magic_number, crypto_id)
	    
	;calculate key
	xor r0, r0, r0
	ldh r5, #00h
	ldl r5, #ffh
	and r1, r10, r5 	 	; a = crypto's magic number and cleans upper byte
	ldh r5, #random_x
	ldl r5, #random_x
	add r5, r5, r14			; 
	ld r2, r5, r0			; r2 <- random_x[cripto_number]
	jsrd #exp_mod			; 
	
	ldh r5, #crypto_key
	ldl r5, #crypto_key
	add r5, r5, r14
	st r3, r5, r0			; crypto_key[cripto_number] <- magic_number_B ^ x % q
	
	xor r0, r0, r0
	ldh r5, #index
	ldl r5, #index
	add r5, r5, r14
	st r0, r5, r0 			; reset index
    
	ldh r11, #00h
	ldl r11, #01h		; data_av mask (must save between calls!!)
	ldh r12, #00h
	ldl r12, #02h		; eof mask (must save between calls!!)
    pooling:
		add r1, r15, r0
		jsrd #read_signals		; read_signals(crypto_id)
		add r10, r0, r3			; signal data must be saved to check for eom
		and r6, r11, r3 		; if(data_av = '1') decrypt_data
		jmpzd #pooling			; else pool again
		
		add r1, r15, r0
		jsrd #read_crypto_ack	; read_crypto_ack(crypto_id)
		
		xor r0, r0, r0
		add r1, r0, r3			; 
		add r2, r14, r0			;
		jsrd #decrypt_and_store	; decrypt_and_store(crypto_data, crypto_number)
		
		and r7, r10, r12 		; check if this was the oef
		jmpzd #pooling			; if(!eof), else end key exchange
    end_of_message:

	;clear the rest of the buffer
	xor r0, r0, r0
	ldh r5, #index 
	ldl r5, #index 
	add r5, r5, r14
	ld r5, r5, r0		; r5 <- index
	ldh r7, #0
	ldl r7, #200
	sub r8, r7, r5 		; if(index > 200) return 
	jmpnd #buffer_clear

	ldh r6, #msg0
	ldl r6, #msg0 
	ldh r7, #0
	ldl r7, #100
	mul r7, r14
	mfl r7
	add r6, r6, r7		; r6 <- &msgN

	ldh r7, #0
	ldl r7, #2
	div r5, r7 			; checks if index is odd
	mfh r7
	mfl r9				; r9 <- index / 2
	addi r7, #0
	jmpzd #loop_even
	ld r8, r6, r9		; r8 <- msgN[index/2] 
	ldh r7, #FFh
	ldl r7, #0
	and r8, r8, r7 		; clears lower byte 
	st r8, r6, r9 		; write in msgN[index/2]
	addi r9, #1
	jmpd #loop_setup
	loop_even:
		;subi r9, #1
	loop_setup:
		ldh r7, #0
		ldl r7, #99
	
	loop_condition:
		sub r5, r7, r9		;  i < 100
		jmpnd #buffer_clear
		st r0, r6, r9
		addi r9, #1
		jmpd #loop_condition
	buffer_clear:
	pop r15
	pop r14
	pop r12
	pop r11
	pop r10
    rts
;end crypto_message_handler

; crypto read and write operations, op being bits(9:8) of regData:
	;op = "00" indica leitura de sinais de data_av e eom 
	;op = "01" indica leitura de DADOS do crypto sem mandar sinal de ack 
	;op = "10" indica leitura de DADOS do crypto COM sinal de ack 
	;op = "11" indica ESCRITA de dados no crypto COM sinal de ack
read_crypto:
; Objective: reads data_in bus from cryptomessage
; Argument: r1 <- cripto_id  (ALREADY SHIFTED TO BITS 11:10)
; Return: r3 <= data_out of cryptomessage
	xor r0, r0, r0          ; 
	ldh r6, #01h
	ldl r6, #00h			; read crypto op is 01
	or r7, r6, r1 			; r7 <- id | op 
	
    ldh r6, #80h            ;
    ldl r6, #01h            ; r6 <- PortA regConfig address
	ldh r5, #f0h
	ldl r5, #FFh
	st r5, r6, r0			; Sets regConfig so portData receives data from cryptomessage
	
	ldh r6, #80h            ;
    ldl r6, #02h            ; r6 <- PortA Data address
	st r7, r6, r0			; writes id or op in regData to allow signals to be input
	ld r3, r6, r0	 		; r3 <- portData
    ldh r5, #00h
    ldl r5, #ffh
    and r3, r3, r5          ; mask to read only data
	rts
;end read_crypto


read_crypto_ack:
; Objective: reads data_in bus from cryptomessage and activates ack PULSE
; Argument: r1 <- cripto_id (ALREADY SHIFTED TO BITS 11:10)
; Return: r3 <- data_out of cryptomessage
	xor r0, r0, r0          ; 
	ldh r6, #02h
	ldl r6, #00h			; read crypt_ack op is 10
	or r7, r6, r1 			; r7 <- id & op 
	
    ldh r6, #80h            ;
    ldl r6, #01h            ; r6 <- PortA regConfig address
	ldh r5, #f0h
	ldl r5, #FFh
	st r5, r6, r0			; Sets regConfig so portData receives data from cryptomessage
	
	ldh r6, #80h            ;
    ldl r6, #02h            ; r6 <- PortA Data address
	st r7, r6, r0			; writes id | op in regData to allow signals to be input and ack signal to be set     
	ld r3, r6, r0	 		; r3 <- portData
    ldh r5, #00h
    ldl r5, #ffh
    and r3, r3, r5          ; mask to read only data
    
    st r0, r6, r0			; clears ack pulse
	rts
;end read_crypto_ack


read_signals:
; Objective: reads data_av and eom signals from cryptomessage
; Argument: r1 <- cripto_id  (ALREADY SHIFTED TO BITS 11:10)
; Return: r3 <= x"00" & eom(cripto_id) & data_av(cripto_id)
	xor r0, r0, r0
	ldh r6, #00h
	ldl r6, #00h			; read signals op is 00
	or r7, r6, r1 			; r7 <- id | op 
	
    ldh r6, #80h            ;
    ldl r6, #01h            ; r6 <- PortA regConfig address
	ldh r5, #F0h
	ldl r5, #FFh
	st r5, r6, r0			; Sets regConfig so portData receives data from cryptomessage
	
	ldh r6, #80h            ;
    ldl r6, #02h            ; r6 <- PortA Data address
	st r7, r6, r0			; writes id | op in regData to allow signals to be input
	     
	ld r3, r6, r0	 		; r3 <- signals
    ldh r5, #00h
    ldl r5, #ffh
    and r3, r3, r5          ; mask to read only data
	rts
;end read_signals


write_crypto:
; Objective: writes to data_in bus of cryptomessage and activates ack PULSE
; Argument: r1 <- data to be written, r2 <- cripto_id (ALREADY SHIFTED TO BITS 11:10)
; Return: NULL
	ldh r6, #03h
	ldl r6, #00h			; write crypto op is 11
	or r7, r6, r2 			; r7 <- id | op 
	
    xor r0, r0, r0
    ldh r6, #80h            ;
    ldl r6, #01h            ; r6 <- PortA regConfig address
	ldh r5, #F0h
	ldl r5, #00h            ;output
	st r5, r6, r0			; Sets regConfig so portData sends data to cryptomessage
	
	ldh r8, #80h            ;
    ldl r8, #02h            ; r6 <- PortA Data address
    xor r0, r0, r0
    ldh r5, #00h
    ldl r5, #ffh
    and r1, r1, r5          ; cleans upper byte of data to be written
    or r7, r7, r1
	st r7, r8, r0			; portData sends id | op | r1(7 downto 0) setting ack = '1'
	
	ldh r6, #80h            ;
    ldl r6, #01h            ; r6 <- PortA regConfig address
	ldh r5, #F0h
	ldl r5, #FFh
	st r5, r6, r0			; changes portA to input
	
	st r0, r8, r0			; disables ack and changes op to 00
	
	rts
;end write_crypto

calc_magic_number:
; Objective: calculates R8's magic number = a exp x % q
; Argument: r1 <- crypto index number
; Return: r3 <- magic_number
	;decrementar random_x (e verificar x < q e x > 0 ) 
	push r10
	
	xor r0, r0, r0
	ldh r8, #random_x
	ldl r8, #random_x
	add r8, r8, r1
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
	jsrd #exp_mod 			; return exp_mod(6, random_x) which is (6 ^ x % 251)
	pop r10
	rts
;end calc_magic_number:

exp_mod:
; Objective: calculates f = a exp b % q, using q = 251
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
; Argument: r1 <-  encrypted data, r2 <- crypto number index
; Return: NULL
	push r10
	push r11
	push r12
	push r13
	push r14
	
	;decrypt
	xor r0, r0, r0
	ldh r5, #00h
	ldl r5, #ffh
	and r1, r1, r5			; cleans upper byte 
	ldh r5, #crypto_key
	ldl r5, #crypto_key
	add r5, r5, r2
	ld r11, r5, r0 
	xor r12, r11, r1 		; r12 <- decrypted data
	
	;store
	ldh r5, #index
	ldl r5, #index
	add r5, r5, r2
	ld r10, r5, r0			; r10 <- index
	ldh r5, #0
	ldl r5, #2 
	div r10, r5 			; index/2  = adress offset  | index % 2 = lower or upper byte
	mfh r6				; mod
	mfl r7 				; div
	
	ldh r13, #msg0
	ldl r13, #msg0
	ldh r5, #0
	ldl r5, #100
	mul r5, r2
	mfl r5
	add r13, r13, r5 	; r13 <- &msgN 
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
		sl0 r12, r12			; shifts to upper byte
		st r12, r13, r7			; stores upper byte
		
	end_ds:
	
    addi r10, #1             ;
	ldh r5, #index
	ldl r5, #index
    st r10, r5, r2           ; index[crypto_number]++
	
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	rts
;end decrypt_and_store
	
	
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
	jmpd #end				; lets the calling end
    ;halt                    ; Suspend the execution
             
.endcode


; Data area (variables)
.org #1000
.data
	irq_handlers: 	db #0, #0, #0, #0, #0, #0, #0, #0
	array:     		db #50 , #49 , #48 , #47 , #46 , #45 , #44 , #43 , #42 , #41 ,#40 , #39 , #38 , #37 , #36 , #35 , #34 , #33 , #32 , #31 , #30 , #29 , #28 , #27 , #26 , #25 , #24 , #23 , #22 , #21 , #20 , #19 , #18 , #17 , #16 , #15 , #14 , #13 , #12 , #11 , #10 , #9 , #8 , #7 , #6 , #5 , #4 , #3 , #2 , #1 
	size:      		db #50    ; 'array' size  
	random_x:   	db #250, #250, #250, #250 	 ; first random number b to calculate crypto key; is decremented each exchange
	crypto_key:	 	db #0, #0, #0, #0
	index:			db #0, #0, #0, #0
	msg0: 	   		db #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
	msg1: 	   		db #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
	msg2: 	   		db #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
	msg3: 	   		db #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
.enddata
