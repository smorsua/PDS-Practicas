module comp_cic_reg_desp #(parameter Win = 16, parameter Num_coef = 17) (
    input clk,
    input [Win-1:0] id_data,
    input ic_val_data,
    input [$clog2(Num_coef)-1:0] ic_addr,
    output [Win-1:0] od_reg_desp
);

logic [Num_coef-1:0][Win-1:0] desp_reg_r = 0; // TODO: check size
logic [Win-1:0] reg_desp_out = 0;

always_ff @(posedge clk) begin
    if(ic_val_data) begin
        for(int i = Num_coef-1; i >= 1; i--) begin
            desp_reg_r[i] <= desp_reg_r[i-1];    
        end

        desp_reg_r[0] <= id_data;
    end

    reg_desp_out <= desp_reg_r[ic_addr];
end

assign od_reg_desp = reg_desp_out;
    
endmodule