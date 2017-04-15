library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_cordic.all;
-- La entidad cordic_stage representa cada una
-- de las etapas de rotación en el algoritm de
-- Cordic. Es decir, esta entidad genera UNA
-- iteración del algoritmo. Para ello, recibe
-- las coord. x,y "viejas" del pto a rotar y
-- genera un nuevo par de coord. "nuevas". La
-- entidad requiere el valor del acumulador ang.
-- z y la "cte" que representa la Arc tg(2**-i).
-- Requiere además el valor de iteración i.
-- Los generics y sus significados son:
-- *COORD_N: cant. de bits usados para representar
-- las coord. x,y incluido el bit de signo.
-- *Z_N: cant. de bits usados para representar
-- el ángulo (en radianes) incluido el bit de signo.
-- I: número de iteración del algoritmo de Cordic.
-- La primer iteración es la iteración I = 0.

entity cordic_stage is
   generic (COORD_N: natural := 10; Z_N: natural := 10; I: natural := 0);
   port(
      x_old: in std_logic_vector(COORD_N-1 downto 0);
	  y_old: in std_logic_vector(COORD_N-1 downto 0);
	  z_old: in std_logic_vector(Z_N-1 downto 0);
      x_new: out std_logic_vector(COORD_N-1 downto 0);
	  y_new: out std_logic_vector(COORD_N-1 downto 0);
	  z_new: out std_logic_vector(Z_N-1 downto 0);
	  valid_in: in std_logic;
	  valid_out: out std_logic;
	  cte: in std_logic_vector(Z_N-1 downto 0);
	  clk: in std_logic;
	  flush: in std_logic
   );
end cordic_stage;

architecture cordic_stage_arq of cordic_stage is
	signal signo_z, no_signo_z: std_logic;
	signal x_o, y_o, aux_a, aux_b: std_logic_vector(COORD_N-1 downto 0);
	signal z_o: std_logic_vector(Z_N-1 downto 0);
	signal v_o: std_logic := '0';
begin
	signo_z <= z_old(Z_N-1);
	no_signo_z <= not(signo_z);
	aux_a <= (x_old(COORD_N-1) & (I-1 downto 0 => '0')& x_old(COORD_N-2 downto I)); 
	aux_b <= (y_old(COORD_N-1) & (I-1 downto 0 => '0')& y_old(COORD_N-2 downto I)); 
--	aux_a <= (x_old(COORD_N-1) & (vec_ceros or (x_old(COORD_N-I-2 downto 0))));
--	aux_b <= (y_old(COORD_N-1) & (vec_ceros or (y_old(COORD_N-I-2 downto 0))));
	
	SR_y: sum_rest_signed
		generic map(N => COORD_N)
		port map (y_old, aux_a, '0', open, y_o, no_signo_z);
	SR_x: sum_rest_signed
		generic map(N => COORD_N)
		port map (x_old, aux_b, '0', open, x_o, signo_z);
	SR_z: sum_rest_signed
		generic map(N => Z_N)
		port map (z_old, cte, '0', open, z_o, signo_z);
	
	reg_x: registro
		generic map(N => COORD_N)
		port map(x_o, x_new, clk, flush, '1');
	reg_y: registro
		generic map(N => COORD_N)
		port map(y_o, y_new, clk, flush, '1');
	reg_z: registro
		generic map(N => Z_N)
		port map(z_o, z_new, clk, flush, '1');
	reg_V: ffd
		port map(clk, flush, '1', valid_in, v_o);

	valid_out <= v_o;
end cordic_stage_arq;