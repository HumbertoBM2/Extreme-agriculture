-- Librerias
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Se declara como entidad un mux de 4 a 1 con sus respectivas caracteristicas
-- 4 Entradas 1 salida y el selector
ENTITY mux_4to1 IS 
	PORT(
		x0, x1, x2, x3			: IN std_logic;
		sel 						: IN std_logic_vector(1 DOWNTO 0);
		y  						: OUT std_logic
	);
END ENTITY;

-- Arquitectura que describe el comportamiento del mux
-- Se declara el comportamiento que y debe tener con base al valor del selector 
ARCHITECTURE behaviour OF mux_4to1 IS 
BEGIN 
	y <= x3 WHEN sel = "11" ELsE
		  x2 WHEN sel = "10" ELSE
		  x1 WHEN sel = "01" ELSE 
		  x0;
END ARCHITECTURE;