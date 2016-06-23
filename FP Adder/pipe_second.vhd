library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_FPAdder.all;

-- Segunda etapa del pipeline del sumador de PF:
		-- Toma las dos mantisas ya desplazadas y con los respectivos '1' explicitados y las suma
		-- Toma los signos de cada operando para saber si 
entity adderFP_P2 is
	generic (E : natural := 8; N : natural := 32; G : natural := 1);-- E = bits de exponente, N = bits totales
	port(
		bigFrac : in std_logic_vector(N-E-1+G downto 0);				-- Mantisa del operando de mayor exponente
		litFrac : in std_logic_vector(N-E-1+G downto 0);				-- Mantisa desplazada del operando menor
		
		sgnA : in std_logic;										-- Signos de A y B respectivamente
		sgnB : in std_logic;
		bigFracIsA : in std_logic;									-- Vale 1 si la fracción más grande corresponde a A
				
		sgnS : out std_logic;										-- Signo del resultado
		resFrac : out std_logic_vector(N-E+G downto 0)				-- Resultado de la suma/resta
		-- Nota: resFrac tiene un bit más que los operandos originales:
			-- Si hay un 1 en resFrac(N-E) la mantisa resultado será (N-E-1 downto 1) y habrá que sumar +1 al exponente
			-- Si resFrac(N-E downto N-E-1) = "01", la mantisa resultado será (N-E-2 downto 0) y el exponente no sufre modificaciones
			-- En cualquier otro caso se shiftea a izquierda hasta que resFrac(N-E downto N-E-1) = "01", sumando -1 al exponente por cada shift.
		
	);
end adderFP_P2;

architecture adderFP_P2_arq of adderFP_P2 is

	signal overflow_aux : std_logic;
	signal sum_sel_aux : std_logic;
	signal sgn_sel_aux : std_logic_vector(1 downto 0);
	
	
begin
	sum_sel_aux <= not(sgnA xor sgnB);

	-- El adder
	myAdder : adder
		generic map (N => N-E+G)
		port map (
			sumA => bigFrac,
			sumB => litFrac,
			sum_sel => sum_sel_aux,
			
			sumS => resFrac(N-E-1+G downto 0),
			c_out => resFrac(N-E+G),
			overflow => overflow_aux		
		);
		
	sgn_sel_aux(1) <= overflow_aux;
	sgn_sel_aux(0) <= bigFracIsA;
	
	with sgn_sel_aux select
		sgnS <= sgnA when "01",
				sgnA when "10",
				sgnB when "00",
				sgnB when "11",
				sgnA when others;
					
end adderFP_P2_arq;