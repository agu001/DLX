library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity BUF is
	generic(NBIT: integer);
	port(I: in std_logic_vector(NBIT-1 downto 0);
		 O: out std_logic_vector(NBIT-1 downto 0));
end BUF;

architecture BEH of BUF is
begin
	O <= I;
end BEH;
