module top (
	clk_i,
	rst_ni,
	test_en_i,
	hart_id_i,
	boot_addr_i,

	instr_req_o,
	instr_gnt_i,
	instr_rvalid_i,
	instr_addr_o,
	instr_rdata_i,
	instr_err_i,

	data_req_o,
	data_gnt_i,
	data_rvalid_i,
	data_we_o,
	data_be_o,
	data_addr_o,
	data_wdata_o,
	data_rdata_i,
	data_err_i,

	irq_software_i,
	irq_timer_i,
	irq_external_i,
	irq_fast_i,
	irq_nm_i,

	debug_req_i,
	fetch_enable_i,
	alert_minor_o,
	alert_major_o,
	core_sleep_o
);

input wire clk_i;
input wire rst_ni;
input wire test_en_i;
input wire [31:0] hart_id_i;
input wire [31:0] boot_addr_i;
output wire instr_req_o;
input wire instr_gnt_i;
input wire instr_rvalid_i;
output wire [31:0] instr_addr_o;
input wire [31:0] instr_rdata_i;
input wire instr_err_i;

output wire data_req_o;
input wire data_gnt_i;
input wire data_rvalid_i;
output wire data_we_o;
output wire [3:0] data_be_o;
output wire [31:0] data_addr_o;
output wire [31:0] data_wdata_o;
input wire [31:0] data_rdata_i;
input wire data_err_i;

input wire irq_software_i;
input wire irq_timer_i;
input wire irq_external_i;
input wire [14:0] irq_fast_i;
input wire irq_nm_i;

input wire debug_req_i;
input wire fetch_enable_i;
output wire alert_minor_o;
output wire alert_major_o;
output wire core_sleep_o;

wire [31:0] data_rdata;
wire [31:0] instr_rdata;
wire [31:0] data_rdata_sram;
wire [31:0] instr_rdata_sram;

wire [31:0] data_rdata_sram0;
wire [31:0] data_rdata_sram1;

wire [31:0] instr_rdata_sram0;
wire [31:0] instr_rdata_sram1;

wire web0, web1;
wire cs0_data, cs1_data, cs0_instr, cs1_instr;

assign cs0_data = data_addr_o < 256;
assign cs1_data = data_addr_o < 512 && data_addr_o >= 256;

assign cs0_instr = instr_addr_o < 256;
assign cs1_instr = instr_addr_o < 512 && instr_addr_o >= 256;

assign web0 = ~(cs0_data && data_we_o);
assign web1 = ~(cs1_data && data_we_o);

assign data_rdata_sram = (cs0_data ? data_rdata_sram0 : data_rdata_sram1);
assign data_rdata = (data_addr_o < 512 ? data_rdata_sram : data_rdata_i);

assign instr_rdata_sram = (cs0_instr ? instr_rdata_sram0 : instr_rdata_sram1);
assign instr_rdata = (instr_addr_o < 512 ? instr_rdata_sram : instr_rdata_i);


ibex_core ibex_core_inst(
    .clk_i(clk_i),
	.rst_ni(rst_ni),
	.test_en_i(test_en_i),
	.hart_id_i(hart_id_i),
	.boot_addr_i(boot_addr_i),

	.instr_req_o(instr_req_o),
	.instr_gnt_i(instr_gnt_i),
	.instr_rvalid_i(instr_rvalid_i),
	.instr_addr_o(instr_addr_o),
	.instr_rdata_i(instr_rdata),
	.instr_err_i(instr_err_i),

	.data_req_o(data_req_o),
	.data_gnt_i(data_gnt_i),
	.data_rvalid_i(data_rvalid_i),
	.data_we_o(data_we_o),
	.data_be_o(data_be_o),
	.data_addr_o(data_addr_o),
	.data_wdata_o(data_wdata_o),
	.data_rdata_i(data_rdata),
	.data_err_i(data_err_i),

	.irq_software_i(irq_software_i),
	.irq_timer_i(irq_timer_i),
	.irq_external_i(irq_external_i),
	.irq_fast_i(irq_fast_i),
	.irq_nm_i(irq_nm_i),

	.debug_req_i(debug_req_i),
	.fetch_enable_i(fetch_enable_i),
	.alert_minor_o(alert_minor_o),
	.alert_major_o(alert_major_o),
	.core_sleep_o(core_sleep_o)
);

sky130_sram_1kbyte_1rw1r_32x256_8 mem_inst0(
	.clk0(clk_i),
  	.csb0(~cs0_data),
  	.web0(web0),
  	.wmask0(4'b1111),
	.addr0(data_addr_o[7:0]),
  	.din0(data_wdata_o),
  	.dout0(data_rdata_sram0),
	.clk1(clk_i),
  	.csb1(~cs0_instr),
	.addr1(instr_addr_o),
  	.dout1(instr_rdata_sram0)
);

sky130_sram_1kbyte_1rw1r_32x256_8 mem_inst1(
	.clk0(clk_i),
  	.csb0(~cs1_data),
  	.web0(web1),
  	.wmask0(4'b1111),
	.addr0(data_addr_o[7:0]),
  	.din0(data_wdata_o),
  	.dout0(data_rdata_sram1),
	.clk1(clk_i),
  	.csb1(~cs1_instr),
	.addr1(instr_addr_o),
  	.dout1(instr_rdata_sram1)
);
endmodule