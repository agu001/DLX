onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix hexadecimal /tb/datain
add wave -noupdate -format Literal /tb/shift
add wave -noupdate -format Literal /tb/conf
add wave -noupdate -format Literal -radix hexadecimal /tb/dataout
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mux1_out_in1
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mux1_out_in2
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mux1_out_in3
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mux1_out_in4
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mask_out
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mux2_out_in1
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mux2_out_in2
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mux2_out_in3
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mux2_out_in4
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mux2_out_in5
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mux2_out_in6
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mux2_out_in7
add wave -noupdate -format Literal -radix hexadecimal /tb/dut/mux2_out_in8
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {540 ps} 0}
configure wave -namecolwidth 183
configure wave -valuecolwidth 113
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
WaveRestoreZoom {0 ps} {10500 ps}
