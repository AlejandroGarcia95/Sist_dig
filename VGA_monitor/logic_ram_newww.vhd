library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

-- El componente logic_ram es el encargado de
-- amacenar las coordenadas del objeto 2D en
-- formato binario punto fijo con signo. De
-- esta forma, en cada ciclo de clock el rotador
-- de Cordic puede leer un par de coordenadas
-- (x,y) de memoria a través de sus dos puertos
-- de salida data_A_out y data_B_out. Se supone
-- que las coordenadas (x,y) de un punto se
-- encuentran en posiciones de mem. consecutivas.
-- De la misma manera, es posible escribir un
-- par de coordenadas (x,y) por ciclo de clock
-- en la memoria a través de los puertos de data_in.
-- El ancho de la memoria (aka la cant. de bits
-- empleados para representar cada coord) viene
-- dado por el generic COORD_N; mientras que la
-- cant. de bits para direccionar la memoria por
-- ADDR_N (2**ADDR_N -1 posiciones de mem.).

entity logic_ram is
	generic(
		ADDR_N: natural := 15;
		COORD_N: natural := 16			
	);
	
	port(
		-- Para obtener valores de la memoria
		addr_A_out: in std_logic_vector(ADDR_N-1 downto 0);
		addr_B_out: in std_logic_vector(ADDR_N-1 downto 0);
		data_A_out: out std_logic_vector(COORD_N-1 downto 0);
		data_B_out: out std_logic_vector(COORD_N-1 downto 0);
		-- Para escribir valores de la memoria
		addr_A_in: in std_logic_vector(ADDR_N-1 downto 0);
		addr_B_in: in std_logic_vector(ADDR_N-1 downto 0);
		data_A_in: in std_logic_vector(COORD_N-1 downto 0);
		data_B_in: in std_logic_vector(COORD_N-1 downto 0);
		write_flag: in std_logic;	
		
		clk: in std_logic
	);


end logic_ram;


architecture logic_ram_arq of logic_ram is

--type ram_t is array (2**(ADDR_N)-1 downto 0) of std_logic_vector(COORD_N-1 downto 0);

--shared variable ram: ram_t;

begin

	miniA: mini_logic_ram
		generic map(
			ADDR_N => ADDR_N ,
			COORD_N => COORD_N			
		)
		
		port map(
			addr_A_out => addr_A_out,
			data_A_out => data_A_out,
			-- Para escribir valores de la memoria
			addr_A_in => addr_A_in,
			data_A_in => data_A_in,
			write_flag => write_flag,
			
			clk => clk
		);
		
	miniB: mini_logic_ram
		generic map(
			ADDR_N => ADDR_N ,
			COORD_N => COORD_N			
		)
		
		port map(
			addr_A_out => addr_B_out,
			data_A_out => data_B_out,
			-- Para escribir valores de la memoria
			addr_A_in => addr_B_in,
			data_A_in => data_B_in,
			write_flag => write_flag,
			
			clk => clk
		);



	
end logic_ram_arq;




