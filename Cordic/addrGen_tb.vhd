library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_cordic.all;

entity addr_gen_tb is
end addr_gen_tb;

architecture addr_gen_tb_arq of addr_gen_tb is

	signal x_t, y_t: std_logic_vector(15 downto 0) := (others => '0');
	signal pixel_x_t: std_logic_vector(9 downto 0);
	signal pixel_y_t: std_logic_vector(8 downto 0);
	signal ena_t: std_logic := '1';
	
begin
	myCS: address_generator
		generic map(COORD_N => 16)
		port map (x_t, y_t, pixel_x_t, pixel_y_t, ena_t);
		
	-- Los puntos que se envian son, en orden: (0,0); (0.5,0); (1,0); (0,1);
	-- (0.5,0.5); (-1,0); (-1,-1); (0.75,-1); (-0.75,1)

	x_t <= "0000000000000000" after 5 ns, "0010000000000000" after 10 ns, "0100000000000000" after 15 ns,
		   "0000000000000000" after 20 ns, "0010000000000000" after 25 ns, "1100000000000000" after 30 ns,
		   "1100000000000000" after 35 ns, "0011000000000000" after 40 ns, "1011000000000000" after 45 ns;
	y_t <= "0000000000000000" after 5 ns, "0000000000000000" after 10 ns, "0000000000000000" after 15 ns,
		   "0100000000000000" after 20 ns, "0010000000000000" after 25 ns, "0000000000000000" after 30 ns,
		   "1100000000000000" after 35 ns, "1100000000000000" after 40 ns, "0100000000000000" after 45 ns;

 
	
end addr_gen_tb_arq;