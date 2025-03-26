module cic_expander #(parameter W = 21, parameter R = 2000) (
    input [W-1:0] id_data,
    input ic_val_data,
    input ic_rst,
    input clk,
    output [W-1:0] od_data,
    output oc_val_data
);
    logic [W-1:0] o_data_r;

    logic is_counting;
    logic [$clog2(R)-1:0] counter;

    always_ff @(posedge clk) begin
        if(ic_rst) begin
            is_counting <= 0;
            counter <= 0;
            o_data_r <= 0;
        end else begin
            if(ic_val_data) begin
                is_counting <= 1;
                counter <= 0;
                o_data_r <= id_data;
            end else if(is_counting) begin
                if(counter == R - 1) begin
                    is_counting <= ic_val_data;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                    o_data_r <= 0;
                end

            end
        end
    end

    assign od_data = o_data_r;
    assign oc_val_data = is_counting;

endmodule