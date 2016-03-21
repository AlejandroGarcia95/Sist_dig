library IEEE;
use IEEE.std_logic_1164.all;

entity deco_7s is
	port(
		num: in std_logic_vector(3 downto 0);		-- Numero BCD a convertir
		display: out std_logic_vector(6 downto 0) -- 7 patas del display en orden abcdefg
	);
end deco_7s;

architecture deco_7s_arq of deco_7s is
begin

	with num select
	display <= 	"1111110" when "0000",
				"0110000" when "0001",
				"1101101" when "0010",
				"1111001" when "0011",
				"0110011" when "0100",
				"1011011" when "0101",
				"1011111" when "0110",
				"1110000" when "0111",
				"1111111" when "1000",
				"1111011" when "1001",
				"1001111" when others;

end deco_7s_arq;
