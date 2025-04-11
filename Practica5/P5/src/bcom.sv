module bcom
	(
	input id_rxsd,
	input ic_rst,
	input clk,
	output od_txsd,
	output [7:0]  od_r_control,
	output [23:0] od_r_frec_mod,
	output [23:0] od_r_frec_por,
	output [15:0] od_r_im_am,
	output [15:0] od_r_im_fm,
	output [7:0]  od_view_rxdw,
	output [8:0]  od_sleds
);

/* DECLARACIONES ------------------------- */

// b0:
logic [7:0] b0_rxdw;
logic b0_txbusy;
logic b0_rxrdy;

// b1:
logic [7:0] b1_txdw;
logic b1_txena;

/* DESCRIPCION ------------------------- */

// b0:
//  bcom_rs232 #(.ncpb(434)) C1 // Configuración Practica P6
bcom_rs232 #(.ncpb(8)) C1       // Configuración Practica P5
			(
			.id_rxsd(id_rxsd),
			.id_txdw(b1_txdw),
			.ic_txena(b1_txena),
			.ic_rst(ic_rst),
			.clk(clk),
			.od_txsd(od_txsd),
			.od_rxdw(b0_rxdw),
			.oc_txbsy(b0_txbusy),
			.oc_rxrdy(b0_rxrdy)
			);

// b1:	
bcom_conf C2 
			(
			.id_rxdw(b0_rxdw), 		// rx dw from RS232
			.ic_rxrdy(b0_rxrdy),
			.ic_txbusy(b0_txbusy),
			.ic_rst(ic_rst),
			.clk(clk), 
			.od_txdw(b1_txdw), 		// tx dw to RS232
			.od_r_control(od_r_control),
			.od_r_frec_mod(od_r_frec_mod),
			.od_r_frec_por(od_r_frec_por),
			.od_r_im_am(od_r_im_am),
			.od_r_im_fm(od_r_im_fm),
			.od_sleds(od_sleds),
			.oc_txena(b1_txena)
			);
		
/* ASIGNACION SALIDAS ------------------------- */

assign od_view_rxdw = b0_rxdw;

		
endmodule
