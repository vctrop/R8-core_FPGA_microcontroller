.code
boot:
    ldh r0, #main
    ldl r0, #main
    ldisra r0
	
	ldh r0, #main
	ldl r0, #main
	ldtsra r0
	
	; SET BAUD RATE
	
	; SET RX BAUD RATE HERE!! CHANGE THIS LASTERRRRRRRRRRRRRRRRRRRR
    ;434  -- floor (25e6 / 57600)
    xor r0, r0, r0
    ldh r8, #80h
	ldl r8, #30h			        ; rx_baud address
	ldh r9, #01h
	ldl r9, #B2h
	st r9, r8, r0 
	
	ldh r8, #80h
	ldl r8, #21h			        ; tx_baud address
	ldh r9, #01h
	ldl r9, #B2h
	st r9, r8, r0 
    
    jmpd #main

main:
	xor r0, r0, r0
	xor r5, r5, r5		            ; memory address index
	xor r6, r6, r6 		            ; byte indicator, 0 for higher and 1 for lower
	ldh r10, #80h           
	ldl r10, #14h		            ; PIC IRQ register address
	ldh r11, #80h           
	ldl r11, #11h 		            ; PIC ACK address
	ldh r12, #0         
	ldl r12, #1		                ; 1 constant to send as ack signal (rx_av 
	ldh r13, #00h           
	ldl r13, #02h 		            ; interruption mask
	ldh r14, #80h           
	ldl r14, #30h		            ; RX address
    xor r7, r7, r7 	                ; reset temporary register
	main_loop:          
		ld r9, r10, r0	            ; check for data_av signal interruption
		and r9, r9, r13             ; check for interruption
		addi r9, #0
		jmpzd #main_loop
		;ld r9, r14, r0		        ; read data_RX
		ldh r9, #00h
        ldl r9, #FAh                ; r9 <- irrelevant number to check for RAM writing
        addi r6, #0
		jmpzd #store_upper_byte
		;store lower byte
			or r9, r9, r7 		    ; combine upper and lower byte
			st r9, r5, r0		    ; store in memory
			addi r5, #1 
			xor r6, r6, r6		    ; set next byte as higher 
            xor r7, r7, r7 	        ; reset temporary register
			jmpd #send_ack  
		store_upper_byte:   
			sl0 r9, r9 
			sl0 r9, r9 
			sl0 r9, r9 
			sl0 r9, r9 
			sl0 r9, r9 
			sl0 r9, r9 
			sl0 r9, r9 
			sl0 r9, r9             ; shift tx_data << 8
			add r7, r9, r0
            st r9, r5, r0           ;store in memory
			addi r6, #1	            ; set next byte as lower
		send_ack:   
		st r12, r11, r0 	        ; send ack signal to PIC
		jmpd #main_loop
.endcode