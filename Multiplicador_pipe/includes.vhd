library IEEE;
use IEEE.std_logic_1164.all;

package includes is
			
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
	
	component mult_stage is
		generic (N: natural := 4);
		port(
			-- Valores provenientes de la etapa anterior
			a_in: in std_logic_vector(N-1 downto 0);
			b_in: in std_logic_vector(N-1 downto 0);
			p_in: in std_logic_vector(N-1 downto 0);
			valid_in: in std_logic;
			
			-- Valores a pasar a la siguiente etapa
			a_out: out std_logic_vector(N-1 downto 0);
			b_out: out std_logic_vector(N-1 downto 0);
			p_out: out std_logic_vector(N-1 downto 0);
			valid_out: out std_logic;
			
			clk: in std_logic;
			
			-- Bit para limpiar el pipe
			flush: in std_logic
		);
	end component mult_stage;
	
	component multiplicador is
		generic (N: natural := 4);
		port(
			-- Dos números a multiplicar, en punto fijo
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			valid_in: in std_logic;
			
			
			s: out std_logic_vector(2*N-1 downto 0);
			valid_out: out std_logic;
			clk: in std_logic;
			flush: in std_logic
		);	
	end component multiplicador;
	
end package;