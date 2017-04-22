library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_TP2.all;
use work.includes.all;


entity digitilizer is
	port(
		clk : in std_logic;
		sig : in std_logic;
				
		dgts : out std_logic_vector(11 downto 0)	-- 3 digitos BCD.. dgt1 = dgts[11..8], dgt2 = dgts[7..4], dgt3 = dgts[3..0]	
	);
end digitilizer;

architecture digitilizer_arq of digitilizer is

	signal reset_aux : std_logic;
	signal load_aux : std_logic;
	
	signal bcd_count_aux : std_logic_vector(19 downto 0);
	signal register_entry_aux : std_logic_vector(11 downto 0);

	constant MAX_MUESTRAS : natural := 33000;
	constant MAX_MUESTRAS_BITS : natural := 16;

begin
	myContador : contador_TP2		-- Contador que generará la señal de rst para reiniciar cuenta de puntos y load para guardar el valor
		generic map(N => MAX_MUESTRAS_BITS, TOPE => MAX_MUESTRAS)
		port map(
			clk => clk,
			out_store => load_aux,
			out_reset => reset_aux
		);

	myContadorBCD : contBCD			-- Contador BCD que llevará la cuenta de los dígitos a mostrar
		generic map( N => 5 )
		port map(
			clk => clk,
			rst => reset_aux,
			ena => sig,
			c_out => open,
			digitos => bcd_count_aux
		);
	
	register_entry_aux <= bcd_count_aux(19 downto 8);
	
	myRegister : registro
		generic map(N => 12)
		port map(
			data_in => register_entry_aux,
			data_out => dgts,
			clk => clk,
			rst => '0',
			load => load_aux
		);
		
end digitilizer_arq;
