library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity tira_coord is
   port(
      x_out: out std_logic_vector(15 downto 0);
	  y_out: out std_logic_vector(15 downto 0);
	  clk: in std_logic
   );
end tira_coord;

architecture tira_coord_arq of tira_coord is
	signal cont_ena: std_logic := '1';
	signal cuenta: std_logic_vector(4 downto 0);
	type COORDENADAS is array (12 downto 0) of std_logic_vector(15 downto 0);	
						                       
	signal valores_x: COORDENADAS := ("0000000000000000", "0001000000000000", "0000100000000000", "0000010010001110", 
	"0000100100011110", "1000000001010110", "1000000010101011", "1000010100011110", "1000101000111101",
	"1000100001000100", "1001000010001100", "1000100011000110", "1001000110010010");
	signal valores_y: COORDENADAS := ("0000000000000000", "0000100000000000", "0000010000000000", "0000011110110010",
	"0000111101100100", "0000100011101110", "0001000111011111", "0000011101010010", "0000111010101000", 
	"0000001101100001", "0000011011000110", "1000000110100011", "1000001101000100");
begin													                       
	process(clk)
	begin
		if rising_edge(clk) then
			x_out <= valores_x(to_integer(unsigned(cuenta)));
			y_out <= valores_y(to_integer(unsigned(cuenta)));
		end if;
 		if (to_integer(unsigned(cuenta)) = 12) then 
 			cont_ena <= '0';
 		else
 			cont_ena <= '1';
 		end if;
	end process;

	myCounter: contador
		generic map(N => 5)
		port map (clk, '0', cont_ena, cuenta);

end tira_coord_arq;