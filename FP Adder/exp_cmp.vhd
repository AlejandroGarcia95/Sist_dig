library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity exp_cmp is
	generic (E: natural := 4);							-- Número de bits del exponente
	port(
		expA : in std_logic_vector(E-1 downto 0);		-- Primer exponente		(en exceso 2**(E-1) - 1) Si E = 8, es exceso 127.
		expB : in std_logic_vector(E-1 downto 0);		-- Segundo exponente
		
		expDif : out std_logic_vector (E-1 downto 0);	-- Diferencia entre los exponentes = |expA - expB|
		expABigger : out std_logic						-- Flag que indica si el exponente A es el mayor		
	);
end exp_cmp;

architecture exp_cmp_arq of exp_cmp is
begin
	process (expA, expB)
		constant excess : integer := 2**(E-1) - 1;
		variable expA_int, expB_int : integer;
	begin
		expA_int := to_integer(unsigned(expA));
		expB_int := to_integer(unsigned(expB));
			
		if (expA_int < expB_int) then
			expABigger <= '0';
			expDif <= std_logic_vector(to_unsigned(expB_int - expA_int, E));
		else
			expABigger <= '1';
			expDif <= std_logic_vector(to_unsigned(expA_int - expB_int, E));
		end if;
	end process;
end exp_cmp_arq;