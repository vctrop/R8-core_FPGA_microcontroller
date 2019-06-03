onerror {resume}
quietly virtual signal -install /r8_crypto_tb/r8_crypto/RX { (context /r8_crypto_tb/r8_crypto/RX )(rx_data & data_av )} A
quietly WaveActivateNextPane {} 0
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/clk
add wave -noupdate -label rst /r8_crypto_tb/r8_crypto/rst
add wave -noupdate -color Sienna -label PC /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regPC
add wave -noupdate -divider Instructions
add wave -noupdate -color Blue -label decodedInstruction /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate -color {Medium Sea Green} -label State /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/currentState
add wave -noupdate -label regIR /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regIR
add wave -noupdate -label HIGH /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regHigh
add wave -noupdate -label LOW /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regLow
add wave -noupdate -color Goldenrod -label registerFile /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile
add wave -noupdate -divider {memory interface}
add wave -noupdate -label data_in_r8 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/data_in
add wave -noupdate -color {Dark Green} -label data_out_r8 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/data_out
add wave -noupdate -color Aquamarine -label address /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/address
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1008)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1009)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1010)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1011)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1012)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1013)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1014)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1015)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1016)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1017)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1018)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1019)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1020)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1021)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1022)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1023)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1024)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1025)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1026)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1027)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1028)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1029)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1030)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1031)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1032)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1033)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1034)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1035)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1036)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1037)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1038)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1039)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1040)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1041)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1042)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1043)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1044)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1045)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1046)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1047)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1048)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1049)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1050)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1051)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1052)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1053)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1054)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1055)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1056)
add wave -noupdate -expand -group Array /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1057)
add wave -noupdate -divider Rx
add wave -noupdate -color Turquoise -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/RX/rx_data
add wave -noupdate /r8_crypto_tb/r8_crypto/RX/data_av
add wave -noupdate /r8_crypto_tb/r8_crypto/RX/rx
add wave -noupdate /r8_crypto_tb/r8_crypto/RX/clk
add wave -noupdate -divider Tx
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/clk
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/tx
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/ready
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/data_av
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/data_in
add wave -noupdate -radix ascii /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/tx_data
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/currentState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16477730000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {16464179076 ps} {16554802428 ps}
