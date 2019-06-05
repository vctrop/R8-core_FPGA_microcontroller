onerror {resume}
quietly virtual signal -install /r8_uc_tb/R8_uC/RAM { (context /r8_uc_tb/R8_uC/RAM )(RAM(150) &RAM(151) &RAM(152) &RAM(153) &RAM(154) &RAM(155) &RAM(156) )} string
quietly WaveActivateNextPane {} 0
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/clk
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/rst
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regPC
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/currentState
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/registerFile
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regSP
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regISRA
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regTSRA
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regIR
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regHigh
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regLow
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/V
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regFlags
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/opA
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/opB
add wave -noupdate /r8_uc_tb/R8_uC/irq
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/InterruptionStatus
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/intr
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/TrapStatus
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/TrapRequest
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regCause
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19050000 ps} 0}
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
WaveRestoreZoom {18093906 ps} {19366094 ps}
