library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_cordic.all;
use IEEE.numeric_std.all;


entity logic_ram_tbII is
end logic_ram_tbII;

architecture logic_ram_tbII_arq of logic_ram_tbII is

	signal a_out, b_out: std_logic_vector(15 downto 0); 
	signal a_in, b_in: std_logic_vector(15 downto 0) := (others => '0');
	signal addr_a_in, addr_b_in, addr_a_out, addr_b_out: std_logic_vector(8 downto 0) := (others => '0');
	signal we_t: std_logic := '1';
	signal clk_t: std_logic := '1';
	signal done_t: std_logic;
	
begin
	myRAM: logic_ram
		generic map(COORD_N => 16, ADDR_N => 9)
		port map (addr_a_out, addr_b_out, a_out, b_out, addr_a_in, addr_b_in, 
		a_in, b_in, we_t, clk_t);

	myHard: init_hardcoded
		generic map(COORD_N => 16, ADDR_N => 9, CANT_PUNTOS => 256)
		port map (a_in, b_in, addr_a_in, addr_b_in, done_t, open, clk_t);
		
	
	addr_a_out <= std_logic_vector(unsigned(addr_a_out)+1) after 10 ns;
	addr_b_out <= std_logic_vector(unsigned(addr_a_out)+2) after 15 ns;	
	
	we_t <= '0' after 800 ns;
	clk_t <= not clk_t after 1 ns;
	
end logic_ram_tbII_arq;