library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity exp_cmp_tb is
end exp_cmp_tb;


architecture exp_cmp_arq_tb of exp_cmp_tb is
	component exp_cmp is
		generic (E: natural := 4);							-- Número de bits del exponente
		port(
			expA : in std_logic_vector(E-1 downto 0);		-- Primer exponente		(en exceso 2**(E-1) - 1) Si E = 8, es exceso 127.
			expB : in std_logic_vector(E-1 downto 0);		-- Segundo exponente
			
			expDif : out std_logic_vector (E-1 downto 0);	-- Diferencia entre los exponentes = |expA - expB|
			expABigger : out std_logic						-- Flag que indica si el exponente A es el mayor		
		);
	end component exp_cmp;
	
	signal expA_t, expB_t, expD_t : std_logic_vector(3 downto 0);
	signal Abig_t : std_logic := '0';
	
begin
	myExpCmp : exp_cmp
		generic map (E => 4)
		port map(
			expA => expA_t,
			expB => expB_t,
			expDif => expD_t,
			expABigger => Abig_t
		);

	expA_t <= "0000" after 50 ns, "0110" after 100 ns, "1110" after 150 ns, "0010" after 200 ns, "0010" after 250 ns;
	expB_t <= "0001" after 50 ns, "1001" after 100 ns, "1100" after 150 ns, "1111" after 200 ns, "0010" after 250 ns;

end exp_cmp_arq_tb;