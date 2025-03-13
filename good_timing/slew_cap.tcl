# Restore design from hold-fixed state
read_db /home/andrew/Documents/projects/ucsc/vlsi/and-tay/runs/RUN_2025-03-12_21-12-39/hold_fixed.odb

# Set constraints again
set_propagated_clock [all_clocks]
set_dont_use sky130_fd_sc_hd__buf_1
set_dont_use sky130_fd_sc_hd__buf_2

# Step 2: Fix Slew and Capacitance
repair_design -slew_margin 0.3 -cap_margin 0.3 -max_wire_length 40

# Check violations
report_check_types -max_slew -violators
report_check_types -max_capacitance -violators

write_db /home/andrew/Documents/projects/ucsc/vlsi/and-tay/runs/RUN_2025-03-12_21-12-39/final_clean.odb

