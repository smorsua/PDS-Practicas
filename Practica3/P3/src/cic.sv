module cic
#(parameter Win = 18, // Input Wordlength
  parameter Ncomb = XX, // Comb growth
  parameter Ng = XX, // Guard bits
  parameter Wout = 16, // Output Wordlength
  parameter R=2000) // Interpolation factor
	

(
input signed [Win-1:0] id_data,		// S[Win,Win-3]			
input ic_val_data,
input ic_rst,	
input clk,
output signed [Wout-1:0] od_data,  // S[Wout,Wout-1] Precisión recortada S[16,15]
output oc_val_data
);
/* DECLARATIONS ------------------------- */
// b0 COMB	 





// b1 Expander




// b2 INT 



// b3 SCALE



// b4 SATURATE



/* DESCRIPTION ------------------------- */		

// b0 COMB



// b1 Expander



// b2 INT


// b3 SCALE 2^-K


 // b4 SATURATE




/* OUTPUT ASSIGN ------------------------- */
assign od_data =          ;
assign oc_val_data =  ;

endmodule 


