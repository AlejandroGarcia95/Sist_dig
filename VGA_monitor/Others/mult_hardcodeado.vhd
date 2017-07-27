library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Utiliza mult_stage
use work.includes.all;

-- multiplicador hardcodeadooooo
entity multiplicador_hardcodeado_cordic is
	generic (N: natural := 4);
	port(
		-- Dos números a multiplicar, en punto fijo
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		valid_in: in std_logic;
		sign_in: in std_logic;
		
		s: out std_logic_vector(2*N-1 downto 0);
		valid_out: out std_logic;
		sign_out: out std_logic;
		clk: in std_logic;
		flush: in std_logic
	);
end multiplicador_hardcodeado_cordic;
-- 0.10011011011101
architecture multiplicador_hardcodeado_cordic_arq of multiplicador_hardcodeado_cordic is

	signal primer_uno, segundo_uno, tercer_uno, cuarto_uno, quinto_uno, 
	sexto_uno, septimo_uno, octavo_uno, noveno_uno: unsigned(N-1 downto 0);
	signal suma_de_todos: std_logic_vector(N-1 downto 0);
	signal resultado: std_logic_vector(2*N-1 downto 0);
	signal ceros_dcha: std_logic_vector(N-2 downto 0);
	
begin
	ceros_dcha <= (others => '0');
	primer_uno <= shift_right(unsigned(a), 1);
	segundo_uno <= shift_right(unsigned(a), 4);
	tercer_uno <= shift_right(unsigned(a), 5);
	cuarto_uno <= shift_right(unsigned(a), 7);
	quinto_uno <= shift_right(unsigned(a), 8);
	sexto_uno <= shift_right(unsigned(a), 10);
	septimo_uno <= shift_right(unsigned(a), 11);
	octavo_uno <= shift_right(unsigned(a), 12);
	noveno_uno <= shift_right(unsigned(a), 14);
	
	suma_de_todos <= std_logic_vector(primer_uno + segundo_uno + tercer_uno + cuarto_uno + quinto_uno + 
						sexto_uno + septimo_uno + octavo_uno + noveno_uno);
	
	resultado <= '0' & suma_de_todos & ceros_dcha;
		
	s <= resultado;
	valid_out <= valid_in;
	sign_out <= sign_in;
	
end multiplicador_hardcodeado_cordic_arq;