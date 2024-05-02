library ieee;
use ieee.std_logic_1164.all;

entity bcd7seg is
	port (
		bcd	:	in std_logic_vector(7 downto 0);
		display	:	out std_logic_vector(15 downto 0)
	);
end bcd7seg;

architecture behaviour of bcd7seg is
begin
	process(bcd)
	begin
		case bcd is
			-- 1 es apagado
			-- 0 es prendido
			when "0000" & "0000" => display <= "11000000" & "11000000"; -- 00
			when "0000" & "0001" => display <= "11111001" & "11000000"; -- 01
			when "0000" & "0010" => display <= "10100100" & "11000000"; -- 02
			when "0000" & "0011" => display <= "10110000" & "11000000"; -- 03
			when "0000" & "0100" => display <= "10011001" & "11000000"; -- 04
			when "0000" & "0101" => display <= "10010010" & "11000000"; -- 05
			when "0000" & "0110" => display <= "10000010" & "11000000"; -- 06
			when "0000" & "0111" => display <= "11111000" & "11000000"; -- 07
			when "0000" & "1000" => display <= "10000000" & "11000000"; -- 08
			when "0000" & "1001" => display <= "10010000" & "11000000"; -- 09
			
			when "0000" & "1010" => display <= "11000000" & "11111001"; -- 10
			when "0000" & "1011" => display <= "11111001" & "11111001"; -- 11
			when "0000" & "1100" => display <= "10100100" & "11111001"; -- 12
			when "0000" & "1101" => display <= "10110000" & "11111001"; -- 13
			when "0000" & "1110" => display <= "10011001" & "11111001"; -- 14
			when "0000" & "1111" => display <= "10010010" & "11111001"; -- 15
			when "0001" & "0000" => display <= "10000010" & "11111001"; -- 16
			when "0001" & "0001" => display <= "11111000" & "11111001"; -- 17
			when "0001" & "0010" => display <= "10000000" & "11111001"; -- 18
			when "0001" & "0011" => display <= "10010000" & "11111001"; -- 19
			
			when "0001" & "0100" => display <= "11000000" & "10100100"; -- 20
			when "0001" & "0101" => display <= "11111001" & "10100100"; -- 21
			when "0001" & "0110" => display <= "10100100" & "10100100"; -- 22
			when "0001" & "0111" => display <= "10110000" & "10100100"; -- 23
			when "0001" & "1000" => display <= "10011001" & "10100100"; -- 24
			when "0001" & "1001" => display <= "10010010" & "10100100"; -- 25
			when "0001" & "1010" => display <= "10000010" & "10100100"; -- 26
			when "0001" & "1011" => display <= "11111000" & "10100100"; -- 27
			when "0001" & "1100" => display <= "10000000" & "10100100"; -- 28
			when "0001" & "1101" => display <= "10010000" & "10100100"; -- 29
			
			when "0001" & "1110" => display <= "11000000" & "10110000"; -- 30
			
			when others => display <= "11111111" & "11111111";
			
		end case;
	end process;
end behaviour;