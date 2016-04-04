library IEEE;
use IEEE.std_logic_1164.all;
use work.includes.all;

entity cont_4dgt_disp is
	port (
		-- Entradas de clock, reset y enabled
		clk : in std_logic;
		rst : in std_logic;
		ena : in std_logic;
		

		-- 4 bits para seleccionar un dígito del display
		dgt_selector : out std_logic_vector(3 downto 0);
		-- 8 bits para indicar los 7 segmentos del dígito y el punto
		dgt_display : out std_logic_vector(7 downto 0);
		c_out : out std_logic
	);
end cont_4dgt_disp;

architecture cont_4dgt_disp_arq of cont_4dgt_disp is

	
	signal digitos_act : std_logic_vector(15 downto 0) := (others => '0');	-- Array de dígitos que salen del contador
	signal ena_1sec : std_logic := '0'; -- Señal de enable que entra al contador y determina el tiempo entre cuentas
	signal ena_mux : std_logic := '0'; -- Señal de enable que entra al mux del display y determina 1/4 de la frecuencia de refresco
	
	signal selected_digit : std_logic_vector(3 downto 0) := (others => '0');
	
	signal mux_out : std_logic_vector(1 downto 0) := "00";
	
begin
	myContBCD : contBCD
		generic map (N => 4)
		port map (
			clk => clk,
			rst => rst,
			ena => ena_1sec,
			c_out => c_out,
			digitos => digitos_act	
		);
		
	my1secGen : freq_div
		generic map (N => 50)	-- Numero de clocks que hacen 1 seg: 50000000
		port map (
			clk => clk,
			rst => rst,
			ena => ena,
			clk_out => ena_1sec
		);
	
	myMuxGen : freq_div
		generic map (N => 2)	-- Numero de clocks que determina la frecuencia de refresco del display: 250000
		port map (
			clk => clk,
			rst => '0',
			ena => '1',
			clk_out => ena_mux
		);
		
	my7segDeco : deco_7s
		port map (
			num => selected_digit,
			display => dgt_display
		);
		
	myMod4Cont : contador
		generic map (N => 2)
		port map (
			clk => clk,
			rst => '0',
			ena => ena_mux,
			count_out => mux_out
		);
		
	with mux_out select
	selected_digit <= 	digitos_act(3 downto 0) when "00",
						digitos_act(7 downto 4) when "01",
						digitos_act(11 downto 8) when "10",
						digitos_act(15 downto 12) when "11",
						"1111" when others;
						
	with mux_out select
	dgt_selector <= "1110" when "00",
					"1101" when "01",
					"1011" when "10",
					"0111" when "11",
					"1111" when others;
	
end cont_4dgt_disp_arq;