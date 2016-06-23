library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use work.includes.all;

entity testbench is
end entity testbench;

architecture simulacion of testbench is
	constant TCK: time:= 20 ns; -- periodo de reloj
	constant DELAY: natural:= 25; -- retardo de procesamiento del DUT
	constant N: natural:= 25;	-- tamano de datos
	constant E: natural:= 7;	-- tamano de datos

	
	signal clk: std_logic:= '0';
	signal a_file: unsigned(N-1 downto 0):= (others => '0');
	signal b_file: unsigned(N-1 downto 0):= (others => '0');
	signal z_file: unsigned(N-1 downto 0):= (others => '0');
	signal z_del: unsigned(N-1 downto 0):= (others => '0');
	signal z_dut: std_logic_vector(N-1 downto 0):= (others => '0');
	signal load_aux: std_logic := '1';
	-- z_del_aux se define por un problema de conversión
	signal z_del_aux: std_logic_vector(N-1 downto 0):= (others => '0');
	
	file datos: text open read_mode is "C:\25-7.txt";
	
	--for all: sum use entity work.sumador(arq_clock);

begin
	-- generacion del clock del sistema
	clk <= not(clk) after TCK/ 2; -- reloj

	Test_Sequence: process
		variable l: line;
		variable ch: character:= ' ';
		variable aux: integer;
	begin
		while not(endfile(datos)) loop 		-- si se quiere leer de stdin se pone "input"
			load_aux <= '1';
			wait until rising_edge(clk);
			readline(datos, l); 			-- se lee una linea del archivo de valores de prueba
			read(l, aux); 					-- se extrae un entero de la linea
			a_file <= to_unsigned(aux, N); 	-- se carga el valor del operando A
			read(l, ch); 					-- se lee un caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero de la linea
			b_file <= to_unsigned(aux, N); 	-- se carga el valor del operando B
			
			read(l, ch); 					-- se lee otro caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero
			z_file <= to_unsigned(aux, N); 	-- se carga el valor de salida (resultado)
			wait until rising_edge(clk);
			load_aux <= '0';
			wait for TCK*(DELAY+2);
		end loop;
		
		file_close(datos); -- cierra el archivo
		wait for TCK*(DELAY+1); -- se pone el +1 para poder ver los datos
		assert false report -- este assert se pone para abortar la simulacion
			"Fin de la simulacion" severity failure;
	end process Test_Sequence;
			 
	DUT: mul_float
		generic map(S => N, E => E)
		port map(
			a_in => std_logic_vector(a_file),
			b_in => std_logic_vector(b_file),
			m_out => z_dut,
			clk => clk,
			load => load_aux
		);			 
			 
	del: delay_gen 	generic map(N, DELAY)
				port map(clk, std_logic_vector(z_file), z_del_aux);
				
	z_del <= unsigned(z_del_aux);
	
	-- Verificacion de la condicion
	verificacion: process
	begin
		wait until rising_edge(load_aux);
		wait for TCK*(DELAY+3);
--			report integer'image(to_integer(a_file)) & " " & integer'image(to_integer(b_file)) & " " & integer'image(to_integer(z_file));
		assert to_integer(z_del) = to_integer(unsigned(z_dut)) report
			"Salida del DUT es "& 
			integer'image(to_integer(unsigned(z_dut))) &
			", salida del archivo es " &
			integer'image(to_integer(z_del)) & " : ERROR"
			severity warning;
		assert to_integer(z_del) /= to_integer(unsigned(z_dut)) report
			"Salida del DUT es "& 
			integer'image(to_integer(unsigned(z_dut))) &
			", salida del archivo es " &
			integer'image(to_integer(z_del)) & " : OK"
			severity note;
	end process;

end architecture Simulacion; 
