library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use WORK.myTypes.all;

entity ND3 is
	Port (	A, B, C: In	std_logic;
		Y:	Out	std_logic);
end ND3;

architecture Struct of ND3 is

	component ND2 is
		Port (	A:	In	std_logic;
			B:	In	std_logic;
			Y:	Out	std_logic);
	end component ND2;

	component IV is
		Port (	A:	In	std_logic;
			Y:	Out	std_logic);
	end component IV;

	signal nd_out, iv_out: std_logic;

begin

	nd1_logic: ND2 port map(A, B, nd_out);
	iv1_logic: IV port map(nd_out, iv_out);
	nd2_logic: ND2 port map(iv_out, C, Y);

end Struct;
