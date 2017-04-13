library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_cordic.all;
use IEEE.numeric_std.all;


entity redondeador_tb is
end redondeador_tb;

architecture redondeador_tb_arq of redondeador_tb is

	signal in_t: std_logic_vector(15 downto 0);
	signal out_t: std_logic_vector(7 downto 0);
begin
	myRED: redondeador
		generic map(N_INICIAL => 16, N_FINAL => 8)
		port map (in_t, out_t);
		
	
	in_t <= "1001001110010101" after 5 ns, "0101001100110111" after 10 ns,
	"0101101010010101" after 15 ns, "1001111110111010" after 20 ns, "0110011001101011" after 25 ns;
	
end redondeador_tb_arq;