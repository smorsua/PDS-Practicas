module dds_test
#(parameter M=24, // DDS accumulator wordlength
  parameter L=15, // DDS phase truncation wordlength
  parameter W=16) // DDS ROM wordlength
(
input [M-1:0] id_p_ac,				// U[M,0]			
input ic_rst_ac, 
input ic_en_ac,
input ic_val_data,	
input clk,
output signed [W-1:0] od_sqr_wave,  // S[W,W-1]
output signed [W-1:0] od_ramp_wave,	// S[W,W-1]
output signed [W-1:0] od_sin_wave,  // S[W,W-1]
output oc_val_data
);

/* DECLARACIONES ------------------------- */

logic [M-1:0] b0_accum_r;               // U[W,0]
logic [L-1:0] b1_accum_trunc_s;         // U[L,0]
logic [L-3:0] b1_preproc_rom_addr_s;    // U[L-3,0]
logic [W-1:0] b2_rom_data_s;            // S[W,W-1]
logic [W-1:0] b3_posproc_data_s;        // S[W,W-1]
logic b3_delayed_control_r;
logic [1:0] b4_delayed_val_data_r;
logic [W-1:0] b4_sqr_wave_r;            // S[W,W-1]
logic [W-1:0] b4_ramp_wave_r;           // S[W,W-1]

/* DESCRIPCION ------------------------- */		

// b0 accumulator
always_ff @(posedge clk) begin
	if(ic_rst_ac)
		b0_accum_r <= 0;
	else if(ic_en_ac)
		b0_accum_r <= b0_accum_r + id_p_ac;

end

// b1 preprocessor
assign b1_accum_trunc_s = b0_accum_r[M-1:M-L];

always_comb begin
	if(b1_accum_trunc_s[L-2] == 0) begin
		b1_preproc_rom_addr_s = b1_accum_trunc_s[L-3:0];
	end else begin
		b1_preproc_rom_addr_s = ~b1_accum_trunc_s[L-3:0];
	end
end

// b2 ROM with sine wave samples
dds_test_rom #(
    .ADDR_WIDTH(L-2),
    .DATA_WIDTH(W)
) sine_wave_rom (
    .clk(clk),
    .ic_addr(b1_preproc_rom_addr_s),
    .od_rom(b2_rom_data_s)
);

// b3 postprocessor
always_ff @(posedge clk) begin
	if(ic_rst_ac) begin
		b3_delayed_control_r <= 0;
	end else begin
		b3_delayed_control_r <= b1_accum_trunc_s[L-1];
	end
end

always_comb begin
    if(b3_delayed_control_r == 0) begin
        b3_posproc_data_s = b2_rom_data_s;
    end else begin
        b3_posproc_data_s = -b2_rom_data_s;
    end
end

// b4 Align outputs with sine wave data delay
always_ff @(posedge clk) begin
    if(ic_rst_ac) begin
		b4_ramp_wave_r <= 0;
		b4_sqr_wave_r <= 0;
		b4_delayed_val_data_r <= 0;
	end else if(ic_en_ac) begin
		b4_ramp_wave_r <= b0_accum_r[M-1:M-W];
		b4_sqr_wave_r <= b0_accum_r[M-1] == 0 ? (1 << (W - 1)) - 1 : (1 << (W - 1)) + 1;
		b4_delayed_val_data_r <= {b4_delayed_val_data_r[0], ic_val_data};
	end
end


/* ASIGNACION SALIDAS ------------------------- */

assign oc_val_data = b4_delayed_val_data_r[1];
assign od_sqr_wave = b4_sqr_wave_r;
assign od_ramp_wave = b4_ramp_wave_r;
assign od_sin_wave = b3_posproc_data_s;

endmodule 


/* MEMORIA ROM PARA dds_test */ 
module dds_test_rom
#(parameter ADDR_WIDTH=13, // Address wordlength
  parameter DATA_WIDTH=14) // ROM output wordlength
(
	input [ADDR_WIDTH-1:0] ic_addr,			// U[ADDR_WIDTH,0]
	input clk, 
	output signed [DATA_WIDTH-1:0] od_rom		// S[DATA_WIDTH,DATA_WIDTH-1]
);

/* DECLARACIONES ------------------------- */
reg signed [DATA_WIDTH-1:0] rom [0:2**ADDR_WIDTH-1];

logic [DATA_WIDTH-1:0] b0_rom_r;

/* DESCRIPCION ------------------------- */		

// ROM data
initial
	if ((DATA_WIDTH == 14)&(ADDR_WIDTH == 13))
			$readmemb("../src/rom_dds_L15_W14.txt", rom);
	else	if ((DATA_WIDTH == 16)&(ADDR_WIDTH == 13))
			$readmemb("../src/rom_dds_L15_W16.txt", rom);
	else	if ((DATA_WIDTH == 16)&(ADDR_WIDTH == 4))
			$readmemb("../src/rom_dds_L6_W16.txt", rom);
				
				
// Read synchronous ROM
always_ff@ (posedge clk) 
			b0_rom_r <= rom[ic_addr];


/* ASIGNACION SALIDAS ------------------------- */
assign od_rom = b0_rom_r;

endmodule
