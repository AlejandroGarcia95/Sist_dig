library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- un contador genérico de n bits
entity contador is
	generic( N : natural := 2 );
	port (
		clk: in std_logic;		-- clock
		rst: in std_logic;		-- reset, coloca el contador en 0
		ena: in std_logic;		-- enable
		count_out: out std_logic_vector(N-1 downto 0)
	);
end contador;


architecture contador_arq of contador is
begin
	process (clk, rst)
		variable count: std_logic_vector((N-1) downto 0) := (others => '0');
	begin
		if rst = '1' then
			count := (others => '0');
		elsif ena = '1' then
			if rising_edge(clk) then
				if (to_integer(unsigned(count)) = 2**(N)) then		
					count := (others => '0');
				else
					count := std_logic_vector(unsigned(count) + 1);
				end if;
			end if;
		end if;
		count_out <= count;
	end process;
end contador_arq;