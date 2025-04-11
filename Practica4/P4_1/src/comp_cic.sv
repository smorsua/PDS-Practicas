module comp_cic
#(  parameter Win=16,     // Input Wordlength 
    parameter Wcoef = 18, // Coefficients Wordlength
    parameter Wout = 18,  // Output wordlength
    parameter Num_coef=17)   // Coefficients number
(input  signed [Win-1:0] id_data_filter, // Input S[16 15]
 input ic_val_data,
 input ic_rst,
 input  clk, 
 output signed [Wout-1:0] od_data_filter, // S[18 15]
 output oc_val_data); 

logic [Win+Wcoef-1:0] out_data_s;
logic out_val_s;

comp_cic_pc #(.Win(Win), .Wcoef(Wcoef), .Num_coef(Num_coef)) UUT (
	.id_data_filter(id_data_filter),
	.ic_val_data(ic_val_data),
	.ic_rst(ic_rst),
	.clk(clk),
	.od_data_filter(out_data_s),
	.oc_val_data(out_val_s)
);

assign od_data_filter = out_data_s[31+3-1:30-15+1];        
assign oc_val_data = out_val_s;

function integer log2;
   input integer value;
   begin
     value = value-1;
     for (log2=0; value>0; log2=log2+1)
       value = value>>1;
   end
 endfunction
endmodule
