library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity uart_final_tb is
end uart_final_tb;

architecture uart_final_tb_arq of uart_final_tb is
	
	component uart is
	generic( COORD_N: natural := 16; ADDR_N: natural := 11; NPOINTS: natural := 3; BAUDRATE: natural := 163);
	port(		
		rx: in std_logic;
		
		x_coord: out std_logic_vector(COORD_N-1 downto 0);
		y_coord: out std_logic_vector(COORD_N-1 downto 0);
		z_coord: out std_logic_vector(COORD_N-1 downto 0);
		
		addr: out std_logic_vector(ADDR_N-1 downto 0);
		valid: out std_logic;
		done: out std_logic;
		
		led_out: out std_logic_vector(7 downto 0);
		switch_in: in std_logic_vector(2 downto 0);
		
		clk: in std_logic
	);		
	end component uart;
	
	
	signal rx_t: std_logic := '1';
	signal rx_t_aux: std_logic := '0';
	
	signal mux: std_logic := '0';
	
	signal clk_t: std_logic := '1';
	
	signal x_coord_t : std_logic_vector(15 downto 0);
	signal y_coord_t : std_logic_vector(15 downto 0);
	signal z_coord_t : std_logic_vector(15 downto 0);
	
begin

	myUART : uart
	generic map(COORD_N => 16, ADDR_N => 11, NPOINTS => 3, BAUDRATE => 4)
	port map (
		rx => rx_t,
			
		x_coord => x_coord_t,
		y_coord => y_coord_t,
		z_coord => z_coord_t,
		
		addr => open,
		valid => open,
		done => open,
			
		led_out => open,
		switch_in => "000",
		clk => clk_t
	);
	
	clk_t <= not clk_t after 1 ns;
	
--rx_t <= '0' after 100 ns,	-- Bit start
--		'1' after 228 ns,	-- Data0
--		'0' after 356 ns,
--		'1' after 484 ns,
--		'0' after 612 ns,
--		'1' after 740 ns,	-- Data4
--		'0' after 868 ns,
--		'1' after 996 ns,
--		'0' after 1124 ns,	-- Data7
--		'1' after 1252 ns,	-- Back to 1
--		'0' after 1600 ns,	-- Next bit
--		'1' after 2700 ns;	-- Back to idle
	
	rx_t_aux <= not rx_t_aux after 128 ns;
	rx_t <= rx_t_aux when mux = '0' else '0';
	mux <= '0' after 0 ns, '1' after 7900 ns;
	
end uart_final_tb_arq;