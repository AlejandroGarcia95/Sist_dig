library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_cordic.all;

entity ram_update_logic is
   generic (COORD_N: natural := 16; ADDR_N: natural := 9);
   port(
		-- Cada pto que el Cordic termina de procesar y las
		-- addr en las que hay que guardarlos
		x_cordic: in std_logic_vector(COORD_N-1 downto 0);
		y_cordic: in std_logic_vector(COORD_N-1 downto 0);
		valid_cordic: in std_logic;
		addr_A_in: out std_logic_vector(ADDR_N-1 downto 0);
		addr_B_in: out std_logic_vector(ADDR_N-1 downto 0);
		x_ram: out std_logic_vector(COORD_N-1 downto 0);
		y_ram: out std_logic_vector(COORD_N-1 downto 0); 
		-- Direcciones del próximo pto a procesar
		addr_A_out: out std_logic_vector(ADDR_N-1 downto 0);
		addr_B_out: out std_logic_vector(ADDR_N-1 downto 0);
		go: in std_logic;	-- Bit para iniciar rotación
		updating: out std_logic;
		cant_ptos: in std_logic_vector(ADDR_N-1 downto 0);
		load_finished: in std_logic;
		clk: in std_logic
   );
end ram_update_logic;

architecture ram_update_logic_arq of ram_update_logic is
	signal counter_o_ena, counter_o_rst: std_logic := '0';
	signal cuenta_o: std_logic_vector(ADDR_N-1 downto 0);
	signal counter_i_ena, counter_i_rst: std_logic := '0';
	signal cuenta_i: std_logic_vector(ADDR_N-1 downto 0);
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if (go = '1') then
				counter_o_ena <= '1';
			end if;
		end if;
 		if (to_integer(unsigned(cuenta_o)) = to_integer(unsigned(cant_ptos)-1)) then 
 			counter_o_ena <= '0';
 			counter_o_rst <= '1';
		else
			counter_o_rst <= '0';
 		end if;
		if (to_integer(unsigned(cuenta_i)) = to_integer(unsigned(cant_ptos)-1)) then 
 			counter_i_rst <= '1';
		else
			counter_i_rst <= '0';
		end if;
		if(valid_cordic = '1') then
			x_ram <= x_cordic;
			y_ram <= y_cordic;
		else
			x_ram <= (others => '0');
			y_ram <= (others => '0');
		end if;
	end process;

	-- Con este contador direcciono los puntos que ingresan al
	-- Cordic para ser rotados
	myCounter_o: contador
		generic map(N => ADDR_N)
		port map (clk, counter_o_rst, counter_o_ena, cuenta_o);
	-- Con este contador direcciono los puntos que me llegan
	-- del Cordic y deben sobrescribir puntos en la memoria
	myCounter_i: contador
		generic map(N => ADDR_N)
		port map (clk, counter_i_rst, counter_i_ena, cuenta_i);

	-- Lectura de la memoria
	addr_A_out <= cuenta_o(ADDR_N-2 downto 0) & '0';
	addr_B_out <= cuenta_o(ADDR_N-2 downto 0) & '1';
	with load_finished select
		updating <= 	counter_o_ena when '1',
						'0' when others;
	
	-- Escritura de la memoria
	with load_finished select
		counter_i_ena <= 	valid_cordic when '1',
							'0' when others;
	addr_A_in <= cuenta_i(ADDR_N-2 downto 0) & '0';
	addr_B_in <= cuenta_i(ADDR_N-2 downto 0) & '1';
		
end ram_update_logic_arq;