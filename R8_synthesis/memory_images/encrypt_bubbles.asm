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
    
    ; print "Array inicial: " +  
    ldh r1, #init_arr_str
    ldl r1, #init_arr_str
    jsrd #print_string
    xor r0, r0, r0          ; r0 <- 0
    ldh r1, #array          ;
    ldl r1, #array          ; r1 <- &array
    ldh r2, #size           ;
    ldl r2, #size           ; r2 <- &size
    ld r2, r2, r0           ; r2 <- size
    jsrd #print_array
    
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
   
; Interruption handlers
handler_key_exchange0:
	ldh r1, #0                      ;
	ldl r1, #0                      ;
	jsrd #crypto_message_handler    ; crypto_message_handler(0)
	rts

handler_key_exchange1:          
	ldh r1, #0                      ;
	ldl r1, #1                      ;
	jsrd #crypto_message_handler    ; crypto_message_handler(1)
	rts

handler_key_exchange2:
	ldh r1, #0                      ;
	ldl r1, #2                      ;
	jsrd #crypto_message_handler    ; crypto_message_handler(2)
	rts

handler_key_exchange3:
	ldh r1, #0                      ;
	ldl r1, #3                      ;
	jsrd #crypto_message_handler    ; crypto_message_handler(3)
	rts


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
	    
	; calculate key
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
		jsrd #decrypt_and_print	; decrypt_and_print(crypto_data, crypto_number)
		
		and r7, r10, r12 		; check if this was the oef
		jmpzd #pooling			; if(!eof), else end key exchange
    end_of_message:
    
    ldh r1, #carriage_return
    ldl r1, #carriage_return
    jsrd #print_string

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
	sub r5, r10, r5				    ; 0 < random_x < 251
	jmpnd #decrement_random_cmn
	reset_random_cmn:
		xor r10, r10, r10
		addi r10, #251
	decrement_random_cmn:
	subi r10, #1
	st r10, r8, r0 			        ; random_x--
	add r2, r10, r0
	ldh r1, #0
	ldl r1, #6				        ; a = 6      
	jsrd #exp_mod 			        ; return exp_mod(6, random_x) which is (6 ^ x % 251)
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
	ldl r10, #80h                   ; r10 <= bit mask to check if b(i) = '1'
	ldh r11, #00h
	ldl r11, #251                   ; r11 = q 
	ldh r3, #00h
	ldl r3, #01h 	                ; r3 <- 1 (f)
	loop_exp:
		mul r3, r3                  ;
		mfl r3                      ; r3 <- f * f (assuming it must be at most 16 bits long)
		div r3, r11   
		mfh r3                      ; r3 <- (f*f) % q 
		and r6, r2, r10             ; checks if b(i) = '1'
		jmpzd #continue_exp
			mul r3, r1              ;
			mfl r3                  ; r3 <- f * a (assuming it must be at most 16 bits long)
			div r3, r11   
			mfh r3                  ; r3 <- (f*a) % q 
		continue_exp:
		sr0 r10, r10                ; mask >>= 1
		jmpzd #end_loop_exp		    ; if mask = 0 then we have checked every bit of b
		jmpd #loop_exp
	end_loop_exp:
	pop r11
	pop r10
	rts
;end exp_mod

decrypt_and_print:
; Objective: decrypts data and prints to serial port
; Argument: r1 <-  encrypted data, r2 <- crypto number index
; Return: NULL
	push r10
	push r11
	push r12
	push r13
	push r14
	
	; decrypt
	xor r0, r0, r0
	ldh r5, #00h
	ldl r5, #ffh
	and r1, r1, r5			; cleans upper byte 
	ldh r5, #crypto_key
	ldl r5, #crypto_key
	add r5, r5, r2
	ld r11, r5, r0 
	xor r12, r11, r1 		; r12 <- decrypted data
	
    ; print
    ldh r9, #80h
	ldl r9, #20h		    ; r9 <- TX address
    st r12, r9, r0          ; TX <- decrypted char

	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	rts
;end decrypt_and_store
	
print_string:
; Objective: sends a NULL TERMINATED STRING to serial port
; Argument: r1 <- &string
; Return: NULL
	xor r0, r0, r0 
	xor r6, r6, r6 		                    ; string index
	ldh r9, #80h
	ldl r9, #20h		                    ; r9 <- TX address
	loop_ps:
		ld r5, r1, r6		                ; r5 <- string[r6]
		addi r5, #0			                ; check for null termination
		jmpzd #return_ps
		wait_for_ready_signal_ps:		
			ld r7, r9, r0					; read ready signal
			addi r7, #0						; while(ready != 1) {}
			jmpzd #wait_for_ready_signal_ps	
		st r5, r9, r0		                ; write to TX
		addi r6, #1
		jmpd #loop_ps
	return_ps:
	rts 
;end print_string

integer_to_string:
; Objective: converts an 16 bit signed integer to ascii, storing the result in &string 
; Argument: r1 <- n, r2 <- &string
; Return: r3 <- &string TODO: (on success, 0 on failure)
	push r10
	push r11
	push r12 
    push r13
    
    xor r0, r0, r0
	ldh r9, #0
	ldl r9, #2bh			            ; sign is '+'
	add r10, r2, r0
    ldh r11, #0
	ldl r11, #0 			            ; r11 is size
	ldh r12, #0
	ldl r12, #10			            ; 10 constant
	ldh r13, #0
	ldl r13, #48			            ; 48 constant ('0' ascii caracter code)
	
	add r3, r0, r10 		            ; r3 <- &string
	
	addi r1, #0
	jmpnd #negative_sign
	jmpzd #zero_is
	jmpd #loop_is
	; if n is zero, write only '0' + '\0' 
	zero_is:
		st r13, r10, r0		            ; write '0' on first byte
		addi r10, #1
		st r0, r10, r0		            ; write '\0' on last byte
		jmpd #return_is
		
	negative_sign:
		not r1, r1
		addi r1, #1			            ; convert number to positive
		addi r9, #2			            ; sign receives '-'
	
	loop_is:
		div r1, r12
		mfh r5				            ; r5 <- n % 10
		add r6, r5, r13 	            ; r6 <- '0' + n % 10
		push r6 			            ; store character on stack
		addi r11, #1		            ; size++
		mfl r1				            ; r1 <- n / 10
		addi r1, #0			            ; if(n == 0) break
		jmpzd #write_is
		jmpd #loop_is
	
	write_is:
		st r9, r10, r0 		            ;write sign in string[0] 
		addi r10, #1
		write_loop_is:
			pop r6 
			st r6, r10, r0		        ; write string
			addi r10, #1 
			subi r11, #1		        ; if (size == 0) break
			jmpzd #write_terminator
			jmpd #write_loop_is
	write_terminator:
		st r0, r10, r0			        ; write '\0' 
	return_is:
	
    pop r13
    pop r12
	pop r11
	pop r10
	rts
; end integer_to_string

print_array:
; Objective: runs through array, converting each number to ascii and printing the result
; Argument: r1 <- &array, r2 <- size
; Return: NULL
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
    
    xor r0, r0, r0
    xor r12, r12, r12                   ; index (r12) <- 0
    add r10, r1, r0                     ; r10 <- &array
    add r11, r2, r0                     ; r11 <- size
    
    do_while_pa:
        ld r1, r10, r12                 ; r1 <- array[r12]
        ldh r2, #string
        ldl r2, #string
        jsrd #integer_to_string
        ldh r1, #string
        ldl r1, #string
        jsrd #print_string
        
        addi r12, #1
        sub r6, r12, r11
        jmpzd #do_while_end
        jmpd #do_while_pa
        
    do_while_end:
 
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
    rts
; end print_array


; THIRD PARTY BUBBLE SORT IMPLEMENTATION
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
    ldh r1, #end_arr_str
    ldl r1, #end_arr_str
    jsrd #print_string
    ldh r1, #array          ;
    ldl r1, #array          ; r1 <- &array
    ldh r2, #size           ;
    ldl r2, #size           ; r2 <- &size
    ld r2, r2, r0           ; r2 <- size
    jsrd #print_array
    
    
    end_loop:
        jmpd #end_loop      ; workaround to enable halting with interruptions on
             
.endcode


; Data area (variables)
.org #1000
.data
    ; 
	irq_handlers: 	    db #0, #0, #0, #0, #0, #0, #0, #0
    ; Bubble sort
    array:     		    db #50 , #49 , #48 , #47 , #46 , #45 , #44 , #43 , #42 , #41 ,#40 , #39 , #38 , #37 , #36 , #35 , #34 , #33 , #32 , #31 , #30 , #29 , #28 , #27 , #26 , #25 , #24 , #23 , #22 , #21 , #20 , #19 , #18 , #17 , #16 , #15 , #14 , #13 , #12 , #11 , #10 , #9 , #8 , #7 , #6 , #5 , #4 , #3 , #2 , #1 
	size:      		    db #50                                  ; 'array' size  
    ; Crypto
    random_x:   	    db #250, #250, #250, #250 	            ; first random number b to calculate crypto key; is decremented each exchange
	crypto_key:	 	    db #0, #0, #0, #0
    ; Strings
    string:             db #0, #0, #0, #0, #0, #0, #0
    init_arr_str:       db #65, #114, #114, #97, #121, #32, #105, #110, #105, #99, #105, #97, #108, #58, #32, #0    ; "Array inicial: "
    end_arr_str:        db #65, #114, #114, #97, #121, #32, #102, #105, #110, #97, #108, #58, #32, #0               ; "Array final: "
    carriage_return:    db #32, #0                                                                                  ; "\n"
.enddata
