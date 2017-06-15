library IEEE;
use IEEE.std_logic_1164.all;
use work.includes.all;
use IEEE.numeric_std.all;


entity range_validator_tb is
end range_validator_tb;

architecture range_validator_tb_arq of range_validator_tb is
	signal in_t: std_logic_vector(5 downto 0);
	signal out_t: std_logic;
begin
	myRV: range_validator
		generic map(N => 6, MENOR => 8, MAYOR => 35)
		port map (in_t, out_t);
		
	
	in_t <= "110001" after 2 ns, "010110" after 4 ns, "111100" after 6 ns,
	 "000010" after 8 ns, "010100" after 10 ns, "110101" after 12 ns,
	 "000000" after 14 ns, "100100" after 16 ns, "010001" after 18 ns,
	 "001010" after 20 ns, "000111" after 22 ns, "010101" after 24 ns;
	
end range_validator_tb_arq;