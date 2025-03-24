module clk_div #(parameter DIV = 48) (
    input clk,
    output clk_out
);

    logic [$clogb2(MODULO)-1:0] count = 0;
    logic tc;

    always @(posedge clk) begin
        count <= count + 1;
        if(count == MODULO - 1) begin
            tc <= 1;
        end
    end

endmodule