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
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/V
add wave -noupdate -label overflow /r8_uc_tb/R8_uC/PROCESSOR/regFlags(3)
add wave -noupdate -label carry /r8_uc_tb/R8_uC/PROCESSOR/regFlags(2)
add wave -noupdate -label zero /r8_uc_tb/R8_uC/PROCESSOR/regFlags(1)
add wave -noupdate -label negative /r8_uc_tb/R8_uC/PROCESSOR/regFlags(0)
add wave -noupdate -divider Traps
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/TrapStatus
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/TrapRequest
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/regCause
add wave -noupdate -divider Interruptions
add wave -noupdate /r8_uc_tb/R8_uC/irq
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/intr
add wave -noupdate /r8_uc_tb/R8_uC/PIC/mask
add wave -noupdate -divider Tx
add wave -noupdate /r8_uc_tb/R8_uC/UART_TX/currentState
add wave -noupdate /r8_uc_tb/R8_uC/UART_TX/reg_freq_baud
add wave -noupdate -radix ascii -childformat {{/r8_uc_tb/R8_uC/data_TX(15) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(14) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(13) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(12) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(11) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(10) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(9) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(8) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(7) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(6) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(5) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(4) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(3) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(2) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(1) -radix ascii} {/r8_uc_tb/R8_uC/data_TX(0) -radix ascii}} -radixshowbase 0 -subitemconfig {/r8_uc_tb/R8_uC/data_TX(15) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(14) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(13) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(12) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(11) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(10) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(9) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(8) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(7) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(6) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(5) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(4) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(3) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(2) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(1) {-height 15 -radix ascii -radixshowbase 0} /r8_uc_tb/R8_uC/data_TX(0) {-height 15 -radix ascii -radixshowbase 0}} /r8_uc_tb/R8_uC/data_TX
add wave -noupdate /r8_uc_tb/R8_uC/TX_av
add wave -noupdate -divider Rx
add wave -noupdate /r8_uc_tb/R8_uC/UART_RX/currentState
add wave -noupdate /r8_uc_tb/R8_uC/UART_RX/rx
add wave -noupdate /r8_uc_tb/R8_uC/UART_RX/reg_freq_baud
add wave -noupdate -radix ascii -radixshowbase 0 /r8_uc_tb/R8_uC/data_RX
add wave -noupdate /r8_uc_tb/R8_uC/RX_av
add wave -noupdate -divider RAM
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(0)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(1)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(2)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(3)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(4)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(5)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(6)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(7)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(8)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(9)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(10)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(11)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(12)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(13)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(14)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(15)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(16)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(17)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(18)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(19)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(20)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(21)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(22)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(23)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(24)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(25)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(26)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(27)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(28)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(29)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(30)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(31)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(32)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(33)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(34)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(35)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(36)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(37)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(38)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(39)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(40)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(41)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(42)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(43)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(44)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(45)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(46)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(47)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(48)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(49)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(50)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(51)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(52)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(53)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(54)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(55)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(56)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(57)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(58)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(59)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(60)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(61)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(62)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(63)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(64)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(65)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(66)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(67)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(68)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(69)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(70)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(71)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(72)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(73)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(74)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(75)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(76)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(77)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(78)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(79)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(80)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(81)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(82)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(83)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(84)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(85)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(86)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(87)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(88)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(89)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(90)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(91)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(92)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(93)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(94)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(95)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(96)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(97)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(98)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(99)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(100)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(101)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(102)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(103)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(104)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(105)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(106)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(107)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(108)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(109)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(110)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(111)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(112)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(113)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(114)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(115)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(116)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(117)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(118)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(119)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(120)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(121)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(122)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(123)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(124)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(125)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(126)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(127)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(128)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(129)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(130)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(131)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(132)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(133)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(134)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(135)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(136)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(137)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(138)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(139)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(140)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(141)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(142)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(143)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(144)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(145)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(146)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(147)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(148)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(149)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(150)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(151)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(152)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(153)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(154)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(155)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(156)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(157)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(158)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(159)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(160)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(161)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(162)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(163)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(164)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(165)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(166)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(167)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(168)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(169)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(170)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(171)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(172)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(173)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(174)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(175)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(176)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(177)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(178)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(179)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(180)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(181)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(182)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(183)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(184)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(185)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(186)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(187)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(188)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(189)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(190)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(191)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(192)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(193)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(194)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(195)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(196)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(197)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(198)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(199)
add wave -noupdate -expand -group RAM /r8_uc_tb/R8_uC/RAM/RAM(200)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2714000 ps} 0}
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
WaveRestoreZoom {0 ps} {25538936 ps}
