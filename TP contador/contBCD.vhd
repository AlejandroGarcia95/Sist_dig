library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contBCD is
	generic( N: natural := 4);
	port (
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		c_out: out std_logic;
		digitos: out std_logic_vector(4*N-1 downto 0)
	);
end contBCD;


architecture contBCD_arq of contBCD is
	component contBCD_1dgt is
		port (
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			c_out: out std_logic;
			digit: out std_logic_vector(3 downto 0)
		);
	end component contBCD_1dgt;
	
	signal carries : std_logic_vector(N-1 downto 0);
	signal enables : std_logic_vector(N-1 downto 0);
begin

	createBCD: for i in 0 to N-1 generate

		first_one: if i = 0 generate
			bcd_1dgt: contBCD_1dgt 
				port map(
					clk => clk,
					rst => rst,
					ena => enables(i),
					c_out => carries(i),
					digit => digitos(4*i+3 downto 4*i)
				);
			enables(i) <= ena;
		end generate first_one;
		
		the_others: if i > 0 generate
			bcd_1dgt: contBCD_1dgt 
				port map(
					clk => clk,
					rst => rst,
					ena => enables(i),
					c_out => carries(i),
					digit => digitos(4*i+3 downto 4*i)
				);	
			enables(i) <= enables(i-1) and carries(i-1);
		end generate the_others;

	end generate createBCD;

	c_out <= carries(N-1);
	
end contBCD_arq;