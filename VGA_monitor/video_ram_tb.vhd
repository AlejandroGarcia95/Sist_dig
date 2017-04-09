library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_vga.all;
use work.includes.all;

entity video_ram_tb is
end video_ram_tb;

architecture tb_beh of video_ram_tb is
	
	signal pr_t, pc_t: std_logic_vector(9 downto 0) := (others => '0');
	signal pc2_t: std_logic_vector(9 downto 0) := (others => '0');

	
	signal w_t: std_logic := '1';
	signal reg_t: std_logic_vector(2 downto 0);
	signal reg_o_t : std_logic_vector(2 downto 0);
	
	signal clk_t: std_logic := '0';
	signal clk2_t: std_logic := '0';
	
	
		
begin

	cont_col : contador
		generic map(10, 10)
		port map(clk_t, '0', '1', pc_t);

	cont2_col : contador
		generic map(10, 10)
		port map(clk2_t, '0', '1', pc2_t);

		
	v_ram : video_ram
		generic map(640, 480, 3)
		port map(
			clk => clk_t,
			pixel_col_out => pc2_t,
			pixel_row_out => pr_t,
			data_out => reg_o_t,
			
			-- Para editar valores de la memoria
			pixel_col_in => pc_t,
			pixel_row_in => pr_t,
			data_in => reg_t,
			write_flag => w_t
		);

	reg_t <= "111";
	clk_t <= not clk_t after 100 ns;	
	clk2_t <= not clk2_t after 200 ns;	

	w_t <= '0' after 1200 ns;
	
end tb_beh;



