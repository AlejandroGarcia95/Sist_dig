library IEEE;
use IEEE.std_logic_1164.all;

entity f_adder_4b is
   port(
		a1: in std_logic;
		a2: in std_logic;
		a3: in std_logic;
		a4: in std_logic;
		c_in: in std_logic;
		
		b1: in std_logic;
		b2: in std_logic;
		b3: in std_logic;
		b4: in std_logic;
		
		s1: out std_logic;
		s2: out std_logic;
		s3: out std_logic;
		s4: out std_logic;
		c_out: out std_logic;		
   );
end f_adder_4b;

architecture f_adder_4b_arq of f_adder_4b is
	component f_adder is
	   port(
		  a: in std_logic;
		  b: in std_logic;
		  c_in: in std_logic;
		  c_out: out std_logic;
		  s: out std_logic
	   );
	end component;
	
	signal c_out1, c_out2, c_out3 : std_logic := '0';
	
begin
	add1: f_adder port map(a1, b1, c_in, s1, c_out1);
	add2: f_adder port map(a2, b2, c_out1, s2, c_out2);
	add3: f_adder port map(a3, b3, c_out2, s3, c_out3);
	add4: f_adder port map(a4, b4, c_out3, s4, c_out);

end f_adder_4b_arq;