onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color {Dark Green} -itemcolor Gray20 -label clk /bcom_conf_tsb/clk
add wave -noupdate -color {Dark Green} -itemcolor Gray20 -label rst /bcom_conf_tsb/rst
add wave -noupdate -divider TX-RX
add wave -noupdate -color {Steel Blue} -itemcolor Gray20 -label rxdw -radix hexadecimal /bcom_conf_tsb/rxdw
add wave -noupdate -color {Steel Blue} -itemcolor Gray20 -label rxrdy /bcom_conf_tsb/rxrdy
add wave -noupdate -color Coral -itemcolor Gray20 -label txbusy /bcom_conf_tsb/txbusy
add wave -noupdate -color Coral -itemcolor Gray20 -label txdw -radix hexadecimal /bcom_conf_tsb/txdw
add wave -noupdate -color Coral -itemcolor Gray20 -label rxena /bcom_conf_tsb/txena
add wave -noupdate -divider {REG. CONF}
add wave -noupdate -color {Medium Orchid} -itemcolor Gray20 -label r_frec_mod -radix hexadecimal /bcom_conf_tsb/r_frec_mod
add wave -noupdate -color {Medium Orchid} -itemcolor Gray20 -label r_frec_por -radix hexadecimal /bcom_conf_tsb/r_frec_por
add wave -noupdate -color {Medium Orchid} -itemcolor Gray20 -label r_im_am -radix hexadecimal /bcom_conf_tsb/r_im_am
add wave -noupdate -color {Medium Orchid} -itemcolor Gray20 -label r_im_fm -radix hexadecimal /bcom_conf_tsb/r_im_fm
add wave -noupdate -color {Medium Orchid} -itemcolor Gray20 -label r_control -radix hexadecimal /bcom_conf_tsb/r_control
add wave -noupdate -divider DEPURACIÓN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5444 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 122
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
configure wave -timelineunits ps
update
WaveRestoreZoom {601 ps} {6301 ps}
