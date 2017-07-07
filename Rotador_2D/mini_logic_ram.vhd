library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mini_logic_ram is
	generic(
		ADDR_N: natural := 15;
		COORD_N: natural := 16			
	);
	
	port(
		-- Para obtener valores de la memoria
		addr_A_out: in std_logic_vector(ADDR_N-1 downto 0);
		data_A_out: out std_logic_vector(COORD_N-1 downto 0);
		-- Para escribir valores de la memoria
		addr_A_in: in std_logic_vector(ADDR_N-1 downto 0);
		data_A_in: in std_logic_vector(COORD_N-1 downto 0);
		write_flag: in std_logic;	
		
		clk: in std_logic
	);


end mini_logic_ram;


architecture mini_logic_ram_arq of mini_logic_ram is

type ram_t is array (2**(ADDR_N)-1 downto 0) of std_logic_vector(COORD_N-1 downto 0);

shared variable ram: ram_t;

begin
	process(clk)
	begin
		if clk'event and clk = '1' then
			if write_flag = '1' then
				ram(to_integer(unsigned(addr_A_in))) := data_A_in;
			end if;
		end if;
	end process;

	process(clk)
	begin
		if clk'event and clk = '1' then
			data_A_out <= ram(to_integer(unsigned(addr_A_out)));
		end if;
	end process;	
	
end mini_logic_ram_arq;




