module comp_cic_pc
#(  parameter Win=16,     // Input Wordlength 
    parameter Wcoef = 18, // Coefficients Wordlength
    parameter Num_coef=17)   // Coefficients number
(input  signed [Win-1:0] id_data_filter, // Input S[16 15]
 input ic_val_data,
 input ic_rst,
 input  clk, 
 output signed [Win+Wcoef-1:0] od_data_filter, // S[18 15]
 output oc_val_data); 


logic [$clog2(Num_coef)-1:0] control_addr_s;
logic control_en_acc_s;
logic control_rst_acc_s;
logic control_en_reg_s;
logic control_control_val_data_s;

comp_cic_control #(.Num_coef(Num_coef)) control (
    .clk(clk),
    .ic_rst(ic_rst),
    .ic_val_data(ic_val_data),
    .oc_addr(control_addr_s),
    .oc_en_acc(control_en_acc_s),
    .oc_rst_acc(control_rst_acc_s),
    .oc_en_reg(control_en_reg_s),
    .oc_val_data(control_control_val_data_s)
);

logic signed [Win-1:0] reg_desp_s;
comp_cic_reg_desp #(.Win(Win), .Num_coef(Num_coef)) reg_desp (
    .clk(clk),
    .id_data(id_data_filter),
    .ic_val_data(ic_val_data),
    .ic_addr(control_addr_s),
    .od_reg_desp(reg_desp_s)
);

logic signed [Wcoef-1:0] current_coef_s;
comp_cic_rom #(.ADDR_WIDTH($clog2(Num_coef)), .DATA_WIDTH(Wcoef)) rom (
    .clk(clk),
    .ic_addr(control_addr_s),
    .od_rom(current_coef_s)
);

logic signed [Win+Wcoef-1:0] mac_od_out_s;
comp_cic_mac #(
    .Win(Win), 
    .Wcoef(Wcoef), 
    .Wmultout(Win+Wcoef), 
    .Waccum(Win+Wcoef)) mac (
        .clk(clk),
        .ic_reg_desp(reg_desp_s),
        .ic_rom_coef(current_coef_s),
        .ic_en_acc(control_en_acc_s),
        .ic_rst_acc(control_rst_acc_s),
        .od_out(mac_od_out_s)
    );

/* ASIGNACION SALIDAS ------------------------- */

logic signed [Win+Wcoef-1:0] od_data_r = 0;
logic oc_val_data_r = 0;
always_ff @(posedge clk) begin
    if(control_en_reg_s) begin
        od_data_r <= mac_od_out_s;        
    end

    oc_val_data_r <= control_control_val_data_s;
end

assign od_data_filter = od_data_r;
assign oc_val_data = oc_val_data_r;
/* DECLARACION FUNCION LOG2 ------------------------- */

function integer log2;
   input integer value;
   begin
     value = value-1;
     for (log2=0; value>0; log2=log2+1)
       value = value>>1;
   end
 endfunction
endmodule
