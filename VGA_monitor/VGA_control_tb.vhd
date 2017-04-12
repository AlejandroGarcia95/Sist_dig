library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_vga.all;
use work.includes.all;

entity vga_ctrl_tb is
end vga_ctrl_tb;

architecture tb_beh of vga_ctrl_tb is
	
	signal pr_t, pc_t: std_logic_vector(9 downto 0);
	
	signal hs_t, vs_t: std_logic;
	signal red_i_t, grn_i_t, blu_i_t: std_logic := '0';
	
	signal red_o_t, grn_o_t: std_logic_vector(2 downto 0);
	signal blu_o_t : std_logic_vector(1 downto 0);
	
	signal clk_t: std_logic := '0';
	
	
		
begin
	vga : vga_ctrl
		port map(clk_t, red_i_t, grn_i_t, blu_i_t,
				hs_t, vs_t,
				red_o_t, grn_o_t, blu_o_t,
				pr_t, pc_t
		);
		
	red_i_t <= pc_t(7);
	blu_i_t <= pr_t(7);
	grn_i_t <= pc_t(6);
	
	
	clk_t <= not clk_t after 10 ns;	
	
end tb_beh;



