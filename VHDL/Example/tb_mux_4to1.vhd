-- Librerias
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Declaración de la entidad para el testbench
ENTITY tb_mux_4to1 IS
END ENTITY;

-- Declaración de la arquitectura del testbench
ARCHITECTURE behaviour of tb_mux_4to1 IS 
	-- Uso del componente mux 4 a 1 previamente delcrado como entidad
	COMPONENT mux_4to1 IS 
		PORT(
			x0, x1, x2, x3			: IN std_logic;
			sel 						: IN std_logic_vector(1 DOWNTO 0);
			y  						: OUT std_logic
		);
	END COMPONENT;
	-- Declaración de señales
	SIGNAL x0_tb, x1_tb, x2_tb, x3_tb : std_logic;
	SIGNAL sel_tb : std_logic_vector(1 DOWNTO 0);
	SIGNAL y_tb, expect : std_logic;
		
	-- Mapeo de puertos a usar
	BEGIN map_mux_4to1 : mux_4to1
								PORT MAP(x0_tb, x1_tb, x2_tb, x3_tb, sel_tb, y_tb);
	-- Declaración de los casos de prueba
	-- Se cambian los valores del selector cada 10 ns
	PROCESS IS 
	BEGIN 
		x0_tb <= '0';
		x1_tb <= '1';
		x2_tb <= '0';
		x3_tb <= '1';
		sel_tb <= "00";
		expect <= '0';
		wait for 10 ns;
		sel_tb <= "01";
		expect <= '1';
		wait for 10 ns;
		sel_tb <= "10";
		expect <= '0';
		wait for 10 ns;
		sel_tb <= "11";
		expect <= '1';
		wait;
	END PROCESS;
	
END ARCHITECTURE; 