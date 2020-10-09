library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.myTypes.all;

entity ADD_SUB_COMP_BLOCK is
		generic (	NBIT:	integer);
		port (	A:	in	std_logic_vector(NBIT-1 downto 0);
				B:	in	std_logic_vector(NBIT-1 downto 0);
				SUB, SIGN:	in	std_logic;
				RES :	out	std_logic_vector(NBIT-1 downto 0);
				Cout, e, ne, lt, le, gt, ge:	out std_logic);
end entity;

architecture arch of ADD_SUB_COMP_BLOCK is
		component ADD_SUB_BLOCK is
			generic ( NBIT:	integer );
			port (	A:	in	std_logic_vector(NBIT-1 downto 0);
					B:	in	std_logic_vector(NBIT-1 downto 0);
					SUB:	in	std_logic;
					RES:	out	std_logic_vector(NBIT-1 downto 0);
					Cout, e, ne, lt, le, gt, ge:	out std_logic);
		end component;

		component comparator is
			generic (NBIT: integer);
			port	(	A, B, SUM:	in std_logic_vector(NBIT-1 downto 0);
						S, Cout:	in std_logic;
						e, ne, lt, le, gt, ge:	out std_logic);		--equal, less than, less or equal, greater than, greater or equal
		end component;

		signal B_1, RES_s: std_logic_vector(NBIT-1 downto 0);
		signal Cout_s: std_logic;
begin

	ADD_SUB: ADD_SUB_BLOCK generic map (NBIT) port map ( A, B, SUB, RES_s, Cout_s);
	COMP: comparator generic map(NBIT) port map(A, B, RES_s, SIGN, Cout_s, e, ne, lt, le, gt, ge);

	RES <= RES_s;
	Cout <= Cout_s;

end architecture;
