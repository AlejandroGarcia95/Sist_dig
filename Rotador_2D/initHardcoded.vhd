library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

-- Componente hardcodeado para inicializar la memoria
-- lógica del Cordic con 256 puntitos x,y que representan
-- un vector (0.4,0).

entity init_hardcoded is
   generic (COORD_N: natural := 16; ADDR_N: natural := 9; CANT_PUNTOS : natural := 256);
   port(
      x_out: out std_logic_vector(COORD_N-1 downto 0);
	  y_out: out std_logic_vector(COORD_N-1 downto 0);
	  addr_x: out std_logic_vector(ADDR_N-1 downto 0);
	  addr_y: out std_logic_vector(ADDR_N-1 downto 0);
	  done: out std_logic;
	  cant_ptos: out std_logic_vector(ADDR_N-1 downto 0);
	  clk: in std_logic
   );
end init_hardcoded;

architecture init_hardcoded_arq of init_hardcoded is
	signal cont_ena: std_logic := '1';
	signal termine: std_logic := '0';
	signal cuenta: std_logic_vector(ADDR_N-1 downto 0);
	type COORDENADAS is array (CANT_PUNTOS-1 downto 0) of std_logic_vector(COORD_N-1 downto 0);	
	signal valores_x: COORDENADAS := ("0000000000000000", "0000000000011011", "0000000000110111", 
	"0000000001010011", "0000000001101111", "0000000010001011", "0000000010100111", "0000000011000011", 
	"0000000011011111", "0000000011111010", "0000000100010110", "0000000100110010", "0000000101001110", 
	"0000000101101010", "0000000110000110", "0000000110100010", "0000000110111110", "0000000111011010", 
	"0000000111110101", "0000001000010001", "0000001000101101", "0000001001001001", "0000001001100101", 
	"0000001010000001", "0000001010011101", "0000001010111001", "0000001011010101", "0000001011110000", 
	"0000001100001100", "0000001100101000", "0000001101000100", "0000001101100000", "0000001101111100", 
	"0000001110011000", "0000001110110100", "0000001111010000", "0000001111101011", "0000010000000111", 
	"0000010000100011", "0000010000111111", "0000010001011011", "0000010001110111", "0000010010010011", 
	"0000010010101111", "0000010011001011", "0000010011100110", "0000010100000010", "0000010100011110", 
	"0000010100111010", "0000010101010110", "0000010101110010", "0000010110001110", "0000010110101010", 
	"0000010111000110", "0000010111100001", "0000010111111101", "0000011000011001", "0000011000110101", 
	"0000011001010001", "0000011001101101", "0000011010001001", "0000011010100101", "0000011011000001", 
	"0000011011011100", "0000011011111000", "0000011100010100", "0000011100110000", "0000011101001100", 
	"0000011101101000", "0000011110000100", "0000011110100000", "0000011110111100", "0000011111010111", 
	"0000011111110011", "0000100000001111", "0000100000101011", "0000100001000111", "0000100001100011", 
	"0000100001111111", "0000100010011011", "0000100010110111", "0000100011010010", "0000100011101110", 
	"0000100100001010", "0000100100100110", "0000100101000010", "0000100101011110", "0000100101111010", 
	"0000100110010110", "0000100110110010", "0000100111001101", "0000100111101001", "0000101000000101", 
	"0000101000100001", "0000101000111101", "0000101001011001", "0000101001110101", "0000101010010001", 
	"0000101010101100", "0000101011001000", "0000101011100100", "0000101100000000", "0000101100011100", 
	"0000101100111000", "0000101101010100", "0000101101110000", "0000101110001100", "0000101110100111", 
	"0000101111000011", "0000101111011111", "0000101111111011", "0000110000010111", "0000110000110011", 
	"0000110001001111", "0000110001101011", "0000110010000111", "0000110010100010", "0000110010111110", 
	"0000110011011010", "0000110011110110", "0000110100010010", "0000110100101110", "0000110101001010", 
	"0000110101100110", "0000110110000010", "0000110110011101", "0000110110111001", "0000110111010101", 
	"0000110111110001", "0000111000001101", "0000111000101001", "0000111001000101", "0000111001100001", 
	"0000111001111101", "0000111010011000", "0000111010110100", "0000111011010000", "0000111011101100", 
	"0000111100001000", "0000111100100100", "0000111101000000", "0000111101011100", "0000111101111000", 
	"0000111110010011", "0000111110101111", "0000111111001011", "0000111111100111", "0001000000000011", 
	"0001000000011111", "0001000000111011", "0001000001010111", "0001000001110011", "0001000010001110", 
	"0001000010101010", "0001000011000110", "0001000011100010", "0001000011111110", "0001000100011010", 
	"0001000100110110", "0001000101010010", "0001000101101110", "0001000110001001", "0001000110100101", 
	"0001000111000001", "0001000111011101", "0001000111111001", "0001001000010101", "0001001000110001", 
	"0001001001001101", "0001001001101001", "0001001010000100", "0001001010100000", "0001001010111100", 
	"0001001011011000", "0001001011110100", "0001001100010000", "0001001100101100", "0001001101001000", 
	"0001001101100100", "0001001101111111", "0001001110011011", "0001001110110111", "0001001111010011", 
	"0001001111101111", "0001010000001011", "0001010000100111", "0001010001000011", "0001010001011110", 
	"0001010001111010", "0001010010010110", "0001010010110010", "0001010011001110", "0001010011101010", 
	"0001010100000110", "0001010100100010", "0001010100111110", "0001010101011001", "0001010101110101", 
	"0001010110010001", "0001010110101101", "0001010111001001", "0001010111100101", "0001011000000001", 
	"0001011000011101", "0001011000111001", "0001011001010100", "0001011001110000", "0001011010001100", 
	"0001011010101000", "0001011011000100", "0001011011100000", "0001011011111100", "0001011100011000", 
	"0001011100110100", "0001011101001111", "0001011101101011", "0001011110000111", "0001011110100011", 
	"0001011110111111", "0001011111011011", "0001011111110111", "0001100000010011", "0001100000101111", 
	"0001100001001010", "0001100001100110", "0001100010000010", "0001100010011110", "0001100010111010", 
	"0001100011010110", "0001100011110010", "0001100100001110", "0001100100101010", "0001100101000101", 
	"0001100101100001", "0001100101111101", "0001100110011001", "0001011110101110", "0001011111100100", 
	"0001100000011011", "0001100001010001", "0001100010001000", "0001100010111111", "0001100011110101", 
	"0001100100101100", "0001100101100010", "0001100110011001", "0001011110101110", "0001011111100100", 
	"0001100000011011", "0001100001010001", "0001100010001000", "0001100010111111", "0001100011110101", 
	"0001100100101100", "0001100101100010", "0001100110011001");		 		 							 			   
	signal valores_y: COORDENADAS := ("0000010000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
	"0000000000000000", "0000000000000000", "0000000000000000", "0000000101000111", "0000000100100011", 
	"0000000011111110", "0000000011011010", "0000000010110110", "0000000010010001", "0000000001101101", 
	"0000000001001000", "0000000000100100", "0000000000000000", "1000000111111111", "1000000111111111", 
	"1000000011111111", "1000000011111111", "1000000011111111", "1000000011111111", "1000000001111111", 
	"1000000001111111", "1000000000111111", "0000000000000000");

--	signal valores_x: COORDENADAS := ("0000000000000000", "0011000000000000", "0001000000000000", "0010000000000000",
--	"0000000000000000");
--	signal valores_y: COORDENADAS := ("0000000000000000", "0011000000000000", "0001000000000000", "0010000000000000",
--	"0000000000000000");								                       
--	signal valores_x: COORDENADAS := ("0000000000000000", "0001000000000000", "0010000000000000", "0000000000000000");
--	signal valores_y: COORDENADAS := ("0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000");
begin													                       
	process(clk)
	begin
		if rising_edge(clk) then
			x_out <= valores_x(to_integer(unsigned(cuenta)));
			y_out <= valores_y(to_integer(unsigned(cuenta)));
			addr_x <= cuenta(ADDR_N-2 downto 0) & '0';
			addr_y <= cuenta(ADDR_N-2 downto 0) & '1';
		end if;
 		if (to_integer(unsigned(cuenta)) = CANT_PUNTOS-1) then 
 			cont_ena <= '0';
 			termine <= '1';
 		else
 			cont_ena <= '1';
 			termine <= '0';
 		end if;
	end process;

	myCounter: contador
		generic map(N => ADDR_N)
		port map (clk, '0', cont_ena, cuenta);

	flipflop: ffd
		port map(clk, '0', '1', termine, done);
		
	cant_ptos <= std_logic_vector(to_unsigned(CANT_PUNTOS, ADDR_N));

end init_hardcoded_arq;