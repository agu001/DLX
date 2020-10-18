library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.myTypes.all;

entity XOR2 is
		port(	A, B: 	in std_logic;
				C:		out std_logic
			);
end entity;

architecture df of XOR2 is




begin
	C <= A xor B after XORDELAY;
end architecture;
