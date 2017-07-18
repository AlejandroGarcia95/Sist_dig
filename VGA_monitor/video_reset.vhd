library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.includes.all;

-- Convierte las coordenadas en pixeles y las guarda en memoria de video.
-- Si valid = '0', ignora la entrada.
entity video_reset is
	port (
		sig_swipe_start: in std_logic;
		sig_reset: in std_logic;
		
		is_resetting: out std_logic;
		is_waiting: out std_logic;
		
		done_rst: out std_logic;
		clk: in std_logic
	);
end video_reset;

architecture video_reset_arq of video_reset is
	
	signal waiting: std_logic := '0';
	signal resetting: std_logic := '0';
	signal ready: std_logic := '1';
	
	signal done_rst_aux: std_logic := '0';
	
begin
	
	process (clk)
	begin
		if rising_edge(clk) then
			if ready = '1' then
				if sig_reset = '1' then
					ready <= '0';
					waiting <= '1';
				end if;
				if done_rst_aux = '1' then
					done_rst_aux <= '0';
				end if;
			else 
				if waiting = '1' then
					if sig_swipe_start = '1' then
						resetting <= '1';
						waiting <= '0';
					end if;
				else
					if resetting = '1' then
						if sig_swipe_start = '1' then
							ready <= '1';
							resetting <= '0';
							done_rst_aux <= '1';
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	is_resetting <= resetting;
	is_waiting <= waiting;
	done_rst <= done_rst_aux;
end video_reset_arq;



