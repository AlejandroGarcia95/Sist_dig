library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

-- Componente hardcodeado para inicializar la memoria
-- lógica del Cordic con 256 puntitos x,y que representan
-- un vector (0.4,0).

entity tira_pixeles is
   port(
      px_out: out std_logic_vector(9 downto 0);
	  py_out: out std_logic_vector(8 downto 0);
	  clk: in std_logic
   );
end tira_pixeles;

architecture tira_pixeles_arq of tira_pixeles is
	signal cont_ena: std_logic := '1';
	signal cuenta: std_logic_vector(5 downto 0);
	type COORDENADAS is array (18 downto 0) of integer;	
							                       
	signal valores_x: COORDENADAS := (320, 344, 368, 334, 347, 319, 318, 304, 289,
								295, 270, 293, 267, 301, 281, 313, 307, 328, 337);
	signal valores_y: COORDENADAS := (240, 228, 216, 217, 194, 214, 187, 218, 196, 
								230, 220, 245, 250, 259, 277, 266, 292, 265, 291);
begin													                       
	process(clk)
	begin
		if rising_edge(clk) then
			px_out <= std_logic_vector(to_unsigned(valores_x(to_integer(unsigned(cuenta))), 10));
			py_out <= std_logic_vector(to_unsigned(valores_y(to_integer(unsigned(cuenta))), 9));
		end if;
 		if (to_integer(unsigned(cuenta)) = 18) then 
 			cont_ena <= '0';
 		else
 			cont_ena <= '1';
 		end if;
	end process;

	myCounter: contador
		generic map(N => 6)
		port map (clk, '0', cont_ena, cuenta);

end tira_pixeles_arq;