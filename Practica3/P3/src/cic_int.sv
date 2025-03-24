module cic_int #(parameter W = 21) (
    input [W-1:0] id_data,
    input ic_val_data,
    input clk,
    output [W-1:0] od_data,
    output oc_val_data
);
    logic [W-1:0] data_delayed = 0;
    logic o_val_data_r;

    always_ff @(posedge clk) begin
        if(ic_val_data) begin
            data_delayed <= id_data + data_delayed;
        end
        o_val_data_r <= ic_val_data;
    end

    assign oc_val_data = o_val_data_r;
    assign od_data = data_delayed;
endmodule