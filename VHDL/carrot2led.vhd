library ieee;
use ieee.std_logic_1164.all;

entity carrot2led is
	port (
		carrots	:	in std_logic_vector(2 downto 0);
		display	:	out std_logic_vector(6 downto 0)
	);
end carrot2led;

architecture behaviour of carrot2led is
begin
	process(carrots)
	begin
		case carrots is
			when "000" => display <= "0000000";
			when "001" => display <= "0000001";
			when "010" => display <= "0000011";
			when "011" => display <= "0000111";
			when "100" => display <= "0001111";
			when "101" => display <= "0011111";
			when "110" => display <= "0111111";
			when "111" => display <= "1111111";
		end case;
	end process;
end behaviour;