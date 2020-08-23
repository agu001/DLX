onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/dram_out
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/dram_addr
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/dram_in
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/rd_mem
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/wr_mem
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/en_mem
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/iram_addr
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/inp1
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/in1_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/in2_out
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/rs1
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/rs2
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/rd
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/rd_r_out
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/rd1_out
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/rd2_out
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/clk
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/rst
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/iram_in
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/pc_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/adder_out
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/ir_r_out
add wave -noupdate -format Literal -radix binary /cu_test/dut/cpu/data_path/controls
add wave -noupdate -format Literal -radix binary /cu_test/dut/cpu/data_path/cwregex
add wave -noupdate -format Literal -radix binary /cu_test/dut/cpu/data_path/cwregmw
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/rfout1
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/rfout2
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/s3_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/a_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/b_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/s1_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/s2_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/alu_op_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/alu_out_reg
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/memory_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/me_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/out_reg_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/rf/registers
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/s1
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/s2
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/alu1
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/alu2
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/en2
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/rm
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/wm
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/en3
add wave -noupdate -format Logic -radix hexadecimal /cu_test/dut/cpu/data_path/s3
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/func_op
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/type_alu
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/memory/x
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/memory/a
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/memory/memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8830 ps} 0}
configure wave -namecolwidth 319
configure wave -valuecolwidth 95
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
WaveRestoreZoom {140 ps} {15810 ps}
