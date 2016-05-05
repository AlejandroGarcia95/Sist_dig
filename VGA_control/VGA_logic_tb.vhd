library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_TP2.all;
use work.includes.all;

entity vga_logic_tb is
end vga_logic_tb;

architecture tb_beh of vga_logic_tb is
	
	signal pr_t, pc_t: std_logic_vector(9 downto 0);
	signal dig_sel_t: std_logic_vector(2 downto 0);
	signal fr_t, fc_t: std_logic_vector(2 downto 0);
	signal clk_t: std_logic := '0';
	
	signal aux_col_ena: std_logic := '0';
		
begin
	cont_col : contador
		generic map(10, 639)
		port map(clk_t, '0', '1', pc_t);

	process(pc_t)
	begin
		if (unsigned(pc_t) = 639) then
			aux_col_ena <= '1';
		else
			aux_col_ena <= '0';
		end if;
	end process;
			
	cont_row : contador
		generic map(10, 480)
		port map(clk_t, '0', aux_col_ena, pr_t);
		
	myControl : vga_logic
		port map(
			digit_selector => dig_sel_t,
			font_row => fr_t,
			font_col => fc_t,
			pixel_row => pr_t,
			pixel_col => pc_t
		);
	
	clk_t <= not clk_t after 10 ns;	

end tb_beh;



