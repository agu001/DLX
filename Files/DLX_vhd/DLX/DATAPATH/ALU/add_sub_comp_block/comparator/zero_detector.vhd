library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity zero_detector is
	generic (NBIT:	integer);
	port 	(A:	in std_logic_vector(NBIT-1 downto 0);
			 Z:	out std_logic);
end;

architecture beh of zero_detector is
begin

	Z <= '1' when unsigned(A) = 0 else
		 '0';
end beh;
