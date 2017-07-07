
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity ensayo_dos is
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

end ensayo_dos;

architecture ensayo_dos_arq of ensayo_dos is
	
	signal hs_t, vs_t: std_logic;
	signal red_o_t, grn_o_t: std_logic_vector(2 downto 0);
	signal blu_o_t : std_logic_vector(1 downto 0);
	
	signal x_t, y_t: std_logic_vector(15 downto 0) := (others => '0');

	signal clk_t: std_logic := '0';	
	
	-- Replace componente tira_coord by the new UART
	-- module to test it on screen.
	-- Lab UART: Your code here.
	component tira_coord is
	   port(
		  x_out: out std_logic_vector(15 downto 0);
		  y_out: out std_logic_vector(15 downto 0);
		  clk: in std_logic
	   );
	end component tira_coord;
		
begin		
	myVGA: video_plot
		generic map( COORD_N => 16 )
		port map(
			coord_x => x_t,
			coord_y => y_t,
			valid => '1',
			
			rst => '0',
			clk => clk_t,
			
			hs => hs_t,
			vs => vs_t,
			red_out => red_o_t,
			grn_out => grn_o_t,
			blu_out => blu_o_t
		);

	tp: tira_coord
		port map (x_t, y_t, clk_t);	


	hs <= hs_t;
	vs <= vs_t;
	red_o <= red_o_t;
	grn_o <= grn_o_t;
	blu_o <= blu_o_t;
		
	clk_t <= clk;	
end ensayo_dos_arq;