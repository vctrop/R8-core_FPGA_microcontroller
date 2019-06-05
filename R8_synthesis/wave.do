onerror {resume}
quietly virtual signal -install /r8_uc_tb/R8_uC/RAM { (context /r8_uc_tb/R8_uC/RAM )(RAM(150) &RAM(151) &RAM(152) &RAM(153) &RAM(154) &RAM(155) &RAM(156) )} string
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider R8
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/clk
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/rst
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/currentState
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/decodedInstruction
add wave -noupdate -expand /r8_uc_tb/R8_uC/PROCESSOR/registerFile
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/data_in
add wave -noupdate /r8_uc_tb/R8_uC/PROCESSOR/data_out
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
add wave -noupdate -divider Tx
add wave -noupdate -radix ascii -radixshowbase 0 /r8_uc_tb/R8_uC/data_TX
add wave -noupdate /r8_uc_tb/R8_uC/TX_av
add wave -noupdate -divider Rx
add wave -noupdate -radix ascii -radixshowbase 0 /r8_uc_tb/R8_uC/data_RX
add wave -noupdate /r8_uc_tb/R8_uC/RX_av
add wave -noupdate /r8_uc_tb/R8_uC/RX_av_latch
add wave -noupdate -divider memory
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1147)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1148)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1149)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1150)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1151)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1152)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1153)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1154)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1155)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1156)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1157)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1158)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1159)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1160)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1161)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1162)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1163)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1164)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1165)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1166)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1167)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1168)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1169)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1170)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1171)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1172)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1173)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1174)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1175)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1176)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1177)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1178)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1179)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1180)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1181)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1182)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1183)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1184)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1185)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1186)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1187)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1188)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1189)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1190)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1191)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1192)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1193)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1194)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1195)
add wave -noupdate -radix decimal -radixshowbase 0 /r8_uc_tb/R8_uC/RAM/RAM(1196)
add wave -noupdate /r8_uc_tb/R8_uC/RAM/RAM(1197)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4948904164 ps} 0}
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
WaveRestoreZoom {4901595904 ps} {5078502144 ps}
