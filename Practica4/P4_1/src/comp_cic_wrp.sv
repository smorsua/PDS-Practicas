module comp_cic_wrp
(input  signed [15:0] id_data_filter, // Input S[16 15]
 input ic_val_data,
 input ic_rst,
 input  clk, 
 output signed [17:0] od_data_filter,  // S[18 15]
 output oc_val_data );

// Declaracion de señales 

logic signed [15:0] id_data_filter_r; // Input S[16 15]
logic ic_val_data_r;
logic ic_rst_r;
logic signed [17:0] od_data_filter_r;  // S[18 15]
logic oc_val_data_r; 
logic signed [17:0] od_data_filter_s;  // S[18 15]
logic oc_val_data_s; 

// Seleccion de registros de I/O: 0-->no, 1-->si 
parameter reg_io = 1;

// No registra I/O
generate if (reg_io == 0)
	always_comb 	
		begin
		id_data_filter_r = id_data_filter;
		ic_val_data_r = ic_val_data;
		ic_rst_r = ic_rst;
		od_data_filter_r = od_data_filter_s;
		oc_val_data_r = oc_val_data_s;
		end
else
	always_ff@(posedge clk) 	
		begin
		id_data_filter_r <= id_data_filter;
		ic_val_data_r <= ic_val_data;
		ic_rst_r <= ic_rst;
		od_data_filter_r <= od_data_filter_s;
		oc_val_data_r <= oc_val_data_s;


		end
endgenerate

// Instanciar comp_cic

comp_cic #(.Win(16), .Wcoef(18), .Wout(18), .Num_coef(17)) UUT (
	.id_data_filter(id_data_filter_r),
	.ic_val_data(ic_val_data_r),
	.ic_rst(ic_rst_r),
	.clk(clk),
	.od_data_filter(od_data_filter_s),
	.oc_val_data(oc_val_data_s)
);


// Asignacion de salidas

assign od_data_filter = od_data_filter_r;
assign oc_val_data = oc_val_data_r;

endmodule
