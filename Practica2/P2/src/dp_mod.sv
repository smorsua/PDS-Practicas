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
logic signed [16:0] b0_multiplicand_mux_r;
logic signed [23:0] b0_mult_res_r;
logic signed [24:0] b0_sum_res_extended_s;
logic signed [23:0] b0_sum_res_r;

// b1: ruta de datos AM
logic [2:0][15:0] b1_id_data_delayed_r;
logic signed [16:0] b1_mult_res_trunc_extend_r;
logic signed [16:0] b1_mult_res_trunc_added_r;

// b2: DDS
logic [1:0] b2_rst_delayed_r;
logic signed [15:0] b2_sine_s;

// b3: etapa final
logic signed [16:0] b3_multiplicand_mux;
logic signed [15:0] b3_mult_res;

// b4: Generacion  de oc_val_data
logic [6:0] b4_delayed_val_data;

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
		logic [32:0] b0_mult_res_full_s;
		b0_mult_res_full_s = id_data * b0_multiplicand_mux_r;
		b0_mult_res_r <= b0_mult_res_full_s[30:30-23]; // Cogemos solo 24 bits fraccionales
		b0_sum_res_extended_s = {b0_mult_res_r[23], b0_mult_res_r} + $signed({1'b0, id_frec_por});
		b0_sum_res_r <= b0_sum_res_extended_s[23:0]; // TODO: possible overflow
	end
end

// b1: ruta de datos AM
always_ff @(posedge clk) begin
	if(ic_rst) begin
		b1_id_data_delayed_r <= 0;
		b1_mult_res_trunc_extend_r <= 0;
		b1_mult_res_trunc_added_r <= 0;
	end else begin
		logic signed [32:0] b1_mult_res_full_s;
		logic signed [15:0] b1_mult_res_trunc_s;

		b1_id_data_delayed_r <= {b1_id_data_delayed_r[1:0], id_data};
		b1_mult_res_full_s = $signed(b1_id_data_delayed_r[2]) * $signed({1'b0, id_im_am});
		b1_mult_res_trunc_s = b1_mult_res_full_s[30:30-15]; // TODO: possible overflow
		b1_mult_res_trunc_extend_r <= b1_mult_res_trunc_s;
		b1_mult_res_trunc_added_r <= b1_mult_res_trunc_extend_r + $signed({1'b0, 1'b1, 15'b0});
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
			.ic_val_data(1), // TODO: change to correct signal
			.clk(clk),
			.od_sin_wave(b2_sine_s),
			.oc_val_data() // TODO: connect
			);

// b3: Etapa final
always_ff @(posedge clk) begin
	if(ic_rst) begin
		b3_multiplicand_mux <= 17'b0;
		b3_mult_res <= 0;
	end else begin
		logic signed [32:0] b3_mult_res_full;

		if(ic_fm_am) begin
			b3_multiplicand_mux <= {1'b0, 1'b1, 15'b0};
		end else begin
			b3_multiplicand_mux <= b1_mult_res_trunc_added_r >>> 1;
		end

		b3_mult_res_full = b2_sine_s * b3_multiplicand_mux;
		b3_mult_res <= b3_mult_res_full[30:30-15];
	end
end

// b4: propagacion de val_data
always_ff @(posedge clk) begin
	if(ic_rst) begin
		b4_delayed_val_data <= 0;
	end else begin
		b4_delayed_val_data <= {b4_delayed_val_data[5:0], ic_val_data};
	end
end

/* ASIGNACION SALIDAS ------------------------- */
assign od_data = b3_mult_res;
assign oc_val_data = b4_delayed_val_data[6]; // HAY QUE MODIFICARLO

endmodule 