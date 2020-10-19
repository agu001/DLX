library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comparator is
	generic (NBIT: integer);
	port	(	A, B, SUM:	in std_logic_vector(NBIT-1 downto 0);
				S, Cout:	in std_logic;
				e, ne, lt, le, gt, ge:	out std_logic		--equal, not equal, less than, less or equal, greater than, greater or equal
			);
end;

architecture struct of comparator is
	component zero_detector is
		generic (NBIT:	integer);
		port 	(A:	in std_logic_vector(NBIT-1 downto 0);
				 Z:	out std_logic);
	end component zero_detector;

	component ND2 is
		Port (	A:	In	std_logic;
				B:	In	std_logic;
				Y:	Out	std_logic);
	end component;

	component IV is
		Port (	A:	In	std_logic;
				Y:	Out	std_logic);
	end component;

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

	signal Z, opp_signs, opp_signs1, opp_signs2, Cout_n, Z_n, le_u, gt_u: std_logic;
begin

	zd: zero_detector generic map (NBIT) port map (SUM, Z);

	e <= Z;
	ne <= Z_n;


	xorx1: XOR2 port map (A(NBIT-1), B(NBIT-1), opp_signs);

	andx1: AND2 port map (opp_signs, S, opp_signs2);

	ivx2: IV port map (Cout, Cout_n);
	ivx3: IV port map (Z, Z_n);

	orx1: OR2 port map (Cout_n, Z, le_u);
	xorx2: XOR2 port map (le_u, opp_signs2, le);

	xorx3: XOR2 port map(Cout_n, opp_signs2, lt);

	andx2: AND2 port map (Cout, Z_n, gt_u);
	xorx4: XOR2 port map (gt_u, opp_signs2, gt);

	xorx5: XOR2 port map (Cout, opp_signs2, ge);

end struct;
