onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/dram_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/dram_addr
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/dram_in
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/rd_mem
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/wr_mem
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/en_mem
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/iram_addr
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/iram_in
add wave -noupdate -format Literal -radix binary /cu_test/dut/cpu/data_path/controls
add wave -noupdate -format Literal -radix binary /cu_test/dut/cpu/data_path/cwregex
add wave -noupdate -format Literal -radix binary /cu_test/dut/cpu/data_path/cwregmw
add wave -noupdate -format Literal -radix binary /cu_test/dut/cpu/data_path/cwregwr
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/clk
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/rst
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/rfout1
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/rfout2
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/s3_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/a_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/b_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/s2_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/alu_op_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/alu_out_reg1
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/alu_out_reg2
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/memory_reg_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/memory_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/me_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/imm32_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/rf/registers
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/en1
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/s2
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/alu1
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/alu2
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/en2
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/rm
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/wm
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/en3
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/s3
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/wf1
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/en4
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/rd1_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/rd2_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/rd3_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/rs1_r_out
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/rs2_r_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/func_op
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/type_alu
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/pc_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/npc
add wave -noupdate -format Literal -radix hexadecimal /cu_test/dut/cpu/data_path/ir_r_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/sign_ext_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/relative_address
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/pc_in
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/address_to_jump
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/npc_reg1_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/npc_reg2_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/npc_reg3_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/mux_to_pc_2_to_1
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/inp2
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/rs1
add wave -noupdate -format Literal -radix unsigned /cu_test/dut/cpu/data_path/rs2
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/rd_rtype_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/rd_itype_out
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/isjump
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/isbranch
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/isbeqz
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/zero_result
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/zero_reg_out
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/branch_taken
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/mux_fw1_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/mux_fw2_out
add wave -noupdate -format Literal -radix decimal /cu_test/dut/cpu/data_path/fu_out
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/fu_ctrl1
add wave -noupdate -format Logic -radix decimal /cu_test/dut/cpu/data_path/fu_ctrl2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7180 ps} 0}
configure wave -namecolwidth 319
configure wave -valuecolwidth 311
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
WaveRestoreZoom {0 ps} {24040 ps}
