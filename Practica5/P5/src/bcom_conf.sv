module bcom_conf
	(
	input [7:0] id_rxdw,
	input ic_rxrdy,
	input ic_txbusy,
	input ic_rst,
	input clk,
	output [7:0]  od_txdw,
	output [7:0]  od_r_control,
	output [23:0] od_r_frec_mod,
	output [23:0] od_r_frec_por,
	output [15:0] od_r_im_am,
	output [15:0] od_r_im_fm,
	output [8:0]  od_sleds,
	output oc_txena
);

/* DECLARACIONES ------------------------- */

logic b0_load_conf_regs_s;
logic b0_shift_rx_regs_s;
logic b0_load_tx_regs_s;
logic b0_shift_tx_regs_s;

/* DESCRIPCION ------------------------- */		

bcom_conf_regs C2 
			(
			.id_rxdw(id_rxdw), 		// rx dw from RS232
			.ic_load_conf_regs(b0_load_conf_regs_s), 	// load configuration registers
			.ic_shift_rx_regs(b0_shift_rx_regs_s), 	// shift rx registers
			.ic_load_tx_regs(b0_load_tx_regs_s), 	// load conf_regs in tx_regs
			.ic_shift_tx_regs(b0_shift_tx_regs_s), 	// shift tx registers
			.clk(clk), 		 
			.od_txdw(od_txdw), 		// tx dw to RS232
			.od_r_control(od_r_control),
			.od_r_frec_mod(od_r_frec_mod),
			.od_r_frec_por(od_r_frec_por),
			.od_r_im_am(od_r_im_am),
			.od_r_im_fm(od_r_im_fm)
			);

bcom_conf_fsms C3
			(
			.id_rxdw(id_rxdw), 		// rx dw from RS232
			.ic_txbusy(ic_txbusy),
			.ic_rxrdy(ic_rxrdy),
			.ic_rst(ic_rst),
			.clk(clk),
			.oc_txena(oc_txena),
			.oc_load_conf_regs(b0_load_conf_regs_s), 	// load configuration registers
			.oc_shift_rx_regs(b0_shift_rx_regs_s), 	// shift rx registers
			.oc_load_tx_regs(b0_load_tx_regs_s), 	// load conf_regs in tx_regs
			.oc_shift_tx_regs(b0_shift_tx_regs_s), 	// shift tx registers
			.od_sleds(od_sleds)
			);

/* ASIGNACION SALIDAS ------------------------- */

endmodule
