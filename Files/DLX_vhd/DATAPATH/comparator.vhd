library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_type.all;

entity comparator is
	generic ( SIZE: natural := 32 );
	port ( R1: in std_logic_vector(SIZE-1 downto 0);
			ISZERO: out std_logic );
end comparator;

architecture Beh of comparator is
begin
	ISZERO <= '1' when (to_integer(unsigned(R1)) = 0) else
			'0';
end Beh;
