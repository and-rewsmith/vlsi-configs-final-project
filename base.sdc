current_design top

# Define clock
set clock_port clk_i
create_clock -name $clock_port -period 100 [get_ports $clock_port]

# Clock uncertainty and transition
# Example: 0.25 ns for setup, 0.05 ns for hold
set_clock_uncertainty 0.25 -setup [get_clocks $clock_port]
set_clock_uncertainty 0.01 -hold  [get_clocks $clock_port]
set_clock_transition 0.15 [get_clocks $clock_port]

# Properly exclude clock from input ports
set clock_input [get_port $clock_port]
set clk_indx [lsearch [all_inputs] $clock_input]
set all_inputs_wo_clk [lreplace [all_inputs] $clk_indx $clk_indx ""]

# Input constraints (excluding clock)
set_input_delay -clock [get_clocks $clock_port] 2 $all_inputs_wo_clk
set_input_transition 0.05 $all_inputs_wo_clk

# Use specified driving cell for inputs
set_driving_cell -lib_cell sky130_fd_sc_hd__dfxtp_1 $all_inputs_wo_clk

# Clock input driving cell
# set_driving_cell -lib_cell sky130_fd_sc_hd__dfxtp_1 $clock_input

# Reset specific constraints
set_max_fanout 8 [get_ports rst_ni]
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_16 [get_ports rst_ni]
set_input_transition 0.05 [get_ports rst_ni]
set_input_delay -clock [get_clocks $clock_port] -max 2 [get_ports rst_ni]
set_input_delay -clock [get_clocks $clock_port] -min 1 [get_ports rst_ni]
set_multicycle_path -setup 2 -from [get_ports rst_ni]
set_multicycle_path -hold 1 -from [get_ports rst_ni]

# Output constraints
set_load -pin_load 0.006 [all_outputs]
set_output_delay -clock [get_clocks $clock_port] 2 [all_outputs]

# Design constraints
set_max_transition 0.5 [current_design]
set_max_capacitance 0.1 [current_design]