library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity tp_rotador is
	port(
		hs: out std_logic;
		vs: out std_logic;
		red_o: out std_logic_vector(2 downto 0);
		grn_o: out std_logic_vector(2 downto 0);
		blu_o: out std_logic_vector(1 downto 0);
		
	--	go: in std_logic;
		clk: in std_logic
	);
	
	attribute loc: string;
			
	-- Mapeo de pines para el kit Nexys 2 (spartan 3E)
	attribute loc of clk: signal is "B8";
--	attribute loc of go: signal is "H13";
	attribute loc of hs: signal is "T4";
	attribute loc of vs: signal is "U3";
	attribute loc of red_o: signal is "R8 T8 R9";
	attribute loc of grn_o: signal is "P6 P8 N8";
	attribute loc of blu_o: signal is "U4 U5";

end tp_rotador;

architecture tp_rotador_arq of tp_rotador is
	
	signal hs_t, vs_t: std_logic;
	signal red_o_t, grn_o_t: std_logic_vector(2 downto 0);
	signal blu_o_t : std_logic_vector(1 downto 0);
	
	signal x_t, y_t: std_logic_vector(15 downto 0) := (others => '0');

	signal regInt_in, regInt_out: std_logic_vector(32 downto 0);
	
	signal valid_t: std_logic;
	signal go_t, go_cordic: std_logic := '0';

	signal cuenta_out: std_logic_vector(21 downto 0);
	signal clk_t: std_logic := '0';	
	signal reset_t: std_logic := '0';
		
begin		

	myDelayCounter: contador
		generic map( N => 22 )
		port map(
			clk => clk_t,
			rst => '0',
			ena => '1',
			count_out => cuenta_out
		);
		
	process(clk)
		begin
		if rising_edge(clk) then
			if (to_integer(unsigned(cuenta_out)) = 0) then
				go_t <= '1';
			else
				go_t <= '0';
			end if;
		end if;
		end process;

	myVGA: video_plot
		generic map( COORD_N => 16 )
		port map(
			coord_x => regInt_out(31 downto 16),
			coord_y => regInt_out(15 downto 0),
			valid => regInt_out(32),
			
			rst => go_t,
			done_rst => go_cordic,
			clk => clk_t,
			
			hs => hs_t,
			vs => vs_t,
			red_out => red_o_t,
			grn_out => grn_o_t,
			blu_out => blu_o_t
		);

	regInt: registro
		generic map(N => 33)
		port map(
			data_in => regInt_in,
			data_out => regInt_out,
			clk => clk,
			rst => '0',
			load => '1'
		);	
		
	regInt_in <= valid_t & x_t & y_t;
	
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
			
			z_in => "0000101100101011",
			go => go_cordic,
			video_reset => reset_t,
			clk => clk_t
		);

	hs <= hs_t;
	vs <= vs_t;
	red_o <= red_o_t;
	grn_o <= grn_o_t;
	blu_o <= blu_o_t;
		
--	go_t <= go;
	clk_t <= clk;	
end tp_rotador_arq;
