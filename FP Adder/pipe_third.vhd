library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_FPAdder.all;

-- Tercer etapa del pipeline del sumador de PF:
	-- Normaliza el resultado de la suma de mantisas del paso anterior
	-- Calcula en cuánto es necesario modificar al exponente
entity adderFP_P3 is
	generic (E : natural := 8; N : natural := 32; G : natural := 1);-- E = bits de exponente, N = bits totales
	port(
		resFrac : in std_logic_vector(N-E+G downto 0);				-- Mantisa a normalizar
		
		normFrac : out std_logic_vector(N-E-2 downto 0);			-- Mantisa normalizada
		deltaExp : out std_logic_vector(E-1 downto 0)				-- Variación del exponente	(en exceso 2**(E-1)-1)
	);
end adderFP_P3;

architecture adderFP_P3_arq of adderFP_P3 is
		
	signal shifted_frac_aux : std_logic_vector(N-E+G downto 0);
	signal sft_ammount_aux : std_logic_vector(E-1 downto 0);
	signal sft_rgt_aux :std_logic;
	
	function count_lead_zeros(lv : std_logic_vector(N-E+G downto 0)) return natural is
		variable count : natural := 0;
	begin
		for i in 0 to N-E+G loop
			if (lv(N-E+G-i) = '0') then
				count := count + 1;
			else
				return count;
			end if;
		end loop;
		return count;
	end function count_lead_zeros;
	
begin

	process (resFrac)
		constant EXCESS : integer := 2**(E-1) - 1;
		variable zeros : natural := 0;
	begin
		zeros := count_lead_zeros(resFrac);
		if (zeros = 0) then
			sft_ammount_aux <= std_logic_vector(to_unsigned(1,E));
			deltaExp <= std_logic_vector(to_unsigned(1 + EXCESS, E));
			sft_rgt_aux <= '1';
		elsif (zeros = 1) then
			sft_ammount_aux <= std_logic_vector(to_unsigned(0,E));
			deltaExp <= std_logic_vector(to_unsigned(0 + EXCESS, E));
			sft_rgt_aux <= '1';
		else
			sft_ammount_aux <= std_logic_vector(to_unsigned(zeros-1,E));
			deltaExp <= std_logic_vector(to_unsigned(-zeros+1 + EXCESS,E));
			sft_rgt_aux <= '0';
		end if;
	end process;

	-- El shifter
	myShift : shifter
		generic map (Nbits => N-E+1+G, MaxSft => E)
		port map(
			data_in => resFrac,
			sft_ammount => sft_ammount_aux,
			sft_right => sft_rgt_aux,
			data_out => shifted_frac_aux
		);
	
	normFrac <= shifted_frac_aux(N-E-2+G downto G);
	 
end adderFP_P3_arq;



