library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

-- un contador genérico de n bits
entity contador_TP2 is
	generic( N : natural := 2;
			 TOPE : natural := 3);
	port (
		clk: in std_logic;			-- clock
		out_store: out std_logic;	-- se pone en 1 cuando la cuenta alcanza TOPE-2
		out_reset: out std_logic	-- se pone en 1 cuando la cuenta alcanza TOPE-1
	);
end contador_TP2;


architecture contador_TP2_arq of contador_TP2 is

	signal count_out : std_logic_vector(N-1 downto 0) := (others => '0');	
	
	constant out1 : std_logic_vector(N-1 downto 0) := std_logic_vector(to_unsigned(TOPE-2, N));
	constant out2 : std_logic_vector(N-1 downto 0) := std_logic_vector(to_unsigned(TOPE-1, N));
	
begin
	myContador : contador
		generic map(N => N, TOPE => TOPE)
		port map(
			clk => clk,
			rst => '0',
			ena => '1',
			count_out => count_out
		);
		
	process(count_out)
	begin
		if (to_integer(unsigned(count_out)) = TOPE-2) then
			out_store <= '1';
			out_reset <= '0';
		elsif (to_integer(unsigned(count_out)) = TOPE-1) then
			out_store <= '0';
			out_reset <= '1';
		else
			out_store <= '0';
			out_reset <= '0';
		end if;
	end process;

	

end contador_TP2_arq;