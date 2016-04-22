library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end tb;

architecture tb_arq of tb is
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

	signal i_t, o_t: std_logic_vector(7 downto 0);
	signal clk_t, rst_t, load_t: std_logic := '0';
	
begin
	myReg: registro
		generic map(N => 8)
		port map (i_t, o_t, clk_t, rst_t, load_t);

	i_t <= "00000011";

	clk_t <= not clk_t after 10 ns;
	load_t <= not load_t after 160 ns;
end tb_arq;