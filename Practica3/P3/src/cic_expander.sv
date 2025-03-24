module cic_expander #(parameter W = 21, parameter R = 2000) (
    input [W-1:0] id_data,
    input ic_val_data,
    input ic_rst,
    input clk,
    output [W-1:0] od_data,
    output oc_val_data
);
    logic [W-1:0] o_data_r;
    logic o_val_data_r;

    logic is_counting;
    logic [$clog2(R)-1:0] counter;

    always_ff @(posedge clk) begin
        if(ic_rst) begin
            o_data_r <= 0;
            o_val_data_r <= 0;
            is_counting <= 0;
            counter <= 0;
        end else begin
            if(is_counting) begin
                if(counter == R-1) begin
                    is_counting <= 0;
                    o_val_data_r <= 0;
                end else begin
                    counter <= counter + 1;
                end    
            end else begin
                if(ic_val_data) begin
                    o_data_r <= id_data;
                    is_counting <= 1;
                    counter <= 0;
                    o_val_data_r <= 1;
                end
            end
        end
    end

    assign oc_val_data = o_val_data_r;
    assign od_data = o_data_r;

endmodule