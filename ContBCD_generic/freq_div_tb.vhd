library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end tb;

architecture tb_arq of tb is

	component contBCD is
		generic( N: natural );
		port (
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			c_out: out std_logic;
			digitos: out std_logic_vector(4*N-1 downto 0)
		);
	end component contBCD;

	component freq_div is
		generic (N : natural);
		port(
			clk: in std_logic;
			rst: in std_logic;
			clk_out: out std_logic
		);
	end component freq_div;
	
	signal clk_t, rst_t: std_logic := '0';
	signal clk_out_t: std_logic;
	signal digitos_t: std_logic_vector(7 downto 0);
	signal c_out_t: std_logic;
	signal ena_t: std_logic := '1';
	
begin
	
	myGen: freq_div
		generic map(N => 1)
		port map(
			clk => clk_t,
			rst => rst_t,
			clk_out => clk_out_t
		);
	
	myBCD: contBCD
		generic map( N => 2)
		port map(
			clk => clk_t,
			rst => rst_t,
			ena => clk_out_t,
			c_out => c_out_t,
			digitos => digitos_t
		);
	
	clk_t <= not clk_t after 5 ns;
	rst_t <= '1' after 10 ns, '0' after 50 ns;
	
end tb_arq;
