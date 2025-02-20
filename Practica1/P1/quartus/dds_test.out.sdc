## Generated SDC file "dds_test.out.sdc"

## Copyright (C) 2017  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 17.1.1 Internal Build 593 12/11/2017 SJ Standard Edition"

## DATE    "Fri Feb 14 18:41:32 2025"

##
## DEVICE  "5CGXFC7C7F23C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clock_m} -period 8.000 -waveform { 0.000 4.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clock_m}] -rise_to [get_clocks {clock_m}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {clock_m}] -rise_to [get_clocks {clock_m}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {clock_m}] -fall_to [get_clocks {clock_m}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {clock_m}] -fall_to [get_clocks {clock_m}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {clock_m}] -rise_to [get_clocks {clock_m}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {clock_m}] -rise_to [get_clocks {clock_m}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {clock_m}] -fall_to [get_clocks {clock_m}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {clock_m}] -fall_to [get_clocks {clock_m}] -hold 0.060  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

