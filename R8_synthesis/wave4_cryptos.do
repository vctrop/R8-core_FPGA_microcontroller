onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label rst /r8_crypto_tb/r8_crypto/rst
add wave -noupdate -divider R8
add wave -noupdate -color Blue -label decodedInstruction /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate -color {Medium Sea Green} -label State /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/currentState
add wave -noupdate -label regPC -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regPC
add wave -noupdate -label regSP -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regSP
add wave -noupdate -label regIR -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regIR
add wave -noupdate -label regISRA -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regISRA
add wave -noupdate -label HIGH -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regHigh
add wave -noupdate -label LOW -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/regLow
add wave -noupdate -color Goldenrod -label registerFile -radix hexadecimal -childformat {{/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(0) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(1) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(2) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(3) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(4) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(5) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(6) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(7) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(8) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(9) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(10) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(11) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(12) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(13) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(14) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(15) -radix hexadecimal}} -radixshowbase 0 -expand -subitemconfig {/r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(0) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(1) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(2) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(3) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(4) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(5) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(6) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(7) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(8) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(9) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(10) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(11) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(12) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(13) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(14) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile(15) {-color Goldenrod -height 15 -radix hexadecimal -radixshowbase 0}} /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/registerFile
add wave -noupdate -label rw /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/rw
add wave -noupdate -label {ce mem} /r8_crypto_tb/r8_crypto/R8_uC/ce_mem
add wave -noupdate -label {ce io} /r8_crypto_tb/r8_crypto/R8_uC/ce_io
add wave -noupdate -divider Interruption
add wave -noupdate -color Magenta -label Request /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/intr
add wave -noupdate -color Wheat -label Status /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/InterruptionStatus
add wave -noupdate -divider {memory interface}
add wave -noupdate -label data_in_r8 -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/data_in
add wave -noupdate -label data_out_r8 -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/data_out
add wave -noupdate -label address -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PROCESSOR/address
add wave -noupdate -divider PIC
add wave -noupdate -label highPriorityRequest -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PIC/highPriorityReq
add wave -noupdate -label address -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PIC/address
add wave -noupdate -label data -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PIC/data
add wave -noupdate -label {ce PIC} /r8_crypto_tb/r8_crypto/R8_uC/ce_PIC
add wave -noupdate -label wr /r8_crypto_tb/r8_crypto/R8_uC/PIC/wr
add wave -noupdate -label {irq reg} -radix hexadecimal -childformat {{/r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(7) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(6) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(5) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(4) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(3) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(2) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(1) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(0) -radix hexadecimal}} -radixshowbase 0 -subitemconfig {/r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(7) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(6) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(5) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(4) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(3) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(2) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(1) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg(0) {-radix hexadecimal -radixshowbase 0}} /r8_crypto_tb/r8_crypto/R8_uC/PIC/irq_reg
add wave -noupdate -label mask -radix hexadecimal -childformat {{/r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(7) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(6) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(5) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(4) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(3) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(2) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(1) -radix hexadecimal} {/r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(0) -radix hexadecimal}} -radixshowbase 0 -subitemconfig {/r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(7) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(6) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(5) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(4) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(3) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(2) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(1) {-radix hexadecimal -radixshowbase 0} /r8_crypto_tb/r8_crypto/R8_uC/PIC/mask(0) {-radix hexadecimal -radixshowbase 0}} /r8_crypto_tb/r8_crypto/R8_uC/PIC/mask
add wave -noupdate -divider portA
add wave -noupdate -label rw /r8_crypto_tb/r8_crypto/R8_uC/PORT_A/wr
add wave -noupdate -label {ce portA} /r8_crypto_tb/r8_crypto/R8_uC/ce_portA
add wave -noupdate -label PortData -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PORT_A/PortData
add wave -noupdate -label PortConfig -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PORT_A/PortConfig
add wave -noupdate -label PortEnable -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PORT_A/PortEnable
add wave -noupdate -label PortIrqEnable -radix hexadecimal -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/PORT_A/PortIrqEnable
add wave -noupdate -divider Cryptos
add wave -noupdate -label op /r8_crypto_tb/r8_crypto/op
add wave -noupdate -label id /r8_crypto_tb/r8_crypto/id
add wave -noupdate -label ack /r8_crypto_tb/r8_crypto/ack
add wave -noupdate -divider {Crypto 0}
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/rst
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/ack
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/data_in
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/data_out
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/data_av
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/keyExchange
add wave -noupdate -format Event /r8_crypto_tb/r8_crypto/Crypto0/eom
add wave -noupdate -divider {Crypto 1}
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/rst
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/ack
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/data_in
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/data_out
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/data_av
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/keyExchange
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto1/eom
add wave -noupdate -divider {Crypto 2}
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/rst
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/ack
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/data_in
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/data_out
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/data_av
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/keyExchange
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto2/eom
add wave -noupdate -divider {Crypto 3}
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/rst
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/ack
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/data_in
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/data_out
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/data_av
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/keyExchange
add wave -noupdate /r8_crypto_tb/r8_crypto/Crypto3/eom
add wave -noupdate -divider {MSG 0}
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1071)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1072)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1073)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1074)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1075)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1076)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1077)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1078)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1079)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1080)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1081)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1082)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1083)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1084)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1085)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1086)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1087)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1088)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1089)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1090)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1091)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1092)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1093)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1094)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1095)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1096)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1097)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1098)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1099)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1100)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1101)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1102)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1103)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1104)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1105)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1106)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1107)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1108)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1109)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1110)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1111)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1112)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1113)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1114)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1115)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1116)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1117)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1118)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1119)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1120)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1121)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1122)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1123)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1124)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1125)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1126)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1127)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1128)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1129)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1130)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1131)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1132)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1133)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1134)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1135)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1136)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1137)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1138)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1139)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1140)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1141)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1142)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1143)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1144)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1145)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1146)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1147)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1148)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1149)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1150)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1151)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1152)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1153)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1154)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1155)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1156)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1157)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1158)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1159)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1160)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1161)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1162)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1163)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1164)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1165)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1166)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1167)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1168)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1169)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1170)
add wave -noupdate -divider msg1
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1171)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1172)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1173)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1174)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1175)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1176)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1177)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1178)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1179)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1180)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1181)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1182)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1183)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1184)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1185)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1186)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1187)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1188)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1189)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1190)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1191)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1192)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1193)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1194)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1195)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1196)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1197)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1198)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1199)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1200)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1201)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1202)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1203)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1204)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1205)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1206)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1207)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1208)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1209)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1210)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1211)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1212)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1213)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1214)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1215)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1216)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1217)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1218)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1219)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1220)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1221)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1222)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1223)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1224)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1225)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1226)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1227)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1228)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1229)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1230)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1231)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1232)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1233)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1234)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1235)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1236)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1237)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1238)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1239)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1240)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1241)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1242)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1243)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1244)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1245)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1246)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1247)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1248)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1249)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1250)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1251)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1252)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1253)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1254)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1255)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1256)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1257)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1258)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1259)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1260)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1261)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1262)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1263)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1264)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1265)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1266)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1267)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1268)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1269)
add wave -noupdate -radix ascii -radixshowbase 0 /r8_crypto_tb/r8_crypto/R8_uC/RAM/RAM(1270)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2335818445 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 151
configure wave -valuecolwidth 65
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
WaveRestoreZoom {2335393511 ps} {2338666490 ps}
