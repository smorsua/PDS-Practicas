module cic_wrp
(
input signed [17:0] id_data,	// S[18,15]		
input ic_val_data,
input ic_rst,	
input clk,
output signed [15:0] od_data,  // S[16,15] 
output oc_val_data
);

/* DECLARACIONES ------------------------- */


/* selección de I/O----------------------- */
// Seleccion de registros de I/O: 0-->no, 1-->si 
parameter reg_io = 0;

// No registra I/O
generate if (reg_io == 0)
	always_comb 	
		begin
			



		end
else
	always_ff@(posedge clk) 	
		begin
			


		end
endgenerate

/* INSTANCIAR EL MODULO ------------------------- */



/* ASIGNACION SALIDAS ------------------------- */
assign od_data = ;
assign oc_val_data = ;

endmodule
