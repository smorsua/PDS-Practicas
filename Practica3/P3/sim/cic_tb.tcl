# run the tcl script: do cic_tsb.tcl
vlog -work work -refresh -force_refresh
# List of files in order from bottom to top
set sv_files {../src/cic_comb.sv 
			  ../src/cic_int.sv 
			  ../src/cic_expander.sv 
			  ../src/cic_pc.sv 
			  ../src/cic.sv 
			  ../tsb/cic_tsb_pkg.sv 
			  ../tsb/cic_tsb.sv}
# Compile all files
foreach sv_file $sv_files {
    vlog $sv_file
}
# Invoke simulator
vsim work.cic_tsb
# Open the wave editor 
do ./do/wave.do
# Run simulation 
run -all
