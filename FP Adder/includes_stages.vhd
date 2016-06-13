library IEEE;
use IEEE.std_logic_1164.all;

package includes_stages is
	-- Primer etapa del pipeline del sumador de PF:
	component adderFP_P1 is
		generic (E : natural := 8; N : natural := 32);				-- E = bits de exponente, N = bits totales
		port(
			expA : in std_logic_vector (E-1 downto 0);					-- Exponente del operando A
			fracA : in std_logic_vector(N-E-2 downto 0);				-- Mantisa del operando A
			
			expB : in std_logic_vector (E-1 downto 0);					-- Exponente del operando B
			fracB : in std_logic_vector(N-E-2 downto 0);				-- Mantisa del operando B

			maxExp : out std_logic_vector(E-1 downto 0);				-- Exponente del operando mayor
			bigFrac : out std_logic_vector(N-E-1 downto 0);				-- Mantisa del operando de mayor exponente (con el 1 explicitado)
			litFrac : out std_logic_vector(N-E-1 downto 0);				-- Mantisa desplazada del operando menor
			bigFracIsA : out std_logic									-- Vale 1 si la fracción más grande corresponde a A
		);
	end component adderFP_P1;

	
	
	
	-- Segunda etapa del pipeline del sumador de PF:
		-- Toma las dos mantisas ya desplazadas y con los respectivos '1' explicitados y las suma
		-- Toma los signos de cada operando para saber si 
	component adderFP_P2 is
		generic (E : natural := 8; N : natural := 32);				-- E = bits de exponente, N = bits totales
		port(
			bigFrac : in std_logic_vector(N-E-1 downto 0);				-- Mantisa del operando de mayor exponente
			litFrac : in std_logic_vector(N-E-1 downto 0);				-- Mantisa desplazada del operando menor
			
			sgnA : in std_logic;										-- Signos de A y B respectivamente
			sgnB : in std_logic;
			bigFracIsA : in std_logic;									-- Vale 1 si la fracción más grande corresponde a A
					
			sgnS : out std_logic;										-- Signo del resultado
			resFrac : out std_logic_vector(N-E downto 0)				-- Resultado de la suma/resta
			-- Nota: resFrac tiene un bit más que los operandos originales:
				-- Si hay un 1 en resFrac(N-E) la mantisa resultado será (N-E-1 downto 1) y habrá que sumar +1 al exponente
				-- Si resFrac(N-E downto N-E-1) = "01", la mantisa resultado será (N-E-2 downto 0) y el exponente no sufre modificaciones
				-- En cualquier otro caso se shiftea a izquierda hasta que resFrac(N-E downto N-E-1) = "01", sumando -1 al exponente por cada shift.
		);
	end component adderFP_P2;
	
	
	-- Tercer etapa del pipeline del sumador de PF:
		-- Normaliza el resultado de la suma de mantisas del paso anterior
		-- Calcula en cuánto es necesario modificar al exponente
	component adderFP_P3 is
		generic (E : natural := 8; N : natural := 32);				-- E = bits de exponente, N = bits totales
		port(
			resFrac : in std_logic_vector(N-E downto 0);				-- Mantisa a normalizar
			
			
			normFrac : out std_logic_vector(N-E-2 downto 0);			-- Mantisa normalizada
			deltaExp : out std_logic_vector(E-1 downto 0)				-- Variación del exponente	
		);
	end component adderFP_P3;
	
	
	
	
	-- Cuarta etapa del pipeline del sumador de PF:
		-- Modifica el exponente de acuerdo al shifteo realizado en la normalización
		-- Corrige el exponente y la fracción en caso de over o undeflow
	component adderFP_P4 is
		generic (E : natural := 8; N : natural := 32);				-- E = bits de exponente, N = bits totales
		port(
			maxExp : in std_logic_vector(E-1 downto 0);				-- Exponente original a modificar
			deltaExp : in std_logic_vector(E-1 downto 0);			-- Variación del exponente (en exceso 2**(E-1)-1)
			
			normFrac : in std_logic_vector(N-E-2 downto 0);			-- Fracción normalizada
					
			finalExp : out std_logic_vector(E-1 downto 0);			-- Exponente final
			finalFrac : out std_logic_vector(N-E-2 downto 0)		-- Fracción final
		);
	end component adderFP_P4;
	
	
	-- Adder armado
	component fp_adder is
		generic (E : natural := 8; N : natural := 32);				-- E = bits de exponente, N = bits totales
		port(
			clk : in std_logic;
			load : in std_logic;
		
			sgnA : in std_logic;
			expA : in std_logic_vector(E-1 downto 0);
			fracA : in std_logic_vector(N-E-2 downto 0);
			
			sgnB : in std_logic;
			expB : in std_logic_vector(E-1 downto 0);
			fracB : in std_logic_vector(N-E-2 downto 0);
			
			sgnC : out std_logic;
			expC : out std_logic_vector(E-1 downto 0);
			fracC : out std_logic_vector(N-E-2 downto 0)
		);
	end component fp_adder;
	
	
end package;