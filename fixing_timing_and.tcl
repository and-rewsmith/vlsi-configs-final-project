# Load design data
read_db /home/andrew/Documents/projects/ucsc/vlsi/and-tay/runs/baseline/52-odb-cellfrequencytables/top.odb
read_liberty $env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_spef /home/andrew/Documents/projects/ucsc/vlsi/and-tay/runs/baseline/53-openroad-rcx/max/top.max.spef
read_sdc /home/andrew/Documents/projects/ucsc/vlsi/and-tay/base.sdc

# Set design constraints
set_propagated_clock [all_clocks]
set_dont_use sky130_fd_sc_hd__buf_1
set_dont_use sky130_fd_sc_hd__buf_2

# Fix slew and capacitance violations
repair_design -slew_margin 0.3 -cap_margin 0.3 -max_wire_length 40

# Check violations
report_check_types -max_slew -violators
report_check_types -max_capacitance -violators