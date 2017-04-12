library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Conversor de números binarios complemento a 2 y
-- signados. El generic N determina los bits del
-- número (incluyendo el signo para el caso signed).
-- Si conv_dir es 0, convierte num_in de comp2 a
-- signed. Si conv_dir es 1, convierte num_in de
-- signed a comp2. El resultado se ve en num_out.
entity comp2_signed_conv is
   generic (N: natural := 4);
   port(
      num_in: in std_logic_vector(N-1 downto 0);
      num_out: out std_logic_vector(N-1 downto 0);
	  conv_dir: in std_logic
   );
end comp2_signed_conv;

architecture comp2_signed_conv_arq of comp2_signed_conv is
	signal aux_sel : std_logic_vector(1 downto 0);
begin
	aux_sel <= (conv_dir & num_in(N-1));
	with aux_sel select
		num_out <=	(std_logic_vector((unsigned(not('0' & num_in(N-2 downto 0)))+1))) when "11",
					num_in when "10",
					--('1' & ((not(std_logic_vector(unsigned(num_in)-1)))(N-2 downto 0))) when "01",
					(not(std_logic_vector(unsigned(num_in)-1+2**(N-1)))) when "01",
					num_in when "00",
					(others => '0') when others;

end comp2_signed_conv_arq;