onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb/dut/cpu/dp/hdu_pc_en
add wave -noupdate -format Logic /tb/dut/cpu/dp/hdu_ir_en
add wave -noupdate -format Logic /tb/dut/clk
add wave -noupdate -format Logic /tb/dut/rst
add wave -noupdate -format Logic /tb/dut/cpu/dp/branch_predict/predict_taken
add wave -noupdate -format Literal /tb/dut/cpu/dp/branch_predict/target_out
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/pc_in
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/pc_out
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/npc
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/iram_addr
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/cpu/dp/iram_in
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/cpu/dp/ir_dec
add wave -noupdate -format Logic /tb/dut/cpu/dp/hdu_mux_sel
add wave -noupdate -format Logic /tb/dut/cpu/dp/flush
add wave -noupdate -format Literal /tb/dut/cpu/dp/opcode_to_cu
add wave -noupdate -format Literal /tb/dut/cpu/dp/func_to_cu
add wave -noupdate -format Literal /tb/dut/cpu/dp/cw_active
add wave -noupdate -format Literal -radix unsigned /tb/dut/cpu/dp/rs1
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/cpu/dp/rf/registers
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/rfout1
add wave -noupdate -format Literal -radix unsigned /tb/dut/cpu/dp/rs2
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/rfout2
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/rel_addr
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/a_out
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/b_out
add wave -noupdate -format Logic -radix decimal /tb/dut/cpu/dp/fu_ctrl1
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/cpu/dp/fu_out_s1
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/cpu/dp/mux_fw1_out
add wave -noupdate -format Logic -radix decimal /tb/dut/cpu/dp/fu_ctrl2
add wave -noupdate -format Literal /tb/dut/cpu/dp/fu_out_s2
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/mux_fw2_out
add wave -noupdate -format Logic /tb/dut/cpu/dp/se_ctrl
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/cpu/dp/imm32
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/cpu/dp/imm32_out
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/cpu/dp/bj_addr
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/s2_out
add wave -noupdate -format Literal /tb/dut/cpu/dp/aluctrl
add wave -noupdate -format Logic /tb/dut/cpu/dp/zero_result
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/me_out
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/dram_addr
add wave -noupdate -format Literal /tb/dut/dram_size
add wave -noupdate -format Logic /tb/dut/clk
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/dram_data_out
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/dram_data_in
add wave -noupdate -format Literal -radix decimal /tb/dut/cpu/dp/memory_out
add wave -noupdate -format Logic /tb/dut/cpu/dp/s2
add wave -noupdate -format Logic /tb/dut/cpu/dp/isjump
add wave -noupdate -format Logic /tb/dut/cpu/dp/isbranch
add wave -noupdate -format Logic /tb/dut/cpu/dp/isbeqz
add wave -noupdate -format Logic /tb/dut/cpu/dp/rm
add wave -noupdate -format Logic /tb/dut/cpu/dp/wm
add wave -noupdate -format Logic /tb/dut/cpu/dp/s3
add wave -noupdate -format Logic /tb/dut/cpu/dp/wf1
add wave -noupdate -format Logic /tb/dut/cpu/dp/se_ctrl
add wave -noupdate -format Logic /tb/dut/cpu/dp/i0_r1_sel
add wave -noupdate -format Logic /tb/dut/cpu/dp/jal_sel
add wave -noupdate -format Logic /tb/dut/cpu/dp/branch_taken
add wave -noupdate -format Literal /tb/dut/dmemory/memory
add wave -noupdate -format Literal /tb/dut/cpu/dp/dram_sign_ext/datain
add wave -noupdate -format Literal /tb/dut/cpu/dp/dram_sign_ext/dataout
add wave -noupdate -format Literal /tb/dut/cpu/dp/dram_sign_ext/int_msize
add wave -noupdate -format Literal /tb/dut/cpu/dp/dram_sign_ext/msize
add wave -noupdate -format Logic /tb/dut/cpu/dp/dram_sign_ext/se_ctrl
add wave -noupdate -format Logic /tb/dut/cpu/dp/branch_predict/branch_was_taken
add wave -noupdate -format Logic /tb/dut/cpu/dp/branch_predict/clk
add wave -noupdate -format Literal /tb/dut/cpu/dp/branch_predict/index_exe
add wave -noupdate -format Literal /tb/dut/cpu/dp/branch_predict/index_fetch
add wave -noupdate -format Logic /tb/dut/cpu/dp/branch_predict/isbranch
add wave -noupdate -format Literal /tb/dut/cpu/dp/branch_predict/pc_from_exe
add wave -noupdate -format Literal /tb/dut/cpu/dp/branch_predict/pc_from_fetch
add wave -noupdate -format Literal -radix unsigned /tb/dut/cpu/dp/branch_predict/pc_mem
add wave -noupdate -format Literal /tb/dut/cpu/dp/branch_predict/predict_mem
add wave -noupdate -format Logic /tb/dut/cpu/dp/branch_predict/rst
add wave -noupdate -format Literal /tb/dut/cpu/dp/branch_predict/target_mem
add wave -noupdate -format Literal /tb/dut/cpu/dp/branch_predict/target_to_save
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {63930 ps} 0}
configure wave -namecolwidth 267
configure wave -valuecolwidth 124
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
WaveRestoreZoom {710 ps} {23920 ps}
