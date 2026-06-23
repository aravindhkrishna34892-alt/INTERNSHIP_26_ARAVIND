########### SDC CONSTRAINTS ####################
####### PARAMETERS ########
set_units -time 1.0ns;
set_units -capacitance 1.0pF;
set CLOCK_PERIOD 30;
set CLOCK_NAME counter_clk;
set SKEW_setup 1.0;
set SKEW_hold 0.5;
set MINRISE 0.2;
set MAXRISE 1.0;
set MIN_PORT 0.5;
set MAX_PORT 2.0;
####### CLOCK CONSTRAINTS ########
create_clock -name counter_clk -period 30 -waveform {0 15} [get_ports clk_pad]
####### CLOCK SOURCE LATENCY ########
set_clock_latency -source -max 3.00 -late [get_clocks counter_clk]
set_clock_latency -source -min 1.00 -late [get_clocks counter_clk]
set_clock_latency -source -max 3.00 -early [get_clocks counter_clk]
set_clock_latency -source -min 1.00 -early [get_clocks counter_clk]
####### CLOCK TRANSITION ########
set_clock_transition -rise -min $MINRISE [get_clocks counter_clk]
set_clock_transition -rise -max $MAXRISE [get_clocks counter_clk]
set_clock_transition -fall -min $MINRISE [get_clocks counter_clk]
set_clock_transition -fall -max $MAXRISE [get_clocks counter_clk]
####### CLOCK UNCERTAINITY ########
set_clock_uncertainty -setup $SKEW_setup [get_clocks counter_clk]
set_clock_uncertainty -hold $SKEW_hold [get_clocks counter_clk]
####### INPUT TRANSITION ########
set_input_transition -max $MAX_PORT [get_ports -filter "direction == in && name !=clk_pad"]
set_input_transition -min $MIN_PORT [get_ports -filter "direction == in && name != clk_pad"]
####### VIRTUAL CLOCK ########
create_clock -name vir_main_clk -period 30####### INPUT DELAYS RELATIVE TO VIRTUAL CLOCK ########
set_input_delay -clock vir_main_clk -min 2 [get_ports -filter "direction == in && name !=clk_pad"]
set_input_delay -clock vir_main_clk -max 4 [get_ports -filter "direction == in && name !=clk_pad"]
####### OUTPUT DELAYS RELATIVE TO VIRTUAL CLOCK ########
set_output_delay -clock vir_main_clk -min 2 [get_ports -filter "direction == out"]
set_output_delay -clock vir_main_clk -max 4 [get_ports -filter "direction == out"]
####### LOAD SPECIFICATIONS ########
set_load 0.05 [all_outputs]
########## FALSE PATHS ###########
set_false_path -from [get_ports rst_pad] -to [all_registers]
########## GROUP PATHS #########
group_path -name I2R -from [all_inputs] -to [all_registers]
group_path -name R2O -from [all_registers] -to [all_outputs]
group_path -name R2R -from [all_registers] -to [all_registers]
group_path -name I2O -from [all_inputs] -to [all_outputs]
########### END of Constraints file###################
