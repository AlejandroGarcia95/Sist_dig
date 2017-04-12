library IEEE;
use IEEE.std_logic_1164.all;

-- a - b
entity sum_rest_signed is
   generic (N: natural := 4);
   port(
      a: in std_logic_vector(N-1 downto 0);
      b: in std_logic_vector(N-1 downto 0);
      c_in: in std_logic;
	  c_out: out std_logic;
      sal: out std_logic_vector(N-1 downto 0);
	  sum_select: in std_logic -- 1 para sumar, 0 para restar
   );
end sum_rest_signed;

architecture sum_rest_signed_arq of sum_rest_signed is
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
	
	component comp2_signed_conv is
	   generic (N: natural := 4);
	   port(
		  num_in: in std_logic_vector(N-1 downto 0);
		  num_out: out std_logic_vector(N-1 downto 0);
		  conv_dir: in std_logic
	   );
	end component comp2_signed_conv;

	signal num_a, num_b, salida: std_logic_vector(N-1 downto 0);
	
begin
	mySR: sum_rest
		generic map(N => N)
		port map (num_a, num_b, c_in, c_out, salida, sum_select);
 	convA: comp2_signed_conv
 		generic map(N => N)
 		port map (a, num_a, '1');
 	convB: comp2_signed_conv
 		generic map(N => N)
 		port map (b, num_b, '1');
 	convS: comp2_signed_conv
 		generic map(N => N)
 		port map (salida, sal, '0');
	
end sum_rest_signed_arq;