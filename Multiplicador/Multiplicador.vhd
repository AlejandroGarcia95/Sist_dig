library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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
	
	component contador is
		generic( N : natural := 2 );
		port (
			clk: in std_logic;		-- clock
			rst: in std_logic;		-- reset, coloca el contador en 0
			ena: in std_logic;		-- enable
			count_out: out std_logic_vector(N-1 downto 0)
		);
	end component contador;

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


	signal a_out, b_out, p_out, b_in, p_in, aux, cant_clks, sum_out: std_logic_vector(N-1 downto 0);
	signal c_out, salida_ok, keep_counting: std_logic;
	signal sal_aux: std_logic_vector(2*N-1 downto 0);
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
		
	regB: registro
		generic map(N => N)
		port map(
			data_in => b_in,
			data_out => b_out,
			clk => clk,
			rst => '0',
			load => '1'
		);
		
	regP: registro
		generic map(N => N)
		port map(
			data_in => p_in,
			data_out => p_out,
			clk => clk,
			rst => load,
			load => '1'
		);

	mySum: sum_rest
		generic map(N => N)
		port map(
			a => aux,
			b => p_out,
			c_in => '0',
			c_out => c_out,
			s => sum_out,
			sum_select => '1'		
		);

	p_in <= c_out & sum_out(N-1 downto 1);
	b_in <= b when load = '1' else
			sum_out(0) & b_out(N-1 downto 1);
		
	with b_out(0) select
		aux <= a_out when '1',
				(others => '0') when others;

	sal_aux <= p_out & b_out;

	regResultado: registro
		generic map(N => 2*N)
		port map(
			data_in => sal_aux,
			data_out => s,
			clk => clk,
			rst => load,
			load => salida_ok
		);
	
	contClcks: contador
		generic map(N =>  N)
		port map(clk, load, keep_counting, cant_clks);
	
	salida_ok <= '1' when (N = (to_integer(unsigned(cant_clks)))) else '0';
	keep_counting <= '0' when (N = (to_integer(unsigned(cant_clks)) - 1)) else '1';
				
	
end multiplicador_arq;