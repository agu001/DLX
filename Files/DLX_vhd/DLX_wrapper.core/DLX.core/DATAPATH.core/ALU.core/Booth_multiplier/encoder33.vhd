library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.myTypes.all;

ENTITY encoder33 is
	port (in_s:in std_logic_vector(2 downto 0);
			out_s: out std_logic_vector(2 downto 0));
end entity;

architecture beh of encoder33 is
begin
		process(in_s)
		begin
			case in_s is
				when "000" | "111" => out_s <= "000"; --  0
				when "001" | "010" => out_s <= "001"; --  A
				when "101" | "110" => out_s <= "010"; -- -A
				when "011" 		   => out_s <= "011";  -- 2A
				when "100" 		   => out_s <= "100"; -- -2A
				when others => out_s <= (others=> '0');
			end case;
		end process;
end architecture;
