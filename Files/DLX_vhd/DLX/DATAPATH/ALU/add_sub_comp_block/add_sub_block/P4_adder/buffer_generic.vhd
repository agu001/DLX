library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity buffer_generic is
	generic(NBIT: integer);
	port(I: in std_logic_vector(NBIT-1 downto 0);
		 O: out std_logic_vector(NBIT-1 downto 0));
end buffer_generic;

architecture BEH of buffer_generic is
begin
	O <= I;
end BEH;
