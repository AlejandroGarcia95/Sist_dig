library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga_logic is
    port (
		digit_selector: out std_logic_vector(2 downto 0);
		font_row, font_col: out std_logic_vector(2 downto 0);
		pixel_row: in std_logic_vector(9 downto 0);
		pixel_col: in std_logic_vector(9 downto 0)
	);
end vga_logic;

architecture vga_logic_arq of vga_logic is 
	
	constant block_row_d1: unsigned(6 downto 0) := "0000000";
	constant block_col_d1: unsigned(6 downto 0) := "0000000";

	constant block_row_comma: unsigned(6 downto 0) := "0000000";
	constant block_col_comma: unsigned(6 downto 0) := "0000001";
	
	constant block_row_d2: unsigned(6 downto 0) := "0000000";
	constant block_col_d2: unsigned(6 downto 0) := "0000010";
	
	constant block_row_d3: unsigned(6 downto 0) := "0000000";
	constant block_col_d3: unsigned(6 downto 0) := "0000011";
	
	constant block_row_V: unsigned(6 downto 0) := "0000000";
	constant block_col_V: unsigned(6 downto 0) := "0000100";
	
	signal block_row, block_col: std_logic_vector(6 downto 0);
	
begin
	block_row <= pixel_row(9 downto 3);
	block_col <= pixel_col(9 downto 3);
	
	font_row <= pixel_row(2 downto 0);
	font_col <= pixel_col(2 downto 0);
	
	process(block_row, block_col)
	begin
		if (unsigned(block_row) = block_row_d1 and unsigned(block_col) = block_col_d1) then
			digit_selector <= "001";
		elsif (unsigned(block_row) = block_row_comma and unsigned(block_col) = block_col_comma) then
			digit_selector <= "010";
		elsif (unsigned(block_row) = block_row_d2 and unsigned(block_col) = block_col_d2) then
			digit_selector <= "011";
		elsif (unsigned(block_row) = block_row_d3 and unsigned(block_col) = block_col_d3) then
			digit_selector <= "100";
		elsif (unsigned(block_row) = block_row_V and unsigned(block_col) = block_col_V) then
			digit_selector <= "101";
		else
			digit_selector <= "000";
		end if;
	end process;
			
end vga_logic_arq;