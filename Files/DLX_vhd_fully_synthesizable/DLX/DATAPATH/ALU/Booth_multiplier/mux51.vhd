library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity mux51 is
	generic (numB: integer := 64);
	port  (
			sel_s: in std_logic_vector(2 downto 0);
		  	in_0: in std_logic_vector(numB-1 downto 0);
			in_1: in std_logic_vector(numB-1 downto 0);
			in_2: in std_logic_vector(numB-1 downto 0);
			in_3: in std_logic_vector(numB-1 downto 0);
			in_4: in std_logic_vector(numB-1 downto 0);
			out_s:out std_logic_vector(numB-1 downto 0)
		);
end entity;

architecture beh of mux51 is
BEGIN
	process(sel_s, in_0, in_1, in_2, in_3, in_4)
	begin
		case sel_s is 
			when "000"  => out_s <= in_0; --  0
			when "001"  => out_s <= in_1; --  A
			when "010"  => out_s <= in_2; -- -A			
			when "011"  => out_s <= in_3;  -- 2A
			when "100"  => out_s <= in_4; -- -2A
			when others => out_s <= (others=> '0');
		end case;
	end process;	
end architecture beh;



