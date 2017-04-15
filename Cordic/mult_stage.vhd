library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Utiliza registro, FFD y sumador_restador
use work.includes_cordic.all;

-- mult_stage
-- Es una etapa genérica del multiplicador pipeline, de N bits.
-- Tiene asociado un registro a la salida para pasar los resultados
-- a la siguiente etapa.
--
-- Ports:
-- 		a, b y p son los registros del pipe.
--		El stage almacena el resultado parcial entre los registros p y b.
--		Todos los bits de p y los primeros N-k dígitos de b conforman al
-- 		concatenarse (p & b) el resultado parcial del stage k.
--
--		Tras completado el pipe de N ciclos, p&b contiene la salida.
--		
-- 		valid es un bit que se propaga por el pipe e indica que el valor
--		a la salida es resultado de una cuenta (usar para saber cuándo
--		la salida es válida y cuándo es basura).

entity mult_stage is
	generic (N: natural := 4);
	port(
		-- Valores provenientes de la etapa anterior
		a_in: in std_logic_vector(N-1 downto 0);
		b_in: in std_logic_vector(N-1 downto 0);
		p_in: in std_logic_vector(N-1 downto 0);
		valid_in: in std_logic;
		
		-- Valores a pasar a la siguiente etapa
		a_out: out std_logic_vector(N-1 downto 0);
		b_out: out std_logic_vector(N-1 downto 0);
		p_out: out std_logic_vector(N-1 downto 0);
		valid_out: out std_logic;
		
		clk: in std_logic;
		-- Bit para limpiar el pipe
		flush: in std_logic
	);
end mult_stage;

architecture mult_stage_arq of mult_stage is
	signal a_aux, b_aux, p_aux, sum_out: std_logic_vector(N-1 downto 0);
	signal c_out: std_logic;
	signal v_o: std_logic := '0';
begin
	-- Registros para almacenar los valores de cada ciclo
	regA: registro
		generic map(N => N)
		port map(
			data_in => a_in,
			data_out => a_out,
			clk => clk,
			rst => flush,
			load => '1'
		);	
	regB: registro
		generic map(N => N)
		port map(
			data_in => b_aux,
			data_out => b_out,
			clk => clk,
			rst => flush,
			load => '1'
		);
	regP: registro
		generic map(N => N)
		port map(
			data_in => p_aux,
			data_out => p_out,
			clk => clk,
			rst => flush,
			load => '1'
		);
	reg_valid: ffd
		generic map(N => 1)
		port map(
			D => valid_in,
			Q => v_o,
			clk => clk,
			rst => flush,
			ena => '1'
		);
	-- El sumador que efectúa la cuenta
	mySum: sum_rest
		generic map(N => N)
		port map(
			a => a_aux,
			b => p_in,
			c_in => '0',
			c_out => c_out,
			s => sum_out,
			sum_select => '1'		
		);

	p_aux <= c_out & sum_out(N-1 downto 1);
	b_aux <= sum_out(0) & b_in(N-1 downto 1);
	valid_out <= v_o;	
	
	-- Selecciono el valor a sumar
	with b_in(0) select
		a_aux <= a_in when '1',
				(others => '0') when others;
		
end mult_stage_arq;