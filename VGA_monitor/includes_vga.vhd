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
	
	
end package;