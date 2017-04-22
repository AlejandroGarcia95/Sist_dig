library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_TP2.all;

entity cont_TP2_tb is
end;

architecture beh of cont_TP2_tb is

	signal clk_t : std_logic := '0';
	signal out1_t : std_logic := '0';
	signal out2_t : std_logic := '0';
	
begin

	myCont : contador_TP2
		generic map(N => 4, TOPE => 10)
		port map(
			clk => clk_t,
			out_store => out1_t,
			out_reset => out2_t
		);

	clk_t <= not clk_t after 50 ns;

end beh;