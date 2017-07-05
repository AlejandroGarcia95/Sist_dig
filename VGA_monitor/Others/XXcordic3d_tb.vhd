library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity cordic_3d_tb is
end cordic_3d_tb;

architecture cordic_3d_tb_arq of cordic_3d_tb is

	signal x_t, y_t, z_t, x_o_t, y_o_t, z_o_t: std_logic_vector(15 downto 0);
	signal ang_x_t, ang_y_t, ang_z_t: std_logic_vector(15 downto 0);
	signal clk_t: std_logic := '0';
	signal v_in_t, v_out_t : std_logic;
	-- La ganancia es de aprox. 1/0.607253 ergo hay que
	-- multiplicar por 0.607253 para anularla.
	signal ganancia: std_logic_vector(14 downto 0) := "000111001010100";	
begin
	myC3D: cordic_3d
		generic map(COORD_N => 16)
		port map (x_t, y_t, z_t, ang_x_t, ang_y_t, ang_z_t, 
		x_o_t, y_o_t, z_o_t, v_in_t, v_out_t, clk_t, '0');


	v_in_t <= '1';
	x_t <= "0001000000000000";
	y_t <= "0010000000000000";
	z_t <= "0001000000000000";
	
	ang_x_t <= "0001101111101100";
	ang_y_t <= "0011001001000011";
	ang_z_t <= "0010000110000010";
	        
	
	clk_t <= not clk_t after 5 ns;  
	
end cordic_3d_tb_arq;