library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity address_generator_3d_tb is
end address_generator_3d_tb;

architecture address_generator_3d_tb_arq of address_generator_3d_tb is
	signal x_t, y_t, z_t: std_logic_vector(15 downto 0);
	signal p_x_out_t: std_logic_vector(9 downto 0);
	signal p_y_out_t: std_logic_vector(8 downto 0);
begin
	myAG3D: address_generator_3d
		generic map(COORD_N => 16)
		port map (x_t, y_t, z_t, p_x_out_t, p_y_out_t, '1');

	x_t <= "1100010101000100";
	y_t <= "1001000000000000";
	z_t <= "0011000000000000";
	

end address_generator_3d_tb_arq;