library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_stages.all;

entity fp_adder_tb is
end fp_adder_tb;


architecture fp_adder_tb_arq of fp_adder_tb is

	constant E : natural := 8;
	constant N : natural := 32;
	
	signal inputA_t, inputB_t, outputC_t : std_logic_vector(N-1 downto 0);
	
	signal fracC_t : std_logic_vector(N-E-2 downto 0);
	signal expC_t : std_logic_vector(E-1 downto 0);
	signal sgnC_t : std_logic;
	
	signal clk_t : std_logic := '0';


begin
	myAdder : fp_adder
		generic map (E => E, N => N)				-- E = bits de exponente, N = bits totales
		port map(
			clk => clk_t,
			load => '1',
			
			sgnA => inputA_t(N-1),
			expA => inputA_t(N-2 downto N-E-1),
			fracA => inputA_t(N-E-2 downto 0),
			
			sgnB => inputB_t(N-1),
			expB => inputB_t(N-2 downto N-E-1),
			fracB => inputB_t(N-E-2 downto 0),
			
			sgnC => sgnC_t,
			expC => expC_t,
			fracC => fracC_t
		);

		
	outputC_t <= sgnC_t & expC_t & fracC_t;
		
	clk_t <= not clk_t after 100 ns;

	inputA_t <= "10111110000001001101001000111000" after 10 ns;
	inputB_t <= "00111110100110101110100100001100" after 10 ns;
		--		"00111110001100001111111111100000"
		--		"00111110001100001111111111100000"
end fp_adder_tb_arq;