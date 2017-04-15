library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_cordic.all;
-- El cordic_pipeline emplea el algoritmo de
-- Cordic para rotar un vector de coord. orig.
-- (x_old, y_old) un ángulo de z_old radianes.
-- Para eso, utiliza una estructura pipeline de
-- STAGES etapas (por ahora, máximo 10).
-- El ángulo debe ser ingresado en el sgte formato:
-- Pto fijo 16 bits, con el bit más pesado como 
-- bit de signo, 1 bit de parte entera y 14 bits 
-- de parte decimal. Las coord. x,y también son
-- binarios de pto fijo con 1 bit de signo y 1
-- bit de parte entera, pero la parte decimal
-- varía según el generic COORD_N. COORD_N indica
-- la cant. total de bits a usar (es decir, se
-- usan COORD_N-2 bits de parte decimal).
-- La primer salida del componente tarda en
-- generarse tantos ciclos de CLK como STAGES se
-- estén usando, pero luego de eso hay una salida
-- por ciclo de CLK. IMPORTANTE: la salida del
-- componente todavía no está escalada.
entity cordic_pipeline is
   generic (COORD_N: natural := 10; STAGES: natural := 5);
   port(
      x_old: in std_logic_vector(COORD_N-1 downto 0);
	  y_old: in std_logic_vector(COORD_N-1 downto 0);
	  z_old: in std_logic_vector(15 downto 0);
      x_new: out std_logic_vector(COORD_N-1 downto 0);
	  y_new: out std_logic_vector(COORD_N-1 downto 0);
	  valid_in: in std_logic;
	  valid_out: out std_logic;
	  clk: in std_logic;
	  flush: in std_logic
   );
end cordic_pipeline;

architecture cordic_pipeline_arq of cordic_pipeline is
	type ANGULOS is array (9 downto 0) of std_logic_vector(15 downto 0);
	type SALIDAS_CORDIC is array (STAGES-1 downto 0) of std_logic_vector(COORD_N-1 downto 0);		
	signal tabla_arctg: ANGULOS := ("0000000000011111", "0000000000111111", "0000000001111111", 
	"0000000011111111", "0000000111111111", "0000001111111110", "0000011111110101", 
	"0000111110101101", "0001110110101100", "0011001001000011");		 		 							 			   
	signal z_out: ANGULOS;
	signal x_coords, y_coords: SALIDAS_CORDIC;
	signal valids: std_logic_vector(STAGES-1 downto 0);
begin

	createCordic: for j in 0 to STAGES-1 generate
		first_one: if j = 0 generate
			myCS: cordic_stage
				generic map(COORD_N => COORD_N, Z_N => 16, I => 0)
				port map (x_old, y_old, z_old, x_coords(j), y_coords(j), z_out(j), valid_in, valids(j),
				tabla_arctg(j), clk, flush);
		end generate first_one;
		
		the_others: if j > 0 generate
			cordS: cordic_stage
				generic map(COORD_N => COORD_N, Z_N => 16, I => j)
				port map (x_coords(j-1), y_coords(j-1), z_out(j-1), x_coords(j), y_coords(j), z_out(j), 
				valids(j-1), valids(j), tabla_arctg(j), clk, flush);
		end generate the_others;
	end generate createCordic;

	x_new <= x_coords(STAGES-1);
	y_new <= y_coords(STAGES-1);
	valid_out <= valids(STAGES-1);

end cordic_pipeline_arq;