# Load design from scratch
read_db /home/andrew/Documents/projects/ucsc/vlsi/and-tay/runs/RUN_2025-03-12_21-12-39/52-odb-cellfrequencytables/top.odb
read_liberty $env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_spef /home/andrew/Documents/projects/ucsc/vlsi/and-tay/runs/RUN_2025-03-12_21-12-39/53-openroad-rcx/max/top.max.spef
read_sdc /home/andrew/Documents/projects/ucsc/vlsi/and-tay/base.sdc

# Set design constraints
set_propagated_clock [all_clocks]
set_dont_use sky130_fd_sc_hd__buf_1
set_dont_use sky130_fd_sc_hd__buf_2

# Step 1: Fix Hold Timing
repair_timing -hold -slack_margin 0.5 -max_buffer_percent 50

# Check hold violations
report_checks -path_delay min -group_count 5

# Save progress so we don't redo this in future runs
write_db /home/andrew/Documents/projects/ucsc/vlsi/and-tay/runs/RUN_2025-03-12_21-12-39/hold_fixed.odb
