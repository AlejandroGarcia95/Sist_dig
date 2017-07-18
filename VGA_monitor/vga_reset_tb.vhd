library IEEE;
use IEEE.std_logic_1164.all;
use work.includes.all;
use IEEE.numeric_std.all;


entity video_reset_tb is
end video_reset_tb;

architecture video_reset_tb_arq of video_reset_tb is

	signal sig_swipe_start_t: std_logic := '0';
	signal sig_reset_t: std_logic := '0';
	
	signal resetting_t: std_logic := '0';
	signal waiting_t: std_logic := '0';
	signal done_rst_t: std_logic := '0';
	signal clk_t: std_logic := '1';
	
begin
	v_rst : video_reset
	port map(
		clk => clk_t,
		
		sig_swipe_start => sig_swipe_start_t,
		sig_reset => sig_reset_t,
		
		is_resetting => resetting_t,
		is_waiting => waiting_t,
		
		done_rst => done_rst_t
	);
	
	clk_t <= not clk_t after 1 ns;
	
	sig_swipe_start_t <= '1' after 20 ns, '0' after 22 ns, '1' after 40 ns, '0' after 42 ns, '1' after 60 ns, '0' after 62 ns,
						 '1' after 80 ns, '0' after 82 ns, '1' after 100 ns, '0' after 102 ns;
	sig_reset_t <= '1' after 25 ns, '0' after 27 ns, '1' after 50 ns, '0' after 52 ns, '1' after 70 ns, '0' after 72 ns;
	
	
end video_reset_tb_arq;