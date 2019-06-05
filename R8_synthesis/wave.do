onerror {resume}
quietly virtual signal -install /r8_uc_tb/R8_uC/RAM { (context /r8_uc_tb/R8_uC/RAM )(RAM(150) &RAM(151) &RAM(152) &RAM(153) &RAM(154) &RAM(155) &RAM(156) )} string
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider R8
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/clk
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/rst
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/currentState
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate -expand /r8_uc_tb/R8_uC/PROCESSOR/registerFile
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/data_in
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/data_out
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/address
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regPC
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regALU
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regA
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regB
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regSP
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regISRA
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regTSRA
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regIR
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regHigh
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regLow
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/V
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regFlags
add wave -noupdate -divider Traps
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/TrapStatus
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/TrapRequest
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regCause
add wave -noupdate -divider Interruptions
add wave -noupdate /r8_uc_tb/R8_uC/irq
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/intr
add wave -noupdate -divider Tx
add wave -noupdate /r8_uc_tb/R8_uC/data_TX
add wave -noupdate /r8_uc_tb/R8_uC/TX_av
add wave -noupdate -divider Rx
add wave -noupdate /r8_uc_tb/R8_uC/data_RX
add wave -noupdate /r8_uc_tb/R8_uC/RX_av
add wave -noupdate /r8_uc_tb/R8_uC/RX_av_latch
add wave -noupdate -divider Stack
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1950)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1951)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1952)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1953)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1954)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1955)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1956)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1957)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1958)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1959)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1960)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1961)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1962)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1963)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1964)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1965)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1966)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1967)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1968)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1969)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1970)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1971)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1972)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1973)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1974)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1975)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1976)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1977)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1978)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1979)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1980)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1981)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1982)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1983)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1984)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1985)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1986)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1987)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1988)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1989)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1990)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1991)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1992)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1993)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1994)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1995)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1996)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1997)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1998)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1999)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(2000)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {998020709 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 129
configure wave -valuecolwidth 150
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {997896026 ps} {1000660187 ps}
