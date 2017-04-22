library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_TP2.all;
use work.includes.all;

entity voltimetro is
	port(
		clk : in std_logic;
		
		opam_in_p : in std_logic;
		opam_in_n : in std_logic;
		res_out : out std_logic;
		
		-- Salidas para VGA
		hsync : out std_logic;
		vsync : out std_logic;
		red_out : out std_logic_vector(2 downto 0);
		grn_out : out std_logic_vector(2 downto 0);
		blu_out : out std_logic_vector(1 downto 0)
		
	);

	attribute loc: string;
			
	-- Mapeo de pines para el kit Nexys 2 (spartan 3E)
	attribute loc of clk: signal is "B8";
	attribute loc of hsync: signal is "T4";
	attribute loc of vsync: signal is "U3";
	attribute loc of red_out: signal is "R8 T8 R9";
	attribute loc of grn_out: signal is "P6 P8 N8";
	attribute loc of blu_out: signal is "U4 U5";
	
	attribute slew: string;
	attribute drive: string;
	attribute iostandard: string;
	
	attribute iostandard of opam_in_p: signal is "LVDS_25";	
	attribute loc of opam_in_p: signal is "G15"; --"D7"		A1
	attribute iostandard of opam_in_n: signal is "LVDS_25";	
	attribute loc of opam_in_n: signal is "G16"; --"E7"		A9

	attribute loc of res_out: signal is "H16";  --"D5"		A4
	attribute slew of res_out: signal is "FAST";
	attribute drive of res_out: signal is "8";
	attribute iostandard of res_out: signal is "LVCMOS25";	
	
	
	
end;

architecture voltimetro_arq of voltimetro is

	signal dgts_aux : std_logic_vector(11 downto 0);
	signal Q_aux, opam_out : std_logic;

	-- 
	component IBUFDS 
		port(
			I : in std_logic; 
			IB : in std_logic; 
			O : out std_logic
		); 
	end component; 
	
	
begin

	myOpam: IBUFDS port map(
		I => opam_in_p,
		IB => opam_in_n,
		O => opam_out
	);

	myDigi : digitilizer
		port map(
			clk => clk,
			sig => Q_aux,
			dgts => dgts_aux
		);

	myVGA : video_logic
		port map(clk, dgts_aux, hsync, vsync, red_out, grn_out, blu_out);
	
--	myFreqDiv : freq_div
--		generic map(N => 1, M => 6)
--		port map(
--			clk => clk,
--			rst => '0',
--			ena => '1',
--			clk_out => sig_aux
--		);
		
	myFFD : ffd
	   port map(
		  clk => clk,
		  rst => '0',
		  ena => '1',
		  D => opam_out,
		  Q => Q_aux
	   );
	   
	res_out <= Q_aux; 
	
end voltimetro_arq;