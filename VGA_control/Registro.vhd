library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity registro is
   generic (N: natural := 4);
   port(
      data_in: in std_logic_vector(N-1 downto 0);
      data_out: out std_logic_vector(N-1 downto 0);
      clk: in std_logic;
      rst: in std_logic;
      load: in std_logic
   );
end registro;

architecture registro_arq of registro is

begin
	createFFDs: for i in 0 to N-1 generate
		actFFD: ffd port map(clk, rst, load, data_in(i), data_out(i));
	end generate;
end registro_arq;