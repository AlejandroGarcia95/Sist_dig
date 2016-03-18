library IEEE;
use IEEE.std_logic_1164.all;


entity f_adder_4b_tb is
end f_adder_4b_tb;



architecture f_adder_4b_tb_arq of f_adder_4b_tb is
	component f_adder_4b is
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
	end component;
	
	
begin
	inst_adder:f_adder_4b port map (a_t, b_t, c_in_t, c_out_t, s_t);
	a_t <= not a_t after 50 ns;
	b_t <= not b_t after 100 ns;
	c_in_t <= not c_in_t after 200 ns;
	
end f_adder_4b_tb_arq;


begin
begin

end f_adder_4b_arq;