onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /r8_uc_tb/R8_uC/clk
add wave -noupdate -label rst /r8_uc_tb/R8_uC/rst
add wave -noupdate -label currentState /r8_uc_tb/R8_uC/PROCESSOR/currentState
add wave -noupdate -label decodedInstruction /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate -label registerFile /r8_uc_tb/R8_uC/PROCESSOR/registerFile
add wave -noupdate -label regA /r8_uc_tb/R8_uC/PROCESSOR/regA
add wave -noupdate -label regB /r8_uc_tb/R8_uC/PROCESSOR/regB
add wave -noupdate -label mulResult /r8_uc_tb/R8_uC/PROCESSOR/mulResult
add wave -noupdate -label regHigh /r8_uc_tb/R8_uC/PROCESSOR/regHigh
add wave -noupdate -label regLow /r8_uc_tb/R8_uC/PROCESSOR/regLow
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3308415 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 291
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {518832 ps}
