library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_cordic.all;
use IEEE.numeric_std.all;


entity ram_update_logic_tb is
end ram_update_logic_tb;

architecture ram_update_logic_tb_arq of ram_update_logic_tb is

	signal xc_t, yc_t, xr_t, yr_t: std_logic_vector(15 downto 0) := (others => '0');
	signal addr_Ai_t, addr_Bi_t, addr_Ao_t, addr_Bo_t: std_logic_vector(8 downto 0);
	signal go_t, valid_t: std_logic := '0';
	signal update_t: std_logic;
	signal clk_t: std_logic := '1';
	signal puntos_t: std_logic_vector(8 downto 0) := "100000000"; --256
	
begin
	myRUL: ram_update_logic
		generic map(COORD_N => 16, ADDR_N => 9)
		port map (xc_t, yc_t, valid_t, addr_Ai_t, addr_Bi_t, xr_t, yr_t, 
		addr_Ao_t, addr_Bo_t, go_t, update_t, puntos_t, clk_t);
		
	clk_t <= not clk_t after 1 ns;
	go_t <= '1' after 50 ns, '0' after 55 ns, '1' after 600 ns, '0' after 605 ns, '1' after 2800 ns, '0' after 2810 ns;
	valid_t <= '1' after 70 ns, '0' after 582 ns;
	
	xc_t <= std_logic_vector(unsigned(xc_t)+1) after 1 ns;
	yc_t <= std_logic_vector(unsigned(xc_t)+7) after 1 ns;
	
end ram_update_logic_tb_arq;