%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generación de ficheros para Testeo del módulo CIC completo
% Incluyendo el compensador
%   Curso 2023-2024 - LAB P3:CIC
%   Versión ESTUDIANTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
warning ('off','all');

% Name of the Simulink Model
name_slx_model = 'cic_model';

% Generation of test files
file_test_gen = 1; %1-> yes; 0->no

% Open figures
open_figs = 1; %1-> yes; 0->no

% Directory to place the test files and the package for tsb.
file_dir = '../sim/iof/';
tsb_dir = '../tsb/';

% Name of the SV testbench
tsb_name = 'cic_tsb';

%% TEST CASES:
test_case = 1

% List of test cases
% 1 : Cosine signal fo = 5 kHz
% 2 : Cosine signal fo = 20 kHz
% 3 : Square signal fo = 10 kHz


switch test_case
    case 1 
        fo= 5; % kHz
        n_periods_to_display = 10; % #periods to display
        switch_case = 1;
    case 2     
        fo= 20; % kHz
        n_periods_to_display = 10; % #periods to display
        switch_case = 1;
    case 3 
        fo= 5; % kHz
        n_periods_to_display = 10; 
        switch_case = 2;
     otherwise
        error ('--> This test case is not defined <--') 
end


%% ------------------Configuration-----------------------------------------

%% Configuracion del CIC

fsL=48;  %% Sample frequency (kHz)
R = 2000; %% Interpolator Factor
fsH = R*fsL/1000;  %% Clock frequency (MHz)
M=1; %% COMB 
N=3; %% CIC order

Tsim = n_periods_to_display/(fo*1000); %% Simulation time

%% ------------------Cuantificacion interna del CIC------------------------
%% 
Win = 18;  %% W input 
Fin = 15;  %% Frac input 
% COMBS
Ncomb = 1; %% Growth in combs
Wcomb = Win + 3 * Ncomb; %% W combs 
Fcomb = Fin; %% Fractional part in combs 
% Expansor
Wexp = Wcomb; %% W  expansor 
Fexp = Fcomb;  %% Fractional part in expansor
% INT
Ng = ceil(log2(10^(132/20)*(2^(Wexp-Fexp-1)-2^-Fexp))); %% Guard bits
Wint = Wexp + Ng; %% W integrators
Fint = Fexp; %% Frac integrators

% k=XX; % Final Scale

Wout = 16; % W Output
Fout = 15; % Frac Output

% ------------------Configuration END--------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---Filtro Compensador de la respuesta del CIC----------------------------
%% Cuantificación señal de entrada al compensador
Wsig = 16;
Fsig = 15;

% % Filtro Compensador del CIC
order_comp_filter = 16;
f_max_comp = 0.4; % Máxima frec (normalizada) a compensar

f1=0:0.01:f_max_comp;
f=f1/(M*R);
resp=abs(sin(pi*f*R*M)./sin(pi*f)).^N;
resp = resp/max(abs(resp));
resp(1)=resp(2);
g_cic04=resp(end);

if open_figs == 1
    figure(30)
    plot(f,20*log10(abs(resp)/2000));
    grid
    %axis([0 0.5/(M*R) abs(resp(2)/R)-8 abs(resp(2)/R)+0.2])
    ylabel('|H(f)| dBs')
    xlabel('f/f_{SH}')
    title(['CIC en el rango a compensar: R=' num2str(R) ' M=' num2str(M) ' N=' num2str(N)])
end

h_comp_cic=remez(order_comp_filter,2*[f1 0.5],[1./resp 1/resp(end)]);
h_comp_cic = round(h_comp_cic*2^16)*2^-16;
[h,Wf]=freqz(h_comp_cic,1,1e5);

% ---END Filtro Compensador de la respuesta del CIC------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---SIMULINK--------------------------------------------------------------

sim([ name_slx_model '.slx']) % Launch Simulink model

%% Graficas INPUT / OUTPUT
L_sin= length(s_in);
L_sout = length(s_out);
if open_figs == 1
        subplot(2,1,1)
        plot((1:L_sin),s_in(1:L_sin))
        ylabel('s\_in(n)')
        xlabel('n')
        axis([0 L_sin -1 1])
        title('Señal de entrada al CIC');
        subplot(2,1,2)
        plot((1:L_sout),s_out(1:L_sout));
        ylabel('s\_out(n)')
        axis([0 L_sout min(s_out) max(s_out)])
        xlabel('n')
        title('Señal de salida del CIC');
end
% ---END SIMULINK----------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -----------------------------------------------------------------
%% Input / Output files generation
%% - CIC input --> id_cic.txt
%% - CIC output --> od_cic.txt
%% - CIC comb input --> id_cic_comb.txt
%% - CIC comb output --> od_cic_comb.txt

if file_test_gen == 1
    % Input data file 'id_cic.txt'
    q_in = quantizer([Win Fin],'wrap','floor');
    f=sprintf([file_dir 'id_cic.txt']);
    num_data_in = length(s_in);
    pack_f=fopen(f,'w');
 
    for i=1:num_data_in-1
       fprintf(pack_f,[num2bin(q_in,s_in(i)) '\n']);
    end
    fprintf(pack_f,[num2bin(q_in,s_in(i+1))]);

    fclose(pack_f);

     % Output data file 'od_cic.txt'
    q_out = quantizer([Wout Fout],'saturate','floor');
    f=sprintf([file_dir 'od_cic.txt']);
    num_data_out = length(s_out);
    pack_f=fopen(f,'w');
 
    for i=1:num_data_out-1
       fprintf(pack_f,[num2bin(q_out,s_out_quant(i)) '\n']);
    end
    fprintf(pack_f,[num2bin(q_out,s_out_quant(i+1))]);

    fclose(pack_f);

    % Input data file 'id_cic_comb.txt'
    q_comb_in = quantizer([Wcomb Fcomb],'wrap','floor');
    f=sprintf([file_dir 'id_cic_comb.txt']);
    num_data_in = length(comb0_input);
    pack_f=fopen(f,'w');
 
    for i=1:num_data_in-1
       fprintf(pack_f,[num2bin(q_comb_in,double(comb0_input(i))) '\n']);
    end
    fprintf(pack_f,[num2bin(q_comb_in,double(comb0_input(i+1)))]);

    fclose(pack_f);

    % Output data file 'od_cic_comb.txt'
    q_comb_out = quantizer([Wcomb Fcomb],'wrap','floor');
    f=sprintf([file_dir 'od_cic_comb.txt']);
    num_data_in = length(comb0_out);
    pack_f=fopen(f,'w');
 
    for i=1:num_data_in-1
       fprintf(pack_f,[num2bin(q_comb_out,double(comb0_out(i))) '\n']);
    end
    fprintf(pack_f,[num2bin(q_comb_out,double(comb0_out(i+1)))]);

    fclose(pack_f);

    % Input data file 'id_cic_int.txt'
    q_int_in = quantizer([Wint Fint],'wrap','floor');
    f=sprintf([file_dir 'id_cic_int.txt']);
    num_data_in = length(int0_input);
    pack_f=fopen(f,'w');
 
    for i=1:num_data_in-1
       fprintf(pack_f,[num2bin(q_int_in,double(int0_input(i))) '\n']);
    end
    fprintf(pack_f,[num2bin(q_int_in,double(int0_input(i+1)))]);

    fclose(pack_f);

    % Output data file 'od_cic_int.txt'
    q_int_out = quantizer([Wint Fint],'wrap','floor');
    f=sprintf([file_dir 'od_cic_int.txt']);
    num_data_in = length(int0_out);
    pack_f=fopen(f,'w');
 
    for i=1:num_data_in-1
       fprintf(pack_f,[num2bin(q_int_out,double(int0_out(i))) '\n']);
    end
    fprintf(pack_f,[num2bin(q_int_out,double(int0_out(i+1)))]);

    fclose(pack_f);

    % Input data file 'id_cic_expander.txt'
    q_exp_in = quantizer([Wcomb Fcomb],'wrap','floor');
    f=sprintf([file_dir 'id_cic_expander.txt']);
    num_data_in = length(comb2_out);
    pack_f=fopen(f,'w');
 
    for i=1:num_data_in-1
       fprintf(pack_f,[num2bin(q_exp_in,double(comb2_out(i))) '\n']);
    end
    fprintf(pack_f,[num2bin(q_exp_in,double(comb2_out(i+1)))]);

    fclose(pack_f);

    % Output data file 'od_cic_expander.txt'
    q_exp_out = quantizer([Wcomb Fcomb],'wrap','floor');
    f=sprintf([file_dir 'od_cic_expander.txt']);
    num_data_in = length(int0_input);
    pack_f=fopen(f,'w');
 
    for i=1:num_data_in-1
       fprintf(pack_f,[num2bin(q_exp_out,double(int0_input(i))) '\n']);
    end
    fprintf(pack_f,[num2bin(q_exp_out,double(int0_input(i+1)))]);

    fclose(pack_f);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -----------------------------------------------------------------
%% Package generation 
%% Parameters:
%% - Win; Ncomb; Ng; Wout; R;
if file_test_gen == 1

%      COMPLETAR
% Configuration file 'id_config_cic.txt'
    f=sprintf([file_dir 'id_config_cic.txt']);
    pack_f=fopen(f,'w');
	
		%%%% TO COMPLETE BY THE STUDENT

    % Package with parameters
    f=sprintf([tsb_dir tsb_name '_pkg.sv']);
    pack_f=fopen(f,'w');
    fprintf(pack_f,'package %s_pkg; \n',tsb_name);
    fprintf(pack_f,' \n');
    fprintf(pack_f,'integer test_case = %d; // #case for test \n',test_case);
    %fprintf(pack_f,'integer in_sample_num = %d; // #processed input samples \n',num_data_in);
    fprintf(pack_f,' \n');
	
    fprintf(pack_f, 'parameter Win = %d; \n', Win);
    fprintf(pack_f, 'parameter Ncomb = %d; \n', Ncomb);
    fprintf(pack_f, 'parameter Ng = %d; \n', Ng);
    fprintf(pack_f, 'parameter Wout = %d; \n', Wout);
    fprintf(pack_f, 'parameter R = %d; \n', R);

    fprintf(pack_f,' \n');
    fprintf(pack_f,'endpackage');
    fclose(pack_f);

    

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

