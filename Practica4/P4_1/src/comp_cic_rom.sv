module comp_cic_rom
#(parameter ADDR_WIDTH=13, // Address wordlength
  parameter DATA_WIDTH=14) // ROM output wordlength
(
	input [ADDR_WIDTH-1:0] ic_addr,			// U[ADDR_WIDTH,0]
	input clk, 
	output signed [DATA_WIDTH-1:0] od_rom		// S[DATA_WIDTH,DATA_WIDTH-1]
);

/* DECLARACIONES ------------------------- */
reg signed [DATA_WIDTH-1:0] rom [0:2**ADDR_WIDTH-1];

logic [DATA_WIDTH-1:0] b0_rom_r;

/* DESCRIPCION ------------------------- */		

// ROM data
initial begin
    for(int i = 0; i < 2**ADDR_WIDTH; i++) begin
        rom[i] = 0;
    end
    $readmemb("../sim/iof/rom_coefs_comp_cic.txt", rom);
end
				
				
// Read synchronous ROM
always_ff@ (posedge clk) 
    b0_rom_r <= rom[ic_addr];


/* ASIGNACION SALIDAS ------------------------- */
assign od_rom = b0_rom_r;

endmodule