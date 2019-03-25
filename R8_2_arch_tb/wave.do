onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /r8_tb/processor/clk
add wave -noupdate -format Literal /r8_tb/processor/control_path/currentstate
add wave -noupdate -format Literal /r8_tb/processor/control_path/decodedinstruction
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/processor/instruction
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/processor/data_in
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/processor/data_out
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/processor/address
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/processor/uins
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/processor/data_path/ra
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/processor/data_path/rb
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/processor/data_path/ralu
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/processor/flag
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/processor/data_path/register_file/reg
add wave -noupdate -format Literal -radix decimal /r8_tb/processor/data_path/sp
add wave -noupdate -format Logic -radix hexadecimal /r8_tb/processor/rw
add wave -noupdate -format Logic -radix hexadecimal /r8_tb/processor/ce
add wave -noupdate -divider memory
add wave -noupdate -format Logic -radix hexadecimal /r8_tb/ram/ce_n
add wave -noupdate -format Logic -radix hexadecimal /r8_tb/ram/we_n
add wave -noupdate -format Logic -radix hexadecimal /r8_tb/ram/oe_n
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/ram/address
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/ram/data
add wave -noupdate -format Literal -radix hexadecimal /r8_tb/ram/memoryarray
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {126 ns} 0} {{Cursor 2} {1250 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
configure wave -timelineunits ns
update
WaveRestoreZoom {35 ns} {287 ns}
