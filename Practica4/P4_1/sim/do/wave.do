onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate -color Aquamarine /comp_cic_tsb/load_data
add wave -noupdate -color Aquamarine /comp_cic_tsb/in_sample_cnt
add wave -noupdate -color Aquamarine /comp_cic_tsb/clk
add wave -noupdate -divider Entradas
add wave -noupdate /comp_cic_tsb/UUT/id_data_filter
add wave -noupdate /comp_cic_tsb/UUT/ic_val_data
add wave -noupdate /comp_cic_tsb/UUT/ic_rst
add wave -noupdate -divider Salidas
add wave -noupdate -color Gold /comp_cic_tsb/UUT/od_data_filter
add wave -noupdate -color Gold /comp_cic_tsb/UUT/oc_val_data
add wave -noupdate -divider {Comparacion M con F}
add wave -noupdate -format Analog-Step -height 74 -max 51600.000000000015 -min -59493.0 /comp_cic_tsb/o_data_M
add wave -noupdate -format Analog-Step -height 74 -max 51600.000000000015 -min -59493.0 /comp_cic_tsb/o_data_F
add wave -noupdate -divider Errores
add wave -noupdate -color {Orange Red} /comp_cic_tsb/out_sample_cnt
add wave -noupdate -color {Orange Red} /comp_cic_tsb/error_cnt
add wave -noupdate -color {Orange Red} /comp_cic_tsb/end_sim
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 219
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
WaveRestoreZoom {0 ps} {2037231 ns}
