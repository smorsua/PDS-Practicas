module cic_comb #(parameter W = 21) (
    input [W-1:0] id_data,
    input ic_val_data,
    input clk,
    output [W-1:0] od_data,
    output oc_val_data
);

    logic val_data_r = 0;
    logic [W-1:0] data_delay = 0;
    logic [W-1:0] od_data_r = 0;

    always_ff @(posedge clk) begin
        if(ic_val_data) begin
            data_delay <= id_data;
            od_data_r <= id_data - data_delay;
        end
        val_data_r <= ic_val_data;
    end

    assign oc_val_data = val_data_r;
    assign od_data = od_data_r;
endmodule