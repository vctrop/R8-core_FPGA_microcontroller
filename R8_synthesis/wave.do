onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /r8_uc_tb/clk
add wave -noupdate -label rst /r8_uc_tb/rst
add wave -noupdate -color Sienna -label PC /r8_uc_tb/R8_uC/PROCESSOR/regPC
add wave -noupdate -divider Instructions
add wave -noupdate -color Blue -label decodedInstruction /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate -color {Medium Sea Green} -label State /r8_uc_tb/R8_uC/PROCESSOR/currentState
add wave -noupdate -label regIR /r8_uc_tb/R8_uC/PROCESSOR/regIR
add wave -noupdate -label HIGH /r8_uc_tb/R8_uC/PROCESSOR/regHigh
add wave -noupdate -label LOW /r8_uc_tb/R8_uC/PROCESSOR/regLow
add wave -noupdate -color Goldenrod -label registerFile -expand -subitemconfig {/r8_uc_tb/R8_uC/PROCESSOR/registerFile(0) {-color Goldenrod} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(1) {-color Yellow} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(2) {-color Goldenrod} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(3) {-color {Green Yellow}} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(4) {-color Goldenrod} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(5) {-color Goldenrod} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(6) {-color Goldenrod} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(7) {-color Goldenrod} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(8) {-color Goldenrod} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(9) {-color Goldenrod} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(10) {-color Sienna} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(11) {-color {Medium Blue}} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(12) {-color Gray75} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(13) {-color Goldenrod} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(14) {-color Goldenrod} /r8_uc_tb/R8_uC/PROCESSOR/registerFile(15) {-color Goldenrod}} /r8_uc_tb/R8_uC/PROCESSOR/registerFile
add wave -noupdate -divider {memory interface}
add wave -noupdate -label data_in_r8 /r8_uc_tb/R8_uC/PROCESSOR/data_in
add wave -noupdate -color {Dark Green} -label data_out_r8 /r8_uc_tb/R8_uC/PROCESSOR/data_out
add wave -noupdate -color Aquamarine -label address /r8_uc_tb/R8_uC/PROCESSOR/address
add wave -noupdate -divider Interruption
add wave -noupdate -color Magenta -label Request /r8_uc_tb/R8_uC/PROCESSOR/intr
add wave -noupdate -color Wheat -label Status /r8_uc_tb/R8_uC/PROCESSOR/InterruptionStatus
add wave -noupdate -color {Medium Orchid} -label regSP /r8_uc_tb/R8_uC/PROCESSOR/regSP
add wave -noupdate -divider portA
add wave -noupdate -color {Medium Spring Green} -label PortData /r8_uc_tb/R8_uC/PORT_A/PortData
add wave -noupdate -color {Midnight Blue} -label PortEnable /r8_uc_tb/R8_uC/PORT_A/PortEnable
add wave -noupdate -color {Steel Blue} -label PortConfig /r8_uc_tb/R8_uC/PORT_A/PortConfig
add wave -noupdate -color Blue -label PortIrqEnable /r8_uc_tb/R8_uC/PORT_A/PortIrqEnable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {350516 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {1110424 ps}
