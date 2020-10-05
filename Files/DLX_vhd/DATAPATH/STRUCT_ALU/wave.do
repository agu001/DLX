onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix decimal /tb/data1
add wave -noupdate -format Literal -radix decimal /tb/data2
add wave -noupdate -format Literal -radix unsigned /tb/data1
add wave -noupdate -format Literal -radix unsigned /tb/data2
add wave -noupdate -format Literal -radix hexadecimal /tb/data1
add wave -noupdate -format Literal -radix hexadecimal /tb/data2
add wave -noupdate -format Logic /tb/se_ctrl_in
add wave -noupdate -format Literal /tb/type_op
add wave -noupdate -format Literal -radix decimal /tb/outalu
add wave -noupdate -format Literal -radix unsigned /tb/outalu
add wave -noupdate -format Literal -radix hexadecimal /tb/outalu
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27000 ps} 0}
configure wave -namecolwidth 150
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
WaveRestoreZoom {750 ps} {53250 ps}
