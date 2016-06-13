library IEEE;
use IEEE.std_logic_1164.all;

entity frac_adder_tb is
end frac_adder_tb;

architecture frac_adder_tb_arq of frac_adder_tb is
		component adder is
			generic (N: natural := 4);
			port(
				sumA : in std_logic_vector(N-1 downto 0);
				sumB : in std_logic_vector(N-1 downto 0);
				sum_sel : in std_logic;							-- 1 para sumar, 0 para restar
				
				sumS : out std_logic_vector(N-1 downto 0);
				c_out : out std_logic;
				overflow : out std_logic
			);
		end component adder;

	signal a_t, b_t, s_t: std_logic_vector(23 downto 0);
	signal c_out_t, overflow_t, sum_select_t: std_logic := '0';
	
begin
	mySR: adder
		generic map(N => 24)
		port map (a_t, b_t, sum_select_t, s_t, c_out_t, overflow_t);

	a_t <= "110000111010110110000011";
	b_t <= "111010000100010100011100";
	
	sum_select_t <= not sum_select_t after 50 ns;  
	
end frac_adder_tb_arq;