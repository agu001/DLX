library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity and2_generic is
	generic(NBIT: integer);
	port(	A, B: 	in std_logic_vector(NBIT-1 downto 0);
			C:		out std_logic_vector(NBIT-1 downto 0));
end and2_generic;

architecture df of and2_generic is
begin
	C <= A and B;
end architecture df;
