library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comparator is
	generic (NBIT: integer:= 32);
	port	(	A, B, SUM:	in std_logic_vector(NBIT-1 downto 0);
				S, Cout:	in std_logic;
				e, ne, lt, le, gt, ge:	out std_logic		--equal, not equal, less than, less or equal, greater than, greater or equal
			);
end;

architecture struct of comparator is
	component zero_detector is
		generic (NBIT:	integer:= 32);
		port 	(A:	in std_logic_vector(NBIT-1 downto 0);
				 Z:	out std_logic);
	end component zero_detector;

	signal Z, opp_signs, opp_signs2: std_logic;
begin

	zd: zero_detector generic map (32) port map (SUM, Z);

	e <= Z;
	ne <= not Z;

	opp_signs <= A(NBIT-1) XOR B(NBIT-1);
	opp_signs2 <= opp_signs AND S;

	le <= (not Cout or Z) XOR opp_signs2;
	lt <= (not Cout) XOR opp_signs2;
	gt <= (Cout and not Z) XOR opp_signs2;
	ge <= (Cout) XOR opp_signs2;

end struct;
