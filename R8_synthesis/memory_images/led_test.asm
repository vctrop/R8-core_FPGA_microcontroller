.code
	xor r0, r0, r0
	ldh r8, #80h
	ldl r8, #01h
	ldh r9, #00h
	ldl r9, #00h
	st r9, r8, r0		; set all as output
		
	ldh r8, #80h
	ldl r8, #00h
	ldh r9, #00h
	ldl r9, #01h		; enable first bit
	st r9, r8, r0
	
	ldh r8, #80h
	ldl r8, #02h
	ldh r9, #00h
	ldl r9, #01h		; light led
	st r9, r8, r0
	halt
.endcode