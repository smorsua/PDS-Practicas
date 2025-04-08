module cic
#(parameter Win = 18, // Input Wordlength
  parameter Ncomb = 1, // Comb growth
  parameter Ng = 27, // Guard bits
  parameter Wout = 27, // Output Wordlength
  parameter K=0,
  parameter R=2000) // Interpolation factor
(
input signed [Win-1:0] id_data,		// S[Win,Win-3]			
input ic_val_data,
input ic_rst,	
input clk,
output signed [Wout-1:0] od_data,  // S[Wout,Wout-1] Precisión recortada S[16,15]
output oc_val_data
);

logic signed [Win+Ncomb*3+Ng-1:0] cic_pc_od_data;
logic cic_pc_oc_val_data;

// b0 cic precision completa
cic_pc #(.Win(Win), .Ncomb(Ncomb), .Ng(Ng), .R(R)) UUT (
    .id_data(id_data),
    .ic_val_data(ic_val_data),
    .ic_rst(ic_rst),
    .clk(clk),
    .od_data(cic_pc_od_data),
    .oc_val_data(cic_pc_oc_val_data)
);

// b3 SCALE 2^-K

logic signed [Win + Ncomb * 3 + Ng - 1:0] scale_od_data;

assign scale_od_data = cic_pc_od_data >>> K;

// b1 conversion y saturacion
logic signed [Wout - 1:0] sat_od_data;

assign sat_od_data = (scale_od_data > $signed({1'b0, {(Wout-1){1'b1}}})) ? {1'b0, {(Wout-1){1'b1}}} :
                    (scale_od_data < $signed({1'b1, {(Wout-1){1'b0}}})) ? {1'b1, {(Wout-1){1'b0}}} :
                    scale_od_data[Wout-1:0];

/* OUTPUT ASSIGN ------------------------- */
assign od_data = sat_od_data;
assign oc_val_data = cic_pc_oc_val_data;

endmodule 


