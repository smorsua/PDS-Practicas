`timescale 1ns/1ps
import cic_tsb_pkg::*; // PACKAGE WITH PARAMETERS TO CONFIGURE THE TB

module cic_int_tsb();

parameter fo = 5; // kHz
parameter n_periods_to_display = 10;
parameter switch_case = 1;

parameter PER=10; // CLOCK PERIOD

logic rst_ac;
logic clk;
logic val_in;
logic val_out;
logic signed [Win+Ncomb*3+Ng-1:0] in_data;
logic signed [Win+Ncomb*3+Ng-1:0] out_data; 

logic signed [Win+Ncomb*3+Ng-1:0] o_data_M, o_data_F; 

// contadores y control
integer in_sample_cnt; // Contador de muestras de entrada
integer out_sample_cnt; // Contador de muestras de salida
integer error_cnt; // Contador de errores

logic load_data;  // Inicio de lectura de datos
logic end_sim; // Indicación de simulación on/off

// Gestion I/O texto
integer data_in_file_val;
logic signed [Win+Ncomb*3+Ng-1:0] data_in_file;
integer scan_data_in;

integer config_file_val;

integer data_out_file_val;
logic signed [Win+Ncomb*3+Ng-1:0] data_out_file;
integer scan_data_out;

// Reloj
always #(PER/2) clk = !clk&end_sim; // Genera reloj

// UUT
// cic_pc #(.Win(Win), .Ncomb(Ncomb), .Ng(Ng), .R(R)) UUT (
// 	.id_data(in_data),
// 	.ic_val_data(val_in),
// 	.ic_rst(rst_ac),
// 	.clk(clk),
// 	.od_data(out_data),
// 	.oc_val_data(val_out)
// );

cic_int #(.W(Win + Ncomb * 3 + Ng)) my_cic_int (
    .id_data(in_data),
	.ic_val_data(val_in),
	.clk(clk),
	.od_data(out_data),
	.oc_val_data(val_out)
);

initial	begin
	$display("########################################### ");
	$display("START TEST # ","%d", test_case);
	$display("########################################### ");

	data_in_file_val = $fopen("./iof/id_cic_int.txt", "r");
	assert (data_in_file_val) else begin
		$display("---> Error opening file id_cic_int.txt");
		$stop;
	end

	data_out_file_val = $fopen("./iof/od_cic_int.txt", "r");
	assert (data_out_file_val) else begin
		$display("---> Error opening file od_cic_int.txt");
		$stop;
	end
	
	// config_file_val = $fopen("./iof/id_config_cic.txt", "r");

	// TODO: si no causa problemas, eliminar tambien en cic_tsb
	// $fscanf(config_file_val, "%d\n", Win);
	// $fscanf(config_file_val, "%d\n", Ncomb);
	// $fscanf(config_file_val, "%d\n", Ng);
	// $fscanf(config_file_val, "%d\n", Wout);
	// $fscanf(config_file_val, "%d\n", R);

	// $fclose(config_file_val);

	in_data = 0;
	error_cnt = 0;
	out_sample_cnt = 0;

	o_data_M = 0;
	o_data_F = 0;

	end_sim = 1'b1;
	in_sample_cnt = 0;
	clk = 1'b1;
	val_in = 1'b0;
	rst_ac = 1'b1;
	load_data = 1'b0;
	#(10*PER);
	load_data = 1'b1;
end

// Proceso de lectura de datos de entrada
always@(posedge clk)
	if (load_data) begin
		if (!$feof(data_in_file_val)) begin
			scan_data_in <= $fscanf(data_in_file_val, "%b", data_in_file);						
			in_data <= data_in_file; //Salida del fichero
			in_sample_cnt <= in_sample_cnt + 1;
			rst_ac  <= 1'b0;
			val_in  <= 1'b1;
		end	else begin
			val_in <= 1'b0;
			load_data = 1'b0;
			end_sim = #(10*PER) 1'b0; // Hay que dejar un numero de peridodos 
										// mayor que la latencia del UUT
			$display(" Number of input samples ","%d", in_sample_cnt);
		end
	end
		
always@(posedge clk)
	if (val_out) begin
		out_sample_cnt = out_sample_cnt +1;
		if (!$feof(data_out_file_val)) begin
			scan_data_out = $fscanf(data_out_file_val, "%b", data_out_file);						
			o_data_F <= #(PER/10) data_out_file; //Salida del fichero
			o_data_M <= #(PER/10) out_data; //Salida del modulo UUT
		end	else begin
			end_sim = #(10*PER) 1'b0;
		end
	end

// Contador de errores y muestras
always@(o_data_F,o_data_M)
	Assert_error_out:
		assert (o_data_F==o_data_M) else begin
			error_cnt = error_cnt + 1;
			$display("Error in sample number ","%d", out_sample_cnt);
		end   

// Fin de simulación
always@(end_sim)
	if (!end_sim) begin
		$display("########################################### ");
		$display("TEST # %d", test_case);
		$display("Win = %d", Win);
		$display("Ncomb = %d", Ncomb);
		$display("Ng = %d", Ng);
		$display("Wout = %d", Wout);
		$display("R = %d", R);
		$display("########################################### ");
		$display("Number of checked samples ","%d", out_sample_cnt);	
		$display("Number of errors ","%d", error_cnt);
		$display("########################################### ");
		#(PER*2) $stop;
	end

endmodule 