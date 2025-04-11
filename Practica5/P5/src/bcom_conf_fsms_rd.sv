module bcom_conf_fsms_rd
(
input ic_txbusy,
input ic_start_rd,
input ic_rst, 
input clk,
output [2:0] od_rd_leds,
output oc_txena,
output oc_load_tx_regs,
output oc_shift_tx_regs,
output oc_done_rd
);

/* DECLARACIONES ------------------------- */
enum logic [2:0] {IDLE, START_RD, WAIT_BUSY, SEND_DATA, END_RD} state;
logic [3:0] data_counter;

/* DESCRIPCION ------------------------- */
// Update state
always_ff @(posedge clk) begin
    if(ic_rst) begin
        state <= IDLE;
    end else begin
        case(state)
        IDLE: begin
            if(ic_start_rd) begin
                state <= START_RD;
            end else begin
                state <= IDLE;
            end
        end
        START_RD: state <= WAIT_BUSY;
        WAIT_BUSY: begin
            if(data_counter < 4'd11) begin
                if(ic_txbusy == 0) begin
                    state <= SEND_DATA;
                end else begin
                    state <= WAIT_BUSY;
                end
            end else begin
                state <= END_RD;
            end
        end
        SEND_DATA: state <= WAIT_BUSY;
        END_RD: state <= IDLE;
        default: state <= IDLE;
        endcase
    end
end

// Update data counter
always_ff @(posedge clk) begin
    if(ic_rst) begin
        data_counter <= 0;
    end else begin
        if(state == START_RD) begin
            data_counter <= 0;
        end else if(state == SEND_DATA) begin
            data_counter = data_counter + 1;
        end
    end
end


/* ASIGNACION SALIDAS ------------------------- */

assign  oc_done_rd = state == END_RD;
assign 	oc_load_tx_regs = state == START_RD;
assign 	oc_shift_tx_regs = state == SEND_DATA;
assign  oc_txena = state == SEND_DATA;
assign 	od_rd_leds = state;
	
endmodule 