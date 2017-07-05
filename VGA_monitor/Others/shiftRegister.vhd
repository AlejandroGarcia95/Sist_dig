library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.includes.all;

-- Un simple shift register de entrada y salida serie.
-- Su único objetivo es que le ingreses un bit d_in y
-- te lo muestra en d_out N_DELAY ciclos de clk después.

entity shift_register is
	generic(
		N_DELAY: natural:= 10
	);
	port(
		clk: in std_logic;
		d_in: in std_logic;
		d_out: out std_logic
	);
end;

architecture arq_shift_register of shift_register is
	type auxi is array(0 to N_DELAY+1) of std_logic;
	signal aux: auxi;
	
begin

	aux(0) <= d_in;
	
	f1: for i in 0 to N_DELAY generate
		i1: if i = 0 generate
			aux(1) <= aux(0);
		end generate;
		i2: if i > 0 generate
			aa: ffd
				port map(clk => clk, rst => '0', D => aux(i),
				Q => aux(i+1), ena => '1');
		end generate;
	end generate;
	
	d_out <= aux(N_DELAY+1);
	
end;