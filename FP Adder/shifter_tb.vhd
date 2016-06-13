library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shifter_tb is
end shifter_tb;


architecture shifter_arq_tb of shifter_tb is
	component shifter is
		generic (Nbits: natural := 4; MaxSft : natural := 2);		-- Número de bits del shifter, Bits para el ammount de shift
		port(
			data_in : in std_logic_vector(Nbits-1 downto 0);		-- Vector a shiftear
			sft_ammount : in std_logic_vector(MaxSft-1 downto 0);	-- Cantidad de bits a shiftear
			sft_right : in std_logic;								-- 1 si shift right, 0 si shift left		
			
			data_out : out std_logic_vector(Nbits-1 downto 0)		-- Salida
		);
	end component shifter;
	
	signal data_in_t, data_out_t : std_logic_vector(5 downto 0);
	signal sft_ammount_t : std_logic_vector(2 downto 0);
	signal right_t : std_logic := '0';
	
begin
	myShifter : shifter
		generic map(Nbits => 6, MaxSft => 3)
		port map (
			data_in => data_in_t,
			sft_ammount => sft_ammount_t,
			sft_right => right_t,
			data_out => data_out_t		
		);
	
	
	right_t <= not right_t after 50 ns;
	
	sft_ammount_t <= "000" after 100 ns, "001" after 200 ns, "010" after 300 ns, "011" after 400 ns, "100" after 500 ns, "101" after 600 ns,"110" after 700 ns,"111" after 800 ns;
	data_in_t <= "111111" after 0 ns;


end shifter_arq_tb;