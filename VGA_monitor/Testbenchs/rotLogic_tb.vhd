library IEEE;
use IEEE.std_logic_1164.all;
use work.includes.all;

entity logica_rotacional_tb is
end logica_rotacional_tb;

architecture logica_rotacional_tb_arq of logica_rotacional_tb is
	signal x_t, y_t, z_t: std_logic_vector(15 downto 0);
	signal go_t : std_logic := '0';
	signal v_t, resetV_t: std_logic;
	signal clk_t: std_logic := '0';
begin
	myRL: logica_rotacional
		generic map(COORD_N => 16, STAGES => 10, ADDR_N => 9)
		port map (x_t, y_t, v_t, z_t, go_t, resetV_t, clk_t);

	z_t <= "0011001001000011";
	        
	go_t <= '1' after 550 ns, '0' after 555 ns, '1' after 1200 ns, '0' after 1205 ns;
	
	clk_t <= not clk_t after 1 ns;  
	
end logica_rotacional_tb_arq;