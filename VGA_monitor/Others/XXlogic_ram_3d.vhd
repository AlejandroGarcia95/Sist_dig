library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

-- El componente logic_ram es el encargado de
-- amacenar las coordenadas del objeto 3D en
-- formato binario punto fijo con signo. De
-- esta forma, en cada ciclo de clock el rotador
-- de Cordic puede leer un par de coordenadas
-- (x,y,z) de memoria a través de sus tres puertos
-- de salida data_out (A, B y C). Se supone
-- que las coordenadas (x,y,z) de un punto se
-- encuentran en posiciones de mem. consecutivas.
-- De la misma manera, es posible escribir un
-- par de coordenadas (x,y,z) por ciclo de clock
-- en la memoria a través de los puertos de data_in.
-- El ancho de la memoria (aka la cant. de bits
-- empleados para representar cada coord) viene
-- dado por el generic COORD_N; mientras que la
-- cant. de bits para direccionar la memoria por
-- ADDR_N (2**ADDR_N -1 posiciones de mem.).

entity logic_ram_3d is
	generic(
		ADDR_N: natural := 15;
		COORD_N: natural := 16			
	);
	
	port(
		-- Para obtener valores de la memoria
		addr_A_out: in std_logic_vector(ADDR_N-1 downto 0);
		addr_B_out: in std_logic_vector(ADDR_N-1 downto 0);
		addr_C_out: in std_logic_vector(ADDR_N-1 downto 0);
		data_A_out: out std_logic_vector(COORD_N-1 downto 0);
		data_B_out: out std_logic_vector(COORD_N-1 downto 0);
		data_C_out: out std_logic_vector(COORD_N-1 downto 0);
		-- Para escribir valores de la memoria
		addr_A_in: in std_logic_vector(ADDR_N-1 downto 0);
		addr_B_in: in std_logic_vector(ADDR_N-1 downto 0);
		addr_C_in: in std_logic_vector(ADDR_N-1 downto 0);
		data_A_in: in std_logic_vector(COORD_N-1 downto 0);
		data_B_in: in std_logic_vector(COORD_N-1 downto 0);
		data_C_in: in std_logic_vector(COORD_N-1 downto 0);
		write_flag: in std_logic;	
		
		clk: in std_logic
	);


end logic_ram_3d;


architecture logic_ram_3d_arq of logic_ram_3d is

--type ram_t is array (2**(ADDR_N)-1 downto 0) of std_logic_vector(COORD_N-1 downto 0);

--shared variable ram: ram_t;

begin

	miniA: mini_logic_ram
		generic map(
			ADDR_N => ADDR_N-1 ,
			COORD_N => COORD_N			
		)
		
		port map(
			addr_A_out => addr_A_out(ADDR_N-2 downto 0),
			data_A_out => data_A_out,
			-- Para escribir valores de la memoria
			addr_A_in => addr_A_in(ADDR_N-2 downto 0),
			data_A_in => data_A_in,
			write_flag => write_flag,
			
			clk => clk
		);
		
	miniB: mini_logic_ram
		generic map(
			ADDR_N => ADDR_N-1 ,
			COORD_N => COORD_N			
		)
		
		port map(
			addr_A_out => addr_B_out(ADDR_N-2 downto 0),
			data_A_out => data_B_out,
			-- Para escribir valores de la memoria
			addr_A_in => addr_B_in(ADDR_N-2 downto 0),
			data_A_in => data_B_in,
			write_flag => write_flag,
			
			clk => clk
		);

		
	miniC: mini_logic_ram
		generic map(
			ADDR_N => ADDR_N-1 ,
			COORD_N => COORD_N			
		)
		
		port map(
			addr_A_out => addr_C_out(ADDR_N-2 downto 0),
			data_A_out => data_C_out,
			-- Para escribir valores de la memoria
			addr_A_in => addr_C_in(ADDR_N-2 downto 0),
			data_A_in => data_C_in,
			write_flag => write_flag,
			
			clk => clk
		);

	
end logic_ram_3d_arq;




