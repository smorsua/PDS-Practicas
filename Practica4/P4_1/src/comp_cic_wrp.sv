module comp_cic_wrp
(input  signed [15:0] id_data_filter, // Input S[16 15]
 input ic_val_data,
 input ic_rst,
 input  clk, 
 output signed [17:0] od_data_filter,  // S[18 15]
 output oc_val_data );

// Declaracion de señales 



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

// Instanciar comp_cic




// Asignacion de salidas

assign od_data_filter = ;
assign oc_val_data = ;

endmodule
