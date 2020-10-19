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

	component ND2 is
		Port (	A:	In	std_logic;
			B:	In	std_logic;
			Y:	Out	std_logic);
	end component ND2;

	component IV is
		Port (	A:	In	std_logic;
			Y:	Out	std_logic);
	end component IV;

	signal B_n, A_n, nd1_out, nd2_out: std_logic;

begin

	A_neg: IV port map(A, A_n);
	B_neg: IV port map(B, B_n);
	nd1_logic: ND2 port map(A, B_n, nd1_out);
	nd2_logic: ND2 port map(A_n, B, nd2_out);
	nd_result: ND2 port map(nd1_out, nd2_out, C);

	--C <= A xor B after XORDELAY;
end architecture;
