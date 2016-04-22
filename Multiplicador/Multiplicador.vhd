library IEEE;
use IEEE.std_logic_1164.all;

entity multiplicador is
   generic (N: natural := 4);
   port(
      a: in std_logic_vector(N-1 downto 0);
      b: in std_logic_vector(N-1 downto 0);
	  s: out std_logic_vector(2*N-1 downto 0);
	  clk: in std_logic;
	  load: in std_logic
   );
end multiplicador;

architecture multiplicador_arq of multiplicador is
   component registro is
	   generic (N: natural := 4);
	   port(
		  data_in: in std_logic_vector(N-1 downto 0);
		  data_out: out std_logic_vector(N-1 downto 0);
		  clk: in std_logic;
		  rst: in std_logic;
		  load: in std_logic
	   );
	end component registro;

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


	signal a_out, p_in, p_out, b_out, aux, b_in: std_logic_vector(N-1 downto 0);
	signal c_out: std_logic;
	
begin
	regA: registro
		generic map(N => N)
		port map(
			data_in => a,
			data_out => a_out,
			clk => clk,
			rst => '0',
			load => '1'
		);
		
	regPyB: registro
		generic map(N => 2*N)
		port map(
			data_in => c_out & p_in & b_in(N-1 downto 1),
			data_out => p_out & b_out,
			clk => clk,
			rst => '0',
			load => '1'		
		);

	mySum: sum_rest
		generic map(N => N)
		port map(
			a => aux,
			b => p_out,
			c_in => '0',
			c_out => c_out,
			s => p_in,
			sum_select => '1'		
		);

	with b_out(0) select
		aux <= a when '1',
				(others => '0') when others;


end multiplicador;