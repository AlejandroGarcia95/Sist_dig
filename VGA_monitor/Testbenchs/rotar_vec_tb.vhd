library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity rot_vec_tb is
end rot_vec_tb;

architecture tb_beh of rot_vec_tb is
	
	signal hs_t, vs_t: std_logic;
	signal red_o_t, grn_o_t: std_logic_vector(2 downto 0);
	signal blu_o_t : std_logic_vector(1 downto 0);
	
	signal x_t, y_t: std_logic_vector(15 downto 0) := (others => '0');

	signal valid_t: std_logic := '0';
	signal go_t: std_logic := '0';

	
	signal clk_t: std_logic := '0';	
	signal reset_t: std_logic := '0';
		
begin		

	myVGA: video_plot
		generic map( COORD_N => 16 )
		port map(
			coord_x => x_t,
			coord_y => y_t,
			valid => valid_t,
			
			rst => reset_t,
			clk => clk_t,
			
			hs => hs_t,
			vs => vs_t,
			red_out => red_o_t,
			grn_out => grn_o_t,
			blu_out => blu_o_t
		);

		
	myCORDIC : logica_rotacional
		generic map(
			COORD_N => 16,
			STAGES => 10,
			ADDR_N => 9
		)
		port map(
			x_out => x_t,
			y_out => y_t,
			valid => valid_t,
			
			z_in => "0011001001000011",
			go => go_t,
			video_reset => reset_t,
			clk => clk_t
		);

	go_t <= '1' after 16000000 ns, '0' after 16000100 ns;
	clk_t <= not clk_t after 10 ns;	
end tb_beh;



