library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_TP2.all;
use work.includes.all;

entity digi_tb2 is
end;

architecture beh of digi_tb2 is

	signal clk_t : std_logic := '0';
	signal sig_t : std_logic := '0';
	signal out_count : std_logic_vector(11 downto 0) := (others => '0');
	
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
			clk => clk_t,
			out_store => load_aux,
			out_reset => reset_aux
		);

	myContadorBCD : contBCD			-- Contador BCD que llevará la cuenta de los dígitos a mostrar
		generic map( N => 5 )
		port map(
			clk => clk_t,
			rst => reset_aux,
			ena => sig_t,
			c_out => open,
			digitos => bcd_count_aux
		);
	
	register_entry_aux <= bcd_count_aux(19 downto 8);
	
	myRegister : registro
		generic map(N => 12)
		port map(
			data_in => register_entry_aux,
			data_out => out_count,
			clk => clk_t,
			rst => '0',
			load => load_aux
		);
		

	clk_t <= not clk_t after 5 ns;
	sig_t <= '1' after 0 ns, '0' after 218000 ns, '1' after 400000 ns, '0' after 440000 ns;

end beh;