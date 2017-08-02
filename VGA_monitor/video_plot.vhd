library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

-- Convierte las coordenadas en pixeles y las guarda en memoria de video.
-- Si valid = '0', ignora la entrada.
entity video_plot is
	generic ( COORD_N: natural := 16 );
	port (
		-- Entrada de coordenadas
		coord_x: in std_logic_vector(COORD_N-1 downto 0);
		coord_y: in std_logic_vector(COORD_N-1 downto 0);
		valid: in std_logic;
		
		-- color: in std_logic_vector(2 downto 0);
		
		-- Sistema de reset del plotter
		-- Enviar un pulso durante al menos un ciclo de reloj.
		-- Esto hace que la memoria entre en estado RESET. Durante este estado
		-- la memoria esperará a que termine el barrido de pantalla actual. En
		-- el siguiente barrido, se ignorará TODA entrada y se irá borrando progresivamente
		-- la memoria. Cuando el barrido de borrado termine, el estado pasa a READY de nuevo
		-- y se envía un pulso de un ciclo de reloj en la salida done_rst.
		
		rst: in std_logic;
		done_rst: out std_logic;
		
		clk: in std_logic;
	
		-- Salida vga
		hs: out std_logic;
		vs: out std_logic;
		red_out: out std_logic_vector(2 downto 0);
		grn_out: out std_logic_vector(2 downto 0);
		blu_out: out std_logic_vector(1 downto 0)
	);

end video_plot;

architecture video_plot_arq of video_plot is
	
	-- Salida y entrada de la memoria RAM
	signal mem_out: std_logic_vector(0 downto 0) := (others => '0');
	signal mem_in: std_logic_vector(0 downto 0) := (others => '0');
	
	-- Direcciones del barrido de pixeles
	signal pixel_col, pixel_row: std_logic_vector(9 downto 0);
	-- Direcciones para escribir datos del cordic y bit de lectura
	signal address_col, address_row: std_logic_vector(9 downto 0);
	signal address_x: std_logic_vector(9 downto 0) := (others => '0');
	signal address_y: std_logic_vector(8 downto 0) := (others => '0');

	signal wr_flag: std_logic;
	
	-- Señal del video_ram que se pone en '1' al comenzar un nuevo barrido de pantalla
	signal swipe_start: std_logic := '0';
	signal resetting: std_logic := '0';
	
begin
	-- El controlador que hace el barrido y genera salida vga
	v_ctrl : vga_ctrl
		port map(
			mclk => clk,
			red_i => mem_out(0),
			grn_i => mem_out(0),
			blu_i => mem_out(0),
			hs => hs,
			vs => vs,
			red_o => red_out,
			grn_o => grn_out,
			blu_o => blu_out,
			pixel_row => pixel_row,
			pixel_col => pixel_col,
			swipe_start => swipe_start
		);

	-- La memoria de video RAM dual port
	v_ram : video_ram
		generic map(N => 1)
		port map(
			clk => clk,
			pixel_col_out => pixel_col,
			pixel_row_out => pixel_row,
			data_out => mem_out,
			
			pixel_col_in => address_col,
			pixel_row_in => address_row,
			data_in => mem_in,
			
			write_flag => wr_flag
		);
	
	-- Lab reset: Your code here.
	v_rst : video_reset
		port map(
		clk => clk,
		
		sig_swipe_start => swipe_start,
		sig_reset => rst,
		
		is_resetting => resetting,
		is_waiting => open,
		
		done_rst => done_rst
		);
			
	-- Conversor de coordenadas a pixeles
	myCS: address_generator
		generic map(COORD_N => COORD_N)
		port map (
			x_coord => coord_x,
			y_coord => coord_y,
			pixel_x => address_x,
			pixel_y => address_y,
			ena => '1'
		);
		
	-- Si está en modo ressetting, pisar siempre con ceros
	address_col <= (address_x(9 downto 0)) when (resetting = '0') else pixel_col;
	address_row <= ('0' & address_y(8 downto 0)) when (resetting = '0') else pixel_row;
	wr_flag <= valid when (resetting = '0') else '1';
	
	mem_in <= "1" when (resetting = '0') else "0";

	
end video_plot_arq;



