module dp_mod
	(
	input signed [15:0] id_data,	// S[16,15] 
	input [23:0] id_frec_por,		// U[24,24]
	input [15:0] id_im_am,			// U[16,15]
	input [15:0] id_im_fm,			// U[16,16]
	input ic_fm_am, 				// Control modo fm/am
	input ic_rst,					// rst sincrono activo a 1
	input ic_val_data,				
	input clk,
	output signed [15:0] od_data,	// S[16,15]
	output oc_val_data
	);

logic signed [15:0] id_data_r,	// S[16,15] 
logic [23:0] id_frec_por_r,		// U[24,24]
logic [15:0] id_im_am_r,			// U[16,15]
logic [15:0] id_im_fm_r,			// U[16,16]
logic ic_fm_am_r, 				// Control modo fm/am
logic ic_rst_r,					// rst sincrono activo a 1
logic ic_val_data_r,				
logic clk_r,
logic signed [15:0] od_data_r,	// S[16,15]
logic oc_val_data_r	
	
logic [26:0] id_p_ac_r;
logic val_in_r;
logic en_ac_r;
logic signed [13:0] sqr_wave_s,sqr_wave_r;
logic signed [13:0] ramp_wave_s,ramp_wave_r;
logic signed [13:0] sin_wave_s,sin_wave_r;
logic val_out_s,val_out_r;

// Seleccion de registros de I/O: 0-->no, 1-->si 
parameter reg_io = 1;

// No registra I/O
generate if (reg_io == 0)
	always_comb 	
		begin
			id_p_ac_r <= id_p_ac;
			val_in_r <= ic_val_data;
			en_ac_r <= ic_en_ac;
			sqr_wave_r <= sqr_wave_s;
			ramp_wave_r <= ramp_wave_s;
			sin_wave_r <= sin_wave_s;
			val_out_r <= val_out_s;
		end
else
	always_ff@(posedge clk) 	
		begin
			id_p_ac_r <= id_p_ac;
			val_in_r <= ic_val_data;
			en_ac_r <= ic_en_ac;
			sqr_wave_r <= sqr_wave_s;
			ramp_wave_r <= ramp_wave_s;
			sin_wave_r <= sin_wave_s;
			val_out_r <= val_out_s;
		end
endgenerate
		

		
dds_test #(.M(27),.L(15),.W(14)) DDS1 
			(.id_p_ac(id_p_ac_r),
			.ic_rst_ac(ic_rst_ac),
			.ic_en_ac(en_ac_r),
			.ic_val_data(val_in_r),
			.clk(clk),
			.od_sqr_wave(sqr_wave_s),
			.od_ramp_wave(ramp_wave_s),
			.od_sin_wave(sin_wave_s),
			.oc_val_data(val_out_s)
			);

assign od_sqr_wave = sqr_wave_r;
assign od_ramp_wave = ramp_wave_r;
assign od_sin_wave = sin_wave_r;
assign oc_val_data = val_out_r;

endmodule 