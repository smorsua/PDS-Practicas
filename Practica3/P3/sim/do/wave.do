onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate -color Orange /cic_tsb/clk
add wave -noupdate -color Orange /cic_tsb/rst_ac
add wave -noupdate -color Orange /cic_tsb/in_sample_cnt
add wave -noupdate -divider {Entrada al CIC}
add wave -noupdate /cic_tsb/UUT/id_data
add wave -noupdate /cic_tsb/UUT/ic_val_data
add wave -noupdate /cic_tsb/UUT/ic_rst
add wave -noupdate /cic_tsb/UUT/clk
add wave -noupdate -divider {Salida del CIC}
add wave -noupdate -color Blue /cic_tsb/UUT/od_data
add wave -noupdate -color Blue /cic_tsb/UUT/oc_val_data
add wave -noupdate -divider {Comparacion _M con _F}
add wave -noupdate -format Analog-Step -height 74 -max 37.0 -min -38.0 /cic_tsb/o_data_M
add wave -noupdate -format Analog-Step -height 74 -max 37.0 -min -38.0 /cic_tsb/o_data_F
add wave -noupdate -divider Errores
add wave -noupdate -color Red /cic_tsb/out_sample_cnt
add wave -noupdate -color Red /cic_tsb/error_cnt
add wave -noupdate -color Red /cic_tsb/end_sim
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11906504 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {504325500 ps}
