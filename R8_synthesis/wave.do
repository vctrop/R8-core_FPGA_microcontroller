onerror {resume}
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
add wave -noupdate -color Goldenrod -label registerFile -expand -subitemconfig {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(0) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(1) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(2) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(3) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(4) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(5) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(6) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(7) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(8) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(9) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(10) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(11) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(12) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(13) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(14) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(15) {-color Goldenrod -height 15}} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile
add wave -noupdate -divider {memory interface}
add wave -noupdate -label data_in_r8 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/data_in
add wave -noupdate -color {Dark Green} -label data_out_r8 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/data_out
add wave -noupdate -color Aquamarine -label address /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/address
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(150)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(151)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(152)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(153)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(154)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(155)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(156)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(157)
add wave -noupdate -divider Rx
add wave -noupdate /r8_crypto_tb/r8_crypto/RX/rx_data
add wave -noupdate /r8_crypto_tb/r8_crypto/RX/data_av
add wave -noupdate /r8_crypto_tb/r8_crypto/RX/rx
add wave -noupdate -divider Tx
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/clk
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/tx
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/ready
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/data_av
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/data_in
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/tx_data
add wave -noupdate /r8_crypto_tb/r8_crypto/R8_uC/UART_TX/currentState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14970000 ps} 0}
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
WaveRestoreZoom {99501927 ps} {100026215 ps}
