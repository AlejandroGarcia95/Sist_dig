library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes_FPAdder.all;
use work.includes_stages.all;

-- Sumador de punto flotante, hecho en pipeline de 4 etapas.
	-- A + B = C
entity fp_adder is
	generic (E : natural := 8; N : natural := 32);				-- E = bits de exponente, N = bits totales
	port(
		clk : in std_logic;
		load : in std_logic;
	
		sgnA : in std_logic;
		expA : in std_logic_vector(E-1 downto 0);
		fracA : in std_logic_vector(N-E-2 downto 0);
		
		sgnB : in std_logic;
		expB : in std_logic_vector(E-1 downto 0);
		fracB : in std_logic_vector(N-E-2 downto 0);
		
		sgnC : out std_logic;
		expC : out std_logic_vector(E-1 downto 0);
		fracC : out std_logic_vector(N-E-2 downto 0)
	);
end fp_adder;


architecture fp_adder_arq of fp_adder is

	constant REG0_SIZE : natural := 2*N;		-- sgnA (1) | expA (E) | fracA (N-E-1) | sgnB (1) | expB (E) | fracB (N-E-1) 
	signal reg0_in, reg0_out : std_logic_vector(REG0_SIZE-1 downto 0);
	
	constant REG1_SIZE : natural := 3+2*N-E;	-- sgnA (1) | sgnB (1) | maxExp (E) | lilFrac (N-E) | bigFrac (N-E) | bigIsA (1)
	signal reg1_in, reg1_out : std_logic_vector(REG1_SIZE-1 downto 0);
	
	constant REG2_SIZE : natural := N+2;		-- sgnS (1) | maxExp (E) | resFrac (N-E+1)
	signal reg2_in, reg2_out : std_logic_vector(REG2_SIZE-1 downto 0);
	
	constant REG3_SIZE : natural := N+E;		-- sgnS (1) | maxExp (E) | deltaExp (E) | normFrac (N-E-1)
	signal reg3_in, reg3_out : std_logic_vector(REG3_SIZE-1 downto 0);
	
	constant REG4_SIZE : natural := N;				-- sgnC (1) | expC (E) | fracC(N-E-1)
	signal reg4_in, reg4_out : std_logic_vector(REG4_SIZE-1 downto 0);
	
begin

	-- Registro de entrada (reg0)
	reg0_in <= sgnA & expA & fracA & sgnB & expB & fracB;
	reg0 : registro
		generic map (N => REG0_SIZE)
		port map (
			data_in => reg0_in,
			data_out => reg0_out,
			clk => clk,
			rst => '0',
			load => load
		);
		
	-- Stage 1
	stage1 : adderFP_P1
		generic map (E => E, N => N)
		port map(
			expA => reg0_out(2*N-2 downto 2*N-E-1),
			fracA => reg0_out(2*N-E-2 downto N),
			expB => reg0_out(N-2 downto N-E-1),
			fracB => reg0_out(N-E-2 downto 0),
		
			maxExp => reg1_in(2*N-E downto 2*N-2*E+1),
			litFrac => reg1_in(2*N-2*E downto N-E+1),
			bigFrac => reg1_in(N-E downto 1),
			bigFracIsA => reg1_in(0)		
		);
	reg1_in(REG1_SIZE-1 downto REG1_SIZE-2) <= reg0_out(2*N-1) & reg0_out(N-1);		-- Puenteo los signos, ya que no los uso en la stage 1
	
	-- Registro s1/s2 (reg1)
	reg1 : registro
		generic map (N => REG1_SIZE)
		port map (
			data_in => reg1_in,
			data_out => reg1_out,
			clk => clk,
			rst => '0',
			load => '1'
		);
	
	
	-- Stage 2
	stage2 :  adderFP_P2
		generic map (E => E, N => N)
		port map (
			bigFrac => reg1_out(N-E downto 1),
			litFrac => reg1_out(2*N-2*E downto N-E+1),
			
			sgnA => reg1_out(REG1_SIZE-1),
			sgnB => reg1_out(REG1_SIZE-2),
			bigFracIsA => reg1_in(0),
			
			sgnS => reg2_in(N+1),
			resFrac => reg2_in(N-E downto 0)		
		);
	reg2_in(N downto N-E+1) <= reg1_out(2*N-E downto 2*N-2*E+1);	-- Puenteo el exponente dado que no lo uso

	
	-- Registro s2/s3 (reg2)
	reg2 : registro
		generic map (N => REG2_SIZE)
		port map (
			data_in => reg2_in,
			data_out => reg2_out,
			clk => clk,
			rst => '0',
			load => '1'
		);
		
	-- Stage 3
	stage3 : adderFP_P3
		generic map (E => E, N => N)
		port map (
			resFrac => reg2_out(N-E downto 0),
			
			normFrac =>	reg3_in(N-E-2 downto 0),
			deltaExp => reg3_in(N-2 downto N-E-1)
		);
		
	reg3_in(N+E-2 downto N-1) <= reg2_out(N downto N-E+1);				-- Puenteo el exponente máximo
	reg3_in(N+E-1) <= reg2_out(N+1);									-- Puenteo el signo de la solución

	-- Registro s3/s4 (reg3)
	reg3 : registro
		generic map (N => REG3_SIZE)
		port map (
			data_in => reg3_in,
			data_out => reg3_out,
			clk => clk,
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
			clk => clk,
			rst => '0',
			load => '1'
		);
		
	-- Mapeo de salidas
	sgnC <= reg4_out(N-1);
	expC <= reg4_out(N-2 downto N-E-1);
	fracC <= reg4_out(N-E-2 downto 0);
		
end fp_adder_arq;