library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux41_generic is
	generic (NBIT: integer);
	port ( in_0, in_1, in_2, in_3: in std_logic_vector(NBIT-1 downto 0);
		   sel: in std_logic_vector(1 downto 0);
		   y: out std_logic_vector(NBIT-1 downto 0)
		 );
end mux41_generic;

architecture df of mux41_generic is
begin
	y <=       in_0 when( sel = "00" ) else
			  in_1 when( sel = "01" ) else
			  in_2 when( sel = "10") else
			  in_3 when( sel = "11") else
			  (others => '0');
end df;
