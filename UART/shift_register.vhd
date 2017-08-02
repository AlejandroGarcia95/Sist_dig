library IEEE;
use IEEE.std_logic_1164.all;

-- Uses FFD
use work.includes_uart.all;

-- Shift register de N bits con entrada serie y salida en paralelo
entity shift_reg is
	generic(N : natural := 8);
	port(
		clk: in std_logic;
		ena: in std_logic;
		ds_in: in std_logic;
		dp_out: out std_logic_vector(N-1 downto 0)
	);
end shift_reg;

architecture shift_reg_arq of shift_reg is
	
	-- Señales auxiliares para los datos
	signal dp_out_aux: std_logic_vector(N-1 downto 0);
	signal ds_in_aux: std_logic;

	
begin

	ds_in_aux <= ds_in;
	
	gen_retardo: for i in 0 to (N-1) generate
		first_one: if i = 0 generate
			myFFD : FFD
				port map(clk, '0', ena, ds_in_aux, dp_out_aux(i));
		end generate first_one;
		the_others: if i > 0 generate
			myFFD : FFD
				port map(clk, '0', ena, dp_out_aux(i-1), dp_out_aux(i));
		end generate the_others;
	end generate;
	
	dp_out <= dp_out_aux;
	
end shift_reg_arq;