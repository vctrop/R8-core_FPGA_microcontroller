onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label rst /r8_crypto_tb/r8_crypto/rst
add wave -noupdate -divider R8
add wave -noupdate -color Blue -label decodedInstruction /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate -color {Medium Sea Green} -label State /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/currentState
add wave -noupdate -color Sienna -label regPC /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regPC
add wave -noupdate -color {Medium Orchid} -label regSP /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regSP
add wave -noupdate -label regIR /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regIR
add wave -noupdate -label regISRA /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regISRA
add wave -noupdate -label HIGH /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regHigh
add wave -noupdate -label LOW /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regLow
add wave -noupdate -color Goldenrod -label registerFile -expand -subitemconfig {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(0) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(1) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(2) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(3) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(4) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(5) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(6) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(7) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(8) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(9) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(10) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(11) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(12) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(13) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(14) {-color Goldenrod -height 15} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(15) {-color Goldenrod -height 15}} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile
add wave -noupdate -label rw /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/rw
add wave -noupdate -label {ce mem} /r8_crypto_tb/r8_crypto/R8_uC/ce_mem
add wave -noupdate -label {ce io} /r8_crypto_tb/r8_crypto/R8_uC/ce_io
add wave -noupdate -divider Interruption
add wave -noupdate -color Magenta -label Request /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/intr
add wave -noupdate -color Wheat -label Status /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/InterruptionStatus
add wave -noupdate -divider {memory interface}
add wave -noupdate -label data_in_r8 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/data_in
add wave -noupdate -color {Dark Green} -label data_out_r8 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/data_out
add wave -noupdate -color Aquamarine -label address /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/address
add wave -noupdate -divider PIC
add wave -noupdate -label highPriorityRequest /r8_crypto_tb/r8_crypto/R8_uC/PIC/highPriorityReq
add wave -noupdate -label address /r8_crypto_tb/r8_crypto/R8_uC/PIC/address
add wave -noupdate -label data /r8_crypto_tb/r8_crypto/R8_uC/PIC/data
add wave -noupdate -label {ce PIC} /r8_crypto_tb/r8_crypto/R8_uC/ce_PIC
add wave -noupdate -label wr /r8_crypto_tb/r8_crypto/R8_uC/PIC/wr
add wave -noupdate -label {irq reg} /r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg
add wave -noupdate -label mask /r8_crypto_tb/r8_crypto/R8_uC/PIC/mask
add wave -noupdate -divider portA
add wave -noupdate -label rw /r8_crypto_tb/r8_crypto/R8_uC/PORT_A/wr
add wave -noupdate -label {ce portA} /r8_crypto_tb/r8_crypto/R8_uC/ce_portA
add wave -noupdate -color {Medium Spring Green} -label PortData /r8_crypto_tb/r8_crypto/R8_uC/PORT_A/PortData
add wave -noupdate -color {Steel Blue} -label PortConfig /r8_crypto_tb/r8_crypto/R8_uC/PORT_A/PortConfig
add wave -noupdate -color {Midnight Blue} -label PortEnable /r8_crypto_tb/r8_crypto/R8_uC/PORT_A/PortEnable
add wave -noupdate -color Blue -label PortIrqEnable /r8_crypto_tb/r8_crypto/R8_uC/PORT_A/PortIrqEnable
add wave -noupdate -divider Cryptos
add wave -noupdate -label op /r8_crypto_tb/r8_crypto/op
add wave -noupdate -label id /r8_crypto_tb/r8_crypto/id
add wave -noupdate -label ack /r8_crypto_tb/r8_crypto/ack
add wave -noupdate -divider {Crypto 0}
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/rst
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/ack
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/data_in
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/data_out
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/data_av
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/keyExchange
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/eom
add wave -noupdate -divider {Crypto 1}
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/rst
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/ack
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/data_in
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/data_out
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/data_av
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/keyExchange
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/eom
add wave -noupdate -divider {Crypto 2}
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/rst
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/ack
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/data_in
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/data_out
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/data_av
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/keyExchange
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/eom
add wave -noupdate -divider {Crypto 3}
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/rst
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/ack
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/data_in
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/data_out
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/data_av
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/keyExchange
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/eom
add wave -noupdate -divider {MSG 0}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {100170000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 151
configure wave -valuecolwidth 65
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {98533511 ps} {101806490 ps}
