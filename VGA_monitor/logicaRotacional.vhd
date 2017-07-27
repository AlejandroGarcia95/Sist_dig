library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity logica_rotacional is
   generic (COORD_N: natural := 16; STAGES : natural := 10; ADDR_N: natural := 9);
   port(
		-- Cada pto que se termina de procesar
		x_out: out std_logic_vector(COORD_N-1 downto 0);
		y_out: out std_logic_vector(COORD_N-1 downto 0);
		valid: out std_logic;
		-- Detección de rotación
		z_in: in std_logic_vector(15 downto 0);
		go: in std_logic;	-- Bit para iniciar rotación
		-- Señal para borrar la mem. de video
		video_reset: out std_logic;
		clk: in std_logic
   );
end logica_rotacional;

architecture logica_rotacional_arq of logica_rotacional is
	-- Señales del initHardcoded. PARA MATAR LUEGO
	signal init_done: std_logic := '0';
	-- Señal para direccionar salida de multiplexores
	-- y entrada de la logic_ram:
	signal mux_sel: std_logic := '1';
	signal mux_x_o, mux_y_o: std_logic_vector(COORD_N-1 downto 0) := (others => '0');
	-- Buffers de señales del multiplexor que va a
	-- la memoria lógica.
	-- El orden de los datos en los buffers es: x & y & addr_x & addr_y
	signal mux_ram_I, mux_ram_II, mux_ram_O: std_logic_vector(2*(ADDR_N+COORD_N)-1 downto 0);
	signal write_logicRAM: std_logic := '0';
	-- Señales del Cordic y los multiplicadores
	signal x_in_c, y_in_c: std_logic_vector(COORD_N-1 downto 0) := (others => '0');
	signal xsc, ysc: std_logic_vector(COORD_N-1 downto 0);
	signal xm, ym: std_logic_vector(2*(COORD_N-1)-1 downto 0);
	signal vld_in_c, valid_out: std_logic;
	signal vld_oc, vld_ox, vld_oy, v_o: std_logic;
	signal signo_x, signo_y: std_logic;
	-- La ganancia es de aprox. 1/0.607253 ergo hay que
	-- multiplicar por 0.607253 para anularla.
	signal ganancia: std_logic_vector(14 downto 0) := "010011011011101";
	-- Señales de la RUL
	signal rul_addAin, rul_addBin, rul_addAout, rul_addBout: std_logic_vector(ADDR_N-1 downto 0);
	signal rul_xout, rul_yout: std_logic_vector(COORD_N-1 downto 0);
	signal rul_updating, rul_go: std_logic := '0';
	signal rul_cantptos: std_logic_vector(ADDR_N-1 downto 0);
begin
	-- initHardcoded que inicia la RAM. MATAR LUEGO
	myIH: init_hardcoded
		generic map(COORD_N => COORD_N, ADDR_N => ADDR_N, CANT_PUNTOS => 256)
		port map (mux_ram_I(2*(ADDR_N+COORD_N)-1 downto 2*ADDR_N+COORD_N), 
		mux_ram_I(2*ADDR_N+COORD_N-1 downto 2*ADDR_N), mux_ram_I(2*ADDR_N-1 downto ADDR_N), 
		mux_ram_I(ADDR_N-1 downto 0), init_done, rul_cantptos, clk);	
	mux_sel <= init_done;

	-- Lógica de actualización de la RAM
	myRUL: ram_update_logic
		generic map(COORD_N => COORD_N, ADDR_N => ADDR_N)
		port map (mux_x_o, mux_y_o, v_o, rul_addAin, rul_addBin, rul_xout, rul_yout, 
		rul_addAout, rul_addBout, rul_go, rul_updating, rul_cantptos, init_done,clk);	
	
	rul_go <= go and (not(rul_updating));
	-- LogicRAM encargada de almacenar los puntos
	myLram: logic_ram
		generic map(COORD_N => COORD_N, ADDR_N => ADDR_N)
		port map (rul_addAout, rul_addBout, x_in_c, y_in_c, mux_ram_O(2*ADDR_N-1 downto ADDR_N), 
		mux_ram_O(ADDR_N-1 downto 0), mux_ram_O(2*(ADDR_N+COORD_N)-1 downto 2*ADDR_N+COORD_N), 
		mux_ram_O(2*ADDR_N+COORD_N-1 downto 2*ADDR_N), write_logicRAM, clk);

	write_logicRAM <= (not(init_done)) or (init_done and v_o);
	
	-- Mux que maneja la escritura de la RAM
	with mux_sel select
		mux_ram_O <=	mux_ram_I when '0',
						mux_ram_II when '1',
						(others => '0') when others;
	
	mux_ram_II <= mux_x_o & mux_y_o & rul_addAin & rul_addBin;
	
	-- Cordic y multiplicadores posteriores
	myCS: cordic_pipeline
		generic map(COORD_N => COORD_N, STAGES => STAGES)
		port map (x_in_c, y_in_c, z_in, xsc, ysc, vld_in_c, vld_oc, clk, "not"(init_done));
	
	with mux_sel select
		vld_in_c <=	rul_updating when '1',
					'0' when others;
	--rul_updating <= vld_in_c;
	
		
 	multiX: multiplicador
 		generic map(N => COORD_N-1)
 		port map (xsc(COORD_N-2 downto 0), ganancia, vld_oc, xsc(COORD_N-1), xm, vld_ox, signo_x, clk, "not"(init_done));
 	
 	multiY: multiplicador
 		generic map(N => COORD_N-1)
 		port map (ysc(COORD_N-2 downto 0), ganancia, vld_oc, ysc(COORD_N-1), ym, vld_oy, signo_y, clk, "not"(init_done));
	
	-- Mux de salida
	with mux_sel select
		mux_x_o <= 	signo_x & xm(2*(COORD_N-1)-2 downto COORD_N-2) when '1',
					mux_ram_I(2*(ADDR_N+COORD_N)-1 downto 2*ADDR_N+COORD_N) when '0',
					(others => '0') when others;
	with mux_sel select
		mux_y_o <= 	signo_y & ym(2*(COORD_N-1)-2 downto COORD_N-2) when '1',
					mux_ram_I(2*ADDR_N+COORD_N-1 downto 2*ADDR_N) when '0',
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
	valid_out <= vld_ox and vld_oy;
	valid <= v_o or (not(init_done));
	video_reset <= go and (not(valid_out)) and (not(rul_updating));
end logica_rotacional_arq;