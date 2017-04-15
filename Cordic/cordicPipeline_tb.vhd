library IEEE;
use IEEE.std_logic_1164.all;
use work.includes_cordic.all;

entity cordic_pipeline_tb is
end cordic_pipeline_tb;

architecture cordic_pipeline_tb_arq of cordic_pipeline_tb is
	component cordic_pipeline is
	   generic (COORD_N: natural := 10; STAGES: natural := 5);
	   port(
		  x_old: in std_logic_vector(COORD_N-1 downto 0);
		  y_old: in std_logic_vector(COORD_N-1 downto 0);
		  z_old: in std_logic_vector(15 downto 0);
		  x_new: out std_logic_vector(COORD_N-1 downto 0);
		  y_new: out std_logic_vector(COORD_N-1 downto 0);
		  valid_in: in std_logic;
		  valid_out: out std_logic;
		  clk: in std_logic
	   );
	end component cordic_pipeline;
	signal x_t, y_t, x_o_t, y_o_t: std_logic_vector(15 downto 0);
	signal x_m_t, y_m_t: std_logic_vector(15 downto 0);
	signal s_x_t, s_y_t: std_logic_vector(29 downto 0);
	signal z_t: std_logic_vector(15 downto 0);
	signal clk_t: std_logic := '0';
	signal v_in_t, v_out_t : std_logic;
	-- La ganancia es de aprox. 1/0.607253 ergo hay que
	-- multiplicar por 0.607253 para anularla.
	signal ganancia: std_logic_vector(14 downto 0) := "010011011011101";
	
begin
	myCS: cordic_pipeline
		generic map(COORD_N => 16, STAGES => 10)
		port map (x_t, y_t, z_t, x_m_t, y_m_t, v_in_t, v_out_t, clk_t);
	
	multiX: multiplicador
		generic map(N => 15)
		port map (x_m_t(14 downto 0), ganancia, '1', s_x_t, open, clk_t, '0');
	
	multiY: multiplicador
		generic map(N => 15)
		port map (y_m_t(14 downto 0), ganancia, '1', s_y_t, open, clk_t, '0');

		
	x_o_t <= x_m_t(15) & s_x_t(28 downto 14);
	y_o_t <= y_m_t(15) & s_y_t(28 downto 14);

	v_in_t <= '1';
	x_t <= "0001100110011001";
	y_t <= "1000110011001100";
	z_t <= "0011110101101111";
	        
	
	clk_t <= not clk_t after 5 ns;  
	
end cordic_pipeline_tb_arq;