library IEEE;
use IEEE.std_logic_1164.all;

entity sum_rest_s_tb is
end sum_rest_s_tb;

architecture sum_rest_s_tb_arq of sum_rest_s_tb is
	component sum_rest_signed is
	   generic (N: natural := 4);
	   port(
		  a: in std_logic_vector(N-1 downto 0);
		  b: in std_logic_vector(N-1 downto 0);
		  c_in: in std_logic;
		  c_out: out std_logic;
		  sal: out std_logic_vector(N-1 downto 0);
		  sum_select: in std_logic -- 1 para sumar, 0 para restar
	   );
	end component sum_rest_signed;
	
	component sum_rest is
	   generic (N: natural := 4);
	   port(
		  a: in std_logic_vector(N-1 downto 0);
		  b: in std_logic_vector(N-1 downto 0);
		  c_in: in std_logic;
		  c_out: out std_logic;
		  s: out std_logic_vector(N-1 downto 0);
		  sum_select: in std_logic -- 1 para sumar, 0 para restar
	   );
	end component sum_rest;
	
	signal a_t, b_t, s_t: std_logic_vector(9 downto 0);
	signal c_in_t, c_out_t, sum_select_t: std_logic := '0';
	
begin
	mySR: sum_rest_signed
		generic map(N => 10)
		port map (a_t, b_t, c_in_t, c_out_t, s_t, sum_select_t);

	a_t <= "0001100101";
	b_t <= "0011001001";
	
	sum_select_t <= '0';  
	
end sum_rest_s_tb_arq;