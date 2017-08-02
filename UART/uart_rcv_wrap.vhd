library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity uart_rcv_wrap is
	port(		
		rx: in std_logic;
		rx_out: out std_logic_vector(7 downto 0);
		rx_done: out std_logic;
		
		clk: in std_logic
	);
	
	attribute loc: string;
			
	-- Mapeo de pines para el kit Nexys 2 (spartan 3E)
	attribute loc of clk: signal is "B8";
	
	attribute loc of rx_out: signal is "J14 J15 K15 K14 E17 P15 F4 R4";
	attribute loc of rx: signal is "U6";
	
end uart_rcv_wrap;

architecture uart_rcv_wrap_arq of uart_rcv_wrap is
	
	component uart_rcv is
		port(
			rx: in std_logic;
			rx_out: out std_logic_vector(7 downto 0);
			rx_done: out std_logic;
			baudtick: in std_logic;	
			clk: in std_logic
		);
	end component uart_rcv;
	
	component baudrate_gen is
		generic(N : natural := 163);
		port(
			clk: in std_logic;
			tick: out std_logic
		);
	end component baudrate_gen;
	
	signal tick_t: std_logic := '0';
	
	signal rx_out_t : std_logic_vector(7 downto 0);
	signal rx_t: std_logic := '1';
	signal clk_t: std_logic := '1';
		
begin

	bgen : baudrate_gen
	generic map (N => 163)
	port map (
		clk => clk_t,
		tick => tick_t
	);
	
	logic : uart_rcv
	port map (
		clk => clk_t,
		rx_done => open,
		rx => rx_t,
		baudtick => tick_t,
		rx_out => rx_out_t
	);
	
	rx_out <= rx_out_t;
	clk_t <= clk;
	rx_t <= rx;
	rx_done <= '0';
	
end uart_rcv_wrap_arq;