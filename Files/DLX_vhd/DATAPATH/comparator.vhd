library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_type.all;

entity comparator is
	generic ( SIZE: natural := 32 );
	port ( R1, R2: in std_logic_vector(SIZE-1 downto 0);
			EQUAL: out std_logic );
end comparator;

architecture Beh of comparator is
begin
	EQUAL <= '1' when (R1 = R2) else
			'0';
end Beh;
