library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Utiliza mult_stage
use work.includes.all;

-- mult_stage
-- Implementación pipeline del multiplicador
--
-- Ports:
-- 		a y b: son los nuevos números a multiplicar
--			s: es la salida de la N-ésima etapa anterior
--		valid_out: indica la validez del valor a la salida
--		valid_in: indica que los valores cargados son válidos
--				si se coloca en '0', el bit de válido
--				de la nueva entrada es setteado a 0
--
--		flush: limpia el pipeline entero si se coloca en 1
entity multiplicador is
	generic (N: natural := 4);
	port(
		-- Dos números a multiplicar, en punto fijo
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		valid_in: in std_logic;
		
		
		s: out std_logic_vector(2*N-1 downto 0);
		valid_out: out std_logic;
		clk: in std_logic;
		flush: in std_logic
	);
end multiplicador;

architecture multiplicador_arq of multiplicador is
	-- Defino las señales interetapas
	type PIPE_CONNECTOR is array (N-1 downto 0) of std_logic_vector(N-1 downto 0);
	type VALID_CONNECTOR is array (N-1 downto 0) of std_logic;
	signal a_mid, b_mid, p_mid: PIPE_CONNECTOR;
	signal valid_mid: VALID_CONNECTOR;
	
begin

	-- Creo N etapas
	create_pipes: for j in 0 to N-1 generate
		first_one: if j = 0  generate
			first_stage: mult_stage
				generic map(N => N)
				port map(a, b, (others => '0'),	valid_in,
						a_mid(0), b_mid(0), p_mid(0), valid_mid(0),
						clk, flush);
		end generate first_one;
			
		the_others: if j > 0 generate	
			other_stage: mult_stage
				generic map(N => N)
				port map(a_mid(j-1), b_mid(j-1), p_mid(j-1), valid_mid(j-1),
						a_mid(j), b_mid(j), p_mid(j), valid_mid(j),
						clk, flush);
		end generate the_others;
	end generate create_pipes;
	
	-- La salida del pipe
	s <= p_mid(N-1) & b_mid(N-1);
	valid_out <= valid_mid(N-1);
	
end multiplicador_arq;