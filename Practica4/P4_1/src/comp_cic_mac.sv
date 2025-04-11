module comp_cic_mac #(
    parameter Win = 16, 
    parameter Wcoef = 18, 
    parameter Wmultout = 34, 
    parameter Waccum = 34) (
    input signed [Win-1:0] ic_reg_desp,
    input signed [Wcoef-1:0] ic_rom_coef,
    input clk,
    input ic_en_acc,
    input ic_rst_acc,
    output signed [Waccum-1:0] od_out
);
    // logic signed [Wmultin-1:0] extended_reg_desp_s;
    // logic signed [Wmultin-1:0] extended_rom_coef_s;
    logic signed [Wmultout-1:0] mult_res_s;
    logic signed [Waccum-1:0] accum_r = 0;

    assign mult_res_s = ic_reg_desp * ic_rom_coef;

    always_ff @(posedge clk) begin
        if(ic_rst_acc) begin
            accum_r <= 0;
        end else begin

            if(ic_en_acc) begin
                accum_r <= accum_r + mult_res_s; // TODO: if accum and mult_res sizes dont match, it doesnt work
            end
        end
    end

    assign od_out = accum_r;

endmodule