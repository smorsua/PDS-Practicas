# run the tcl script: do cic_tsb.tcl
vlog -work work -refresh -force_refresh
# List of files in order from bottom to top
set sv_files {../src/comp_cic_control.sv 
			  ../src/comp_cic_mac.sv 
			  ../src/comp_cic_reg_desp.sv 
			  ../src/comp_cic_rom.sv 
			  ../src/comp_cic_pc.sv 
			  ../src/comp_cic.sv 
			  ../tsb/comp_cic_tsb_pkg.sv 
			  ../tsb/comp_cic_tsb.sv}
# Compile all files
foreach sv_file $sv_files {
    vlog $sv_file
}
# Invoke simulator
vsim work.comp_cic_tsb
# Open the wave editor 
do ./do/wave.do
# Run simulation 
run -all
