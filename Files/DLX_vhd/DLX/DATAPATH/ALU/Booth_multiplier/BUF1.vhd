library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity BUF1 is
	port(I: in std_logic;
		 O: out std_logic);
end BUF1;

architecture BEH of BUF1 is
begin
	O <= I;
end BEH;
