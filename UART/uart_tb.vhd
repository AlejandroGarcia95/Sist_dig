library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity uart_tb is
end uart_tb;

architecture uart_tb_arq of uart_tb is
	
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
		generic(N : natural := 193);
		port(
			clk: in std_logic;
			tick: out std_logic
		);
	end component baudrate_gen;
	
	signal tick_t: std_logic := '0';
	
	signal rx_out_t : std_logic_vector(7 downto 0);
	signal rx_done_t: std_logic := '0';
	signal rx_t: std_logic := '1';
	signal clk_t: std_logic := '1';
	
	
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
	
	clk_t <= not clk_t after 1 ns;
	
	rx_t <= '0' after 100 ns,	-- Bit start
			'1' after 228 ns,	-- Data0
			'0' after 356 ns,
			'1' after 484 ns,
			'0' after 612 ns,
			'1' after 740 ns,	-- Data4
			'0' after 868 ns,
			'1' after 996 ns,
			'0' after 1124 ns,	-- Data7
			'1' after 1252 ns,	-- Back to 1
			'0' after 1600 ns,	-- Next bit
			'1' after 2700 ns;	-- Back to idle
	
end uart_tb_arq;