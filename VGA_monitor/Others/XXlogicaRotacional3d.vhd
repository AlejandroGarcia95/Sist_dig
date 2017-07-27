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
		-- Detección de rotación
		ang_x_in: in std_logic_vector(15 downto 0);
		ang_y_in: in std_logic_vector(15 downto 0);
		ang_z_in: in std_logic_vector(15 downto 0);
		go: in std_logic;	-- Bit para iniciar rotación
		-- Señal para borrar la mem. de video
		video_reset: out std_logic;
		clk: in std_logic
   );
end logica_rotacional_3d;

architecture logica_rotacional_3d_arq of logica_rotacional_3d is
	-- Señales del initHardcoded. PARA MATAR LUEGO
	signal init_done: std_logic := '0';
	-- Señal para direccionar salida de multiplexores
	-- y entrada de la logic_ram:
	signal mux_sel: std_logic := '1';
	signal mux_x_o, mux_y_o, mux_z_o: std_logic_vector(COORD_N-1 downto 0) := (others => '0');
	-- Buffers de señales del multiplexor que va a
	-- la memoria lógica.
	-- El orden de los datos en los buffers es: x & y & z & addr_x & addr_y & addr_z
	signal mux_ram_I, mux_ram_II, mux_ram_O: std_logic_vector(3*(ADDR_N+COORD_N)-1 downto 0);
	signal write_logicRAM: std_logic := '0';
	-- Señales del Cordic y los multiplicadores
	signal x_in_c, y_in_c, z_in_c: std_logic_vector(COORD_N-1 downto 0) := (others => '0');
	signal xsc, ysc, zsc: std_logic_vector(COORD_N-1 downto 0) := (others => '0');
	signal vld_in_c, valid_out, v_o: std_logic;

	-- Señales de la RUL
	signal rul_addAin, rul_addBin, rul_addCin, rul_addAout, rul_addBout, rul_addCout: std_logic_vector(ADDR_N-1 downto 0);
	signal rul_xout, rul_yout, rul_zout: std_logic_vector(COORD_N-1 downto 0);
	signal rul_updating, rul_go: std_logic := '0';
	signal rul_cantptos: std_logic_vector(ADDR_N-1 downto 0);
begin
	-- initHardcoded que inicia la RAM. MATAR LUEGO
	myIH: init_hardcoded_3d
		generic map(COORD_N => COORD_N, ADDR_N => ADDR_N, CANT_PUNTOS => 9)
		port map (mux_ram_I(3*(ADDR_N+COORD_N)-1 downto 3*ADDR_N+2*COORD_N), 
		mux_ram_I(3*ADDR_N+2*COORD_N-1 downto 3*ADDR_N+COORD_N), 
		mux_ram_I(3*ADDR_N+COORD_N-1 downto 3*ADDR_N), mux_ram_I(3*ADDR_N-1 downto 2*ADDR_N),
		mux_ram_I(2*ADDR_N-1 downto ADDR_N), mux_ram_I(ADDR_N-1 downto 0), 
		init_done, rul_cantptos, clk);	
	mux_sel <= init_done;

	-- Lógica de actualización de la RAM
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