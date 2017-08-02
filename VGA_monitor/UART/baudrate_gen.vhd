library IEEE;
use IEEE.std_logic_1164.all;

-- Genera un pulso cada N ciclos de reloj.
-- La frecuencia tiene que ser 16 veces superior al baud-rate
-- establecido por el protocolo. Asumiendo un reloj de 50 MHz,
-- dependiendo del baudrate se tendrá la cantidad de ciclos a utiliar.
-- 50 MHz/(baud per sec * 16) = N
--		Para un baud rate de 19200, N = 163
entity baudrate_gen is
	generic(N : natural := 163);
	port(
		clk: in std_logic;
		tick: out std_logic
	);
end baudrate_gen;

architecture baudrate_gen_arq of baudrate_gen is
begin
	process(clk)
		variable cont: integer := 0;
	begin
		if rising_edge(clk) then
			cont := cont + 1;
			if cont = N then
				cont := 0;
				tick <= '1';
			else
				tick <= '0';
			end if;
		end if;
	end process;

end baudrate_gen_arq;