# run the tcl script: do cic_tsb.tcl 
# CIC con precisión completa
vlog -work work -refresh -force_refresh
# List of files in order from bottom to top
set sv_files {../src/bcom_conf_fsms_main.sv
              ../src/bcom_conf_fsms_wr.sv
              ../src/bcom_conf_fsms_rd.sv
              ../src/bcom_conf_fsms.sv
              ../src/bcom_conf_regs.sv
			  ../src/bcom_conf.sv
			  ../tsb/bcom_conf_tsb.sv}
# Compile all files
foreach sv_file $sv_files {
    vlog $sv_file
}
# Invoke simulator
vsim work.bcom_conf_tsb
# Open the wave editor 
do ./do/bcom_conf_tsb.do
# Run simulation 
run -all
