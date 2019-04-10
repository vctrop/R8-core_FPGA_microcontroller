onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /r8_uc_tb/R8_uC/port_io
add wave -noupdate /r8_uc_tb/R8_uC/clk
add wave -noupdate /r8_uc_tb/R8_uC/rw
add wave -noupdate /r8_uc_tb/R8_uC/ce
add wave -noupdate /r8_uc_tb/R8_uC/rst
add wave -noupdate /r8_uc_tb/R8_uC/ce_mem
add wave -noupdate /r8_uc_tb/R8_uC/ce_io
add wave -noupdate /r8_uc_tb/R8_uC/ce_portA
add wave -noupdate /r8_uc_tb/R8_uC/R8_out
add wave -noupdate /r8_uc_tb/R8_uC/R8_in
add wave -noupdate /r8_uc_tb/R8_uC/addressR8
add wave -noupdate /r8_uc_tb/R8_uC/mem_out
add wave -noupdate /r8_uc_tb/R8_uC/data_portA
add wave -noupdate /r8_uc_tb/R8_uC/address_peripherals
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/currentState
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/data
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/address
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/port_io
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/PortEnable
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/PortConfig
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/regSync1
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/regSync2
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/PortData
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
WaveRestoreZoom {5507110 ps} {6025942 ps}
