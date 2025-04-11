module top_test_bcom_DE2_115
	(
	input 	UART_RXD, 		// rx serial input
	input	CLOCK_50, 		// Main clock 50 MHz
	input	[0:0]	KEY, 	// Push buttom [3:0]
	input   [3:0] SW, 		// Switch [17:0]
	output	UART_TXD, 		// tx serial output
	output	[8:0]	LEDG,	// green LEDs [8:0]
	output	[15:0]	LEDR 	// Red LEDs [17:0]
	);
	
/* DECLARACIONES ------------------------- */

// b0:
logic b0_rst_s;
logic [3:0] b0_addr_s;
reg [7:0] b0_viewregs_s;

// b1:
logic b1_txsd_s;
logic [7:0] b1_r_control_s;
logic [23:0] b1_r_frec_mod_s;
logic [23:0] b1_r_frec_por_s;
logic [15:0] b1_r_im_am_s;
logic [15:0] b1_r_im_fm_s;
logic [7:0] b1_view_rxdw_s;
logic [8:0] b1_sleds_s;

// b2:
logic clk_pll;

/* DESCRIPCION ------------------------- */

// b0:
assign b0_rst_s = !KEY[0];
assign b0_addr_s = SW[3:0];

always_comb
	case(b0_addr_s)
		4'b 0000: 	b0_viewregs_s = b1_r_control_s;
		4'b 0001: 	b0_viewregs_s = b1_r_frec_mod_s[23:16];
		4'b 0010: 	b0_viewregs_s = b1_r_frec_mod_s[15:8];
		4'b 0011: 	b0_viewregs_s = b1_r_frec_mod_s[7:0];
		4'b 0100: 	b0_viewregs_s = b1_r_frec_por_s[23:16];
		4'b 0101: 	b0_viewregs_s = b1_r_frec_por_s[15:8];
		4'b 0110: 	b0_viewregs_s = b1_r_frec_por_s[7:0];
		4'b 0111: 	b0_viewregs_s = b1_r_im_am_s[15:8];
		4'b 1000: 	b0_viewregs_s = b1_r_im_am_s[7:0];
		4'b 1001: 	b0_viewregs_s = b1_r_im_fm_s[15:8];
		4'b 1010: 	b0_viewregs_s = b1_r_im_fm_s[7:0];
		default:  	b0_viewregs_s = 8'b 00000000;
	endcase 

// b1: 
bcom INST1
		(
		.id_rxsd(UART_RXD),
		.ic_rst(b0_rst_s),
		.clk(clk_pll),
		.od_txsd(b1_txsd_s),
		.od_r_control(b1_r_control_s),
		.od_r_frec_mod(b1_r_frec_mod_s),
		.od_r_frec_por(b1_r_frec_por_s),
		.od_r_im_am(b1_r_im_am_s),
		.od_r_im_fm(b1_r_im_fm_s),
		.od_view_rxdw(b1_view_rxdw_s),
		.od_sleds(b1_sleds_s)
		);
	
// b2:	
PLL_test	PLL_test_inst (
						.areset (1'b0),
						.inclk0 (CLOCK_50),
						.c0 (clk_pll)
						);
					
/* ASIGNACION SALIDAS ------------------------- */

assign UART_TXD = b1_txsd_s;
assign LEDG = b1_sleds_s;
assign LEDR[7:0] = b0_viewregs_s;
assign LEDR[15:8] = b1_view_rxdw_s;

endmodule 