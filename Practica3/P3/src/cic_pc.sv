module cic_pc
#(parameter Win = 18, // Input Wordlength
  parameter Ncomb = 1, // Comb growth
  parameter Ng = 27, // Guard bits
  parameter R=2000) // Interpolation factor
(
input signed [Win-1:0] id_data,		// S[Win,Win-3]			
input ic_val_data,
input ic_rst,	
input clk,
output signed [Win+Ncomb*3+Ng-1:0] od_data,  // 
output oc_val_data
);

/* DECLARATIONS ------------------------- */

// b0 COMB	 
logic [2:0][Win + Ncomb * 3-1:0] combs_od_data;
logic [2:0] combs_od_val_data;

// b1 Expander


// b2 INT 


/* DESCRIPTION ------------------------- */		

// b0 COMB

logic [Win + Ncomb * 3 - 1:0] id_data_expanded;
assign id_data_expanded = $signed(id_data);

cic_comb #(.W(Win + Ncomb * 3)) comb (
    .id_data(id_data_expanded),
    .ic_val_data(ic_val_data),
    .clk(clk),
    .od_data(combs_od_data[0]),
    .oc_val_data(combs_od_val_data[0])
);

generate
    for(genvar i = 1; i < 3; i++) begin
        cic_comb #(.W(Win + Ncomb * 3)) comb (
            .id_data(combs_od_data[i-1]),
            .ic_val_data(combs_od_val_data[i-1]),
            .clk(clk),
            .od_data(combs_od_data[i]),
            .oc_val_data(combs_od_val_data[i])
        );
    end
endgenerate

// b1 Expander

logic [Win + Ncomb * 3-1:0] expander_od_data;
logic expander_oc_val_data;
cic_expander #(.W(Win + Ncomb * 3), .R(R)) expander (
    .id_data(combs_od_data[2]),
    .ic_val_data(combs_od_val_data[2]),
    .ic_rst(ic_rst),
    .clk(clk),
    .od_data(expander_od_data),
    .oc_val_data(expander_oc_val_data)
);

//  b2 INT

logic [Win + Ncomb * 3 + Ng - 1:0] int_id_data_expanded;
assign int_id_data_expanded = $signed(expander_od_data);

logic [2:0][Win + Ncomb * 3 + Ng - 1:0] int_od_data;
logic [2:0] int_od_val_data;

cic_int #(.W(Win + Ncomb * 3 + Ng)) my_cic_int (
    .id_data(int_id_data_expanded),
    .ic_val_data(expander_oc_val_data),
    .clk(clk),
    .od_data(int_od_data[0]),
    .oc_val_data(int_od_val_data[0])
);

generate
    for(genvar i = 1; i < 3; i++) begin
        cic_int #(.W(Win + Ncomb * 3 + Ng)) my_cic_int (
            .id_data(int_od_data[i-1]),
            .ic_val_data(int_od_val_data[i-1]),
            .clk(clk),
            .od_data(int_od_data[i]),
            .oc_val_data(int_od_val_data[i])
        );
    end
endgenerate

		    
/* OUTPUT ASSIGN ------------------------- */
assign od_data = int_od_data[2];
assign oc_val_data = int_od_val_data[2];

endmodule 


