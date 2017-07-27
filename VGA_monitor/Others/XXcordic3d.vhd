library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

-- El cordic_3d emplea el algoritmo de Cordic
-- para rotar un vector de coord. (x, y, z)
-- iniciales en 3 ángulos distintos respecto 
-- los 3 ejes coordenados (primero se rota el
-- pto angulo_x rad según el eje x, luego 
-- angulo_y rad según el eje y, y finalmente
-- angulo_z rad). Al ingresar un dato, se debe
-- colocar valid_in en 1 para así poder ver una
-- salida correcta cuando valid_out esté en 1.
-- Los ángulos deben respetar el sgte formato:
-- Pto fijo 16 bits, con el bit más pesado como 
-- bit de signo, 1 bit de parte entera y 14 bits 
-- de parte decimal. Las coord. del pto también son
-- binarios de pto fijo con 1 bit de signo y 1
-- bit de parte entera, pero la parte decimal
-- varía según el generic COORD_N. COORD_N indica
-- la cant. total de bits a usar (es decir, se
-- usan COORD_N-2 bits de parte decimal).
-- Si los ptos se ingresan uno detrás de otro en
-- cada ciclo de CLK, la primer salida del comp. 
-- tarda en generarse 30+3*COORD_N-3 ciclos de CLK, 
-- pero luego de eso hay una por ciclo de CLK. 
-- IMPORTANTE: la salida del componente YA ESTA 
-- ESCALADA (no hay que agregar multiplicadores).


entity cordic_3d is
	generic ( COORD_N: natural := 16 );
	port (
		x_inicial: in std_logic_vector(COORD_N-1 downto 0);
		y_inicial: in std_logic_vector(COORD_N-1 downto 0);
		z_inicial: in std_logic_vector(COORD_N-1 downto 0);
		angulo_x: in std_logic_vector(15 downto 0);
		angulo_y: in std_logic_vector(15 downto 0);
		angulo_z: in std_logic_vector(15 downto 0);
		x_final: out std_logic_vector(COORD_N-1 downto 0);
		y_final: out std_logic_vector(COORD_N-1 downto 0);
		z_final: out std_logic_vector(COORD_N-1 downto 0);
		valid_in: in std_logic;
		valid_out: out std_logic;
		clk: in std_logic;
		flush: in std_logic
	);

end cordic_3d;
-- AGREGAR MULTIS INTER ETAPAS
architecture cordic_3d_arq of cordic_3d is
	constant CANT_STAGES: natural := 7;
	signal x_c1, y_c1, x_c2, y_c2, x_c3, y_c3: std_logic_vector(COORD_N-1 downto 0);
	signal x_in_c2, x_in_c3, y_in_c3: std_logic_vector(COORD_N-1 downto 0);
	signal x_m1, y_m1, x_m2, y_m2, x_m3, y_m3: std_logic_vector(2*(COORD_N-1)-1 downto 0);
	signal v_out_c1, v_out_c2, v_out_c3, v_in_c2, v_in_c3, fl: std_logic;
	signal v_o_m1x, v_o_m1y, v_o_m2x, v_o_m2y, v_o_m3x, v_o_m3y: std_logic;
	signal s_x1_o, s_y1_o, s_x2_o, s_y2_o, s_x3_o, s_y3_o: std_logic;
	-- La ganancia es de aprox. 1/0.607253 ergo hay que
	-- multiplicar por 0.607253 para anularla.
	signal ganancia: std_logic_vector(14 downto 0) := "010011011011101";
--	signal ganancia: std_logic_vector(14 downto 0) := "010011011011101";
	-- Registros para retrasar valores que no se estan rotando
	--type CONNECTOR is array (CANT_STAGES+COORD_N-1 downto 0) of std_logic_vector(COORD_N-1 downto 0);
	type CONNECTOR is array (CANT_STAGES downto 0) of std_logic_vector(COORD_N-1 downto 0);
	signal a_del, b_del, c_del: CONNECTOR;
begin

	valid_out <= (v_o_m3x and v_o_m3y);
	fl <= flush;
	
	-- Rotacion en x
	rotX: cordic_pipeline
		generic map(COORD_N => COORD_N, STAGES => CANT_STAGES)
		port map (y_inicial, z_inicial, angulo_x, x_c1, y_c1, valid_in, v_out_c1, clk, fl);

	mult1X: multiplicador_hardcodeado_cordic
		generic map(N => COORD_N-1)
		port map (x_c1(COORD_N-2 downto 0), ganancia(14 downto 16-COORD_N), v_out_c1, 
					x_c1(COORD_N-1), x_m1, v_o_m1x, s_x1_o, clk, fl);
	
	mult1Y: multiplicador_hardcodeado_cordic
		generic map(N => COORD_N-1)
		port map (y_c1(COORD_N-2 downto 0), ganancia(14 downto 16-COORD_N), v_out_c1, 
					y_c1(COORD_N-1), y_m1, v_o_m1y, s_y1_o, clk, fl);

	a_del(0) <= x_inicial;				
	-- Rotacion en y
	v_in_c2 <= (v_o_m1x and v_o_m1y);
	x_in_c2 <= s_y1_o & y_m1(2*(COORD_N-1)-2 downto COORD_N-2);
	
	rotY: cordic_pipeline
		generic map(COORD_N => COORD_N, STAGES => CANT_STAGES)
		port map (x_in_c2, a_del(CANT_STAGES), angulo_y, x_c2, y_c2, v_in_c2, v_out_c2, clk, fl);
	
	mult2X: multiplicador_hardcodeado_cordic
		generic map(N => COORD_N-1)
		port map (x_c2(COORD_N-2 downto 0), ganancia(14 downto 16-COORD_N), v_out_c2, 
					x_c2(COORD_N-1), x_m2, v_o_m2x, s_x2_o, clk, fl);
	
	mult2Y: multiplicador_hardcodeado_cordic
		generic map(N => COORD_N-1)
		port map (y_c2(COORD_N-2 downto 0), ganancia(14 downto 16-COORD_N), v_out_c2, 
					y_c2(COORD_N-1), y_m2, v_o_m2y, s_y2_o, clk, fl);
		
	-- Rotación en z
	
	x_in_c3 <= s_y2_o & y_m2(2*(COORD_N-1)-2 downto COORD_N-2);
	y_in_c3 <= s_x1_o & x_m1(2*(COORD_N-1)-2 downto COORD_N-2);
	v_in_c3 <= (v_o_m2x and v_o_m2y);
	
	b_del(0) <= y_in_c3;
	
	rotZ: cordic_pipeline
		generic map(COORD_N => COORD_N, STAGES => CANT_STAGES)
		port map (x_in_c3, b_del(CANT_STAGES), angulo_z, x_c3, y_c3, v_in_c3, v_out_c3, clk, fl);
		
	mult3X: multiplicador_hardcodeado_cordic
		generic map(N => COORD_N-1)
		port map (x_c3(COORD_N-2 downto 0), ganancia(14 downto 16-COORD_N), v_out_c3, 
					x_c3(COORD_N-1), x_m3, v_o_m3x, s_x3_o, clk, fl);
	
	mult3Y: multiplicador_hardcodeado_cordic
		generic map(N => COORD_N-1)
		port map (y_c3(COORD_N-2 downto 0), ganancia(14 downto 16-COORD_N), v_out_c3, 
					y_c3(COORD_N-1), y_m3, v_o_m3y, s_y3_o, clk, fl);
		
	-- Señales retrasadas	
--	create_regs: for j in 1 to CANT_STAGES+COORD_N-1 generate	
	create_regs: for j in 1 to CANT_STAGES generate	
		regA: registro
			generic map(N => COORD_N)
			port map(
				data_in => a_del(j-1),
				data_out => a_del(j),
				clk => clk,
				rst => flush,
				load => '1'
			);
		regB: registro
			generic map(N => COORD_N)
			port map(
				data_in => b_del(j-1),
				data_out => b_del(j),
				clk => clk,
				rst => flush,
				load => '1'
			);
		regC: registro
			generic map(N => COORD_N)
			port map(
				data_in => c_del(j-1),
				data_out => c_del(j),
				clk => clk,
				rst => flush,
				load => '1'
			);
	end generate create_regs;
	
	
	
	x_final <= s_x3_o & x_m3(2*(COORD_N-1)-2 downto COORD_N-2);
	y_final <= s_y3_o & y_m3(2*(COORD_N-1)-2 downto COORD_N-2);
	
	c_del(0) <= s_x2_o & x_m2(2*(COORD_N-1)-2 downto COORD_N-2);
	z_final <= c_del(CANT_STAGES);
	
end cordic_3d_arq;