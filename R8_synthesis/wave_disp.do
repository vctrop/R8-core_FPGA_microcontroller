onerror {resume}
quietly virtual signal -install /r8_uc_tb/R8_uC/RAM { (context /r8_uc_tb/R8_uC/RAM )(RAM(150) &RAM(151) &RAM(152) &RAM(153) &RAM(154) &RAM(155) &RAM(156) )} string
quietly virtual signal -install /r8_uc_tb/R8_uC/RAM { (context /r8_uc_tb/R8_uC/RAM )(RAM(140) &RAM(141) &RAM(142) &RAM(143) &RAM(144) &RAM(145) &RAM(146) )} string001
quietly WaveActivateNextPane {} 0
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/clk
add wave -noupdate /r8_uc_tb/clk
add wave -noupdate /r8_uc_tb/clk_div4
add wave -noupdate -divider R8
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/rst
add wave -noupdate /r8_uc_tb/R8_uC/board_rst
add wave -noupdate /r8_uc_tb/R8_uC/mode_rst
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/currentState
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate -expand /r8_uc_tb/R8_uC/PROCESSOR/registerFile
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
add wave -noupdate -divider TX_R8
add wave -noupdate /r8_uc_tb/R8_uC/UART_TX/data_in
add wave -noupdate /r8_uc_tb/R8_uC/UART_TX/ready
add wave -noupdate -radix ascii /r8_uc_tb/R8_uC/UART_TX/tx_data
add wave -noupdate -divider RX_R8
add wave -noupdate /r8_uc_tb/R8_uC/UART_RX/currentState
add wave -noupdate /r8_uc_tb/R8_uC/UART_RX/clk
add wave -noupdate /r8_uc_tb/R8_uC/UART_RX/data_out
add wave -noupdate /r8_uc_tb/R8_uC/UART_RX/data_av
add wave -noupdate -divider TX_TB
add wave -noupdate /r8_uc_tb/TB_TX/currentState
add wave -noupdate /r8_uc_tb/TB_TX/clk
add wave -noupdate /r8_uc_tb/TB_TX/data_in
add wave -noupdate /r8_uc_tb/TB_TX/ready
add wave -noupdate /r8_uc_tb/TB_TX/tx_data
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
add wave -noupdate -divider RAM
add wave -noupdate /r8_uc_tb/state
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(0)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(2)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(3)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(4)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(5)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(6)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(7)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(8)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(9)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(10)
add wave -noupdate -divider string
add wave -noupdate -expand -group string -radix ascii -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(140)
add wave -noupdate -expand -group string -radix ascii -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(141)
add wave -noupdate -expand -group string -radix ascii -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(142)
add wave -noupdate -expand -group string -radix ascii -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(143)
add wave -noupdate -expand -group string -radix ascii -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(144)
add wave -noupdate -expand -group string -radix ascii -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(145)
add wave -noupdate -expand -group string -radix ascii -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(146)
add wave -noupdate -divider BUFFER
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(300)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(301)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(302)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(303)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(304)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(305)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(306)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(307)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(308)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(309)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(310)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(311)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(312)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(313)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(314)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(315)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(316)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(317)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(318)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(319)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(320)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(321)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(322)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(323)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(324)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(325)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(326)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(327)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(328)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(329)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(330)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(331)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(332)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(333)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(334)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(335)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(336)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(337)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(338)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(339)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(340)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(341)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(342)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(343)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(344)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(345)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(346)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(347)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(348)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(349)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(350)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1994701550 ps} 0}
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
WaveRestoreZoom {1990389633 ps} {2000505809 ps}
