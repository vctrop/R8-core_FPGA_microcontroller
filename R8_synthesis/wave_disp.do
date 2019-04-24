onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /r8_uc_tb/clk
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/PortEnable
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/PortConfig
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/PortData
add wave -noupdate /r8_uc_tb/rst
add wave -noupdate /r8_uc_tb/port_io
add wave -noupdate -divider {New Divider}
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/address
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/data_in
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/data_out
add wave -noupdate -divider Display
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(176)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(177)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(178)
add wave -noupdate -divider Display_index
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(184)
add wave -noupdate -divider 7SEG
add wave -noupdate /r8_uc_tb/display_digit
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
WaveRestoreCursors {{Cursor 1} {108329732 ps} 0}
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
WaveRestoreZoom {108159322 ps} {108623194 ps}
