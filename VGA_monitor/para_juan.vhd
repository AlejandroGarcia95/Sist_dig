library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity para_juan is
	port(
		hs: out std_logic;
		vs: out std_logic;
		red_o: out std_logic_vector(2 downto 0);
		grn_o: out std_logic_vector(2 downto 0);
		blu_o: out std_logic_vector(1 downto 0);
		
		rx: in std_logic;
		
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
	attribute loc of rx: signal is "U6";
	
end para_juan;

architecture para_juan_arq of para_juan is
	
	signal hs_t, vs_t: std_logic;
	signal red_o_t, grn_o_t: std_logic_vector(2 downto 0);
	signal blu_o_t : std_logic_vector(1 downto 0);
	
	signal x_t, y_t, z_t: std_logic_vector(15 downto 0) := (others => '0');

	signal valid_t: std_logic;

	signal clk_t: std_logic := '0';	
	signal reset_t: std_logic := '0';
		
begin		
	
	-- Simplemente instancia acá tu coso UART que tira los puntos,
	-- sacándolos en x_t, y_t y z_t. El address y la señal de que
	-- terminaste no tenés que mappearlas a ningún lado. Sin embargo,
	-- se requiere en valid_t un bit de que el punto es válido. Si no
	-- tenés ninguno en tu componente, podrías sólamente poner a valid_t
	-- en 0 cuando la address es inválida y ya.
	
	myUART : uart
		generic map( COORD_N => 16, ADDR_N => 11, NPOINTS => 506, BAUDRATE => 163 )
		port map(
			rx => rx,
			x_coord => x_t,
			y_coord => y_t,
			z_coord => z_t,
			
			addr => open,
			valid => valid_t,
			done => open,
			
			clk => clk_t
		);	
	
	myVGA: video_plot_3d
		generic map( COORD_N => 16 )
		port map(
			coord_x => x_t,
			coord_y => y_t,
			coord_z => z_t,
			valid => valid_t,
			
			rst => '0',
			done_rst => open,
			clk => clk_t,
			
			hs => hs_t,
			vs => vs_t,
			red_out => red_o_t,
			grn_out => grn_o_t,
			blu_out => blu_o_t
		);

		
	hs <= hs_t;
	vs <= vs_t;
	red_o <= red_o_t;
	grn_o <= grn_o_t;
	blu_o <= blu_o_t;
		
	clk_t <= clk;	
end para_juan_arq;
