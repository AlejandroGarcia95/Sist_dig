library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

-- El address_generator realiza la traducción de coord.
-- lógicas (x,y) a coordenadas de píxeles en pantalla.
-- Para ello, mappea el intervalo [-1,+1] a 384 píxeles
-- en pantalla, centrados en resolución de 640x480.
-- Es decir, las sgtes coord. lógicas (x,y) mappean a
-- los sgtes valores (row, col) de píxeles:
-- (x,y)=(0,0) --> (pixel_row, pixel_col)=(320,240)
-- (x,y)=(1,0) --> (pixel_row, pixel_col)=(512,240)
-- (x,y)=(0,1) --> (pixel_row, pixel_col)=(320,48)
-- (x,y)=(-1,0) --> (pixel_row, pixel_col)=(128,240)
-- (x,y)=(0,-1) --> (pixel_row, pixel_col)=(320,432)
-- Importante: se asume que todos los vectores recibidos
-- son binarios en punto fijo signados, con un único
-- bit de parte entera y coord. en el intervalo [-1,+1]

entity address_generator is
   generic (COORD_N: natural := 10);
   port(
      x_coord: in std_logic_vector(COORD_N-1 downto 0);
	  y_coord: in std_logic_vector(COORD_N-1 downto 0);
      pixel_x: out std_logic_vector(9 downto 0);
	  pixel_y: out std_logic_vector(8 downto 0);
	  ena: in std_logic
   );
end address_generator;

architecture address_generator_arq of address_generator is
	constant x_center : integer := 128;
	constant y_center : integer := 48;
	constant screen_height: integer := 480;
	signal pixel_x_sin_centrado: std_logic_vector(9 downto 0);
	signal pixel_y_sin_centrado: std_logic_vector(8 downto 0);
	signal px_x: std_logic_vector(COORD_N-1 downto COORD_N-11);
	signal px_y: std_logic_vector(COORD_N-1 downto COORD_N-10);
	signal shift_uno: std_logic_vector(COORD_N downto 0) := ("001") & (COORD_N-3 downto 0 => '0');
	signal coord_x_ext, coord_y_ext, sum_x_out, sum_y_out: std_logic_vector(COORD_N downto 0);
begin
	coord_x_ext <= (x_coord(COORD_N-1)) & '0' & (x_coord(COORD_N-2 downto 0));
	coord_y_ext <= (y_coord(COORD_N-1)) & '0' & (y_coord(COORD_N-2 downto 0));
	-- Sumo 1 para que los valores queden en el intervalo (0, +2)
	SR_y: sum_rest_signed
		generic map(N => COORD_N+1)
		port map (coord_y_ext, shift_uno, '0', open, sum_y_out, '1');
	SR_x: sum_rest_signed
		generic map(N => COORD_N+1)
		port map (coord_x_ext, shift_uno, '0', open, sum_x_out, '1');
	-- Aplico factores de escala para que los valores mapeen a un
	-- a un cuadrado de 384x384
	with ena select
		px_x <= 	(others => '0') when '0',
					--(std_logic_vector(unsigned('0' & sum_x_out(COORD_N-1 downto COORD_N-9)) + unsigned("00" & sum_x_out(COORD_N-1 downto COORD_N-8)) + x_center)) when '1',
					(std_logic_vector(unsigned('0' & sum_x_out(COORD_N-1 downto COORD_N-10)) + unsigned("00" & sum_x_out(COORD_N-1 downto COORD_N-9)))) when '1',
					(others => '0') when others;
				
	with ena select
		px_y <= 	(others => '0') when '0',
					--(std_logic_vector(screen_height - unsigned(sum_y_out(COORD_N-1 downto COORD_N-9)) - unsigned('0' & sum_y_out(COORD_N-1 downto COORD_N-8)) - y_center)) when '1',
					(std_logic_vector(unsigned(sum_y_out(COORD_N-1 downto COORD_N-10)) + unsigned('0' & sum_y_out(COORD_N-1 downto COORD_N-9)))) when '1',
					(others => '0') when others;
	-- Redondeo el resultado a la cant. de bits que necesito
 	Red_x: redondeador
 		generic map(N_INICIAL => 11, N_FINAL => 10)
 		port map (px_x, pixel_x_sin_centrado);
 	Red_y: redondeador
 		generic map(N_INICIAL => 10, N_FINAL => 9)
		port map (px_y, pixel_y_sin_centrado);
	-- Desplazo los valores para que el cuadrado quede centrado	
	pixel_x <= std_logic_vector(unsigned(pixel_x_sin_centrado) + x_center);
	pixel_y <= std_logic_vector(screen_height - unsigned(pixel_y_sin_centrado) - y_center);
end address_generator_arq;