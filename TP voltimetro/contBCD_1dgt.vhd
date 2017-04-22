library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contBCD_1dgt is
	port (
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		c_out: out std_logic;
		digit: out std_logic_vector(3 downto 0)
	);
end contBCD_1dgt;


architecture contBCD_1dgt_arq of contBCD_1dgt is
begin
	process (clk, rst)
		variable count: integer := 0;
	begin
		if rst = '1' then
			count := 0;
			c_out <= '0';
			digit <= "0000";
		elsif rising_edge(clk) then 
			if ena = '1' then
				count := count + 1;
				if count = 9 then
					c_out <= '1';
				elsif count = 10 then
					count := 0;
					c_out <= '0';
				else
					c_out <= '0';
				end if;
			end if;
		end if;
		digit <= std_logic_vector(to_unsigned(count, 4));
	end process;

end contBCD_1dgt_arq;