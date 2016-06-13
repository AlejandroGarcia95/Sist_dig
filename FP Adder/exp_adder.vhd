library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity exp_add is
	generic (E: natural := 4);							-- Número de bits del exponente
	port(
		expA : in std_logic_vector(E-1 downto 0);		-- Primer exponente		(en exceso 2**(E-1) - 1) Si E = 8, es exceso 127.
		expB : in std_logic_vector(E-1 downto 0);		-- Segundo exponente
		
		expSum : out std_logic_vector (E-1 downto 0);	-- Suma de los exponentes
		overflow : out std_logic;						-- Flag que indica si A+B es un exponente que supera el expMax (= 2**(E-1) - 1) [127]
		underflow : out std_logic						-- Flag que indica si A+B es un exponente inferior al expMin (= -(2**(E-1)-1) + 1) [-126]
	);
end exp_add;

architecture exp_add_arq of exp_add is
begin
	process (expA, expB)
		constant EXCESS : integer := 2**(E-1) - 1;
		constant EXP_MIN : integer := - EXCESS + 1;
		constant EXP_MAX : integer := EXCESS;
		variable expA_int, expB_int, expSum_int : integer;
	begin
		expA_int := to_integer(unsigned(expA));
		expB_int := to_integer(unsigned(expB));
		
		expSum_int := expA_int + expB_int - 2*EXCESS;
		if (expSum_int > EXP_MAX) then
			overflow <= '1';
			underflow <= '0';
			expSum <= (others => '1');
		elsif (expSum_int < EXP_MIN) then
			overflow <= '0';
			underflow <= '1';
			expSum <= (others => '0');
		else
			overflow <= '0';
			underflow <= '0';
			expSum <= std_logic_vector(to_unsigned(expSum_int + EXCESS, E));
		end if;
	end process;
end exp_add_arq;