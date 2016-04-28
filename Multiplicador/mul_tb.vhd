library IEEE;
use IEEE.std_logic_1164.all;

entity mult_tb is
end mult_tb;

architecture mult_tb_arq of mult_tb is
	component multiplicador is
	   generic (N: natural := 4);
	   port(
		  a: in std_logic_vector(N-1 downto 0);
		  b: in std_logic_vector(N-1 downto 0);
		  s: out std_logic_vector(2*N-1 downto 0);
		  clk: in std_logic;
		  load: in std_logic
	   );
	end component multiplicador;

	signal a_t, b_t: std_logic_vector(7 downto 0);
	signal s_t: std_logic_vector(15 downto 0);
	signal clk_t, load_t: std_logic := '0';
	
begin
	myMul: multiplicador
		generic map(N => 8)
		port map (a_t, b_t, s_t, clk_t, load_t);

	a_t <= "11001110";
	b_t <= "10000100", s_t(7 downto 0) after 125 ns;
	
	load_t <= '1' after 10 ns, '0' after 40 ns;
	
	clk_t <= not clk_t after 5 ns;  
	
end mult_tb_arq;