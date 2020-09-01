onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /tb/dut/cpu/dp/controls
add wave -noupdate -format Literal /tb/dut/cpu/dp/alu_operation
add wave -noupdate -format Literal /tb/dut/cpu/dp/dram_addr
add wave -noupdate -format Literal /tb/dut/cpu/dp/dram_data_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/dram_data_in
add wave -noupdate -format Logic /tb/dut/cpu/dp/dram_rd
add wave -noupdate -format Logic /tb/dut/cpu/dp/dram_wr
add wave -noupdate -format Logic /tb/dut/cpu/dp/dram_en
add wave -noupdate -format Literal /tb/dut/cpu/dp/iram_addr
add wave -noupdate -format Literal /tb/dut/cpu/dp/iram_in
add wave -noupdate -format Literal /tb/dut/cpu/dp/opcode_to_cu
add wave -noupdate -format Literal /tb/dut/cpu/dp/func_to_cu
add wave -noupdate -format Logic /tb/dut/cpu/dp/clk
add wave -noupdate -format Logic /tb/dut/cpu/dp/rst
add wave -noupdate -format Literal /tb/dut/cpu/dp/rfout1
add wave -noupdate -format Literal /tb/dut/cpu/dp/rfout2
add wave -noupdate -format Literal /tb/dut/cpu/dp/s3_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/a_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/b_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/s2_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/alu_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/alu_out_reg1
add wave -noupdate -format Literal /tb/dut/cpu/dp/alu_out_reg2
add wave -noupdate -format Literal /tb/dut/cpu/dp/memory_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/memory_out_reg1
add wave -noupdate -format Literal /tb/dut/cpu/dp/me_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/pc_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/npc
add wave -noupdate -format Literal /tb/dut/cpu/dp/ir_r_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/sign_ext_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/relative_address
add wave -noupdate -format Literal /tb/dut/cpu/dp/pc_in
add wave -noupdate -format Literal /tb/dut/cpu/dp/address_to_jump
add wave -noupdate -format Literal /tb/dut/cpu/dp/npc_reg1_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/npc_reg2_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/npc_reg3_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/mux_to_pc_2_to_1
add wave -noupdate -format Literal /tb/dut/cpu/dp/mux_to_ir
add wave -noupdate -format Literal /tb/dut/cpu/dp/imm32_out
add wave -noupdate -format Logic /tb/dut/cpu/dp/en1
add wave -noupdate -format Logic /tb/dut/cpu/dp/s2
add wave -noupdate -format Logic /tb/dut/cpu/dp/en2
add wave -noupdate -format Logic /tb/dut/cpu/dp/isjump
add wave -noupdate -format Logic /tb/dut/cpu/dp/isbranch
add wave -noupdate -format Logic /tb/dut/cpu/dp/isbeqz
add wave -noupdate -format Logic /tb/dut/cpu/dp/rm
add wave -noupdate -format Logic /tb/dut/cpu/dp/wm
add wave -noupdate -format Logic /tb/dut/cpu/dp/en3
add wave -noupdate -format Logic /tb/dut/cpu/dp/s3
add wave -noupdate -format Logic /tb/dut/cpu/dp/wf1
add wave -noupdate -format Logic /tb/dut/cpu/dp/se_ctrl
add wave -noupdate -format Literal /tb/dut/cpu/dp/rs1
add wave -noupdate -format Literal /tb/dut/cpu/dp/rs2
add wave -noupdate -format Literal /tb/dut/cpu/dp/rd1_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/rd2_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/rd3_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/rs1_r_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/rs2_r_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/aluctrl
add wave -noupdate -format Literal /tb/dut/cpu/dp/aluctrlint
add wave -noupdate -format Literal /tb/dut/cpu/dp/aluctrlbits1
add wave -noupdate -format Literal /tb/dut/cpu/dp/aluctrlbits2
add wave -noupdate -format Literal /tb/dut/cpu/dp/cwregex
add wave -noupdate -format Literal /tb/dut/cpu/dp/cwregmw
add wave -noupdate -format Literal /tb/dut/cpu/dp/inp2
add wave -noupdate -format Literal /tb/dut/cpu/dp/cwregwr
add wave -noupdate -format Literal /tb/dut/cpu/dp/cwregwr_temp
add wave -noupdate -format Literal /tb/dut/cpu/dp/rd_rtype_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/rd_itype_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/s_rd_out
add wave -noupdate -format Logic /tb/dut/cpu/dp/i0_r1_sel
add wave -noupdate -format Logic /tb/dut/cpu/dp/jal_sel
add wave -noupdate -format Logic /tb/dut/cpu/dp/zero_result
add wave -noupdate -format Logic /tb/dut/cpu/dp/zero_reg_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/mux_fw1_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/mux_fw2_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/fu_out
add wave -noupdate -format Logic /tb/dut/cpu/dp/branch_taken
add wave -noupdate -format Logic /tb/dut/cpu/dp/branch_taken1
add wave -noupdate -format Logic /tb/dut/cpu/dp/fu_ctrl1
add wave -noupdate -format Logic /tb/dut/cpu/dp/fu_ctrl2
add wave -noupdate -format Logic /tb/dut/cpu/dp/pcwrite
add wave -noupdate -format Logic /tb/dut/cpu/dp/irwrite
add wave -noupdate -format Logic /tb/dut/cpu/dp/mux_ctrl
add wave -noupdate -format Literal /tb/dut/cpu/dp/controls_out
add wave -noupdate -format Literal -expand /tb/dut/memory/memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 350
configure wave -valuecolwidth 40
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {65310 ps}
