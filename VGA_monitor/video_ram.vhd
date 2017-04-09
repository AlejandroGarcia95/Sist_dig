library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity video_ram is
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


end video_ram;


architecture video_ram_arq of video_ram is

type ram_t is array (0 to 2**(20)-1) of std_logic_vector(N-1 downto 0);

signal ram : ram_t := (others => (others => '0'));
signal address_out : std_logic_vector(19 downto 0);
signal address_in : std_logic_vector(19 downto 0);

begin

address_out <= (pixel_col_out & pixel_row_in);
address_in <= (pixel_col_in & pixel_row_in);

process(clk)
begin
	if rising_edge(clk) then
		if (write_flag = '1') then
			ram(to_integer(unsigned(address_in))) <= data_in;
		end if;
		data_out <= ram(to_integer(unsigned(address_out)));
	end if;
end process;
	
end video_ram_arq;