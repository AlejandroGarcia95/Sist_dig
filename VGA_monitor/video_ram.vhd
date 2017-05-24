library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity video_ram is
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
		
		reset: in std_logic;
		
		clk: in std_logic
	);


end video_ram;


architecture video_ram_arq of video_ram is

signal address_out : std_logic_vector(19 downto 0);
signal address_in : std_logic_vector(19 downto 0);

begin

address_out <= (pixel_col_out & pixel_row_out);
address_in <= (pixel_col_in & pixel_row_in);

bram : block_ram
		generic map(N)
		port map(
			ena => '1',
			enb => '1',
			wea => write_flag,
			addra => address_in,
			addrb => address_out,
			dia => data_in,
			dob => data_out,
			clk => clk			
		);

end video_ram_arq;