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
		  clk: in std_logic
	   );
	end component cordic_pipeline;
	signal x_t, y_t, x_o_t, y_o_t: std_logic_vector(15 downto 0);
	signal z_t: std_logic_vector(15 downto 0);
	signal clk_t: std_logic := '0';
	
begin
	myCS: cordic_pipeline
		generic map(COORD_N => 16, STAGES => 10)
		port map (x_t, y_t, z_t, x_o_t, y_o_t, clk_t);
		    
	x_t <= "0010110111110110";
	y_t <= "0000011100101111";
	z_t <= "0100010001111010";
	        
	
	clk_t <= not clk_t after 5 ns;  
	
end cordic_pipeline_tb_arq;