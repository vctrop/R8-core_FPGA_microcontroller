onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /r8_uc_tb/clk
add wave -noupdate -label rst /r8_uc_tb/rst
add wave -noupdate -color Sienna -label PC /r8_uc_tb/R8_uC/PROCESSOR/regPC
add wave -noupdate -divider Instructions
add wave -noupdate -color Blue -label decodedInstruction /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate -color {Medium Sea Green} -label State /r8_uc_tb/R8_uC/PROCESSOR/currentState
add wave -noupdate -label regIR /r8_uc_tb/R8_uC/PROCESSOR/regIR
add wave -noupdate -divider {memory interface}
add wave -noupdate -label data_in_r8 /r8_uc_tb/R8_uC/PROCESSOR/data_in
add wave -noupdate -color {Dark Green} -label data_out_r8 /r8_uc_tb/R8_uC/PROCESSOR/data_out
add wave -noupdate -color Aquamarine -label address /r8_uc_tb/R8_uC/PROCESSOR/address
add wave -noupdate -divider Flags
add wave -noupdate -label V /r8_uc_tb/R8_uC/PROCESSOR/regFlags(3)
add wave -noupdate -label C /r8_uc_tb/R8_uC/PROCESSOR/regFlags(2)
add wave -noupdate -label Z /r8_uc_tb/R8_uC/PROCESSOR/regFlags(1)
add wave -noupdate -label N /r8_uc_tb/R8_uC/PROCESSOR/regFlags(0)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(32764)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(32765)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(32766)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(32767)
add wave -noupdate -divider Interruption
add wave -noupdate -color Magenta -label Request /r8_uc_tb/R8_uC/PROCESSOR/intr
add wave -noupdate -color {Orange Red} -label Status /r8_uc_tb/R8_uC/PROCESSOR/InterruptionStatus
add wave -noupdate -color {Medium Orchid} -label regSP /r8_uc_tb/R8_uC/PROCESSOR/regSP
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2150832 ps} 0}
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
WaveRestoreZoom {0 ps} {1032192 ps}
