module bcom_conf_fsms
	(
	input [7:0] id_rxdw, 		// rx dw from RS232
	input	ic_rxrdy, 	// rx rdy from RS232
	input	ic_txbusy, 	// tx busy from RS232
	input	ic_rst,
	input	clk, 
	output [8:0] od_sleds,	
	output  oc_txena, 	// tx enable to RS232
	output  oc_load_conf_regs, 	// load configuration registers
	output  oc_shift_rx_regs, 	// shift rx registers
	output  oc_load_tx_regs, 	// load conf_regs in tx_regs
	output  oc_shift_tx_regs 	// shift tx registers
	);

/* DECLARACIONES ------------------------- */

// b0:
logic b0_start_wr_s;
logic b0_start_rd_s;
logic [2:0] b0_sleds_s;
// b1:
logic b1_done_wr_s;
logic [2:0] b1_sleds_s;
// b2:
logic b2_done_rd_s;
logic [2:0] b2_sleds_s;

/* DESCRIPCION ------------------------- */	

// b0:
bcom_conf_fsms_main C1
			(
			.ic_rxrdy(ic_rxrdy),
			.id_rxdw(id_rxdw),
			.ic_done_wr(b1_done_wr_s),
			.ic_done_rd(b2_done_rd_s),
			.ic_rst(ic_rst),
			.clk(clk),
			.od_sleds(b0_sleds_s),
			.oc_start_wr(b0_start_wr_s),
			.oc_start_rd(b0_start_rd_s)
			);

// b1:		
bcom_conf_fsms_wr C2
			(
			.ic_rxrdy(ic_rxrdy),
			.ic_start_wr(b0_start_wr_s),
			.ic_rst(ic_rst),
			.clk(clk),
			.od_wr_leds(b1_sleds_s),
			.oc_shift_rx_regs(oc_shift_rx_regs),
			.oc_load_conf_regs(oc_load_conf_regs),
			.oc_done_wr(b1_done_wr_s)
			);

// b2:
bcom_conf_fsms_rd C3
			(
			.ic_txbusy(ic_txbusy),
			.ic_start_rd(b0_start_rd_s),
			.ic_rst(ic_rst),
			.clk(clk),
			.od_rd_leds(b2_sleds_s),
			.oc_txena(oc_txena),
			.oc_load_tx_regs(oc_load_tx_regs),
			.oc_shift_tx_regs(oc_shift_tx_regs),
			.oc_done_rd(b2_done_rd_s)
			);		
			
/* ASIGNACION SALIDAS ------------------------- */

assign od_sleds = {b2_sleds_s,b1_sleds_s,b0_sleds_s};

endmodule
