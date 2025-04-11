module bcom_conf_fsms_wr
(
input ic_rxrdy,
input ic_start_wr,
input ic_rst, 
input clk,
output [2:0] od_wr_leds,
output oc_shift_rx_regs,
output oc_load_conf_regs,
output oc_done_wr
);

/* DECLARACIONES ------------------------- */
enum logic [2:0] {IDLE, START_WR, WAITING_DATA, RECEIVED_DATA, END_WR}  state;
logic [3:0] data_counter;	
/* DESCRIPCION ------------------------- */	

// Update state
always_ff @(posedge clk) begin
    if(ic_rst) begin
        state <= IDLE;
    end else begin
        case(state)
        IDLE: begin
            if(ic_start_wr) begin
                state <= START_WR;
            end else begin
                state <= IDLE;
            end
        end
        START_WR: state <= WAITING_DATA;
        WAITING_DATA: begin
            if(data_counter < 4'd11) begin
                if(ic_rxrdy) begin
                    state <= RECEIVED_DATA;
                end else begin
                    state <= WAITING_DATA;
                end
            end else begin
                state <= END_WR;
            end
        end
        RECEIVED_DATA: state <= WAITING_DATA;
        END_WR: state <= IDLE;
        default: state <= IDLE;
        endcase
    end
end

// Update data counter
always_ff @(posedge clk) begin
    if(ic_rst) begin
        data_counter <= 0;
    end else begin
        if(state == START_WR) begin
            data_counter <= 0;
        end else if(state == RECEIVED_DATA) begin
            data_counter = data_counter + 1;
        end
    end
end

/* ASIGNACION SALIDAS ------------------------- */
assign oc_done_wr = state == END_WR;
assign oc_shift_rx_regs = state == RECEIVED_DATA;
assign oc_load_conf_regs = state == END_WR;
assign od_wr_leds = state;
	
endmodule 