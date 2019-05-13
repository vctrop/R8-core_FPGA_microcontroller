.org #00h
.code
    ldh r1, #00h
    ldl r1, #0Ah        ; 10
    ;mul r1, r1
    div r1, r1
    
    mfh r5
    mfl r4
    
    ldh r2, #FFh
    ldl r2, #F6h        ; -10
    ;mul r2, r2
    div r2, r2
    
    mfh r5
    mfl r4
    
    ;mul r1, r2
    div r1, r2
    
    xor r0, r0, r0
    ;mul r1, r0
    div r1, r0
    
    mfh r5
    mfl r4
    
    halt
.endcode