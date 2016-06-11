library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

entity mul_float is
	-- S: Tamaño en bits del formato (en total)
	-- E: Tamaño en bits para el exponente
	generic (S: natural := 32; E: natural := 8);
	port(
		a_in: in std_logic_vector(S-1 downto 0);
		b_in: in std_logic_vector(S-1 downto 0);
		m_out: out std_logic_vector(S-1 downto 0);
		clk: in std_logic;
		load: in std_logic
	);
end mul_float;

architecture mul_float_arq of mul_float is
	constant M: natural := S-E-1;
	signal mant_aux : std_logic_vector(2*M+1 downto 0);
	signal exp_aux : std_logic_vector(E downto 0);
	signal reg_in : std_logic_vector(S-1 downto 0);
	signal overfl, mul_done : std_logic := '0';
	signal mult_mant_a, mult_mant_b : std_logic_vector(M downto 0);

begin
	
	mult_mant_a <= '1' & a_in(M-1 downto 0);
	mult_mant_b <= '1' & b_in(M-1 downto 0);
	
	myMul: multiplicador
		generic map(N => M+1)
		port map (mult_mant_a, mult_mant_b, mant_aux, clk, mul_done, load);
	
--mySum: sum_rest
--	generic map(N => E)
--	port map(
--		a => a_in(S-2 downto M),
--		b => b_in(S-2 downto M),
--		c_in => mant_aux(2*M+1),
--		c_out => overfl,
--		s => exp_aux,
--		sum_select => '1'			
--	);

	myResult: registro
		generic map(N => S)
		port map(
			data_in => reg_in,
			data_out => m_out,
			clk => clk,
			rst => load,
			load => mul_done
		);
	

	-- Cargo el resultado en el registro
	process(mul_done)
		
		constant e_min : integer := -2**(E-1) + 1;
		constant e_max : integer := 2**(E-1);
		variable exp_sum : integer;
	
	--	variable exp_aux : unsigned (E downto 0);
	begin
		reg_in(S-1) <= a_in(S-1) xor b_in(S-1); -- Signo del numero
		
		exp_sum := to_integer(unsigned(a_in(S-2 downto M))) + to_integer(unsigned(b_in(S-2 downto M))) + to_integer(unsigned(mant_aux(2*M+1 downto 2*M+1))) - 2*(e_max - 1);
		if (exp_sum > e_max-1) then
			reg_in(S-2 downto M) <= (others => '1');
			reg_in(M-1 downto 0) <= (others => '0');
		elsif (exp_sum < e_min+1) then
			reg_in(S-2 downto 0) <= (others => '0');
		else
			if (unsigned(a_in(S-2 downto 0)) = 0) or (unsigned(b_in(S-2 downto 0)) = 0) then
				reg_in(S-1 downto 0) <= (others => '0');
			else
				if mant_aux(2*M+1) = '1' then
					reg_in(M-1 downto 0) <= mant_aux(2*M downto M+1);
				else
					reg_in(M-1 downto 0) <= mant_aux(2*M-1 downto M);
				end if;		
			reg_in(S-2 downto M) <= std_logic_vector(to_unsigned(exp_sum + e_max - 1,E));
			end if;
		end if;
			
		
		
		
		
		
		
		
--	exp_aux := unsigned(a_in(S-2 downto M)) + unsigned(b_in(S-2 downto M)) + unsigned(mant_aux(2*M+1 downto 2*M+1)) - (2**(E-1) - 1);
		
		
	end process;
	
end mul_float_arq;