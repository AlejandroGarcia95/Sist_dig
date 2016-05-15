library IEEE;
use IEEE.std_logic_1164.all;
use work.includes.all;

package includes_TP2 is

	component contador_TP2 is
		generic( N : natural := 2;
				 TOPE : natural := 3);
		port (
			clk: in std_logic;			-- clock
			out_store: out std_logic;	-- se pone en 1 cuando la cuenta alcanza TOPE-2
			out_reset: out std_logic	-- se pone en 1 cuando la cuenta alcanza TOPE-1
		);
	end component contador_TP2;
	
	component digitilizer is
	port(
		clk : in std_logic;
		sig : in std_logic;
		dgts : out std_logic_vector(11 downto 0)	-- 3 digitos BCD.. dgt1 = dgts[11..8], dgt2 = dgts[7..4], dgt3 = dgts[3..0]	
	);
	end component;
		
	component vga_logic is
		port (
			digit_selector: out std_logic_vector(2 downto 0);
			font_row, font_col: out std_logic_vector(2 downto 0);
			pixel_row: in std_logic_vector(9 downto 0);
			pixel_col: in std_logic_vector(9 downto 0)
		);
	end component;	
	
	
	
	component video_logic is
		port(
			clk : in std_logic;
			dgts : in std_logic_vector(11 downto 0);	-- 3 digitos BCD.. dgt1 = dgts[11..8], dgt2 = dgts[7..4], dgt3 = dgts[3..0]
														-- dgt1 es la unidad, dgt2 es el décimo, y dgt3 es el centésimo
		
			-- Salidas para VGA
			hsync : out std_logic;
			vsync : out std_logic;
			red_out : out std_logic_vector(2 downto 0);
			grn_out : out std_logic_vector(2 downto 0);
			blu_out : out std_logic_vector(1 downto 0)
		);
	end component video_logic;
		
	
	-- Componentes que no hicimos nosotros

	component vga_ctrl is
		port (
			mclk: in std_logic;
			red_i: in std_logic;
			grn_i: in std_logic;
			blu_i: in std_logic;
			hs: out std_logic;
			vs: out std_logic;
			red_o: out std_logic_vector(2 downto 0);
			grn_o: out std_logic_vector(2 downto 0);
			blu_o: out std_logic_vector(1 downto 0);
			pixel_row: out std_logic_vector(9 downto 0);
			pixel_col: out std_logic_vector(9 downto 0)
		);
	end component vga_ctrl;
		
	component Char_ROM is
		generic(
			N: integer:= 6;
			M: integer:= 3;
			W: integer:= 8
		);
		port(
			char_address: in std_logic_vector(5 downto 0);
			font_row, font_col: in std_logic_vector(M-1 downto 0);
			rom_out: out std_logic
		);
	end component Char_ROM;
	
	
end package;