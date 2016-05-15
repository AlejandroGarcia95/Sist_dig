library IEEE;
use IEEE.std_logic_1164.all;

entity freq_div is
	generic (N : natural := 100; M : natural := 200);
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		clk_out: out std_logic
	);
end freq_div;

architecture freq_div_arq of freq_div is
	signal aux : std_logic;
begin
	process (clk, rst)
		variable cont: integer := 0;
	begin
		if rst = '1' then
			cont := 0;
			aux <= '0';
		elsif rising_edge(clk) then
			if ena = '1' then
				cont := cont + 1;
				if cont = N then
					aux <= '0';
				elsif cont = M then
					aux <= '1';
					cont := 0;
				end if;
			end if;
		end if;
	end process;
	
	clk_out <= aux;

end freq_div_arq;