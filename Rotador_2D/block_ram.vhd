library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity block_ram is
	generic(
		N: natural := 1			-- Cantidad de bits por dirección
	);
	
	port(
		-- Write enable for input
		wea: in std_logic;
		
		-- Address
		addra: in std_logic_vector(17 downto 0);
		addrb: in std_logic_vector(17 downto 0);
		
		-- Data buses
		dia: in std_logic_vector(N-1 downto 0);
		dob: out std_logic_vector(N-1 downto 0);
		
		clk: in std_logic
	);


end block_ram;


architecture block_ram_arq of block_ram is

--type ram_t is array (2**(20)-1 downto 0) of std_logic_vector(N-1 downto 0);
-- Área imprimible de 384x384 píxeles => 147456 Píxeles imprimibles
-- Se necesitan 18 bits para el número 147455
type ram_t is array (147455 downto 0) of std_logic_vector(N-1 downto 0);
shared variable RAM: ram_t;

begin

process(clk)
begin
	if clk'event and clk = '1' then
		if wea = '1' then
			RAM(to_integer(unsigned(addra))) := dia;
		end if;
	end if;
end process;

process(clk)
begin
	if clk'event and clk = '1' then
		dob <= RAM(to_integer(unsigned(addrb)));
	end if;
end process;
	
end block_ram_arq;