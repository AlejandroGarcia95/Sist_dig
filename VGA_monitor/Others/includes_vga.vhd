library IEEE;
use IEEE.std_logic_1164.all;

package includes_vga is
	
	component video_ram is
		generic(
			W: natural := 640;		-- Ancho de la pantalla
			H: natural := 480;		-- Alto de la pantalla
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
			
			reset: in std_logic;
			
			clk: in std_logic
		);
	end component video_ram;
	
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
			pixel_col: out std_logic_vector(9 downto 0)
		);
	end component vga_ctrl;
	
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

	component init_hardcoded is
	   generic (COORD_N: natural := 16; ADDR_N: natural := 9; CANT_PUNTOS : natural := 256);
	   port(
		  x_out: out std_logic_vector(COORD_N-1 downto 0);
		  y_out: out std_logic_vector(COORD_N-1 downto 0);
		  addr_x: out std_logic_vector(ADDR_N-1 downto 0);
		  addr_y: out std_logic_vector(ADDR_N-1 downto 0);
		  done: out std_logic;
		  clk: in std_logic
	   );
	end component init_hardcoded;
	
	
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
	
	
	component redondeador is
		generic (N_INICIAL: natural := 16; N_FINAL: natural := 8);
		port(
			num_in: in std_logic_vector(N_INICIAL-1 downto 0);
			num_out: out std_logic_vector(N_FINAL-1 downto 0)
		);
	end component redondeador;

end package;