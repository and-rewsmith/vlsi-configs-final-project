# Define corners
define_corners fast typ slow

# Read liberty files for each corner
read_liberty -corner fast /Users/taylorkergan/.volare/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib
read_liberty -corner typ /Users/taylorkergan/.volare/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_liberty -corner slow /Users/taylorkergan/.volare/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib

# Read LEF files
read_lef /Users/taylorkergan/.volare/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
read_lef /Users/taylorkergan/.volare/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef

# Read netlist
read_verilog runs/RUN_2025-03-10_08-25-04/06-yosys-synthesis/top.nl.v

# Link design
link_design top

# Read constraints
read_sdc base.sdc

# Report timing for each corner with minimal details
puts "\n=== Fast Corner Summary ==="
# report_checks -path_delay min_max -format full_clock_expanded -corner fast -fields {slew cap input nets fanout}
report_checks -path_delay min -fields {slew cap input nets fanout} -format full_clock_expanded -group_count 5 -corner fast

puts "\n=== Typical Corner Summary ==="
# report_checks -path_delay min_max -format full_clock_expanded -corner typ -fields {slew cap input nets fanout}
report_checks -path_delay min -fields {slew cap input nets fanout} -format full_clock_expanded -group_count 5 -corner typ

puts "\n=== Slow Corner Summary ==="
# report_checks -path_delay min_max -format full_clock_expanded -corner slow -fields {slew cap input nets fanout}
report_checks -path_delay min -fields {slew cap input nets fanout} -format full_clock_expanded -group_count 5 -corner slow

exit