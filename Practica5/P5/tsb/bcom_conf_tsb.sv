module bcom_conf_tsb();
parameter HPER = 5;
parameter PER = 2*HPER;
parameter RET = 1;

logic rst;
logic clk = 1'b0;
logic rxrdy;
logic txbusy;
logic [7:0] rxdw;
logic [7:0] txdw;
logic txena;
logic [8:0] sleds;
logic [7:0] c_check = 8'b1;
logic [7:0] r_control;
logic [23:0] r_frec_mod;
logic [23:0] r_frec_por;
logic [15:0] r_im_am;
logic [15:0] r_im_fm;
	
// clock generator
always #HPER clk = ~clk;


bcom_conf UUT
	(
	.id_rxdw(rxdw),
	.ic_rxrdy(rxrdy),
	.ic_txbusy(txbusy),
	.ic_rst(rst),
	.clk(clk),
	.od_txdw(txdw),
	.od_r_control(r_control),
	.od_r_frec_mod(r_frec_mod),
	.od_r_frec_por(r_frec_por),
	.od_r_im_am(r_im_am),
	.od_r_im_fm(r_im_fm),
	.od_sleds(sleds),
	.oc_txena(txena)
	);

initial begin
	rxrdy = 1'b0;  		// 1st variables initialization
	rst = 1'b0;
	txbusy = 1'b0;
	delay_clks(3);		// 2nd delays 3 clk cycles
	mk_rst();   		// 3th  makes reset
	delay_clks(3);		// 4th delays 3 clk cycles
	wr_frame();			// 5th generates a write frame to send 5 bytes
	delay_clks(20);		// 6th delays 20 clk cycles
	rd_frame();			// 7th generates a reaf frame to receive 5 bytes
	delay_clks(3);		// 8th delays 3 clk cycles
    //Assert_registers:
	$display(" CHECK CONFIGURATION REGISTER ====================");	// 
    assert  (r_frec_mod == 24'h030201) // expression to be checked
		 $display(" Reg frec_mod configured OK");
		else                  // 
		 $error("  WRONG Reg frec_mod config.  %h",r_frec_mod);
	assert  (r_frec_por == 24'h060504) // expression to be checked
		 $display(" Reg frec_por configured OK");
		else                  // 
		 $error("  WRONG Reg frec_por config.  %h",r_frec_por);
	assert  (r_im_am == 16'h0807) // expression to be checked
		 $display(" Reg im_am configured OK");
		else                  // 
		 $error("  WRONG Reg im_am config.  %h",r_im_am);	
	assert  (r_im_fm == 16'h0a09) // expression to be checked
		 $display(" Reg im_fm configured OK");
		else                  // 
		 $error("  WRONG Reg im_fm config.  %h",r_im_fm);
	assert  (r_control == 8'h0b) // expression to be checked
		 $display(" Reg r_control configured OK");
		else                  // 
		 $error("  WRONG Reg control config.  %h",r_control);		 
	$stop;

end

// Busy generator
always@(posedge clk)
	if (txena)
		begin
			#(RET/10) txbusy = 1'b1;
			@(posedge clk);
			delay_clks(10);
			#(RET/10) txbusy = 1'b0;
		end


// Assertion on txena signal		
always@(posedge txena)
	Assert_tena:              // assertion name
     assert (txena != txbusy) // expression to be checked
		 $display(" OK: txena is activated properly");
		else                  // (optional) custom error message
		 $error(" txena cannot be activated when txbusy is enable");

// Assertion on txena 		
always@(posedge txena)
begin
	Assert_tx:              // assertion name
     assert (c_check == txdw) // expression to be checked
		 $display(" Data %d transmitted OK",c_check);
		else                  // (optional) custom error message
		 $error(" TX data should be %d",c_check);		 
	c_check = c_check + 8'b1;
end

// Assertion on txena 		



// Tasks
task wr_frame() ;
	logic [7:0] C;
	// Write instruction
	tx_byte(8'h0F);
	// 11 consecutive data
	C = 8'b0;
	repeat(11) begin
		C = C +8'b1;
		tx_byte(C);
		end
endtask

task tx_byte(logic [7:0] data) ;
	// Write instruction
	@(posedge clk);
	#RET rxrdy = 1'b1;
	#RET rxdw = data;
	@(posedge clk);
	#RET rxrdy = 1'b0;
	// delay
	#(PER*$urandom_range(30,20));
endtask

task rd_frame() ;
	logic C;
	// Write instruction
	tx_byte(8'hF0);
	// Wait to TX data
	delay_clks(11*20);
endtask

task mk_rst();
	@(posedge clk);
	#RET rst = 1'b1;
	@(posedge clk);
	#RET rst = 1'b0;
endtask

task delay_clks(integer n_delays);
	#(PER*n_delays);
endtask

	
endmodule 