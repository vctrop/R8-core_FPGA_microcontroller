onerror {resume}
quietly virtual signal -install /r8_uc_tb/R8_uC/RAM { (context /r8_uc_tb/R8_uC/RAM )(RAM(150) &RAM(151) &RAM(152) &RAM(153) &RAM(154) &RAM(155) &RAM(156) )} string
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider R8
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/clk
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/rst
add wave -noupdate /r8_uc_tb/R8_uC/board_rst
add wave -noupdate /r8_uc_tb/R8_uC/mode_rst
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/currentState
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/registerFile
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/data_in
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/data_out
add wave -noupdate /r8_uc_tb/R8_uC/mode
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/address
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regPC
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regALU
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regA
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regB
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regSP
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regISRA
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regTSRA
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regIR
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regHigh
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regLow
add wave -noupdate -divider Traps
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/TrapStatus
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/TrapRequest
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regCause
add wave -noupdate -divider Interruptions
add wave -noupdate /r8_uc_tb/R8_uC/irq
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/InterruptionStatus
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/intr
add wave -noupdate /r8_uc_tb/R8_uC/PIC/mask
add wave -noupdate -divider RAM
add wave -noupdate -expand -group display /r8_uc_tb/R8_uC/RAM/RAM(618)
add wave -noupdate -expand -group display /r8_uc_tb/R8_uC/RAM/RAM(619)
add wave -noupdate -expand -group display /r8_uc_tb/R8_uC/RAM/RAM(620)
add wave -noupdate -expand -group display /r8_uc_tb/R8_uC/RAM/RAM(621)
add wave -noupdate -expand -group enables /r8_uc_tb/R8_uC/RAM/RAM(622)
add wave -noupdate -expand -group enables /r8_uc_tb/R8_uC/RAM/RAM(623)
add wave -noupdate -expand -group enables /r8_uc_tb/R8_uC/RAM/RAM(624)
add wave -noupdate -expand -group enables /r8_uc_tb/R8_uC/RAM/RAM(625)
add wave -noupdate -label index /r8_uc_tb/R8_uC/RAM/RAM(626)
add wave -noupdate -label debounce_flag /r8_uc_tb/R8_uC/RAM/RAM(627)
add wave -noupdate -label one_ms_timer /r8_uc_tb/R8_uC/RAM/RAM(628)
add wave -noupdate -label one_s_timer /r8_uc_tb/R8_uC/RAM/RAM(629)
add wave -noupdate -divider PortA
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/PortEnable
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/PortConfig
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/PortData
add wave -noupdate /r8_uc_tb/R8_uC/PORT_A/PortIrqEnable
add wave -noupdate -divider PIC
add wave -noupdate /r8_uc_tb/R8_uC/PIC/irq_reg
add wave -noupdate /r8_uc_tb/R8_uC/PIC/mask
add wave -noupdate /r8_uc_tb/R8_uC/PIC/pendingRequests
add wave -noupdate /r8_uc_tb/R8_uC/PIC/highPriorityReq
add wave -noupdate -divider 7seg
add wave -noupdate /r8_uc_tb/DISP/segment
add wave -noupdate /r8_uc_tb/DISP/digit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {99193090 ps} 0}
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
WaveRestoreZoom {75738311 ps} {101277247 ps}
