library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_cordic.all;
use IEEE.numeric_std.all;


entity logic_ram_tb is
end logic_ram_tb;

architecture logic_ram_tb_arq of logic_ram_tb is

	signal a_out, b_out: std_logic_vector(4 downto 0); 
	signal a_in, b_in: std_logic_vector(4 downto 0) := (others => '0');
	signal addr_a_in, addr_b_in, addr_a_out, addr_b_out: std_logic_vector(3 downto 0) := (others => '0');
	signal we_t: std_logic := '1';
	signal clk_t: std_logic := '1';
	
begin
	myRAM: logic_ram
		generic map(COORD_N => 5, ADDR_N => 4)
		port map (addr_a_out, addr_b_out, a_out, b_out, addr_a_in, addr_b_in, 
		a_in, b_in, we_t, clk_t);

	a_in <= "00100" after 5 ns, "00010" after 10 ns, "01011" after 15 ns,
		   "00101" after 20 ns, "10001" after 25 ns, "01100" after 30 ns,
		   "00011" after 35 ns, "00101" after 40 ns;
	b_in <= "10100" after 5 ns, "11100" after 10 ns, "11000" after 15 ns,
		   "10111" after 20 ns, "01110" after 25 ns, "11101" after 30 ns,
		   "11100" after 35 ns, "10000" after 40 ns;
		   
	addr_a_in <= "0010" after 7 ns, "0100" after 12 ns, "0110" after 17 ns,
				"1000" after 22 ns, "1010" after 27 ns, "1100" after 32 ns,
				"1110" after 37 ns;
	addr_b_in <= "0001" after 2 ns, "0011" after 7 ns, "0101" after 12 ns, "0111" after 17 ns,
				"1001" after 22 ns, "1011" after 27 ns, "1101" after 32 ns, "1111" after 37 ns;
	
	addr_a_out <= std_logic_vector(unsigned(addr_a_out)+1) after 2 ns;
	addr_b_out <= std_logic_vector(unsigned(addr_a_out)+2) after 10 ns;	
	
	we_t <= '0' after 42 ns;
	clk_t <= not clk_t after 1 ns;
	
end logic_ram_tb_arq;