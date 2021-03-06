library IEEE;
use IEEE.std_logic_1164.all;

package includes_cordic is
			
	-- Registro y FFD
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

	component contador is
		generic( N : natural := 2 );
		port (
			clk: in std_logic;		-- clock
			rst: in std_logic;		-- reset, coloca el contador en 0
			ena: in std_logic;		-- enable
			count_out: out std_logic_vector(N-1 downto 0)
		);
	end component contador;
		
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
			
			-- Valores a pasar a la siguiente etapa
			a_out: out std_logic_vector(N-1 downto 0);
			b_out: out std_logic_vector(N-1 downto 0);
			p_out: out std_logic_vector(N-1 downto 0);
			valid_out: out std_logic;
			
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
			
			
			s: out std_logic_vector(2*N-1 downto 0);
			valid_out: out std_logic;
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
	
end package;