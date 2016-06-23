library IEEE;
use IEEE.std_logic_1164.all;

package includes_FPAdder is

	-- Comparador de exponentes
	component exp_cmp is
		generic (E: natural := 4);							-- Número de bits del exponente
		port(
			expA : in std_logic_vector(E-1 downto 0);		-- Primer exponente		(en exceso 2**(E-1) - 1) Si E = 8, es exceso 127.
			expB : in std_logic_vector(E-1 downto 0);		-- Segundo exponente
			
			expDif : out std_logic_vector (E-1 downto 0);	-- Diferencia entre los exponentes = |expA - expB|
			expABigger : out std_logic						-- Flag que indica si el exponente A es el mayor		
		);
	end component exp_cmp;
	
	
	-- Sumador de exponentes (con indicadores de overflow y undeflow)
	component exp_add is
		generic (E: natural := 4);							-- Número de bits del exponente
		port(
			expA : in std_logic_vector(E-1 downto 0);		-- Primer exponente		(en exceso 2**(E-1) - 1) Si E = 8, es exceso 127.
			expB : in std_logic_vector(E-1 downto 0);		-- Segundo exponente
			
			expSum : out std_logic_vector (E-1 downto 0);	-- Suma de los exponentes
			overflow : out std_logic;						-- Flag que indica si A+B es un exponente que supera el expMax (= 2**(E-1) - 1) [127]
			underflow : out std_logic						-- Flag que indica si A+B es un exponente inferior al expMin (= -(2**(E-1)-1) + 1) [-126]
		);
	end component exp_add;
	
	

	-- Bit shifter
	component shifter is
		generic (Nbits: natural := 4; MaxSft : natural := 2);		-- Número de bits del shifter, Bits para el ammount de shift
		port(
			data_in : in std_logic_vector(Nbits-1 downto 0);		-- Vector a shiftear
			sft_ammount : in std_logic_vector(MaxSft-1 downto 0);	-- Cantidad de bits a shiftear
			sft_right : in std_logic;								-- 1 si shift right, 0 si shift left		
			
			data_out : out std_logic_vector(Nbits-1 downto 0)		-- Salida
		);
	end component shifter;
	
	-- Adder para las mantisas
	-- NOTA: si sum_sel es '1'
	--				sumS pasa a tener el resultado de (A+B) mod 2**N 
	--				si se excede la representación c_out pasa a valer '1'
	--				ignorar overflow
	--		 si sum_sel es '0'
	--				sumS pasa a tener el resultado de |A-B|
	--				si A < B el bit de overflow pasa a valer '1'
	--				ignorar c_out
	component adder is
		generic (N: natural := 4);
		port(
			sumA : in std_logic_vector(N-1 downto 0);
			sumB : in std_logic_vector(N-1 downto 0);
			sum_sel : in std_logic;
			
			sumS : out std_logic_vector(N-1 downto 0);
			c_out : out std_logic;
			overflow : out std_logic
		);
	end component adder;
		
	-- Registro y FFD
	component ffd is
		port(
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			D: in std_logic;
			Q: out std_logic
		);
	end component ffd;
	
	component registro is
		generic (N: natural := 4);
		port(
			data_in: in std_logic_vector(N-1 downto 0);
			data_out: out std_logic_vector(N-1 downto 0);
			clk: in std_logic;
			rst: in std_logic;
			load: in std_logic
			);
	end component registro;

		
	component delay_gen is
		generic(
			N: natural:= 8;
			DELAY: natural:= 0
		);
		port(
			clk: in std_logic;
			A: in std_logic_vector(N-1 downto 0);
			B: out std_logic_vector(N-1 downto 0)
		);
	end component delay_gen;
	
end package;