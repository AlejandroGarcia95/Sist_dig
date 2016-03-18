library IEEE;
use IEEE.std_logic_1164.all;

entity f_adder is
   port(
      a: in std_logic;
      b: in std_logic;
      c_in: in std_logic;
	  c_out: out std_logic;
	  s: out std_logic
   );
end f_adder;

architecture f_adder_arq of f_adder is
begin
   s <= a xor b xor c_in;
   c_out <= (a and b) or (c_in and b) or (a and c_in);
end f_adder_arq;