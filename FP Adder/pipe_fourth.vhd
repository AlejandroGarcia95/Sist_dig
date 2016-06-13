library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_FPAdder.all;

-- Cuarta etapa del pipeline del sumador de PF:
	-- Modifica el exponente de acuerdo al shifteo realizado en la normalización
	-- Corrige el exponente y la fracción en caso de over o undeflow
entity adderFP_P4 is
	generic (E : natural := 8; N : natural := 32);				-- E = bits de exponente, N = bits totales
	port(
		maxExp : in std_logic_vector(E-1 downto 0);				-- Exponente original a modificar
		deltaExp : in std_logic_vector(E-1 downto 0);			-- Variación del exponente (en exceso 2**(E-1)-1)
		
		normFrac : in std_logic_vector(N-E-2 downto 0);			-- Fracción normalizada
				
		finalExp : out std_logic_vector(E-1 downto 0);			-- Exponente final
		finalFrac : out std_logic_vector(N-E-2 downto 0)		-- Fracción final
	);
end adderFP_P4;

architecture adderFP_P4_arq of adderFP_P4 is
		
	signal expSum_aux : std_logic_vector(E-1 downto 0);
	signal flags_aux : std_logic_vector(1 downto 0);
	
begin

	-- Sumador de exponentes
	myExpAdd : exp_add
		generic map (E => E)
		port map(
			expA => maxExp,
			expB => deltaExp,
			
			expSum => expSum_aux,
			overflow => flags_aux(1),
			underflow => flags_aux(0)
		);
		
	with flags_aux select
		finalExp <= expSum_aux when "00",
					(others => '1') when "10",
					(others => '0') when "01",
					(others => '1') when others;
	

	with flags_aux select
		finalFrac <= normFrac when "00",
					(others => '0') when "10",
					(others => '0') when "01",
					(others => '1') when others;
	
	
end adderFP_P4_arq;