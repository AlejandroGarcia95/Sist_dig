library IEEE;
use IEEE.std_logic_1164.all;

entity conv_tb is
end conv_tb;

architecture conv_tb_arq of conv_tb is
	component comp2_signed_conv is
	   generic (N: natural := 4);
	   port(
		  num_in: in std_logic_vector(N-1 downto 0);
		  num_out: out std_logic_vector(N-1 downto 0);
		  conv_dir: in std_logic
	   );
	end component comp2_signed_conv;

	signal in_t, out_t: std_logic_vector(7 downto 0);
	signal conv_dir_t: std_logic := '0';
	
begin
	myCV: comp2_signed_conv
		generic map(N => 8)
		port map (in_t, out_t, conv_dir_t);

	in_t <= "00001111";
	
	conv_dir_t <= '1';  
	
end conv_tb_arq;