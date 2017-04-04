library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_cordic.all;

entity cordic_stage_tb is
end cordic_stage_tb;

architecture cordic_stage_tb_arq of cordic_stage_tb is

	signal x_t, y_t, x_o_t, y_o_t, x_m, y_m: std_logic_vector(9 downto 0);
	signal z_t, salidita, cte_t, z_o_t, z_m, otra_cte: std_logic_vector(9 downto 0);
	signal clk_t: std_logic := '0';
	
begin
	myCS: cordic_stage
		generic map(COORD_N => 10, Z_N => 10, I => 0)
		port map (x_t, y_t, z_t, x_m, y_m, z_m, cte_t, clk_t);
	myCS2: cordic_stage
		generic map(COORD_N => 10, Z_N => 10, I => 1)
		port map (x_m, y_m, z_m, x_o_t, y_o_t, z_o_t, otra_cte, clk_t);


	x_t <= "0010011001";
	y_t <= "0001100110";
	z_t <= "0001100101";
	cte_t <= "0011001001";
 otra_cte <= "0001110110";
 

	
	clk_t <= not clk_t after 5 ns;  
	
end cordic_stage_tb_arq;