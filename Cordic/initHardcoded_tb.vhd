library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_cordic.all;
use IEEE.numeric_std.all;


entity init_hardcoded_tb is
end init_hardcoded_tb;

architecture init_hardcoded_tb_arq of init_hardcoded_tb is

	signal x_t, y_t: std_logic_vector(15 downto 0);
	signal addr_x_t, addr_y_t, cuenta_t: std_logic_vector(8 downto 0);
	signal done_t, ena_t: std_logic;
	signal clk_t: std_logic := '1';
	
	signal cuenta_pr: std_logic_vector(8 downto 0);
	
begin
	myHard: init_hardcoded
		generic map(COORD_N => 16, ADDR_N => 9, CANT_PUNTOS => 256)
		port map (x_t, y_t, addr_x_t, addr_y_t, done_t, clk_t);
		
	clk_t <= not clk_t after 1 ns;
	
	mySCounter: contador
		generic map(N => 9)
		port map (clk_t, '0', '1', cuenta_pr);
	
end init_hardcoded_tb_arq;