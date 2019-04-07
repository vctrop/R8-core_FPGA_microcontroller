onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider top
add wave -noupdate /r8_bram_tb/clk
add wave -noupdate /r8_bram_tb/rst
add wave -noupdate /r8_bram_tb/display_enable
add wave -noupdate /r8_bram_tb/display_data
add wave -noupdate -divider R8_BRAM
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/board_clock
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/board_rst
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/display_en_n
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/display_data
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/clk
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/clk_mem
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/clk_div4
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/rw
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/ce
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/rst
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/ce_mem
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/ce_regDisp
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/rw_n
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/dataR8
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/dataBus
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/addressR8
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/regDisp
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/display0
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/display1
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/display2
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/display3
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/num3
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/num2
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/num1
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/num0
add wave -noupdate -divider RAM
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/RAM/clk
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/RAM/wr
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/RAM/en
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/RAM/address
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/RAM/data_in
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/RAM/data_out
add wave -noupdate /r8_bram_tb/R8_BRAM_BLOCK/RAM/RAM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {314 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 291
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
WaveRestoreZoom {0 ps} {879 ps}
