module comp_cic_control #(parameter Num_coef = 17) (
    input clk, //
    input ic_rst, //
    input ic_val_data, // 
    output reg oc_val_data, //
    output reg oc_en_acc, //
    output reg oc_rst_acc, //
    output reg oc_en_reg, // 
    output [$clog2(Num_coef)-1:0] oc_addr //
);

enum logic [2:0] {IDLE, START_COUNTER, WAIT, FINISH_COUNTER, DONE} state;

logic [$clog2(Num_coef)-1:0] counter = 0;

always_comb begin
    case(state)
    IDLE: begin
        oc_en_acc = 0;
        oc_rst_acc = 1;
        oc_en_reg = 0;
        oc_val_data = 0;
    end
    START_COUNTER: begin
        oc_en_acc = 0;
        oc_rst_acc = 1;
        oc_en_reg = 0;
        oc_val_data = 0;
    end
    WAIT: begin
        oc_en_acc = 1;
        oc_rst_acc = 0;
        oc_en_reg = 0;
        oc_val_data = 0;
    end
    FINISH_COUNTER: begin
        oc_en_acc = 1;
        oc_rst_acc = 0;
        oc_en_reg = 0;
        oc_val_data = 0;
    end
    DONE: begin 
        oc_en_acc = 0;
        oc_rst_acc = 0;
        oc_en_reg = 1;
        oc_val_data = 1;
    end
    default: begin
        oc_en_acc = 0;
        oc_rst_acc = 1;
        oc_en_reg = 0;
        oc_val_data = 0;
    end
    endcase
end

always_ff @(posedge clk) begin
    if(ic_rst) begin
        state <= IDLE;
    end else begin
        case(state)
        IDLE: begin
            if(ic_val_data) begin
                state <= START_COUNTER;
            end else begin
                state <= IDLE;
            end
        end
        START_COUNTER: state <= WAIT; 
        WAIT: begin
            if(counter == Num_coef - 1) begin
                state <= FINISH_COUNTER;
            end else begin
                state <= WAIT;
            end
        end
        FINISH_COUNTER: state <= DONE;
        DONE: state <= IDLE;
        default: state <= IDLE;
        endcase
    end
end


always_ff @(posedge clk) begin
    if(ic_rst) begin
        counter <= 0;
    end else begin
        if(state == IDLE) begin
            counter <= 0;
        end

        if(state == START_COUNTER || state == WAIT) begin
            if(counter < Num_coef - 1) begin
                counter <= counter + 1;
            end
        end
    end
end

assign oc_addr = counter;
endmodule