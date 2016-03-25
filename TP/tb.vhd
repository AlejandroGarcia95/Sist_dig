library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end;

architecture beh of tb is

	component cont_4dgt_disp is
		port (
			clk : in std_logic;
			rst : in std_logic;
			ena : in std_logic;
			
			dgt_selector : out std_logic_vector(3 downto 0);
			dgt_display : out std_logic_vector(6 downto 0);
			c_out : out std_logic
		);
	end component cont_4dgt_disp;
	
	signal clk_t, rst_t, ena_t : std_logic := '0';
	signal sel_t : std_logic_vector(3 downto 0) := "0000";
	signal dgt_t : std_logic_vector(6 downto 0) := "0000000";

begin
	myDisplay : cont_4dgt_disp
		port map (
			clk => clk_t,
			rst => rst_t,
			ena => ena_t,
			dgt_selector => sel_t,
			dgt_display => dgt_t,
			c_out => open
		);
		
	clk_t <= not clk_t after 5 ns;
	rst_t <= '1' after 1 ns, '0' after 20 ns;
	ena_t <= '1' after 100 ns, '0' after 25000 ns;
end beh;