library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sum_rest is
   generic (N: natural := 4);
   port(
      a: in std_logic_vector(N-1 downto 0);
      b: in std_logic_vector(N-1 downto 0);
      c_in: in std_logic;
	  c_out: out std_logic;
      s: out std_logic_vector(N-1 downto 0);
	  sum_select: in std_logic -- 1 para sumar, 0 para restar
   );
end sum_rest;

architecture sum_rest_arq of sum_rest is
	signal aux: std_logic_vector(N+1 downto 0);
begin
	with sum_select select
		aux <= std_logic_vector(unsigned('0' & a & c_in) + unsigned('0' & b & c_in)) when '1',
				std_logic_vector(unsigned('0' & a & '0') - unsigned('0' & b & '0')) when '0',
				(others => '0') when others;
				
	s <= aux(N downto 1);
	
	with sum_select select
		c_out <= aux(N+1) when '1',
				'0' when others;
end sum_rest_arq;