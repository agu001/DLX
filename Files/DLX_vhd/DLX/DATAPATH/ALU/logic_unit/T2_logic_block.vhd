library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use WORK.myTypes.all;

entity T2_logic_block is
	port ( S: in std_logic_vector(2 downto 0);
		   R1, R2: in std_logic;
		   O: out std_logic
		 );
end entity T2_logic_block;

architecture Struct of T2_logic_block is

	component ND3 is
		Port (	A, B, C: In	std_logic;
			Y:	Out	std_logic);
	end component ND3;

	component ND4 is
		Port (	A, B, C, D: In	std_logic;
			Y:	Out	std_logic);
	end component ND4;

	component IV is
		Port (	A:	In	std_logic;
			Y:	Out	std_logic);
	end component IV;

	signal R2_n, R1_n, l0, l1, l2, l3: std_logic;

begin

	R0_neg: IV port map(R2, R2_n);
	R1_neg: IV port map(R1, R1_n);

	l0_logic: ND3 port map('0', R2_n, R1_n, l0);
	l1_logic: ND3 port map(S(0), R2, R1_n, l1);
	l2_logic: ND3 port map(S(1), R2_n, R1, l2);
	l3_logic: ND3 port map(S(2), R2, R1, l3);

	n4_logic: ND4 port map(l0, l1, l2, l3, O);

end Struct;
