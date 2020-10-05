onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix decimal /tb_comparator/dut2/a
add wave -noupdate -format Literal -radix decimal /tb_comparator/dut2/b
add wave -noupdate -format Literal -radix unsigned /tb_comparator/dut2/a
add wave -noupdate -format Literal -radix unsigned /tb_comparator/dut2/b
add wave -noupdate -format Literal -radix hexadecimal /tb_comparator/dut2/a
add wave -noupdate -format Literal -radix hexadecimal /tb_comparator/dut2/b
add wave -noupdate -format Logic /tb_comparator/dut2/cout
add wave -noupdate -format Literal -radix decimal /tb_comparator/dut/sum
add wave -noupdate -format Logic /tb_comparator/dut/z
add wave -noupdate -format Logic /tb_comparator/dut/e
add wave -noupdate -format Logic /tb_comparator/dut/ge
add wave -noupdate -format Logic /tb_comparator/dut/le
add wave -noupdate -format Logic /tb_comparator/dut/gt
add wave -noupdate -format Logic /tb_comparator/dut/lt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {73990 ps} 0}
configure wave -namecolwidth 282
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
WaveRestoreZoom {41390 ps} {93890 ps}
