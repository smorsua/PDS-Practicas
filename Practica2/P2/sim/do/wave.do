onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dp_mod_tsb/UUT/b0_multiplicand_mux_r
add wave -noupdate /dp_mod_tsb/UUT/id_data
add wave -noupdate -radix decimal /dp_mod_tsb/UUT/id_frec_por
add wave -noupdate /dp_mod_tsb/UUT/b0_sum_res_r
add wave -noupdate /dp_mod_tsb/UUT/b3_mult_res
add wave -noupdate /dp_mod_tsb/UUT/b2_sine_s
add wave -noupdate -format Analog-Step -height 74 -max 32767.0 -min -32767.0 /dp_mod_tsb/wave_M
add wave -noupdate -format Analog-Step -height 74 -max 32767.0 -min -32767.0 /dp_mod_tsb/wave_F
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {169497 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 330
configure wave -valuecolwidth 83
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
WaveRestoreZoom {192480578 ps} {394323128 ps}
