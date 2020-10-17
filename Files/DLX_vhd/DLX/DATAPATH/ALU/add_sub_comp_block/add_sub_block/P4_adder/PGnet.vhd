library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PGnet is
	port( a,b: in std_logic;
		   pg: out std_logic_vector(1 downto 0)
		);
end PGnet;

architecture BEH of PGnet is

	component XOR2 is
			port(	A, B: 	in std_logic;
					C:		out std_logic
				);
	end component XOR2;

	component AND2 is
			port(	A, B: 	in std_logic;
					C:		out std_logic
				);
	end component AND2;

begin

	xor_logic: XOR2 port map(a, b, pg(1));
	and_logic: AND2 port map(a, b, pg(0));

	--pg(1) <= a xor b;	--P
	--pg(0) <= a and b;	--G
end BEH;
