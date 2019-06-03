onerror {resume}
quietly virtual signal -install /r8_uc_tb/R8_uC/RAM { (context /r8_uc_tb/R8_uC/RAM )(RAM(150) &RAM(151) &RAM(152) &RAM(153) &RAM(154) &RAM(155) &RAM(156) )} string
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider uC
add wave -noupdate /r8_uc_tb/R8_uC/port_io
add wave -noupdate /r8_uc_tb/R8_uC/board_clock
add wave -noupdate /r8_uc_tb/R8_uC/board_rst
add wave -noupdate /r8_uc_tb/R8_uC/ce
add wave -noupdate /r8_uc_tb/R8_uC/ce_io
add wave -noupdate /r8_uc_tb/R8_uC/ce_portA
add wave -noupdate /r8_uc_tb/R8_uC/ce_PIC
add wave -noupdate -divider R8
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/currentState
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regPC
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/registerFile
add wave -noupdate /r8_uc_tb/R8_uC/R8_out
add wave -noupdate /r8_uc_tb/R8_uC/R8_in
add wave -noupdate -divider Memory
add wave -noupdate /r8_uc_tb/R8_uC/clk_mem
add wave -noupdate /r8_uc_tb/R8_uC/ce_mem
add wave -noupdate -divider TX
add wave -noupdate /r8_uc_tb/R8_uC/UART_TX/currentState
add wave -noupdate /r8_uc_tb/R8_uC/UART_TX/tx_data
add wave -noupdate /r8_uc_tb/R8_uC/TX_av
add wave -noupdate /r8_uc_tb/R8_uC/ce_TX
add wave -noupdate -divider RX
add wave -noupdate /r8_uc_tb/R8_uC/UART_RX/currentState
add wave -noupdate /r8_uc_tb/R8_uC/UART_RX/rx_data
add wave -noupdate /r8_uc_tb/R8_uC/RX_av
add wave -noupdate /r8_uc_tb/R8_uC/RX_av_latch
add wave -noupdate /r8_uc_tb/R8_uC/ce_RX
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1721627 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 239
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
WaveRestoreZoom {0 ps} {614400 ps}
