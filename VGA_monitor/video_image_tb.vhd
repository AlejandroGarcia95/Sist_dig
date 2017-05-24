library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity video_img_tb is
end video_img_tb;

architecture tb_beh of video_img_tb is
	
	signal pr_t, pc_t: std_logic_vector(9 downto 0) := (others => '0');
	signal pr_i_t, pc_i_t: std_logic_vector(9 downto 0) := (others => '0');
	
	signal w_t: std_logic := '1';
	signal reg_t: std_logic_vector(2 downto 0);
	signal reg_o_t : std_logic_vector(2 downto 0);
	
	signal hs_t, vs_t: std_logic;
	signal red_o_t, grn_o_t: std_logic_vector(2 downto 0);
	signal blu_o_t : std_logic_vector(1 downto 0);
	
	signal x_t, y_t: std_logic_vector(15 downto 0) := (others => '0');
	signal pixel_x_t: std_logic_vector(9 downto 0) := (others => '0');
	signal pixel_y_t: std_logic_vector(8 downto 0) := (others => '0');
	signal ena_t: std_logic := '1';
	signal done_t: std_logic;

	
	signal clk_t: std_logic := '0';
	
	signal reset_t: std_logic := '0';
		
begin		
	v_ctrl : vga_ctrl
		port map(clk_t, reg_o_t(0), reg_o_t(1), reg_o_t(2),
				hs_t, vs_t,
				red_o_t, grn_o_t, blu_o_t,
				pr_t, pc_t
		);

	v_ram : video_ram
		generic map(3)
		port map(
			clk => clk_t,
			pixel_col_out => pc_t,
			pixel_row_out => pr_t,
			data_out => reg_o_t,
			
			-- Para editar valores de la memoria
			pixel_col_in => pc_i_t,
			pixel_row_in => pr_i_t,
			data_in => reg_t,
			write_flag => w_t,
			
			reset => reset_t
		);
		
	myHard: init_hardcoded
		generic map(COORD_N => 16, ADDR_N => 9, CANT_PUNTOS => 256)
		port map (x_t, y_t, open, open, open, open, clk_t);

	myCS: address_generator
		generic map(COORD_N => 16)
		port map (x_t, y_t, pixel_x_t, pixel_y_t, ena_t);
	
	pc_i_t <= pixel_x_t(9 downto 0);
	pr_i_t <= '0' & pixel_y_t(8 downto 0);
	
	reg_t <= "111";
	w_t <= '0' after 5120 ns;
	clk_t <= not clk_t after 10 ns;
	
end tb_beh;



