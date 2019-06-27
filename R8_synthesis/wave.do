onerror {resume}
quietly virtual signal -install /r8_uc_tb/R8_uC/RAM { (context /r8_uc_tb/R8_uC/RAM )(RAM(150) &RAM(151) &RAM(152) &RAM(153) &RAM(154) &RAM(155) &RAM(156) )} string
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider R8
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/clk
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/rst
add wave -noupdate /r8_uc_tb/R8_uC/board_rst
add wave -noupdate /r8_uc_tb/R8_uC/mode_rst
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/currentState
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/registerFile
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/data_in
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/data_out
add wave -noupdate /r8_uc_tb/R8_uC/mode
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
add wave -noupdate -label overflow /r8_uc_tb/R8_uC/PROCESSOR/regFlags(3)
add wave -noupdate -label carry /r8_uc_tb/R8_uC/PROCESSOR/regFlags(2)
add wave -noupdate -label zero /r8_uc_tb/R8_uC/PROCESSOR/regFlags(1)
add wave -noupdate -label negative /r8_uc_tb/R8_uC/PROCESSOR/regFlags(0)
add wave -noupdate -divider Traps
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/TrapStatus
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/TrapRequest
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regCause
add wave -noupdate -divider Interruptions
add wave -noupdate /r8_uc_tb/R8_uC/irq
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/intr
add wave -noupdate /r8_uc_tb/R8_uC/PIC/mask
add wave -noupdate -divider Tx
add wave -noupdate /r8_uc_tb/R8_uC/UART_TX/currentState
add wave -noupdate /r8_uc_tb/R8_uC/UART_TX/reg_freq_baud
add wave -noupdate -radix hexadecimal -childformat {{/r8_uc_tb/R8_uC/data_TX(15) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(14) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(13) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(12) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(11) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(10) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(9) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(8) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(7) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(6) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(5) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(4) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(3) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(2) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(1) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(0) -radix ascii}} -radixshowbase 0 -subitemconfig {/r8_uc_tb/R8_uC/data_TX(15) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(14) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(13) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(12) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(11) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(10) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(9) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(8) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(7) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(6) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(5) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(4) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(3) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(2) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(1) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(0) {-height 15 -radix ascii -radixshowbase 0}} /r8_uc_tb/R8_uC/data_TX
add wave -noupdate /r8_uc_tb/R8_uC/TX_av
add wave -noupdate -divider Rx
add wave -noupdate /r8_uc_tb/R8_uC/UART_RX/currentState
add wave -noupdate /r8_uc_tb/R8_uC/UART_RX/rx
add wave -noupdate /r8_uc_tb/R8_uC/UART_RX/reg_freq_baud
add wave -noupdate -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/data_RX
add wave -noupdate /r8_uc_tb/R8_uC/RX_av
add wave -noupdate -divider {RX buffer}
add wave -noupdate -label rx_buffer_ready /r8_uc_tb/R8_uC/RAM/RAM(1115)
add wave -noupdate -label rx_buffer_index /r8_uc_tb/R8_uC/RAM/RAM(1116)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1035)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1036)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1037)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1038)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1039)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1040)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1041)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1042)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1043)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1044)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1045)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1046)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1047)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1048)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1049)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1050)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1051)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1052)
add wave -noupdate -expand -group RX_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1053)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1237)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1238)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1239)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1240)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1241)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1242)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1243)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1244)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1245)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1246)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1247)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1248)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1249)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1250)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1251)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1252)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1253)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1254)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1255)
add wave -noupdate -expand -group User_buffer -radix hexadecimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1256)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {969976981 ps} 0} {{Cursor 2} {5261780 ps} 0}
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
WaveRestoreZoom {959372883 ps} {1002138270 ps}
