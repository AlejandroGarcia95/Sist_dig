library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Uses shift_reg
use work.includes_uart.all;

-- UART receiver logic
entity uart_rcv is
	port(
		-- Data input
		rx: in std_logic;
	
		-- Data output and data ready signal
		rx_out: out std_logic_vector(7 downto 0);
		rx_done: out std_logic;
		
		-- Debug state
		-- dbg_idle: out std_logic;
		-- dbg_first: out std_logic;
		-- dbg_data: out std_logic;
		-- dbg_store: out std_logic;
		
		-- Synchronous clock and baudrate tick
		baudtick: in std_logic;	
		clk: in std_logic
	);
end uart_rcv;

architecture uart_rcv_arq of uart_rcv is
	-- Internal state signals
	signal idle: std_logic := '1';
	signal rcv_first: std_logic := '0';
	signal rcv_data: std_logic := '0';
	signal rcv_ending: std_logic := '0';
	
	signal store: std_logic;
	
begin
	process(clk)
		variable cont: integer := 0;
		variable bits: integer := 0;
	begin
		if rising_edge(clk) then
			if baudtick = '1' then
				-- If idle, wait until rx = 0
				if idle = '1' then
					rx_done <= '0';
					if rx = '0' then
						cont := 0;
						idle <= '0';
						rcv_first <= '1';
					end if;
				
				-- If rcv_first header bit wait to align
				elsif rcv_first = '1' then
					if cont = 7 then
						cont := 0;
						bits := 0;
						rcv_first <= '0';
						rcv_data <= '1';
					else
						cont := cont + 1;
					end if;
				
				-- If rec_data, wait 15 baudticks and take sample
				elsif rcv_data = '1' then
					if cont = 15 then
						cont := 0;
						bits := bits + 1;
						store <= '1';
					else
						cont := cont + 1;
						store <= '0';
						if bits = 8 then
							bits := 0;
							rcv_ending <= '1';
							rcv_data <= '0';
							rx_done <= '1';
						end if;
					end if;
					
				-- Wait to recieve the last half of the last bit
				elsif rcv_ending = '1' then
					if cont = 7 then
						cont := 0;
						bits := 0;
						rcv_ending <= '0';
						idle <= '1';
					else
						cont := cont + 1;
					end if;
				end if;
			else
			
				rx_done <= '0';
				store <= '0';
			end if;
		end if;
	end process;
	
	myReg : shift_reg
		generic map (N => 8)
		port map(
			clk => clk,
			ena => store,
			ds_in => rx,
			dp_out => rx_out
		);
	
	
	
	-- dbg_data <= rcv_data;
	-- dbg_first <= rcv_first;
	-- dbg_idle <= idle;
	-- dbg_store <= store;
end uart_rcv_arq;