module bcom_conf_fsms_main
(
    input [7:0] id_rxdw,
    input ic_rxrdy,
    input ic_done_wr, 
    input ic_done_rd,
    input ic_rst, 
    input clk,
    output [2:0] od_sleds,
    output oc_start_wr, 
    output oc_start_rd
);

enum logic [2:0] {IDLE, START_WR, WAIT_WR, START_RD, WAIT_RD} state;

/* DECLARACIONES ------------------------- */

// b0: FSM 

logic oc_start_wr_s;
logic oc_start_rd_s;

/* DESCRIPCION ------------------------- */	

// b0: FSM 
always_ff @(posedge clk) begin
    if(ic_rst) begin
        state <= IDLE;
    end else begin
        case(state)
        IDLE: begin
            if(ic_rxrdy) begin
                case(id_rxdw)
                8'h0F: state <= START_WR;
                8'hF0: state <= START_RD;
                default: state <= IDLE;
                endcase
            end else begin
                state <= IDLE;
            end
        end
        START_RD: state <= WAIT_RD;
        WAIT_RD: begin
            if(ic_done_rd) state <= IDLE;
        end
        START_WR: state <= WAIT_WR;
        WAIT_WR: if(ic_done_wr) state <= IDLE;
        default: state <= IDLE;
        endcase
    end
end

always_comb begin
    case(state)
    IDLE: begin
        oc_start_wr_s = 0;
        oc_start_rd_s = 0;
    end
    START_RD: begin
        oc_start_wr_s = 0;
        oc_start_rd_s = 1;
    end
    WAIT_RD: begin
        oc_start_wr_s = 0;
        oc_start_rd_s = 0;
    end
    START_WR: begin
        oc_start_wr_s = 1;
        oc_start_rd_s = 0;
    end
    WAIT_WR: begin
        oc_start_wr_s = 0;
        oc_start_rd_s = 0;
    end
    endcase
end

/* ASIGNACION SALIDAS ------------------------- */
 
assign oc_start_wr = oc_start_wr_s; 
assign oc_start_rd = oc_start_rd_s;
assign od_sleds = state;

endmodule
