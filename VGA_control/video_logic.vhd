library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_TP2.all;

entity video_logic is
	port(
		clk : in std_logic;
		dgts : in std_logic_vector(11 downto 0);	-- 3 digitos BCD.. dgt1 = dgts[11..8], dgt2 = dgts[7..4], dgt3 = dgts[3..0]
													-- dgt1 es la unidad, dgt2 es el décimo, y dgt3 es el centésimo
	
		-- Salidas para VGA
		hsync : out std_logic;
		vsync : out std_logic;
		red_out : out std_logic;
		grn_out : out std_logic;
		blu_out : out std_logic
	);
end video_logic;


architecture video_logic_arc of video_logic is

	-- Auxiliares para el multiplexor
	signal mux_selected : std_logic_vector(5 downto 0);	-- Salida del multiplexor del selector de
														-- caracteres (a la memoria ROM para recuperar información visual)
	signal mux_selector_aux : std_logic_vector(3 downto 0);
	
	-- Señal auxiliar para conectar VGA_Logic con Char_ROM
	signal f_col_aux, f_row_aux : std_logic_vector(2 downto 0);
	
	-- Señales auxiliares para conectar VGA_logic con VGA_printer
	signal p_col_aux, p_row_aux : std_logic_vector(9 downto 0);
	
	-- Señal auxiliar para la salida de Char_ROM
	signal rom_out_aux : std_logic;
	
begin

	myLogic : VGA_logic
		port map(
			digit_selector => mux_selector_aux,
			font_row => f_row_aux,
			font_col => f_row_aux,
			pixel_col => p_col_aux,
			pixel_row => p_row_aux
		);

	myVGA_Control : vga_ctrl
		port map(
			mclk => clk,
			red_i => rom_out_aux,
			grn_i => rom_out_aux,
			blu_i => '1',
			
			hs => hsync,
			vs => vsync,
			red_o => red_out,
			grn_o => grn_out,
			blu_o => blu_out,
			
			pixel_row => p_col_aux,
			pixel_col => p_row_aux		
		);
		
	myROM : Char_ROM
		generic map (N => 6, M => 3, W => 8)
		port map (
			char_address => mux_selected,
			font_row => f_row_aux,
			font_col => f_col_aux,
			rom_out => rom_out_aux		
		);
		
	with mux_selector_aux select
	mux_selected <= "00" & dgts(11 downto 8) when "000"
					"00" & dgts(7 downto 4) when "001"
					"00" & dgts(3 downto 0) when "010"
					"001011" when "011"						-- Se supone que es la address de la ","
					"001010" when "100"						-- Idem para la "V"
					"001100" when others;					-- Alguna dirección en blanco
		
end video_logic_arc;