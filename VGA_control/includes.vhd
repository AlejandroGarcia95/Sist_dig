library IEEE;
use IEEE.std_logic_1164.all;

package includes is

	component contador is
		generic( N : natural := 2;
			 TOPE : natural := 3);
		port (
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			count_out: out std_logic_vector(N-1 downto 0)
		);
	end component contador;

	component contBCD is
		generic( N: natural );		-- El número de dígitos bcd que tendrá
		port (
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			c_out: out std_logic;
			digitos: out std_logic_vector(4*N-1 downto 0)
		);
	end component contBCD;
	
	component deco_7s is
		port(
			num: in std_logic_vector(3 downto 0);		-- Numero BCD a convertir
			display: out std_logic_vector(7 downto 0) -- 8 patas del display en orden Pabcdefg
		);
	end component deco_7s;
	
	component freq_div is
		generic (N : natural);
		port(
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			clk_out: out std_logic
		);
	end component freq_div;
	
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
	
end package;