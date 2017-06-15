library IEEE;
use IEEE.std_logic_1164.all;
use work.includes.all;
use IEEE.numeric_std.all;


entity video_ram_tb is
end video_ram_tb;

architecture video_ram_tb_arq of video_ram_tb is

	signal col_out, row_out: std_logic_vector(9 downto 0); 
	signal col_in, row_in: std_logic_vector(9 downto 0); 
	signal d_in, d_out: std_logic_vector(0 downto 0);
	signal we_t: std_logic := '1';
	signal clk_t: std_logic := '1';
	
begin
	myRAM: video_ram
		generic map(N => 1)
		port map (col_out, row_out, d_out, col_in, row_in, d_in, we_t, '0', clk_t);
	
	-- Para el testbench, voy a intentar guardar un pixel en '1' en los siguientes
	-- pares (col, row): (320, 240) ; (110, 240) ; (200, 240) ; (200, 470);
	-- (16, 16) ; (350, 350) ; (270, 240) ; (100, 64) ; (200, 64) ; (200, 16)
	-- Luego de eso voy a intentar poner un '0' en (200, 240) y (350, 350)
	-- Y mientras voy intentando acceder a lo que voy escribiendo

	
	d_in <= "1" after 1 ns, "0" after 22 ns;	
		
	col_in <= "0101000000" after 2 ns, "0001101110" after 4 ns, "0011001000" after 6 ns,
			"0011001000" after 8 ns, "0000010000" after 10 ns, "0101011110" after 12 ns,
			"0100001110" after 14 ns, "0001100100" after 16 ns, "0011001000" after 18 ns,
			"0011001000" after 20 ns, "0011001000" after 22 ns, "0101011110" after 24 ns;
	row_in <= "0011110000" after 2 ns, "0011110000" after 4 ns, "0011110000" after 6 ns,
			"0111010110" after 8 ns, "0000010000" after 10 ns, "0101011110" after 12 ns,
			"0011110000" after 14 ns, "0001000000" after 16 ns, "0001000000" after 18 ns,
			"0000010000" after 20 ns, "0011110000" after 22 ns, "0101011110" after 24 ns;
	
	col_out <= "0101000000" after 3 ns, "0001101110" after 7 ns, "0011001000" after 9 ns,
			"0011001000" after 13 ns, "0000010000" after 15 ns, "0101011110" after 17 ns,
			"0001100100" after 21 ns, "0011001000" after 23 ns, "0011001000" after 27 ns,
			"0101011110" after 29 ns, "0101000000" after 33 ns, "0101011110" after 39 ns;
	
	row_out <= "0011110000" after 3 ns, "0011110000" after 7 ns, "0011110000" after 9 ns,
			"0111010110" after 13 ns, "0000010000" after 15 ns, "0101011110" after 17 ns,
			"0001000000" after 21 ns, "0001000000" after 23 ns, "0011110000" after 27 ns,
			"0101011110" after 29 ns, "0011110000" after 33 ns, "0011110000" after 39 ns;
	
	we_t <= '0' after 27 ns;
	clk_t <= not clk_t after 1 ns;
	
end video_ram_tb_arq;