;register usage:
;r0
;r1
;r2
;r3
;r4
;r5
;r6
;r7
;r8
;r9
;r10
;r11
;r12
;r13
;r14
;r15
;       PortA config:
;   bits 15:8 => 7 seg display
;   bits 7:4  => display enables, 7 being the leftmost and 4 the rightmost
;   bits 3:2  => push buttons, 3 being increment and 2 decrement

.org #00h
.code

main:
    ldh r0, #7Fh
    ldl r0, #FFh            
    ldsp r0                 ; Initiate stack pointer at the end of memory
    
    
    
    ldh r8, #80h            ;
    ldl r8, #01h            ; r8 <= PortA regConfig address
    ldh r9, #00h            ;
    ldl r9, #0Ch            ; r9 <= PortA regConfig content
    st r9, r8, r0           ; Write regConfig
    
    ldh r8, #80h            ;
    ldl r8, #00h            ; r8 <= PortA regEnable address
    ldh r9, #FFh            ;
    ldl r9, #FCh            ; r9 <= PortA regEnable content
    st r9, r8, r0           ; Write regEnable content on regEnable address
   
    ldh r10, #80h           ;
    ldl r10, #02h           ; r10 <= PortA regData address
    
    xor rIt, rIt, rIt       ; rX is the independent tens counter
    xor rIu, rIu, rIu       ; rX is the independent units counter
    xor rDt, rDt, rDt       ; rX is the dependent tens counter
    xor rDu, rDu, rDu       ; rX is the dependent units counter
    

loop: 

    ; Decimal increment of independent counter
    xor r0, r0, r0          
    addi r0, #9             ; r0 <= 9
 
    sub temp, rIu, r0       ; if rIu == r0
    jmpzd #if1
    jmp #else1_begin
    if1:
        xor rIu, rIu, rIu       ; riU <= 0
        sub temp, rId, r0       ; if rId == 9
        jmpzd #if11
        jmp else11:
        if11:
            xor rId, rId, rId       ; rId <= 0
        else11:
            addi rId, #1            ; rId++
            jmp #else1_end
    else1_begin:
        addi rIu, #1
    else1_end:
    
    jsrd #wait_sr			;waits a second while pooling and multiplexing displays	
    jmpd #loop
;end main


;4 ms wait = 200e3 cycles
wait_sr:
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    
    ldh r5, #XXh            ;
    ldl r5, #XXh            ; number of outer loop runs
    outer_loop:
        subi r5, #1
        jmpzd #wait_end
        ldh r6, #XXh        ;
        ldl r6, #XXh        ; number of inner loop runs
        
        ; read bit 3 and 2 from regData (button_inc and button_dec)
        xor r0, r0, r0
        ld button_press, r10, r0
        ldh mask_inc, #00h
        ldl mask_inc, #08h
        ldh mask_dec, #00h
        ldl mask_dec, #04h
        and button_inc_result, button_press, mask_inc            ; if button_inc is pressed, flag z = 0
        jmpzd #continue
		
        and button_dec_result, button_press, mask_dec               
        jmpzd #continue
		
        ; implement: if button is pressed, increment dependent counter (decimal)
        
        continue:
        inner_loop:
            subi r6, #1			
            jmpzd #write_display			;waits 4ms
            jmpd  #inner_loop
			
		write_display:
		;writes display and chooses the enable
		xor r0, r0, r0
		ldh r6, #00h
		ldl r6, #04h			;4 constant
		ldh r7, #display_index
		ldl r7, #display_index
		ld r5, r7, r0
		addi r5, #1				;display_index++
		sub r6, r6, r5			; if display_index >= 4, reset it to zero
		jmpnd  #reset_to_zero	; display_index >= 4
		jmpzd  #reset_to_zero
		jmpd   #store_index
		reset_to_zero:
			xor r5, r5, r5		; display_index = 0
		store_index:
		st r5, r7, r0
		
		ldh r8, #enable_display_mask
		ldl r8, #enable_display_mask
		ld r10, r8, r5		; loads the apropriate display_mask	
		
		ldh r9, #display
		ldl r9, #display
		ld r11, r9, r5		; loads the apropriate display 
		
		;7seg decoding:
		ldh r7, #seg_codes
		ldl r7, #seg_codes
		ld r12, r7, r11		; loads the decoded display
		
		or r13, r12, r10 	;sets both enable and seg_code
		
		ldh r7, #80h            ;
		ldl r7, #02h        	; r7 <= PortA regData address
		st r13, r7, r0			;writes to display
		jmpd #outer_loop

wait_end:
    ;select display to be output and print on displays here:
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    rts

.endcode

.data
    seg_codes:  			db #0300h, #9F00h, #2500h, #0D00h, #9900h, #4900h, #4100h, #1F00h, #0100h, #0900h
	display : 				db #0000h, #0000h, #0000h, #0000h						;display[0] = units timer, display[3] = tens counter
	enable_display_mask : 	db #0010h, #0020h, #0040h, #0080h
	display_index : 		db #0000h												;selects witch display is enabled	
.enddata