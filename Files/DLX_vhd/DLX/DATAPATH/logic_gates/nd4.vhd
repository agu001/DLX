library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use WORK.myTypes.all;

entity ND4 is
	Port (	A, B, C, D: In	std_logic;
		Y:	Out	std_logic);
end ND4;

architecture Struct of ND4 is

	component ND2 is
		Port (	A:	In	std_logic;
			B:	In	std_logic;
			Y:	Out	std_logic);
	end component ND2;

	component IV is
		Port (	A:	In	std_logic;
			Y:	Out	std_logic);
	end component IV;

	signal nd1_out, nd2_out, iv1_out, iv2_out: std_logic;

begin

	nd1_logic: ND2 port map(A, B, nd1_out);
	iv1_logic: IV port map(nd1_out, iv1_out);
	nd2_logic: ND2 port map(C, D, nd2_out);
	iv2_logic: IV port map(nd2_out, iv2_out);
	nd3_logic: ND2 port map(iv1_out, iv2_out, Y);

end Struct;
