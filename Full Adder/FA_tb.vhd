library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_FPAdder.all;

entity f_adder_tb is
end f_adder_tb;

architecture f_adder_tb_arq of f_adder_tb is
	component f_adder is	
	   port(
		  a: in std_logic;
		  b: in std_logic;
		  c_in: in std_logic;
		  c_out: out std_logic;
		  s: out std_logic
	   );
	end component;
	
	signal a_t, b_t, c_in_t : std_logic := '0';
	signal c_out_t, s_t : std_logic;
	
begin
	inst_adder:f_adder port map (a_t, b_t, c_in_t, c_out_t, s_t);
	a_t <= not a_t after 50 ns;
	b_t <= not b_t after 100 ns;
	c_in_t <= not c_in_t after 200 ns;
	
end f_adder_tb_arq;