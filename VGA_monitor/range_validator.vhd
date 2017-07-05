library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Componente que valida si su entrada num_in
-- de N bits cumple estar en el rango
-- MENOR < num_in < MAYOR
-- Observar las desigualdades estrictas!
-- La salida range_ok vale 1 si se cumple la
-- condición y 0 si no se cumple.  
entity range_validator is
   generic (N: natural := 4; MAYOR: natural := 16; MENOR: natural := 0);
   port(
		num_in: in std_logic_vector(N-1 downto 0);
		range_ok: out std_logic
   );
end range_validator;

architecture range_validator_arq of range_validator is
begin
	process(num_in)
		begin
		if unsigned(num_in) > MENOR then
			if unsigned(num_in) < MAYOR then
				range_ok <= '1';
			else
				range_ok <= '0';
			end if;
		else
			range_ok <= '0';
		end if;
		end process;

end range_validator_arq;