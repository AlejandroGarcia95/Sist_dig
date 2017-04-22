library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_TP2.all;

entity digi_tb is
end;

architecture beh of digi_tb is

	signal clk_t : std_logic := '0';
	signal sig_t : std_logic := '0';
	signal out_count : std_logic_vector(11 downto 0) := (others => '0');
	
begin

	myDigi : digitilizer
		port map(
			clk => clk_t,
			sig => sig_t,
			dgts => out_count
		);

	clk_t <= not clk_t after 5 ns;
	sig_t <= not sig_t after 825 ns;

end beh;