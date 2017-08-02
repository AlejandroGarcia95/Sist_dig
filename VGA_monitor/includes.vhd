library IEEE;
use IEEE.std_logic_1164.all;


package includes is
	component contador is
		generic( N : natural := 2 );
		port (
			clk: in std_logic;		-- clock
			rst: in std_logic;		-- reset, coloca el contador en 0
			ena: in std_logic;		-- enable
			count_out: out std_logic_vector(N-1 downto 0)
		);
	end component contador;
	
	component ffd is
	   port(
		  clk: in std_logic;
		  rst: in std_logic;
		  ena: in std_logic;
		  D: in std_logic;
		  Q: out std_logic
	   );
	end component ffd;
	
	component registro is
	   generic (N: natural := 4);
	   port(
		  data_in: in std_logic_vector(N-1 downto 0);
		  data_out: out std_logic_vector(N-1 downto 0);
		  clk: in std_logic;
		  rst: in std_logic;
		  load: in std_logic
	   );
	end component registro;
	
	component shift_register is
	generic(
		N_DELAY: natural:= 10
	);
	port(
		clk: in std_logic;
		d_in: in std_logic;
		d_out: out std_logic
	);
	end component;
		
	component shift_reg is
		generic(N : natural := 8);
		port(
			clk: in std_logic;
			ena: in std_logic;
			ds_in: in std_logic;
			dp_out: out std_logic_vector(N-1 downto 0)
		);
	end component shift_reg;
	
	component delay_gen is
		generic(
			N: natural:= 8;
			DELAY: natural:= 0
		);
		port(
			clk: in std_logic;
			A: in std_logic_vector(N-1 downto 0);
			B: out std_logic_vector(N-1 downto 0)
		);
	end component delay_gen;
	
	component sum_rest is
	   generic (N: natural := 4);
	   port(
		  a: in std_logic_vector(N-1 downto 0);
		  b: in std_logic_vector(N-1 downto 0);
		  c_in: in std_logic;
		  c_out: out std_logic;
		  s: out std_logic_vector(N-1 downto 0);
		  sum_select: in std_logic -- 1 para sumar, 0 para restar
	   );
	end component sum_rest;
	
	component comp2_signed_conv is
	   generic (N: natural := 4);
	   port(
		  num_in: in std_logic_vector(N-1 downto 0);
		  num_out: out std_logic_vector(N-1 downto 0);
		  conv_dir: in std_logic
	   );
	end component comp2_signed_conv;
	
	component redondeador is
	   generic (N_INICIAL: natural := 16; N_FINAL: natural := 8);
	   port(
		  num_in: in std_logic_vector(N_INICIAL-1 downto 0);
		  num_out: out std_logic_vector(N_FINAL-1 downto 0)
	   );
	end component redondeador;
	
	component sum_rest_signed is
	   generic (N: natural := 4);
	   port(
		  a: in std_logic_vector(N-1 downto 0);
		  b: in std_logic_vector(N-1 downto 0);
		  c_in: in std_logic;
		  c_out: out std_logic;
		  sal: out std_logic_vector(N-1 downto 0);
		  sum_select: in std_logic -- 1 para sumar, 0 para restar
	   );
	end component sum_rest_signed;
	

	component cordic_stage is
	   generic (COORD_N: natural := 10; Z_N: natural := 10; I: natural := 0);
	   port(
		  x_old: in std_logic_vector(COORD_N-1 downto 0);
		  y_old: in std_logic_vector(COORD_N-1 downto 0);
		  z_old: in std_logic_vector(Z_N-1 downto 0);
		  x_new: out std_logic_vector(COORD_N-1 downto 0);
		  y_new: out std_logic_vector(COORD_N-1 downto 0);
		  z_new: out std_logic_vector(Z_N-1 downto 0);
		  valid_in: in std_logic;
		  valid_out: out std_logic;
		  cte: in std_logic_vector(Z_N-1 downto 0);
		  clk: in std_logic;
		  flush: in std_logic
	   );
	end component cordic_stage;
	
	component cordic_pipeline is
	   generic (COORD_N: natural := 10; STAGES: natural := 5);
	   port(
		  x_old: in std_logic_vector(COORD_N-1 downto 0);
		  y_old: in std_logic_vector(COORD_N-1 downto 0);
		  z_old: in std_logic_vector(15 downto 0);
		  x_new: out std_logic_vector(COORD_N-1 downto 0);
		  y_new: out std_logic_vector(COORD_N-1 downto 0);
		  valid_in: in std_logic;
		  valid_out: out std_logic;
		  clk: in std_logic;
		  flush: in std_logic
	   );
	end component cordic_pipeline;
	
	
	component address_generator is
	   generic (COORD_N: natural := 10);
	   port(
		  x_coord: in std_logic_vector(COORD_N-1 downto 0);
		  y_coord: in std_logic_vector(COORD_N-1 downto 0);
		  pixel_x: out std_logic_vector(9 downto 0);
		  pixel_y: out std_logic_vector(8 downto 0);
		  ena: in std_logic
	   );
	end component address_generator;
	
	component logic_ram is
		generic(
			ADDR_N: natural := 15;
			COORD_N: natural := 16			
		);
		port(
			-- Para obtener valores de la memoria
			addr_A_out: in std_logic_vector(ADDR_N-1 downto 0);
			addr_B_out: in std_logic_vector(ADDR_N-1 downto 0);
			data_A_out: out std_logic_vector(COORD_N-1 downto 0);
			data_B_out: out std_logic_vector(COORD_N-1 downto 0);
			-- Para escribir valores de la memoria
			addr_A_in: in std_logic_vector(ADDR_N-1 downto 0);
			addr_B_in: in std_logic_vector(ADDR_N-1 downto 0);
			data_A_in: in std_logic_vector(COORD_N-1 downto 0);
			data_B_in: in std_logic_vector(COORD_N-1 downto 0);
			write_flag: in std_logic;	
			
			clk: in std_logic
		);
	end component logic_ram;
	
	component init_hardcoded is
	   generic (COORD_N: natural := 16; ADDR_N: natural := 9; CANT_PUNTOS : natural := 256);
	   port(
		  x_out: out std_logic_vector(COORD_N-1 downto 0);
		  y_out: out std_logic_vector(COORD_N-1 downto 0);
		  addr_x: out std_logic_vector(ADDR_N-1 downto 0);
		  addr_y: out std_logic_vector(ADDR_N-1 downto 0);
		  done: out std_logic;
		  cant_ptos: out std_logic_vector(ADDR_N-1 downto 0);
		  clk: in std_logic
	   );
	end component init_hardcoded;
	
	component ram_update_logic is
	   generic (COORD_N: natural := 16; ADDR_N: natural := 9);
	   port(
			-- Cada pto que el Cordic termina de procesar y las
			-- addr en las que hay que guardarlos
			x_cordic: in std_logic_vector(COORD_N-1 downto 0);
			y_cordic: in std_logic_vector(COORD_N-1 downto 0);
			valid_cordic: in std_logic;
			addr_A_in: out std_logic_vector(ADDR_N-1 downto 0);
			addr_B_in: out std_logic_vector(ADDR_N-1 downto 0);
			x_ram: out std_logic_vector(COORD_N-1 downto 0);
			y_ram: out std_logic_vector(COORD_N-1 downto 0); 
			-- Direcciones del próximo pto a procesar
			addr_A_out: out std_logic_vector(ADDR_N-1 downto 0);
			addr_B_out: out std_logic_vector(ADDR_N-1 downto 0);
			go: in std_logic;	-- Bit para iniciar rotación
			updating: out std_logic;
			cant_ptos: in std_logic_vector(ADDR_N-1 downto 0);
			load_finished: in std_logic;
			clk: in std_logic
	   );
	end component ram_update_logic;
	
	component mult_stage is
		generic (N: natural := 4);
		port(
			-- Valores provenientes de la etapa anterior
			a_in: in std_logic_vector(N-1 downto 0);
			b_in: in std_logic_vector(N-1 downto 0);
			p_in: in std_logic_vector(N-1 downto 0);
			valid_in: in std_logic;
			aux_sign_in: in std_logic;
			
			-- Valores a pasar a la siguiente etapa
			a_out: out std_logic_vector(N-1 downto 0);
			b_out: out std_logic_vector(N-1 downto 0);
			p_out: out std_logic_vector(N-1 downto 0);
			valid_out: out std_logic;
			aux_sign_out: out std_logic;
			
			clk: in std_logic;
			-- Bit para limpiar el pipe
			flush: in std_logic
		);
	end component mult_stage;
	
	component multiplicador is
		generic (N: natural := 4);
		port(
			-- Dos números a multiplicar, en punto fijo
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			valid_in: in std_logic;
			sign_in: in std_logic;
			
			
			s: out std_logic_vector(2*N-1 downto 0);
			valid_out: out std_logic;
			sign_out: out std_logic;
			clk: in std_logic;
			flush: in std_logic
		);	
	end component multiplicador;
	
	component logica_rotacional is
	   generic (COORD_N: natural := 16; STAGES : natural := 10; ADDR_N: natural := 9);
	   port(
			-- Cada pto que se termina de procesar
			x_out: out std_logic_vector(COORD_N-1 downto 0);
			y_out: out std_logic_vector(COORD_N-1 downto 0);
			valid: out std_logic;
			-- Detección de rotación
			z_in: in std_logic_vector(15 downto 0);
			go: in std_logic;	-- Bit para iniciar rotación
			-- Señal para borrar la mem. de video
			video_reset: out std_logic;
			clk: in std_logic
	   );
	end component logica_rotacional;

	component video_ram is
		generic(
			N: natural := 1			-- Cantidad de bits por pixel
		);
		
		port(
			-- Para obtener valores de la memoria
			pixel_col_out: in std_logic_vector(9 downto 0);	-- 8 bits para seleccionar columna
			pixel_row_out: in std_logic_vector(9 downto 0);	-- 8 bits para seleccionar fila
			data_out: out std_logic_vector(N-1 downto 0);	-- Salida de los datos
			
			-- Para editar valores de la memoria
			pixel_col_in: in std_logic_vector(9 downto 0);
			pixel_row_in: in std_logic_vector(9 downto 0);
			data_in: in std_logic_vector(N-1 downto 0);
			write_flag: in std_logic;	
			
			clk: in std_logic
		);
	end component video_ram;
	
	component block_ram is
		generic(
			N: natural := 1			-- Cantidad de bits por dirección
		);
		
		port(
			wea: in std_logic;
			addra: in std_logic_vector(17 downto 0);
			addrb: in std_logic_vector(17 downto 0);
			dia: in std_logic_vector(N-1 downto 0);
			dob: out std_logic_vector(N-1 downto 0);
			clk: in std_logic
		);
	end component block_ram;
	
	component vga_ctrl is
		port (
			mclk: in std_logic;
			red_i: in std_logic;
			grn_i: in std_logic;
			blu_i: in std_logic;
			hs: out std_logic;
			vs: out std_logic;
			red_o: out std_logic_vector(2 downto 0);
			grn_o: out std_logic_vector(2 downto 0);
			blu_o: out std_logic_vector(1 downto 0);
			pixel_row: out std_logic_vector(9 downto 0);
			pixel_col: out std_logic_vector(9 downto 0);
			swipe_start: out std_logic
		);
	end component vga_ctrl;
	
	component video_reset is
		port (
			sig_swipe_start: in std_logic;
			sig_reset: in std_logic;
			
			is_resetting: out std_logic;
			is_waiting: out std_logic;
			
			done_rst: out std_logic;
			clk: in std_logic
		);
	end component video_reset;
	
	component video_plot is
		generic ( COORD_N: natural := 16 );
		port (
			-- Entrada de coordenadas
			coord_x: in std_logic_vector(COORD_N-1 downto 0);
			coord_y: in std_logic_vector(COORD_N-1 downto 0);
			valid: in std_logic;
			
			-- color: in std_logic_vector(2 downto 0);
			
			-- Add new output terminal to video_plot.
			-- Lab reset: Your code here.
			
			rst: in std_logic;
			done_rst: out std_logic;
			clk: in std_logic;
		
			-- Salida vga
			hs: out std_logic;
			vs: out std_logic;
			red_out: out std_logic_vector(2 downto 0);
			grn_out: out std_logic_vector(2 downto 0);
			blu_out: out std_logic_vector(1 downto 0)
		);

	end component video_plot;
	
	component mini_logic_ram is
		generic(
			ADDR_N: natural := 15;
			COORD_N: natural := 16			
		);
		
		port(
			-- Para obtener valores de la memoria
			addr_A_out: in std_logic_vector(ADDR_N-1 downto 0);
			data_A_out: out std_logic_vector(COORD_N-1 downto 0);
			-- Para escribir valores de la memoria
			addr_A_in: in std_logic_vector(ADDR_N-1 downto 0);
			data_A_in: in std_logic_vector(COORD_N-1 downto 0);
			write_flag: in std_logic;	
			
			clk: in std_logic
		);


	end component mini_logic_ram;
	
	component range_validator is
	   generic (N: natural := 4; MAYOR: natural := 16; MENOR: natural := 0);
	   port(
			num_in: in std_logic_vector(N-1 downto 0);
			range_ok: out std_logic
	   );
	end component range_validator;
	
	--
	--
	-- De aca en adelante viene el 3D
	--
	--
	component cordic_3d is
		generic ( COORD_N: natural := 16 );
		port (
			x_inicial: in std_logic_vector(COORD_N-1 downto 0);
			y_inicial: in std_logic_vector(COORD_N-1 downto 0);
			z_inicial: in std_logic_vector(COORD_N-1 downto 0);
			angulo_x: in std_logic_vector(15 downto 0);
			angulo_y: in std_logic_vector(15 downto 0);
			angulo_z: in std_logic_vector(15 downto 0);
			x_final: out std_logic_vector(COORD_N-1 downto 0);
			y_final: out std_logic_vector(COORD_N-1 downto 0);
			z_final: out std_logic_vector(COORD_N-1 downto 0);
			valid_in: in std_logic;
			valid_out: out std_logic;
			clk: in std_logic;
			flush: in std_logic
		);
	end component cordic_3d;
	
	component address_generator_3d is
		generic (COORD_N: natural := 10);
		port(
			x_coord: in std_logic_vector(COORD_N-1 downto 0);
			y_coord: in std_logic_vector(COORD_N-1 downto 0);
			z_coord: in std_logic_vector(COORD_N-1 downto 0);
			pixel_x: out std_logic_vector(9 downto 0);
			pixel_y: out std_logic_vector(8 downto 0);
			ena: in std_logic
		);
	end component address_generator_3d;
	
	
	component init_hardcoded_3d is
	   generic (COORD_N: natural := 16; ADDR_N: natural := 12; CANT_PUNTOS : natural := 510);
	   port(
		  x_out: out std_logic_vector(COORD_N-1 downto 0);
		  y_out: out std_logic_vector(COORD_N-1 downto 0);
		  z_out: out std_logic_vector(COORD_N-1 downto 0);  
		  addr_x: out std_logic_vector(ADDR_N-1 downto 0);
		  addr_y: out std_logic_vector(ADDR_N-1 downto 0);
		  addr_z: out std_logic_vector(ADDR_N-1 downto 0);
		  done: out std_logic;
		  cant_ptos: out std_logic_vector(ADDR_N-1 downto 0);
		  clk: in std_logic
	   );
	end component init_hardcoded_3d;
	
	
	component ram_update_logic_3d is
	   generic (COORD_N: natural := 16; ADDR_N: natural := 9);
	   port(
			-- Cada pto que el Cordic termina de procesar y las
			-- addr en las que hay que guardarlos
			x_cordic: in std_logic_vector(COORD_N-1 downto 0);
			y_cordic: in std_logic_vector(COORD_N-1 downto 0);
			z_cordic: in std_logic_vector(COORD_N-1 downto 0);
			valid_cordic: in std_logic;
			addr_A_in: out std_logic_vector(ADDR_N-1 downto 0);
			addr_B_in: out std_logic_vector(ADDR_N-1 downto 0);
			addr_C_in: out std_logic_vector(ADDR_N-1 downto 0);
			x_ram: out std_logic_vector(COORD_N-1 downto 0);
			y_ram: out std_logic_vector(COORD_N-1 downto 0); 
			z_ram: out std_logic_vector(COORD_N-1 downto 0); 
			-- Direcciones del próximo pto a procesar
			addr_A_out: out std_logic_vector(ADDR_N-1 downto 0);
			addr_B_out: out std_logic_vector(ADDR_N-1 downto 0);
			addr_C_out: out std_logic_vector(ADDR_N-1 downto 0);
			go: in std_logic;	-- Bit para iniciar rotación
			updating: out std_logic;
			cant_ptos: in std_logic_vector(ADDR_N-1 downto 0);
			load_finished: in std_logic;
			clk: in std_logic
	   );
	end component ram_update_logic_3d;
	
	
	component logic_ram_3d is
		generic(
			ADDR_N: natural := 15;
			COORD_N: natural := 16			
		);
		
		port(
			-- Para obtener valores de la memoria
			addr_A_out: in std_logic_vector(ADDR_N-1 downto 0);
			addr_B_out: in std_logic_vector(ADDR_N-1 downto 0);
			addr_C_out: in std_logic_vector(ADDR_N-1 downto 0);
			data_A_out: out std_logic_vector(COORD_N-1 downto 0);
			data_B_out: out std_logic_vector(COORD_N-1 downto 0);
			data_C_out: out std_logic_vector(COORD_N-1 downto 0);
			-- Para escribir valores de la memoria
			addr_A_in: in std_logic_vector(ADDR_N-1 downto 0);
			addr_B_in: in std_logic_vector(ADDR_N-1 downto 0);
			addr_C_in: in std_logic_vector(ADDR_N-1 downto 0);
			data_A_in: in std_logic_vector(COORD_N-1 downto 0);
			data_B_in: in std_logic_vector(COORD_N-1 downto 0);
			data_C_in: in std_logic_vector(COORD_N-1 downto 0);
			write_flag: in std_logic;	
			
			clk: in std_logic
		);
	end component logic_ram_3d;
	
	component logica_rotacional_3d is
	   generic (COORD_N: natural := 16; ADDR_N: natural := 9);
	   port(
			-- Cada pto que se termina de procesar
			x_out: out std_logic_vector(COORD_N-1 downto 0);
			y_out: out std_logic_vector(COORD_N-1 downto 0);
			z_out: out std_logic_vector(COORD_N-1 downto 0);
			valid: out std_logic;
			-- Detección de rotación
			ang_x_in: in std_logic_vector(15 downto 0);
			ang_y_in: in std_logic_vector(15 downto 0);
			ang_z_in: in std_logic_vector(15 downto 0);
			go: in std_logic;	-- Bit para iniciar rotación
			
			rx: in std_logic;
			done_uart: out std_logic;
			-- Señal para borrar la mem. de video
			video_reset: out std_logic;
			clk: in std_logic
	   );
	end component logica_rotacional_3d;
	
		
	component multiplicador_hardcodeado_cordic is
		generic (N: natural := 4);
		port(
			-- Dos números a multiplicar, en punto fijo
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			valid_in: in std_logic;
			sign_in: in std_logic;
			
			
			s: out std_logic_vector(2*N-1 downto 0);
			valid_out: out std_logic;
			sign_out: out std_logic;
			clk: in std_logic;
			flush: in std_logic
		);	
	end component multiplicador_hardcodeado_cordic;
	
	
	component video_plot_3d is
		generic ( COORD_N: natural := 16 );
		port (
			-- Entrada de coordenadas
			coord_x: in std_logic_vector(COORD_N-1 downto 0);
			coord_y: in std_logic_vector(COORD_N-1 downto 0);
			coord_z: in std_logic_vector(COORD_N-1 downto 0);
			valid: in std_logic;
			
			-- color: in std_logic_vector(2 downto 0);
			
			-- Sistema de reset del plotter
			-- Enviar un pulso durante al menos un ciclo de reloj.
			-- Esto hace que la memoria entre en estado RESET. Durante este estado
			-- la memoria esperará a que termine el barrido de pantalla actual. En
			-- el siguiente barrido, se ignorará TODA entrada y se irá borrando progresivamente
			-- la memoria. Cuando el barrido de borrado termine, el estado pasa a READY de nuevo
			-- y se envía un pulso de un ciclo de reloj en la salida done_rst.
			
			rst: in std_logic;
			done_rst: out std_logic;
			
			clk: in std_logic;
		
			-- Salida vga
			hs: out std_logic;
			vs: out std_logic;
			red_out: out std_logic_vector(2 downto 0);
			grn_out: out std_logic_vector(2 downto 0);
			blu_out: out std_logic_vector(1 downto 0)
		);

	end component video_plot_3d;
	
		-- Específicos de la UART
	component uart_rcv is
		port(
			rx: in std_logic;
			rx_out: out std_logic_vector(7 downto 0);
			rx_done: out std_logic;
			baudtick: in std_logic;
			clk: in std_logic
		);
	end component uart_rcv;
	
	component baudrate_gen is
		generic(N : natural := 163);
		port(
			clk: in std_logic;
			tick: out std_logic
		);
	end component baudrate_gen;
	
		
	component uart_interface is
		generic( COORD_N: natural := 16; ADDR_N: natural := 11; NPOINTS: natural := 3);
		port(
			rx_in: in std_logic_vector(7 downto 0);
			rx_done: in std_logic;
		
			x_coord: out std_logic_vector(COORD_N-1 downto 0);
			y_coord: out std_logic_vector(COORD_N-1 downto 0);
			z_coord: out std_logic_vector(COORD_N-1 downto 0);
			
			addr: out std_logic_vector(ADDR_N-1 downto 0);
			valid: out std_logic;
			done: out std_logic;
			
			clk: in std_logic
		);
	end component uart_interface;
	
	
	-- COMPONENTE UART COMPLETO
	component uart is
		generic( COORD_N: natural := 16; ADDR_N: natural := 11; NPOINTS: natural := 3; BAUDRATE: natural := 163);
		port(
			rx: in std_logic;
			
			x_coord: out std_logic_vector(COORD_N-1 downto 0);
			y_coord: out std_logic_vector(COORD_N-1 downto 0);
			z_coord: out std_logic_vector(COORD_N-1 downto 0);
			
			addr: out std_logic_vector(ADDR_N-1 downto 0);
			valid: out std_logic;
			done: out std_logic;
			
			clk: in std_logic
		);			
	end component uart;
	
	
	
end package;