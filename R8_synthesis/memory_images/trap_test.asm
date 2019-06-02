.code
    ldh r1, #02h
    ldl r1, #20h
    ldtsra r1
    mfc r1
    halt
.endcode