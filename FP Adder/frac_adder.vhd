library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder is
	generic (N: natural := 4);
	port(
		sumA : in std_logic_vector(N-1 downto 0);
		sumB : in std_logic_vector(N-1 downto 0);
		sum_sel : in std_logic;							-- 1 para sumar, 0 para restar
		
		sumS : out std_logic_vector(N-1 downto 0);
		c_out : out std_logic;
		overflow : out std_logic
	);
end adder;

architecture adder_arq of adder is
	signal aux : std_logic_vector(N downto 0);
begin
	process (sumA, sumB, sum_sel)
		variable A, B, S : integer;
	begin
		A := to_integer(unsigned(sumA));
		B := to_integer(unsigned(sumB));
		if (sum_sel = '1') then
			S := A + B;
			if (S < 2**N) then
				c_out <= '0';
				overflow <= '0';
			else
				c_out <= '1';
				overflow <= sumA(N-1) xor sumB(N-1);
			end if;
		else
			if (A > B) then
				S := A - B;
				c_out <= '0';
				overflow <= '0';
			else
				S := B - A;
				c_out <= '0';
				overflow <= '1';
			end if;
		end if;
		aux <= std_logic_vector(to_unsigned(S, N+1));
	end process;
	sumS <= aux(N-1 downto 0);
end adder_arq;