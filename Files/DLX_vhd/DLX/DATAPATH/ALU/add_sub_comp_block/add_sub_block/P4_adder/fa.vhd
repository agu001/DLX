library ieee;
use ieee.std_logic_1164.all;
use WORK.myTypes.all;

entity FA is
	Port (	A:	In	std_logic;
			B:	In	std_logic;
			Ci:	In	std_logic;
			S:	Out	std_logic;
			Co:	Out	std_logic);
end FA;

architecture BEHAVIORAL of FA is
	component XOR2 is
		port(	A, B: 	in std_logic;
				C:		out std_logic);
	end component;

	component OR2 is
		port(	A, B: 	in std_logic;
				C:		out std_logic);
	end component;

	component AND2 is
		port(	A, B: 	in std_logic;
				C:		out std_logic);
	end component;

	signal s1, s2, s3: std_logic;
begin
	xorx1: XOR2 port map (A, B, s1);
	xorz2: XOR2 port map (s1, Ci, S);

	andx1: AND2 port map (A, B, s2);
	andx2: AND2 port map (s1, Ci, s3);
	orx1: OR2 port map (s3, s2, Co);

	--S <= A xor B xor Ci after FASDELAY;
	--Co <= (A and B) or (B and Ci) or (A and Ci) after FACDELAY;

end BEHAVIORAL;
