module bcom_rs232 #(parameter ncpb = 434) (
    input logic id_rxsd,                  // rx serial data
    input logic [7:0] id_txdw,            // data to transmit: u[8 0]
    input logic ic_txena,                 // transmit enable
    input logic ic_rst,                   // reset signal
    input logic clk,                   	  // clock signal
    output logic od_txsd,                 // tx serial data
    output logic [7:0] od_rxdw,           // received data: u[8 0]
	output logic oc_txbsy,                // transmitting busy
    output logic oc_rxrdy                 // received ready
);

    // functions
    function int log2(int n);
        int i;
        for (i = 0; i < 32; i++) begin
            if ((1 << i) >= n) return i;
        end
        return 31;
    endfunction

    // b0: rs232 receiver
    logic [0:15] b0_loadbit_c = 16'h8001;
    logic [0:7] b0_rxcontrol_c = 8'h70;
    logic [5:0] b0_rxsyn_r;                 // u[6 0]
    logic b0_rxsld_s;
    logic b0_rxbit_r;
    logic b0_rxcrun_r, b0_rxcend_s;
    logic [2:0] b0_rxcaddr_s;               // [3 0]
    logic b0_cntb_inc_s;
    logic [log2(ncpb)-1:0] b0_cntw_r;       // u[ncpb 0]
    logic [3:0] b0_cntb_r;                  // u[4 0]
    logic [8:0] b0_rxsrl_r;                 // u[9 0]
    logic b0_rxtick_s;
    logic [7:0] b0_rxdw_r;                  // u[8 0]
    logic b0_rxrdy_r;

    // b1: rs232 transmitter
    logic [0:7] b1_txcontrol_c = 8'h70;
    logic b1_txcrun_r, b1_txcend_s;
    logic [2:0] b1_txcaddr_s;               // [3 0]
    logic b1_cntb_inc_s;
    logic [log2(ncpb)-1:0] b1_cntw_r;       // u[ncpb 0]
    logic [3:0] b1_cntb_r;                  // u[4 0]
    logic [8:0] b1_psrl_r;                  // u[9 0]
    logic b1_txtick_s;

    always_ff @(posedge clk) begin
        if (ic_rst) begin
            b0_rxsyn_r <= 0;
            b0_rxbit_r <= 1'b0;
            b0_rxcrun_r <= 1'b0;
            b0_cntw_r <= 0;
            b0_cntb_r <= 0;
            b0_rxsrl_r <= 0;
            b0_rxdw_r <= 0;
            b0_rxrdy_r <= 1'b0;
        end 
		  else begin
            b0_rxsyn_r <= {~id_rxsd, b0_rxsyn_r[5:1]};
            if (b0_rxsld_s) begin
                b0_rxbit_r <= b0_rxsyn_r[0];
            end
            b0_rxcrun_r <= b0_rxcontrol_c[b0_rxcaddr_s];
            if (!b0_rxcrun_r || (b0_cntw_r == (ncpb-1))) begin
                b0_cntw_r <= 0;
            end else begin
                b0_cntw_r <= b0_cntw_r + 1'b1;
            end
            if (!b0_rxcrun_r || b0_rxcend_s) begin
                b0_cntb_r <= 0;
            end else begin
                b0_cntb_r <= b0_cntb_r + b0_cntb_inc_s;
            end
            if (b0_rxtick_s) begin
                b0_rxsrl_r <= {~b0_rxbit_r, b0_rxsrl_r[8:1]};
            end
            if (b0_rxcend_s) begin
                b0_rxdw_r <= b0_rxsrl_r[7:0];
            end
            b0_rxrdy_r <= b0_rxcend_s;
        end
    end

    assign b0_rxsld_s = b0_loadbit_c[b0_rxsyn_r[3:0]];
    assign b0_rxcaddr_s = {b0_rxcend_s, b0_rxbit_r, b0_rxcrun_r};
    assign b0_cntb_inc_s = (b0_cntw_r == (ncpb-1)) ? 1'b1 : 1'b0;
    assign b0_rxcend_s = (b0_cntb_r == 4'b1001 && (b0_cntw_r == (ncpb-1))) ? 1'b1 : 1'b0;
    assign b0_rxtick_s = (b0_cntw_r == (ncpb/2)) ? 1'b1 : 1'b0;

    always_ff @(posedge clk) begin
        if (ic_rst) begin
            b1_txcrun_r <= 1'b0;
            b1_cntw_r <= 0;
            b1_cntb_r <= 0;
            b1_psrl_r <= 0;
        end else begin
            b1_txcrun_r <= b1_txcontrol_c[b1_txcaddr_s];
            if (!b1_txcrun_r || (b1_cntw_r == (ncpb-1))) begin
                b1_cntw_r <= 1'b0;
            end else begin
                b1_cntw_r <= b1_cntw_r + 1;
            end
            if (!b1_txcrun_r || b1_txcend_s) begin
                b1_cntb_r <= 0;
            end else begin
                b1_cntb_r <= b1_cntb_r + b1_cntb_inc_s;
            end
            if (ic_txena && !b1_txcrun_r) begin
                b1_psrl_r <= {~id_txdw, 1'b1};
            end else if (b1_txtick_s) begin
                b1_psrl_r <= {1'b0, b1_psrl_r[8:1]};
            end
        end
    end

    assign b1_txcaddr_s = {b1_txcend_s, ic_txena, b1_txcrun_r};
    assign b1_cntb_inc_s = (b1_cntw_r == (ncpb-1)) ? 1'b1 : 1'b0;
    assign b1_txcend_s = (b1_cntb_r == 4'b1001 && (b1_cntw_r == (ncpb-1))) ? 1'b1 : 1'b0;
    assign b1_txtick_s = (b1_cntw_r == (ncpb-1)) ? 1'b1 : 1'b0;

    assign od_txsd = ~b1_psrl_r[0];
    assign oc_txbsy = b1_txcrun_r;
    assign od_rxdw = b0_rxdw_r;
    assign oc_rxrdy = b0_rxrdy_r;

endmodule