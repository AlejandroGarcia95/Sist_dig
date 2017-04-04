library IEEE;
use IEEE.std_logic_1164.all;

package includes_cordic is
			
	-- Registro y FFD
	component ffd is
		port(
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			D: in std_logic;
			Q: out std_logic
		);
	end component ffd;
	
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

		
	component delay_gen is
		generic(
			N: natural:= 8;
			DELAY: natural:= 0
		);
		port(
			clk: in std_logic;
			A: in std_logic_vector(N-1 downto 0);
			B: out std_logic_vector(N-1 downto 0)
		);
	end component delay_gen;
	
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
	

	component cordic_stage is
	   generic (COORD_N: natural := 10; Z_N: natural := 10; I: natural := 0);
	   port(
		  x_old: in std_logic_vector(COORD_N-1 downto 0);
		  y_old: in std_logic_vector(COORD_N-1 downto 0);
		  z_old: in std_logic_vector(Z_N-1 downto 0);
		  x_new: out std_logic_vector(COORD_N-1 downto 0);
		  y_new: out std_logic_vector(COORD_N-1 downto 0);
		  z_new: out std_logic_vector(Z_N-1 downto 0);
		  cte: in std_logic_vector(Z_N-1 downto 0);
		  clk: in std_logic
	   );
	end component cordic_stage;
	
end package;