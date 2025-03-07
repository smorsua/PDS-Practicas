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
	
/* DECLARACIONES ------------------------- */

// b0: ruta datos FM
logic signed [16:0] b0_multiplicand_mux_r; // S[17,16]
logic [32:0] b0_mult_res_full_s; // S[33,31]
logic signed [23:0] b0_mult_res_r; // S[24,24]
logic signed [24:0] b0_sum_res_extended_s; // S[25,24]
logic signed [23:0] b0_sum_res_r; // S[24,24]

// b1: ruta de datos AM
logic [2:0][15:0] b1_id_data_delayed_r; // Each element S[16,15]
logic signed [32:0] b1_mult_res_full_s; // S[33,30]
logic signed [15:0] b1_mult_res_r; // S[16,15]
logic signed [16:0] b1_mult_res_trunc_extend_s; // S[17,15]
logic signed [16:0] b1_mult_res_added_r; // S[17,15]

// b2: DDS
logic [1:0] b2_rst_delayed_r;
logic signed [15:0] b2_sine_s; // S[16,15]

// b3: etapa final
logic signed [16:0] b3_multiplicand_mux_r; // S[17,15]
logic signed [32:0] b3_mult_res_full_s; // S[33,30]
logic signed [15:0] b3_mult_res_r; // S[16,15]

// b4: Generacion  de oc_val_data
logic [6:0] b4_delayed_val_data_r;

/* DESCRIPCION ------------------------- */	

// b0: ruta datos FM
always_ff @(posedge clk) begin
	if(ic_fm_am) begin
		b0_multiplicand_mux_r <= $signed({1'b0, id_im_fm});
	end else begin
		b0_multiplicand_mux_r <= 17'd0;
	end
end

always_ff @(posedge clk) begin
	if(ic_rst) begin
		b0_mult_res_r <= 0;
		b0_sum_res_r <= 0;
	end else begin
		b0_mult_res_full_s = id_data * b0_multiplicand_mux_r;
		b0_mult_res_r <= b0_mult_res_full_s[30:30-23];
		b0_sum_res_extended_s = {b0_mult_res_r[23], b0_mult_res_r} + $signed({1'b0, id_frec_por});
		b0_sum_res_r <= b0_sum_res_extended_s[23:0];
	end
end

// b1: ruta de datos AM
always_ff @(posedge clk) begin
	if(ic_rst) begin
		b1_id_data_delayed_r <= 0;
		b1_mult_res_r <= 0;
		b1_mult_res_added_r <= 0;
	end else begin
		b1_id_data_delayed_r <= {b1_id_data_delayed_r[1:0], id_data};
		b1_mult_res_full_s = $signed(b1_id_data_delayed_r[2]) * $signed({1'b0, id_im_am});
		b1_mult_res_r <= b1_mult_res_full_s[30:30-15];
		b1_mult_res_trunc_extend_s = b1_mult_res_r;
		b1_mult_res_added_r <= b1_mult_res_trunc_extend_s + $signed({1'b0, 1'b1, 15'b0});
	end
end

// b2: DDS
always_ff @(posedge clk) begin
	if(ic_rst) begin
		b2_rst_delayed_r <= {ic_rst, ic_rst};
	end else begin
		b2_rst_delayed_r <= {b2_rst_delayed_r[0], ic_rst};
	end
end

dds_mod_dds #(.M(24),.L(15),.W(16)) dds
		   (.id_p_ac(b0_sum_res_r),
			.ic_rst_ac(b2_rst_delayed_r[1]),
			.ic_en_ac(!b2_rst_delayed_r[1]),
			.ic_val_data(1),
			.clk(clk),
			.od_sin_wave(b2_sine_s),
			.oc_val_data()
			);

// b3: Etapa final
always_ff @(posedge clk) begin
	if(ic_rst) begin
		b3_multiplicand_mux_r <= 17'b0;
		b3_mult_res_r <= 0;
	end else begin
		if(ic_fm_am) begin
			b3_multiplicand_mux_r <= {1'b0, 1'b1, 15'b0};
		end else begin
			b3_multiplicand_mux_r <= b1_mult_res_added_r >>> 1;
		end

		b3_mult_res_full_s = b2_sine_s * b3_multiplicand_mux_r;
		b3_mult_res_r <= b3_mult_res_full_s[30:30-15];
	end
end

// b4: propagacion de val_data
always_ff @(posedge clk) begin
	if(ic_rst) begin
		b4_delayed_val_data_r <= 0;
	end else begin
		b4_delayed_val_data_r <= {b4_delayed_val_data_r[5:0], ic_val_data};
	end
end

/* ASIGNACION SALIDAS ------------------------- */
assign od_data = b3_mult_res_r;
assign oc_val_data = b4_delayed_val_data_r[6]; // HAY QUE MODIFICARLO

endmodule 