.code
boot:
    ldh r0, #main_loop
    ldl r0, #main_loop
    ldisra r0
	
	ldh r0, #main_loop
	ldl r0, #main_loop
	ldtsra r0
	
	; SET BAUD RATE
	
	; SET RX BAUD RATE HERE!! CHANGE THIS LASTERRRRRRRRRRRRRRRRRRRR
    ;217  -- floor (25e6 / 115200)
    xor r0, r0, r0
    ldh r8, #80h
	ldl r8, #30h			        ; rx_baud address
	ldh r9, #00h
	ldl r9, #D9h
	st r9, r8, r0 	
	
	ldh r8, #80h
	ldl r8, #21h			        ; tx_baud address
	ldh r9, #00h
	ldl r9, #D9h
	st r9, r8, r0 
    
    jmpd #main

main:
	xor r0, r0, r0
	xor r5, r5, r5		            ; memory address index
	;ldh r5, #01h
	;ldl r5, #2ch
	xor r6, r6, r6 		            ; byte indicator, 0 for higher and 1 for lower
	ldh r10, #80h           
	ldl r10, #13h		            ; PIC IRQ register address
	ldh r11, #80h           
	ldl r11, #11h 		            ; PIC ACK address
	ldh r12, #0         
	ldl r12, #1		                ; 1 constant to send as ack signal (rx_av 
	ldh r14, #80h           
	ldl r14, #30h		            ; RX address
	ldh r8, #80h
	ldl r8, #20h			        ; tx_data address
	
    xor r7, r7, r7 	                ; reset temporary register
	
	main_loop:          
		ld r9, r10, r0	            ; check for data_av signal interruption
		subi r9, #02h             	; check for interruption
		
		jmpzd #rx_available_main
		jmpd #main_loop
		rx_available_main:
		ld r9, r14, r0		        ; read data_RX
        addi r6, #0
		jmpzd #store_upper_byte
		;store lower byte
			or r9, r9, r7 		    ; combine upper and lower byte
			st r9, r5, r0		    ; store in memory
			
			wait_for_ready_signal_lower1:		
				ld r13, r8, r0					; read ready signal
				addi r13, #0						; while(ready != 1) {}
				jmpzd #wait_for_ready_signal_lower1			
			st r9, r8, r0		                ; write to TX
			
			; wait_for_ready_signal_lower2:		
				; ld r13, r8, r0					; read ready signal
				; addi r13, #0						; while(ready != 1) {}
				; jmpzd #wait_for_ready_signal_lower2			
			; ldl r15, #13						; send \r
			; st r15, r8, r0		                ; write to TX
			
			; wait_for_ready_signal_lower3:		
				; ld r13, r8, r0					; read ready signal
				; addi r13, #0						; while(ready != 1) {}
				; jmpzd #wait_for_ready_signal_lower3		
			; ldl r15, #10						; send \n
			; st r15, r8, r0		                ; write to TX
			
			addi r5, #1 
			ldh r7, #75h
			ldl r7, #30h
			sub r7, r7, r5			; if (r5 > 30000) halt
			jmpnd #halt_main
			xor r6, r6, r6		    ; set next byte as higher 
            xor r7, r7, r7 	        ; reset temporary register
			jmpd #send_ack  
			store_upper_byte:  
			wait_for_ready_signal_upper:		
				ld r13, r8, r0					; read ready signal
				addi r13, #0						; while(ready != 1) {}
				jmpzd #wait_for_ready_signal_upper			
			st r9, r8, r0		                ; write to TX
			sl0 r9, r9 
			sl0 r9, r9 
			sl0 r9, r9 
			sl0 r9, r9 
			sl0 r9, r9 
			sl0 r9, r9 
			sl0 r9, r9 
			sl0 r9, r9             ; shift rx_data << 8
			add r7, r9, r0
            st r9, r5, r0           ;store in memory
			addi r6, #1	            ; set next byte as lower
		send_ack:   
		st r12, r11, r0 	        ; send ack signal to PIC
		jmpd #main_loop
		halt_main:
			halt
.endcode