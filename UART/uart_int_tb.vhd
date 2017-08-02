library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity uart_int_tb is
end uart_int_tb;

architecture uart_int_tb_arq of uart_int_tb is
	
	component uart_interface is
		generic( COORD_N: natural := 16; ADDR_N: natural := 11; NPOINTS: natural := 3);
		port(
			rx_in: in std_logic_vector(7 downto 0);
			rx_done: in std_logic;
		
			x_coord: out std_logic_vector(COORD_N-1 downto 0);
			y_coord: out std_logic_vector(COORD_N-1 downto 0);
			z_coord: out std_logic_vector(COORD_N-1 downto 0);
			
			addr: out std_logic_vector(ADDR_N-1 downto 0);
			valid: out std_logic;
			done: out std_logic;
			
			clk: in std_logic
		);
		
	end component uart_interface;

	component uart_rcv is
		port(
			rx: in std_logic;
			rx_out: out std_logic_vector(7 downto 0);
			rx_done: out std_logic;
			baudtick: in std_logic;	
			dbg_idle: out std_logic;
			dbg_first: out std_logic;
			dbg_data: out std_logic;
			dbg_store: out std_logic;
			clk: in std_logic
		);
	end component uart_rcv;
	
	component baudrate_gen is
		generic(N : natural := 4);
		port(
			clk: in std_logic;
			tick: out std_logic
		);
	end component baudrate_gen;
	
	signal tick_t: std_logic := '0';
	
	signal rx_out_t : std_logic_vector(7 downto 0);
	signal rx_done_t: std_logic := '0';
	signal rx_t: std_logic := '1';
	signal rx_t_aux: std_logic := '0';
	signal mux: std_logic := '0';
	
	signal clk_t: std_logic := '1';
	
	signal x_coord_t : std_logic_vector(15 downto 0);
	signal y_coord_t : std_logic_vector(15 downto 0);
	signal z_coord_t : std_logic_vector(15 downto 0);
	
	
	signal dbg_idle_t: std_logic := '0';
	signal dbg_first_t: std_logic := '0';
	signal dbg_data_t: std_logic := '0';
	signal dbg_store_t: std_logic := '0';
	
begin

	bgen : baudrate_gen
	generic map (N => 4)
	port map (
		clk => clk_t,
		tick => tick_t
	);
	
	logic : uart_rcv
	port map (
		clk => clk_t,
		rx_done => rx_done_t,
		rx => rx_t,
		baudtick => tick_t,
		rx_out => rx_out_t,
		dbg_data => dbg_data_t,
		dbg_first => dbg_first_t,
		dbg_idle => dbg_idle_t,
		dbg_store => dbg_store_t
	);
	
	
	interface : uart_interface
	generic map ( COORD_N => 16, ADDR_N => 11 )
	port map(
		rx_in => rx_out_t,
		rx_done => rx_done_t,
		
		x_coord => x_coord_t,
		y_coord => y_coord_t,
		z_coord => z_coord_t,
		
		addr => open,
		valid => open,
			
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
end uart_int_tb_arq;