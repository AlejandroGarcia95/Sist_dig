library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end;

architecture beh of tb is

	component contador is
		generic( N : natural := 2 );
		port (
			clk: in std_logic;		-- clock
			rst: in std_logic;		-- reset, coloca el contador en 0
			ena: in std_logic;		-- enable
			count_out: out std_logic_vector(N-1 downto 0)
		);
	end component contador;
	
	signal clk_t, rst_t, ena_t : std_logic := '0';
	signal count : std_logic_vector(3 downto 0);

begin
	myCont : contador
		generic map ( N => 4 )
		port map (
			clk => clk_t,
			rst => rst_t,
			ena => ena_t,
			count_out => count
		);
		
	clk_t <= not clk_t after 5 ns;
	rst_t <= '1' after 1 ns, '0' after 20 ns, '1' after 994 ns, '0' after 1000 ns;
	ena_t <= '1' after 100 ns, '0' after 150 ns, '1' after 164 ns;
end beh;