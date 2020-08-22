onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix unsigned /cu_test/dut/data_path/rst
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/dram_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/dram_addr
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/dram_in
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/inp1
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/inp1_r_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/inp2
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/inp2_r_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/in1_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/in2_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/rs1
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/rs2
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/rd
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/rd_r_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/rd1_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/rd2_out
add wave -noupdate -format Literal -radix hexadecimal /cu_test/ir
add wave -noupdate -format Literal -radix binary /cu_test/dut/data_path/controls
add wave -noupdate -format Literal /cu_test/dut/data_path/cwregex
add wave -noupdate -format Literal /cu_test/dut/data_path/cwregmw
add wave -noupdate -format Logic -radix unsigned /cu_test/dut/data_path/clk
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/rfout1
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/rfout2
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/a_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/b_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/s1_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/s2_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/alu_op_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/alu_out_reg
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/memory_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/me_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/s3_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/out_reg_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/func_op
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/data_path/type_alu
add wave -noupdate -format Literal -radix unsigned -expand /cu_test/dut/data_path/rf/registers
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1370 ps} 0}
configure wave -namecolwidth 286
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
WaveRestoreZoom {0 ps} {26250 ps}
