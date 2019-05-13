;test exp_mod
.code
main:
	ldh r1, #00
	ldl r1, #250
	ldh r10, #00h
	ldl r10, #80h   ; r10 <= bit mask to check if b(i) = '1'
	ldh r11, #00h
	ldl r11, #06h   ; r11 = a 
	ldh r12, #00h
	ldl r12, #251  ; r12 = q 
	ldh r3, #00h
	ldl r3, #01h 	; r3 <= 1 (f)
	loop_exp:
		mul r3, r3   ;
		mfl r3       ; r3 <= f * f (assuming it must be at most 16 bits long)
		div r3, r12   
		mfh r3       ; r3 <= (f*f) % q 
		and r6, r1, r10   ; checks if b(i) = '1'
		jmpzd #continue_exp
			mul r3, r11   ;
			mfl r3       ; r3 <= f * a (assuming it must be at most 16 bits long)
			div r3, r12   
			mfh r3       ; r3 <= (f*a) % q 
		continue_exp:
		sr0 r10, r10     ; mask >>= 1
		jmpzd #end_loop_exp		; if mask = 0 then we have checked every bit of b
		jmpd #loop_exp
	end_loop_exp:
	halt
.endcode