library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_FPAdder.all;

-- Primer etapa del pipeline del sumador de PF:
		-- Compra los exponentes y obtiene el mayor
		-- Desplaza la mantisa del exponente menor para que coincidan los exponentes
		-- Explicita los '1' implícitos en la representación
entity adderFP_P1 is
	generic (E : natural := 8; N : natural := 32; G : natural := 1);-- E = bits de exponente, N = bits totales
	port(
		expA : in std_logic_vector (E-1 downto 0);					-- Exponente del operando A
		fracA : in std_logic_vector(N-E-2 downto 0);				-- Mantisa del operando A
		
		expB : in std_logic_vector (E-1 downto 0);					-- Exponente del operando B
		fracB : in std_logic_vector(N-E-2 downto 0);				-- Mantisa del operando B

		maxExp : out std_logic_vector(E-1 downto 0);				-- Exponente del operando mayor
		bigFrac : out std_logic_vector(N-E-1+G downto 0);				-- Mantisa del operando de mayor exponente (con el 1 explicitado)
		litFrac : out std_logic_vector(N-E-1+G downto 0);				-- Mantisa desplazada del operando menor
		bigFracIsA : out std_logic									-- Vale 1 si la fracción más grande corresponde a A
	);
end adderFP_P1;

architecture adderFP_P1_arq of adderFP_P1 is

	constant bits_de_guarda : std_logic_vector(G-1 downto 0) := (others => '0');

	signal sft_amm_aux : std_logic_vector(E-1 downto 0);			-- Diferencia de exponentes, usada para el shifteo
	signal expABig_aux : std_logic;
	signal fracToShift : std_logic_vector(N-E-1+G downto 0);
	
begin
	
	-- El comparador de exponentes
	myComp : exp_cmp
		generic map (E => E)
		port map(
			expA => expA,
			expB => expB,
			expDif => sft_amm_aux,
			expABigger => expABig_aux
		);
	
	-- El shifter
	myShift : shifter
		generic map (Nbits => N-E+G, MaxSft => E)
		port map(
			data_in => fracToShift,
			sft_ammount => sft_amm_aux,
			sft_right => '1',
			data_out => litFrac
		);

		
	with expABig_aux select
		fracToShift <=  ('1' & fracA & bits_de_guarda) when '0',
						('1' & fracB & bits_de_guarda) when '1',
						('1' & fracA & bits_de_guarda) when others;
						
	with expABig_aux select
		bigFrac <=  ('1' & fracA & bits_de_guarda) when '1',
					('1' & fracB & bits_de_guarda) when '0',
					('1' & fracA & bits_de_guarda) when others;
	
	with expABig_aux select
		maxExp <= expA when '1',
				  expB when '0',
				  expA when others;
				  
	bigFracIsA <= expABig_aux;
					
end adderFP_P1_arq;