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
		pixel_col_out: in std_logic_vector(9 downto 0);	-- 10 bits para seleccionar columna
		pixel_row_out: in std_logic_vector(9 downto 0);	-- 10 bits para seleccionar fila
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

-- Señales que van para la memoria (block ram)
signal mem_write_en: std_logic;
signal mem_data_out: std_logic_vector(N-1 downto 0);
signal mem_address_out, mem_address_in : std_logic_vector(17 downto 0);
-- Señales auxiliares
signal col_out_ok, row_out_ok, col_in_ok, row_in_ok: std_logic;
signal lect_ok, escr_ok: std_logic;
begin

-- Mappeo a la block ram, la cual sólo tiene 147456 direcciones
-- representando cada pixel imprimible
bram : block_ram
		generic map(N)
		port map(
			wea => mem_write_en,
			addra => mem_address_in,
			addrb => mem_address_out,
			dia => data_in,
			dob => mem_data_out,
			clk => clk			
		);
		
-- Para asignar unequívocamente una posición de memoria a cada
-- par (col, row) se usan los siguientes pasos:
-- 		col = col - 128
--		row = row - 48
--		Mem Addr = col + row * 384
-- o lo que es lo mismo:
-- 		Mem Addr = (col-128) + ((row-48) << 8) + ((row-48) << 7)
-- Pero esta transformación sólo se hace si el par (col, row)
-- está dentro del área imprimible... Si no, no se escribe en
-- la block ram, o bien se devuelve un 0 en la lectura.
		
-- Validación de la lectura de la memoria:

	-- Valido que pixel_col_out y pixel_row_out estén en el
	-- area imprimible con range_validator
	RV_col_lect: range_validator
		generic map(N => 10, MAYOR => 512, MENOR => 128)
		port map (pixel_col_out, col_out_ok);

	RV_row_lect: range_validator
		generic map(N => 10, MAYOR => 432, MENOR => 48)
		port map (pixel_row_out, row_out_ok);
		
	lect_ok <= row_out_ok and col_out_ok;
	
	-- Si la lect está ok, calculo la posicion de mem de
	-- la block ram de la cual quiero leer
	with lect_ok select
	mem_address_out <= std_logic_vector(unsigned("00000000" & pixel_col_out) - 128 +
				shift_left((unsigned("00000000" & pixel_row_out) - 48), 8) + 
				shift_left((unsigned("00000000" & pixel_row_out) - 48), 7)) when '1',
				(others => '0') when others;
	
	-- Si la lect está ok, devuelvo el valor de la posicion de mem.
	-- calculada... si no, devuelvo 0
	with lect_ok select
		data_out	<=	mem_data_out when '1',
						(others => '0') when others;	
		
-- Validación de la escritura de la memoria:

	-- Valido que pixel_col_in y pixel_row_in estén en el
	-- area imprimible con range_validator
	RV_col_escr: range_validator
		generic map(N => 10, MAYOR => 512, MENOR => 128)
		port map (pixel_col_in, col_in_ok);

	RV_row_escr: range_validator
		generic map(N => 10, MAYOR => 432, MENOR => 48)
		port map (pixel_row_in, row_in_ok);
		
	escr_ok <= row_in_ok and col_in_ok;
	
	-- Si la escr está ok, calculo la posicion de mem de
	-- la block ram en la cual quiero escribir
	mem_address_in <= std_logic_vector(unsigned("00000000" & pixel_col_in) - 128 +
				shift_left((unsigned("00000000" & pixel_row_in) - 48), 8) + 
				shift_left((unsigned("00000000" & pixel_row_in) - 48), 7));
	
	-- Si la escritura está ok, habilito el write flag
	mem_write_en <= escr_ok and write_flag;
		
end video_ram_arq;