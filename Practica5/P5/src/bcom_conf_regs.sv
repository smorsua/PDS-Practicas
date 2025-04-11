module bcom_conf_regs
	(
	input [7:0] id_rxdw, 		// rx dw from RS232
	input  ic_load_conf_regs, 	// load configuration registers
	input  ic_shift_rx_regs, 	// shift rx registers
	input  ic_load_tx_regs, 	// load b1_conf_regs_r in tx_regs
	input  ic_shift_tx_regs, 	// shift tx registers
	input  clk, 		 
	output [7:0] od_txdw, 		// tx dw to RS232
	output [7:0] od_r_control,
	output [23:0] od_r_frec_mod,
	output [23:0] od_r_frec_por,
	output [15:0] od_r_im_am,
	output [15:0] od_r_im_fm
	);

/* DECLARACIONES ------------------------- */

logic [10:0][7:0] rx_shift_reg = 0; // 11 elements of 8 bits
logic [10:0][7:0] tx_shift_reg = 0; // 11 elements of 8 bits
logic [10:0][7:0] config_shift_reg = 0; // 11 elements of 8 bits

/* DESCRIPCION ------------------------- */	

always @(posedge clk) begin
	if(ic_load_conf_regs) begin
		config_shift_reg <= rx_shift_reg;
	end

	if(ic_load_tx_regs) begin
		tx_shift_reg <= config_shift_reg;
	end

	if(ic_shift_rx_regs) begin
		rx_shift_reg <= {id_rxdw, rx_shift_reg[10:1]};
	end

	if(ic_shift_tx_regs) begin
		tx_shift_reg <= {8'b0, tx_shift_reg[10:1]};
	end
end

/* ASIGNACION SALIDAS ------------------------- */

assign od_r_control = config_shift_reg[10];
assign od_r_im_fm = config_shift_reg[9:8];
assign od_r_im_am = config_shift_reg[7:6];
assign od_r_frec_por = config_shift_reg[5:3];
assign od_r_frec_mod = config_shift_reg[2:0];
assign od_txdw = tx_shift_reg[0];

endmodule 