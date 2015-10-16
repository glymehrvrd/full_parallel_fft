onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_partial_product/clk
add wave -noupdate /test_partial_product/rst
add wave -noupdate /test_partial_product/en
add wave -noupdate /test_partial_product/ctrl
add wave -noupdate /test_partial_product/d1_in
add wave -noupdate /test_partial_product/d2_in
add wave -noupdate /test_partial_product/ctrl_buff
add wave -noupdate /test_partial_product/d1_in_buff
add wave -noupdate /test_partial_product/pp_out
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/clk
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/rst
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/en
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/d1_in
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/d1_in_delay1
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/ctrl
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/adder_in1
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/d2_in
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/adder_in2
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/adder_c_in
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/c_out
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/c_buff
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/ctrl_delay1
add wave -noupdate -expand -group {New Group} /test_partial_product/uut/pp_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {261913 ps} 0}
configure wave -namecolwidth 256
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
configure wave -timelineunits ns
update
WaveRestoreZoom {183675 ps} {440540 ps}
