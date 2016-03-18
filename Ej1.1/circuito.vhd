library IEEE;
use IEEE.std_logic_1164.all;

entity circuito is
   port(
      clk: in std_logic;
      rst: in std_logic;
      ena: in std_logic;
      Q0: out std_logic;
      Q1: out std_logic
   );
end circuito;

architecture circuito_arq of circuito is
	component ffd is
		port(
		  clk: in std_logic;
		  rst: in std_logic;
		  ena: in std_logic;
		  D: in std_logic;
		  Q: out std_logic
	   );
	end component;	

	signal aux_d1, aux_d0 : std_logic := '0';
	signal aux_q1, aux_q0 : std_logic := '0';
	
begin	
	aux_d1 <= aux_q1 xor aux_q0;
	aux_d0 <= not aux_q0;
	Q0 <= aux_q0;
	Q1 <= aux_q1;
	inst_ff0 : ffd port map(clk, rst, ena, aux_d0, aux_q0);
	inst_ff1 : ffd port map(clk, rst, ena, aux_d1, aux_q1);


end circuito_arq;
