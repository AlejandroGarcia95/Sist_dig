library IEEE;
use IEEE.std_logic_1164.all;
use work.includes.all;

entity mult_tb is
end mult_tb;

architecture mult_tb_arq of mult_tb is

	signal a_t, b_t: std_logic_vector(7 downto 0);
	signal s_t: std_logic_vector(15 downto 0);
	signal clk_t, valid_in_t, valid_out_t: std_logic := '0';
	signal flush_t: std_logic := '1';
	
begin
	myMul: multiplicador
		generic map(N => 8)
		port map (a_t, b_t, valid_in_t, s_t, valid_out_t, clk_t, flush_t);

	a_t <= "11001110", "00101110" after 20 ns, "00011011" after 40 ns;
	b_t <= "10000100", "10110000" after 20 ns, "11101101" after 40 ns;

	valid_in_t <= '1' after 10 ns, '0' after 60 ns;
	
	clk_t <= not clk_t after 10 ns; 
	flush_t <= '0' after 10 ns;
	
end mult_tb_arq;