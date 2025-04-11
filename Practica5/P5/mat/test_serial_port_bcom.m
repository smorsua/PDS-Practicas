clear all

%% Configura operacion
WRITE = 1; % Escritura si -> 1, no ->0
READ = 1; % Lectura si -> 1, no ->0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Configure and open serial port
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
port = 'COM3'; 
baudrate = 57600;

s_port = serialport(port,baudrate);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bytes configuración
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% frec_mod registers
frec_mod_b0 = 11;
frec_mod_b1 = 22;
frec_mod_b2 = 33;
% frec_por register
frec_por_b0 = 44;
frec_por_b1 = 55;
frec_por_b2 = 66;
% im_am registers
im_am_b0 = 77;
im_am_b1 = 88;
% im_fm registers
im_fm_b0 = 99;
im_fm_b1 = 101;
% Control register
c_byte = 111;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Write registers 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if WRITE == 1
 % Envio instruccion
 write(s_port,hex2dec('0F'),"uint8")
 % Envio 11 bytes
 write(s_port,frec_mod_b0,"uint8")
 write(s_port,frec_mod_b1,"uint8")
 write(s_port,frec_mod_b2,"uint8")
 write(s_port,frec_por_b0,"uint8")
 write(s_port,frec_por_b1,"uint8")
 write(s_port,frec_por_b2,"uint8")
 write(s_port,im_am_b0,"uint8")
 write(s_port,im_am_b1,"uint8")
 write(s_port,im_fm_b0,"uint8")
 write(s_port,im_fm_b1,"uint8")
 write(s_port,c_byte,"uint8")
 % Cierro el puerto
 %fclose(s_port)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read registers 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if READ == 1
 % Envio instruccion lectura
 write(s_port,hex2dec('F0'),"uint8")
 % Leo 11 bytes
 r_frec_mod_b0 = read(s_port,1,"uint8");
 r_frec_mod_b1 = read(s_port,1,"uint8");
 r_frec_mod_b2 = read(s_port,1,"uint8");
 r_frec_por_b0 = read(s_port,1,"uint8");
 r_frec_por_b1 = read(s_port,1,"uint8");
 r_frec_por_b2 = read(s_port,1,"uint8");
 r_im_am_b0 = read(s_port,1,"uint8");
 r_im_am_b1 = read(s_port,1,"uint8");
 r_im_fm_b0 = read(s_port,1,"uint8");
 r_im_fm_b1 = read(s_port,1,"uint8");
 r_c_byte = read(s_port,1,"uint8");
 % Cierra puerto
end
%%
delete(s_port)
%%%%%%%%%%