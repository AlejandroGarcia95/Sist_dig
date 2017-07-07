library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Redondeador de números binarios, que toma un
-- número de N_INICIAL bits y lo redondea a uno
-- de N_FINAL bits. Para ello, obviamente utiliza
-- el bit N_INICIAL-N_FINAL-1.
entity redondeador is
   generic (N_INICIAL: natural := 16; N_FINAL: natural := 8);
   port(
      num_in: in std_logic_vector(N_INICIAL-1 downto 0);
      num_out: out std_logic_vector(N_FINAL-1 downto 0)
   );
end redondeador;

architecture redondeador_arq of redondeador is
	signal aux_sel : std_logic;
begin
	aux_sel <= num_in(N_INICIAL -N_FINAL -1);
	-- Si aux_sel es 1, redondeo hacia arriba; si no, 
	-- dejo como está (redondeo hacia abajo)
	with aux_sel select
		num_out <=	num_in(N_INICIAL-1 downto N_INICIAL-N_FINAL) when '0',
					std_logic_vector(unsigned(num_in(N_INICIAL-1 downto N_INICIAL-N_FINAL)) + 1) when '1',
					(others => '0') when others;

end redondeador_arq;