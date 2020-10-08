library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity or2_generic is
	generic(NBIT: integer);
	port(	A, B: 	in std_logic_vector(NBIT-1 downto 0);
			C:		out std_logic_vector(NBIT-1 downto 0));
end or2_generic;

architecture df of or2_generic is
begin
	C <= A or B;
end architecture df;
