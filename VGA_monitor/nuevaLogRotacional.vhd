library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity logica_rotacional_3d is
   generic (COORD_N: natural := 16; ADDR_N: natural := 9);
   port(
		-- Cada pto que se termina de procesar
		x_out: out std_logic_vector(COORD_N-1 downto 0);
		y_out: out std_logic_vector(COORD_N-1 downto 0);
		z_out: out std_logic_vector(COORD_N-1 downto 0);
		valid: out std_logic;
		-- Detecci�n de rotaci�n
		ang_x_in: in std_logic_vector(15 downto 0);
		ang_y_in: in std_logic_vector(15 downto 0);
		ang_z_in: in std_logic_vector(15 downto 0);
		go: in std_logic;	-- Bit para iniciar rotaci�n
		
		rx: in std_logic;		
		done_uart: out std_logic;
		
		-- Se�al para borrar la mem. de video
		video_reset: out std_logic;
		clk: in std_logic
   );
end logica_rotacional_3d;

architecture logica_rotacional_3d_arq of logica_rotacional_3d is
	-- Se�ales del initHardcoded. PARA MATAR LUEGO
	signal init_done: std_logic := '0';
	-- Se�al para direccionar salida de multiplexores
	-- y entrada de la logic_ram:
	signal mux_sel: std_logic := '1';
	signal mux_x_o, mux_y_o, mux_z_o: std_logic_vector(COORD_N-1 downto 0) := (others => '0');
	-- Buffers de se�ales del multiplexor que va a
	-- la memoria l�gica.
	-- El orden de los datos en los buffers es: x & y & z & addr_x & addr_y & addr_z
	signal mux_ram_I, mux_ram_II, mux_ram_O: std_logic_vector(3*(ADDR_N+COORD_N)-1 downto 0);
	signal write_logicRAM: std_logic := '0';
	-- Se�ales del Cordic y los multiplicadores
	signal x_in_c, y_in_c, z_in_c: std_logic_vector(COORD_N-1 downto 0) := (others => '0');
	signal xsc, ysc, zsc: std_logic_vector(COORD_N-1 downto 0) := (others => '0');
	signal vld_in_c, valid_out, v_o: std_logic;

	-- Se�ales de la RUL
	signal rul_addAin, rul_addBin, rul_addCin, rul_addAout, rul_addBout, rul_addCout: std_logic_vector(ADDR_N-1 downto 0);
	signal rul_xout, rul_yout, rul_zout: std_logic_vector(COORD_N-1 downto 0);
	signal rul_updating, rul_go: std_logic := '0';
	signal rul_cantptos: std_logic_vector(ADDR_N-1 downto 0);
	
	signal uart_addr: std_logic_vector(ADDR_N-1 downto 0);
	signal valid_t: std_logic;
	
begin
	-- Colocar aqu� el componente UART !!! Seguir las sgtes especificaciones:
	-- Las coord. x, y, z que el componente tira y que se tienen que grabar
	-- en la ROM se mappean RESPECTIVAMENTE a: 
	-- mux_ram_I(3*(ADDR_N+COORD_N)-1 downto 3*ADDR_N+2*COORD_N), 
	-- mux_ram_I(3*ADDR_N+2*COORD_N-1 downto 3*ADDR_N+COORD_N)  y 
	-- mux_ram_I(3*ADDR_N+COORD_N-1 downto 3*ADDR_N),
	-- Las addr en las que esas cosas se guardan (que en tu caso ser�a una
	-- �nica pero bueno, que aparezca por triplicado igual) se mappean a:
	-- mux_ram_I(3*ADDR_N-1 downto 2*ADDR_N),
	-- mux_ram_I(2*ADDR_N-1 downto ADDR_N)  y mux_ram_I(ADDR_N-1 downto 0)
	-- La cantidad de puntitos que recibiste por la UART tiene que mappearse
	-- a la se�al rul_cantptos (observar que es un vector de ADDR_N-1 downto 0)
	-- Y la se�al que mandas cuando terminas (que tiene que ser un 1 sostenido
	-- en el tiempo para siempre!) se mappea a la se�al init_done.
	-- Muchas gracias, y perd�n por los mappeos horribles
	-- Lab UART: Your code here.
	
	myUART : uart
		generic map( COORD_N => 16, ADDR_N => 11, NPOINTS => 4, BAUDRATE => 163 )
		port map(
			rx => rx,
			x_coord => mux_ram_I(3*(ADDR_N+COORD_N)-1 downto 3*ADDR_N+2*COORD_N),
			y_coord => mux_ram_I(3*ADDR_N+2*COORD_N-1 downto 3*ADDR_N+COORD_N),
			z_coord => mux_ram_I(3*ADDR_N+COORD_N-1 downto 3*ADDR_N),
			
			addr => uart_addr,
			valid => valid_t,
			done => init_done,
			
			clk => clk
		);
		
		mux_ram_I(3*ADDR_N-1 downto 2*ADDR_N) <= uart_addr when valid_t = '1' else (others => '1');
		mux_ram_I(2*ADDR_N-1 downto ADDR_N) <= uart_addr when valid_t = '1' else (others => '1');
		mux_ram_I(ADDR_N-1 downto 0) <= uart_addr when valid_t = '1' else (others => '1');
		
		rul_cantptos <= uart_addr;
		done_uart <= init_done;
		
		
		
	-- L�gica de actualizaci�n de la RAM
	myRUL: ram_update_logic_3d
		generic map(COORD_N => COORD_N, ADDR_N => ADDR_N)
		port map (mux_x_o, mux_y_o, mux_z_o, v_o, rul_addAin, rul_addBin, rul_addCin, 
		rul_xout, rul_yout, rul_zout, rul_addAout, rul_addBout, rul_addCout,
		rul_go, rul_updating, rul_cantptos, init_done, clk);	
	
	rul_go <= go and (not(rul_updating));
	-- LogicRAM encargada de almacenar los puntos
	myLram: logic_ram_3d
		generic map(COORD_N => COORD_N, ADDR_N => ADDR_N)
		port map (rul_addAout, rul_addBout, rul_addCout, x_in_c, y_in_c, z_in_c, 
		mux_ram_O(3*ADDR_N-1 downto 2*ADDR_N), mux_ram_O(2*ADDR_N-1 downto ADDR_N), 
		mux_ram_O(ADDR_N-1 downto 0), 
		mux_ram_O(3*(ADDR_N+COORD_N)-1 downto 3*ADDR_N+2*COORD_N), 
		mux_ram_O(3*ADDR_N+2*COORD_N-1 downto 3*ADDR_N+COORD_N), 
		mux_ram_O(3*ADDR_N+COORD_N-1 downto 3*ADDR_N), write_logicRAM, clk);

	write_logicRAM <= (not(init_done)) or (init_done and v_o);
	
	-- Mux que maneja la escritura de la RAM
	with mux_sel select
		mux_ram_O <=	mux_ram_I when '0',
						mux_ram_II when '1',
						(others => '0') when others;
	
	mux_ram_II <= mux_x_o & mux_y_o & mux_z_o & rul_addAin & rul_addBin & rul_addCin;
	
	-- Cordic 3d
	myCS: cordic_3d
		generic map(COORD_N => COORD_N)
		port map (x_in_c, y_in_c, z_in_c, ang_x_in, ang_y_in, ang_z_in, 
		xsc, ysc, zsc, vld_in_c, valid_out, clk, "not"(init_done));
			
	
	with mux_sel select
		vld_in_c <=	rul_updating when '1',
					'0' when others;
	
	-- Mux de salida
	with mux_sel select
		mux_x_o <= 	xsc when '1',
					mux_ram_I(3*(ADDR_N+COORD_N)-1 downto 3*ADDR_N+2*COORD_N) when '0',
					(others => '0') when others;
	with mux_sel select
		mux_y_o <= 	ysc when '1',
					mux_ram_I(3*ADDR_N+2*COORD_N-1 downto 3*ADDR_N+COORD_N) when '0',
					(others => '0') when others;
	with mux_sel select
		mux_z_o <= 	zsc when '1',
					mux_ram_I(3*ADDR_N+COORD_N-1 downto 3*ADDR_N) when '0',
					(others => '0') when others;
	-- valid_out a ffd
	ffdValid: ffd
		port map(
			D => valid_out,
			Q => v_o,
			clk => clk,
			rst => '0',
			ena => '1'
		);

	-- Salidas del componente
	x_out <= mux_x_o;
	y_out <= mux_y_o;
	z_out <= mux_z_o;
	valid <= v_o or (not(init_done));
	video_reset <= go and (not(valid_out)) and (not(rul_updating));
end logica_rotacional_3d_arq;