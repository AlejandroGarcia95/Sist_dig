library IEEE;
use IEEE.std_logic_1164.all;

entity mul_float_tb is
end mul_float_tb;

architecture mul_float_tb_arq of mul_float_tb is
	component mul_float is
		generic (S: natural := 32; E: natural := 8);
		port(
			a_in: in std_logic_vector(S-1 downto 0);
			b_in: in std_logic_vector(S-1 downto 0);
			m_out: out std_logic_vector(S-1 downto 0);
			clk: in std_logic;
			load: in std_logic
		);
	end component mul_float;

	signal a_t, b_t: std_logic_vector(31 downto 0);
	signal s_t: std_logic_vector(31 downto 0);
	signal clk_t, load_t: std_logic := '0';
	
begin
	myMul: mul_float
		generic map(32, 8)
		port map (a_t, b_t, s_t, clk_t, load_t);

		
	a_t <= "11011111001010100110100000011001";
	b_t <= "01011111111000101111010010011011";
		
	--s_t ="1111110110001010011111010"
	
	load_t <= '1' after 10 ns, '0' after 40 ns;
	
	clk_t <= not clk_t after 5 ns;  
	
end mul_float_tb_arq;


