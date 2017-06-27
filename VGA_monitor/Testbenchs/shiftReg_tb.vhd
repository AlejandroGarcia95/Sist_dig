library IEEE;
use IEEE.std_logic_1164.all;
use work.includes.all;
use IEEE.numeric_std.all;


entity shift_register_tb is
end shift_register_tb;

architecture shift_register_tb_arq of shift_register_tb is
	signal in_t: std_logic := '0';
	signal out_t: std_logic;
	signal clk_t: std_logic := '0';
begin
	mySR: shift_register
		generic map(N_DELAY => 15)
		port map (clk_t, in_t, out_t);
	
	clk_t <= not clk_t after 1 ns; 
	
	in_t <= '1' after 153 ns, '0' after 155 ns;
	
end shift_register_tb_arq;