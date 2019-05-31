onerror {resume}
quietly virtual signal -install /r8_uc_tb/R8_uC/RAM { (context /r8_uc_tb/R8_uC/RAM )(RAM(150) &RAM(151) &RAM(152) &RAM(153) &RAM(154) &RAM(155) &RAM(156) )} string
quietly WaveActivateNextPane {} 0
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/clk
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/rst
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regPC
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/currentState
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/registerFile
add wave -noupdate -divider memory
add wave -noupdate -radix ascii -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/string
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(150)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(151)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(152)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(153)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(154)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(155)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(156)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ns} {36205 ns}
