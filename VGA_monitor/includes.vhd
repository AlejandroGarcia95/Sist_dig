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