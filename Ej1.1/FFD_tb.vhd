library IEEE;
use IEEE.std_logic_1164.all;

entity ffd_tb is

end ffd_tb;


architecture ffd_tb_arq of ffd_tb is
	component ffd is
		port(
		  clk: in std_logic;
		  rst: in std_logic;
		  ena: in std_logic;
		  D: in std_logic;
		  Q: out std_logic
	   );
	end component;
	
	signal clock: std_logic := '0';
	signal d_t, res_t, en_t : std_logic := '0';
	signal q_t : std_logic;
	
	
begin

	inst_ffd : ffd port map(clock, res_t, en_t, d_t, q_t);
	clock <= not clock after 20 ns;
	d_t <= not d_t after 50 ns;
	res_t <= not res_t after 400 ns;
	en_t <= not en_t after 100 ns;

end ffd_tb_arq;
