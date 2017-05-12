library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

--El address_generator_3d realiza la traducción de coord.
--lógicas en 3D a coord. de píxeles de pantalla. Para eso
--realiza una proyección paralela sobre el plano yz; es
--decir, a cada pto 3D (x, y, z) lo proyecta como un pto
--(y, z). Como utiliza el address_generator de 2D, el
--área imprimible en pantalla es un cuadrado de 384 píxeles
--centrados en la pantalla de resolución 640x480.
-- Importante: se asume que todos los vectores recibidos
-- son binarios en punto fijo signados, con un único
-- bit de parte entera y coord. en el intervalo [-1,+1]

entity address_generator_3d is
   generic (COORD_N: natural := 10);
   port(
      x_coord: in std_logic_vector(COORD_N-1 downto 0);
	  y_coord: in std_logic_vector(COORD_N-1 downto 0);
	  z_coord: in std_logic_vector(COORD_N-1 downto 0);
      pixel_x: out std_logic_vector(9 downto 0);
	  pixel_y: out std_logic_vector(8 downto 0);
	  ena: in std_logic
   );
end address_generator_3d;

architecture address_generator_3d_arq of address_generator_3d is
begin
	myAG: address_generator
		generic map(COORD_N => COORD_N)
		port map (
			x_coord => y_coord,
			y_coord => z_coord,
			pixel_x => pixel_x,
			pixel_y => pixel_y,
			ena => ena
		);
end address_generator_3d_arq;