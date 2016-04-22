library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb is
end tb;

architecture tb_beh of tb is
	component vga_logic is
		port (
			digit_selector: out std_logic_vector(2 downto 0);
			font_row, font_col: out std_logic_vector(2 downto 0);
			pixel_row: in std_logic_vector(9 downto 0);
			pixel_col: in std_logic_vector(9 downto 0)
		);
	end component;
	
	component contador is
		generic( N : natural := 2;
				 TOPE : natural := 3);
		port (
			clk: in std_logic;		-- clock
			rst: in std_logic;		-- reset, coloca el contador en 0
			ena: in std_logic;		-- enable
			count_out: out std_logic_vector(N-1 downto 0)
		);
	end component;	

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



