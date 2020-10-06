library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity xor2_block is
		port(	A, B: 	in std_logic;
				C:		out std_logic
			);
end entity;

architecture df of xor2_block is
begin
	C <= A xor B;
end architecture;
