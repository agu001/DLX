library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.myTypes.all;

entity AND2 is
		port(	A, B: 	in std_logic;
				C:		out std_logic
			);
end entity;

architecture df of AND2 is
	component ND2 is
		Port (	A:	In	std_logic;
				B:	In	std_logic;
				Y:	Out	std_logic);
	end component;

	component IV is
		Port (	A:	In	std_logic;
				Y:	Out	std_logic);
	end component;

	signal ND_OUT: std_logic;
begin

	ndx: ND2 port map (A, B, ND_OUT);
	iva: IV port map (ND_OUT, C);

end architecture;
