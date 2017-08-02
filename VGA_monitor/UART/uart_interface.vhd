library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Uses registro
use work.includes.all;

entity uart_interface is
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
	
end uart_interface;

architecture uart_interface_arq of uart_interface is
	
	signal reset: std_logic := '0';
	
	signal addr_aux: std_logic_vector(ADDR_N-1 downto 0) := (others => '1');
	signal valid_aux: std_logic := '0';
	signal done_aux: std_logic := '0';
	
	signal ena_select: std_logic_vector(5 downto 0) := "100000";
	signal ena_select_aux: std_logic_vector(5 downto 0);
	
	
begin

	xhigh : registro
		generic map (N => 8)
		port map (
			data_in => rx_in,
			data_out => x_coord(COORD_N-1 downto COORD_N/2),
			clk => clk,
			rst => '0',
			load => ena_select_aux(5)
		);
	
	xlow : registro
		generic map (N => 8)
		port map (
			data_in => rx_in,
			data_out => x_coord(COORD_N/2 - 1 downto 0),
			clk => clk,
			rst => '0',
			load => ena_select_aux(4)
		);
	
	
	yhigh : registro
		generic map (N => 8)
		port map (
			data_in => rx_in,
			data_out => y_coord(COORD_N-1 downto COORD_N/2),
			clk => clk,
			rst => '0',
			load => ena_select_aux(3)
		);
	
	ylow : registro
		generic map (N => 8)
		port map (
			data_in => rx_in,
			data_out => y_coord(COORD_N/2 - 1 downto 0),
			clk => clk,
			rst => '0',
			load => ena_select_aux(2)
		);
		
	zhigh : registro
		generic map (N => 8)
		port map (
			data_in => rx_in,
			data_out => z_coord(COORD_N-1 downto COORD_N/2),
			clk => clk,
			rst => '0',
			load => ena_select_aux(1)
		);
	
	zlow : registro
		generic map (N => 8)
		port map (
			data_in => rx_in,
			data_out => z_coord(COORD_N/2 - 1 downto 0),
			clk => clk,
			rst => '0',
			load => ena_select_aux(0)
		);
		
	
	process(clk)
		variable count: integer range 0 to 2**ADDR_N-1;
	begin
		if rising_edge(clk) and (done_aux = '0') then
			if rx_done = '1' then
				if ena_select = "100000" then
					ena_select <= "010000";
				elsif ena_select = "010000" then
					ena_select <= "001000";
				elsif ena_select = "001000" then
					ena_select <= "000100";
				elsif ena_select = "000100" then
					ena_select <= "000010";
				elsif ena_select = "000010" then
					ena_select <= "000001";
				elsif ena_select = "000001" then
					ena_select <= "100000";
					valid_aux <= '1';
				end if;
			else
				if (valid_aux = '1') then
					if (count = NPOINTS) then
						done_aux <= '1';
					else
						count := count + 1;
					end if;
				end if;
				valid_aux <= '0';
			end if;
			addr_aux <= std_logic_vector(to_unsigned(count, ADDR_N));
		end if;
	end process;


	ena_select_aux(0) <= ena_select(0) and rx_done;
	ena_select_aux(1) <= ena_select(1) and rx_done;
	ena_select_aux(2) <= ena_select(2) and rx_done;
	ena_select_aux(3) <= ena_select(3) and rx_done;
	ena_select_aux(4) <= ena_select(4) and rx_done;
	ena_select_aux(5) <= ena_select(5) and rx_done;
	
	addr <= addr_aux when done_aux = '1' else
			(others => '1') when valid_aux = '0' else (addr_aux);
	valid <= valid_aux;
	done <= done_aux;
	
end uart_interface_arq;