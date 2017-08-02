library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity tp_rotador_3d is
	port(
		hs: out std_logic;
		vs: out std_logic;
		red_o: out std_logic_vector(2 downto 0);
		grn_o: out std_logic_vector(2 downto 0);
		blu_o: out std_logic_vector(1 downto 0);
		
		go_x: in std_logic;
		go_y: in std_logic;
		go_z: in std_logic;
		
		rx: in std_logic;
		done_uart: out std_logic;
		clk: in std_logic
	);
	
	attribute loc: string;
			
	-- Mapeo de pines para el kit Nexys 2 (spartan 3E)
	attribute loc of clk: signal is "B8";
	attribute loc of go_x: signal is "H13";
	attribute loc of go_y: signal is "E18";
	attribute loc of go_z: signal is "D18";
	attribute loc of hs: signal is "T4";
	attribute loc of vs: signal is "U3";
	attribute loc of red_o: signal is "R8 T8 R9";
	attribute loc of grn_o: signal is "P6 P8 N8";
	attribute loc of blu_o: signal is "U4 U5";
	
	attribute loc of rx: signal is "U6";
	attribute loc of done_uart: signal is "J14";

end tp_rotador_3d;

architecture tp_rotador_3d_arq of tp_rotador_3d is
	
	signal hs_t, vs_t: std_logic;
	signal red_o_t, grn_o_t: std_logic_vector(2 downto 0);
	signal blu_o_t : std_logic_vector(1 downto 0);
	
	signal x_t, y_t, z_t: std_logic_vector(15 downto 0) := (others => '0');
	signal angx_t, angy_t, angz_t: std_logic_vector(15 downto 0) := (others => '0');

	signal regInt_in, regInt_out: std_logic_vector(48 downto 0);
	
	signal valid_t: std_logic;
	signal go_t, go_cordic: std_logic := '0';

	signal cuenta_out: std_logic_vector(23 downto 0);
	signal clk_t: std_logic := '0';	
	signal reset_t: std_logic := '0';
		
begin		

	myDelayCounter: contador
		generic map( N => 24 )
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
				if ((go_x = '1') or (go_y = '1') or (go_z = '1')) then
					go_t <= '1';
				else
					go_t <= '0';
				end if;
			else
				go_t <= '0';
			end if;
		end if;
		end process;

	myVGA: video_plot_3d
		generic map( COORD_N => 16 )
		port map(
			coord_x => regInt_out(47 downto 32),
			coord_y => regInt_out(31 downto 16),
			coord_z => regInt_out(15 downto 0),
			valid => regInt_out(48),
			
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
		generic map(N => 49)
		port map(
			data_in => regInt_in,
			data_out => regInt_out,
			clk => clk,
			rst => '0',
			load => '1'
		);	
		
	regInt_in <= valid_t & x_t & y_t &z_t;
	
	myCORDIC : logica_rotacional_3d
		generic map(
			COORD_N => 16,
			ADDR_N => 11
		)
		port map(
			x_out => x_t,
			y_out => y_t,
			z_out => z_t,
			valid => valid_t,
			ang_x_in => angx_t,
			ang_y_in => angy_t,
			ang_z_in => angz_t,
			go => go_cordic,
			video_reset => reset_t,
			rx => rx,
			done_uart => done_uart,
			clk => clk_t
		);

	angx_t <= "0000010110010101" when (go_x='1') else "0000000000000000";
	angy_t <= "0000010110010101" when (go_y='1') else "0000000000000000";	
	angz_t <= "0000010110010101" when (go_z='1') else "0000000000000000";		
		
	hs <= hs_t;
	vs <= vs_t;
	red_o <= red_o_t;
	grn_o <= grn_o_t;
	blu_o <= blu_o_t;
		
--	go_t <= go;
	clk_t <= clk;	
end tp_rotador_3d_arq;
