
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity ensayo_uno is
	port(
		hs: out std_logic;
		vs: out std_logic;
		red_o: out std_logic_vector(2 downto 0);
		grn_o: out std_logic_vector(2 downto 0);
		blu_o: out std_logic_vector(1 downto 0);
		clk: in std_logic
	);
	
	attribute loc: string;
			
	-- Mapeo de pines para el kit Nexys 2 (spartan 3E)
	attribute loc of clk: signal is "B8";
	attribute loc of hs: signal is "T4";
	attribute loc of vs: signal is "U3";
	attribute loc of red_o: signal is "R8 T8 R9";
	attribute loc of grn_o: signal is "P6 P8 N8";
	attribute loc of blu_o: signal is "U4 U5";

end ensayo_uno;

architecture ensayo_uno_arq of ensayo_uno is
	
	signal hs_t, vs_t: std_logic;
	signal red_o_t, grn_o_t: std_logic_vector(2 downto 0);
	signal blu_o_t : std_logic_vector(1 downto 0);
	
	signal x_t, y_t: std_logic_vector(15 downto 0) := (others => '0');

	signal clk_t: std_logic := '0';	
	signal pixel_col, pixel_row: std_logic_vector(9 downto 0);
	signal address_x: std_logic_vector(9 downto 0) := (others => '0');
	signal address_y: std_logic_vector(8 downto 0) := (others => '0');
	signal address_col, address_row: std_logic_vector(9 downto 0);
	-- Salida y entrada de la memoria RAM
	signal mem_out: std_logic_vector(0 downto 0) := (others => '0');
	signal mem_in: std_logic_vector(0 downto 0) := (others => '0');
	
   component tira_pixeles is
   port(
      px_out: out std_logic_vector(9 downto 0);
	  py_out: out std_logic_vector(8 downto 0);
	  clk: in std_logic
	);
	end component tira_pixeles;
		
begin		
	-- El controlador que hace el barrido y genera salida vga
	v_ctrl : vga_ctrl
		port map(
			mclk => clk,
			red_i => mem_out(0),
			grn_i => mem_out(0),
			blu_i => mem_out(0),
			hs => hs_t,
			vs => vs_t,
			red_o => red_o_t,
			grn_o => grn_o_t,
			blu_o => blu_o_t,
			pixel_row => pixel_row,
			pixel_col => pixel_col
		);

	-- La memoria de video RAM dual port
	v_ram : video_ram
		generic map(N => 1)
		port map(
			clk => clk,
			pixel_col_out => pixel_col,
			pixel_row_out => pixel_row,
			data_out => mem_out,
			
			pixel_col_in => address_col,
			pixel_row_in => address_row,
			data_in => "1",
			
			write_flag => '1',
			reset => '0'
		);

	tp: tira_pixeles
		port map (address_x, address_y, clk_t);	

	address_col <= address_x(9 downto 0);
	address_row <= '0' & address_y(8 downto 0);
		
	hs <= hs_t;
	vs <= vs_t;
	red_o <= red_o_t;
	grn_o <= grn_o_t;
	blu_o <= blu_o_t;
		
	clk_t <= clk;	
end ensayo_uno_arq;