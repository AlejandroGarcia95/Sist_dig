library IEEE;
use IEEE.std_logic_1164.all;

-- Importar como
-- use work.includes_uart.all;

package includes_uart is
	component ffd is
	   port(
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			D: in std_logic;
			Q: out std_logic
	   );
	end component ffd;
	
	
	component shift_reg is
		generic(N : natural := 8);
		port(
			clk: in std_logic;
			ena: in std_logic;
			ds_in: in std_logic;
			dp_out: out std_logic_vector(N-1 downto 0)
		);
	end component shift_reg;
	
	
	component registro is
		generic (N: natural := 4);
		port(
			data_in: in std_logic_vector(N-1 downto 0);
			data_out: out std_logic_vector(N-1 downto 0);
			clk: in std_logic;
			rst: in std_logic;
			load: in std_logic
		);
	end component registro;
	
	-- Específicos de la UART
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
	
	
	-- COMPONENTE UART COMPLETO
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
			
			clk: in std_logic
		);			
	end component uart;
	
	
end package;