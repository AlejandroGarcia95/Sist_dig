library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.includes_uart.all;

entity uart is
	generic( COORD_N: natural := 16; ADDR_N: natural := 11; NPOINTS: natural := 3; BAUDRATE: natural := 163);
	port(
		rx: in std_logic;
		
		x_coord: out std_logic_vector(COORD_N-1 downto 0);
		y_coord: out std_logic_vector(COORD_N-1 downto 0);
		z_coord: out std_logic_vector(COORD_N-1 downto 0);
		
		addr: out std_logic_vector(ADDR_N-1 downto 0);
		valid: out std_logic;
		done: out std_logic;
		
		--- DEBUG
		led_out: out std_logic_vector(7 downto 0);
		switch_in: in std_logic_vector(2 downto 0);
		
		clk: in std_logic
	);
	
	attribute loc: string;
			
	-- Mapeo de pines para el kit Nexys 2 (spartan 3E)
	attribute loc of clk: signal is "B8";
	attribute loc of rx: signal is "U6";
		
	--- DEBUG
	attribute loc of led_out: signal is "J14 J15 K15 K14 E17 P15 F4 R4";
	attribute loc of switch_in: signal is "K18 H18 G18";
		
end uart;

architecture uart_arq of uart is
	signal tick_t: std_logic := '0';
	signal rx_out_t : std_logic_vector(7 downto 0);
	signal rx_done_t : std_logic := '0';
	
	
	--- DEBUG
	signal x_coord_t: std_logic_vector(15 downto 0);
	signal y_coord_t: std_logic_vector(15 downto 0);
	signal z_coord_t: std_logic_vector(15 downto 0);
	signal addr_t: std_logic_vector(10 downto 0);
	signal led_out_aux: std_logic_vector(7 downto 0);
		
begin
	bgen : baudrate_gen
	generic map (N => BAUDRATE)
	port map (
		clk => clk,
		tick => tick_t
	);
	
	logic : uart_rcv
	port map (
		clk => clk,
		rx_done => rx_done_t,
		rx => rx,
		baudtick => tick_t,
		rx_out => rx_out_t
	);
	
	interface : uart_interface
	generic map (COORD_N, ADDR_N, NPOINTS) 
	port map (
		rx_in => rx_out_t,
		rx_done => rx_done_t,
		
		x_coord => x_coord_t,
		y_coord => y_coord_t,
		z_coord => z_coord_t,
		
		addr => addr_t,
		valid => valid,
		done => done,
			
		clk => clk
	);
	
	led_out <=  x_coord_t(15 downto 8) when switch_in = "000" else
				x_coord_t(7 downto 0)  when switch_in = "001" else
				y_coord_t(15 downto 8) when switch_in = "010" else
				y_coord_t(7 downto 0)  when switch_in = "011" else
				z_coord_t(15 downto 8) when switch_in = "100" else
				z_coord_t(7 downto 0)  when switch_in = "101" else
				addr_t(7 downto 0)	   when switch_in = "110" else
				"10101010";

	x_coord <= x_coord_t;
	y_coord <= y_coord_t;
	z_coord <= z_coord_t;
	addr <= addr_t;
end uart_arq;