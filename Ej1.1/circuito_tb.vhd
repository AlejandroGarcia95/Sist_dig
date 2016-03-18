library IEEE;
use IEEE.std_logic_1164.all;

entity circuito_tb is
end circuito_tb;

architecture circuito_tb_arq of circuito_tb is
	component circuito is
		port(
		  clk: in std_logic;
		  rst: in std_logic;
		  ena: in std_logic;
		  Q0: out std_logic;
		  Q1: out std_logic
		);
	end component;	

	signal clock: std_logic := '0';
	signal res_t, en_t : std_logic := '0';
	signal q1_t, q0_t : std_logic;
		
begin
	
	inst_circuito : circuito port map(clock, res_t, en_t, q0_t, q1_t);
	clock <= not clock after 20 ns;
	en_t <= not en_t after 120 ns;
	
	res_t <= '1', '0' after 480 ns, '1' after 2000 ns;
	
end circuito_tb_arq;
