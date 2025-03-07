onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate /dp_mod_tsb/load_data
add wave -noupdate -color Salmon /dp_mod_tsb/in_sample_cnt
add wave -noupdate /dp_mod_tsb/clk
add wave -noupdate /dp_mod_tsb/UUT/b0_multiplicand_mux_r
add wave -noupdate -divider {Entrada a DDS}
add wave -noupdate /dp_mod_tsb/UUT/dds/id_p_ac
add wave -noupdate /dp_mod_tsb/UUT/dds/ic_rst_ac
add wave -noupdate /dp_mod_tsb/UUT/dds/ic_en_ac
add wave -noupdate /dp_mod_tsb/UUT/dds/ic_val_data
add wave -noupdate -divider {Salida datapath}
add wave -noupdate /dp_mod_tsb/UUT/od_data
add wave -noupdate /dp_mod_tsb/UUT/oc_val_data
add wave -noupdate -divider {Comparacion M con F}
add wave -noupdate -color Orange -format Analog-Step -height 74 -max 32744.0 -min -32767.0 /dp_mod_tsb/wave_M
add wave -noupdate -color Cyan -format Analog-Step -height 74 -max 32744.0 -min -32767.0 /dp_mod_tsb/wave_F
add wave -noupdate -divider {Monitorizacion de errores}
add wave -noupdate /dp_mod_tsb/error_cnt
add wave -noupdate -color Coral /dp_mod_tsb/out_sample_cnt
add wave -noupdate /dp_mod_tsb/end_sim
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {206471000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 269
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
WaveRestoreZoom {0 ps} {403442550 ps}
