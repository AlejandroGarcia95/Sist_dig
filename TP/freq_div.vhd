library IEEE;
use IEEE.std_logic_1164.all;

entity freq_div is
	generic (N : natural := 100);
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		clk_out: out std_logic
	);
end freq_div;

architecture freq_div_arq of freq_div is
begin
	process (clk, rst)
		variable cont: integer := 0;
	begin
		if rst = '1' then
			cont := 0;
			clk_out <= '0';
		elsif rising_edge(clk) and ena = '1' then
			cont := cont + 1;
			if cont = N then
				cont := 0;
				clk_out <= '1';
			else
				clk_out <= '0';
			end if;
		end if;
	end process;

end freq_div_arq;