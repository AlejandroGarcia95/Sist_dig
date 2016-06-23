library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_FPAdder.all;
use work.includes_stages.all;

-- Sumador de punto flotante, hecho en pipeline de 4 etapas.
	-- A + B = C
entity fp_adder_tb2 is
end fp_adder_tb2;


architecture fp_adder_tb2_arq of fp_adder_tb2 is

	constant E : natural := 8;
	constant N : natural := 30;
	constant G : natural := 6;
	
	signal inputA_t, inputB_t, outputC_t : std_logic_vector(N-1 downto 0);
	
	signal fracC_t : std_logic_vector(N-E-2 downto 0);
	signal expC_t : std_logic_vector(E-1 downto 0);
	signal sgnC_t : std_logic;
	
	signal clk_t : std_logic := '0';

	constant REG0_SIZE : natural := 2*N;		-- sgnA (1) | expA (E) | fracA (N-E-1) | sgnB (1) | expB (E) | fracB (N-E-1) 
	signal reg0_in, reg0_out : std_logic_vector(REG0_SIZE-1 downto 0);
	
	constant REG1_SIZE : natural := 3+2*N-E+2*G;	-- sgnA (1) | sgnB (1) | maxExp (E) | lilFrac (N-E+G) | bigFrac (N-E+G) | bigIsA (1)
	signal reg1_in, reg1_out : std_logic_vector(REG1_SIZE-1 downto 0);
	
	constant REG2_SIZE : natural := N+2+G;		-- sgnS (1) | maxExp (E) | resFrac (N-E+1+G)
	signal reg2_in, reg2_out : std_logic_vector(REG2_SIZE-1 downto 0);
	
	constant REG3_SIZE : natural := N+E;		-- sgnS (1) | maxExp (E) | deltaExp (E) | normFrac (N-E-1)
	signal reg3_in, reg3_out : std_logic_vector(REG3_SIZE-1 downto 0);
	
	constant REG4_SIZE : natural := N;				-- sgnC (1) | expC (E) | fracC(N-E-1)
	signal reg4_in, reg4_out : std_logic_vector(REG4_SIZE-1 downto 0);
	
begin

	-- Registro de entrada (reg0)
	reg0_in <= inputA_t & inputB_t;
	reg0 : registro
		generic map (N => REG0_SIZE)
		port map (
			data_in => reg0_in,
			data_out => reg0_out,
			clk => clk_t,
			rst => '0',
			load => '1'
		);
		
	-- Stage 1
	stage1 : adderFP_P1
		generic map (E => E, N => N, G => G)
		port map(
			expA => reg0_out(2*N-2 downto 2*N-E-1),
			fracA => reg0_out(2*N-E-2 downto N),
			expB => reg0_out(N-2 downto N-E-1),
			fracB => reg0_out(N-E-2 downto 0),
		
			maxExp => reg1_in(2*N-E+2*G downto 2*N-2*E+1+2*G),
			litFrac => reg1_in(2*N-2*E+2*G downto N-E+1+G),
			bigFrac => reg1_in(N-E+G downto 1),
			bigFracIsA => reg1_in(0)		
		);
	reg1_in(REG1_SIZE-1 downto REG1_SIZE-2) <= reg0_out(2*N-1) & reg0_out(N-1);		-- Puenteo los signos, ya que no los uso en la stage 1
	
	-- Registro s1/s2 (reg1)
	reg1 : registro
		generic map (N => REG1_SIZE)
		port map (
			data_in => reg1_in,
			data_out => reg1_out,
			clk => clk_t,
			rst => '0',
			load => '1'
		);
	
	
	-- Stage 2
	stage2 :  adderFP_P2
		generic map (E => E, N => N, G => G)
		port map (
			bigFrac => reg1_out(N-E+G downto 1),
			litFrac => reg1_out(2*N-2*E+2*G downto N-E+1+G),
			
			sgnA => reg1_out(REG1_SIZE-1),
			sgnB => reg1_out(REG1_SIZE-2),
			bigFracIsA => reg1_out(0),
			
			sgnS => reg2_in(N+1+G),
			resFrac => reg2_in(N-E+G downto 0)		
		);
	reg2_in(N+G downto N-E+1+G) <= reg1_out(2*N-E+2*G downto 2*N-2*E+1+2*G);	-- Puenteo el exponente dado que no lo uso

	
	-- Registro s2/s3 (reg2)
	reg2 : registro
		generic map (N => REG2_SIZE)
		port map (
			data_in => reg2_in,
			data_out => reg2_out,
			clk => clk_t,
			rst => '0',
			load => '1'
		);
		
	-- Stage 3
	stage3 : adderFP_P3
		generic map (E => E, N => N, G => G)
		port map (
			resFrac => reg2_out(N-E+G downto 0),
			
			normFrac =>	reg3_in(N-E-2 downto 0),
			deltaExp => reg3_in(N-2 downto N-E-1)
		);
		
	reg3_in(N+E-2 downto N-1) <= reg2_out(N+G downto N-E+1+G);				-- Puenteo el exponente máximo
	reg3_in(N+E-1) <= reg2_out(N+1+G);									-- Puenteo el signo de la solución

	-- Registro s3/s4 (reg3)
	reg3 : registro
		generic map (N => REG3_SIZE)
		port map (
			data_in => reg3_in,
			data_out => reg3_out,
			clk => clk_t,
			rst => '0',
			load => '1'
		);
		
		
	-- Stage 4
	stage4 : adderFP_P4
		generic map (E => E, N => N)
		port map (
			maxExp => reg3_out(N+E-2 downto N-1),
			deltaExp => reg3_out(N-2 downto N-E-1),
			normFrac => reg3_out(N-E-2 downto 0),
			
			finalExp => reg4_in(N-2 downto N-E-1),
			finalFrac => reg4_in(N-E-2 downto 0)	
		);
	reg4_in(N-1) <= reg3_out(N+E-1);		-- Puenteo el signo	
	
	-- Registro de salida s4/out (reg4)
	reg4 : registro
		generic map (N => REG4_SIZE)
		port map (
			data_in => reg4_in,
			data_out => reg4_out,
			clk => clk_t,
			rst => '0',
			load => '1'
		);
		
	-- Mapeo de salidas
	sgnC_t <= reg4_out(N-1);
	expC_t <= reg4_out(N-2 downto N-E-1);
	fracC_T <= reg4_out(N-E-2 downto 0);
		
	
	outputC_t <= sgnC_t & expC_t & fracC_t;
		
	clk_t <= not clk_t after 100 ns;

	inputA_t <= "101111101000000110101110101001" after 10 ns;
	inputB_t <= "001110111110110001011000100011" after 10 ns;
	--			"1011110100101010111001010
	--			 1011110100101010111001011
	--	A:	"1 01111011 10111100010011010101100"
	--	B:	"0 01111100 10001110110111101111110"
	--
	--												   00101010010011001110101011			 100010000111001000101011
	-- sgnA: 0  sgnB: 1  maxExp: 01111101 litFrac (B): 001010100100110011101010  bigFrac(A): 100010000111001000101011 aBig: 1
	--				0110111100010011010101100 1100011101101111011111100 0
	-- 1 0 01111100 0110111100010011010101100 1100011101101111011111100 0
	--
	--									   0010111100010010101000001
	-- sgnS: 0 	maxExp: 01111101  resFrac: 0010111100010010101000001
	--															01111000100101010000010
	-- sgnS: 0  maxExp: 01111101  deltaExp: 10000000  normFrac: 01111000100101010000010
	-- 
	--
	-- sgnC: 0  expC: 01111100  normFrac: 01111000100101010000010	Nosotros
	--		 0		  01111100			  01111000100101010000000 	El archivo
end fp_adder_tb2_arq;