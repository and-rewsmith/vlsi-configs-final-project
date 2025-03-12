
read_db /Users/taylorkergan/Desktop/CSE222A/hw7/runs/baseline/52-odb-cellfrequencytables/top.odb
read_liberty $env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_spef /Users/taylorkergan/Desktop/CSE222A/hw7/runs/baseline/53-openroad-rcx/max/top.max.spef
read_sdc /Users/taylorkergan/Desktop/CSE222A/hw7/base.sdc

# Set design constraints
set_propagated_clock [all_clocks]
set_max_fanout 10 [current_design]
set_max_transition 0.75 [current_design]
set_max_capacitance 0.2 [current_design]

# Fix hold violations - much more aggressive
repair_timing -hold -slack_margin 2.0 -max_buffer_percent 100

# Fix setup violations
repair_timing -setup -slack_margin 0.1 -max_buffer_percent 50

# Fix slew/cap violations - much more aggressive
repair_design -slew_margin 0.5 -cap_margin 0.5

# Check if violations are fixed
report_checks -path_delay min -group_count 5
report_check_types -max_slew -violators
report_check_types -max_capacitance -violators

exit