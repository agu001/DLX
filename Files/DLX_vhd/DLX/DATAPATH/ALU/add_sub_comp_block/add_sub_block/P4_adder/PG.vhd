library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PG is
	port( PGin1, PGin2: in std_logic_vector(1 downto 0);
			     PGout: out std_logic_vector(1 downto 0)
		);
end entity PG;

architecture BEH of PG is

	component OR2 is
			port(	A, B: 	in std_logic;
					C:		out std_logic
				);
	end component OR2;

	component AND2 is
			port(	A, B: 	in std_logic;
					C:		out std_logic
				);
	end component AND2;

	signal and2_out: std_logic;

begin

	and1_logic: AND2 port map(PGin1(1), PGin2(1), PGout(1));

	and2_logic: AND2 port map(PGin1(1), PGin2(0), and2_out);
	or1_logic: OR2 port map(PGin1(0), and2_out, PGout(0));

	--PGout(1) <= PGin1(1) and PGin2(1);
	--PGout(0) <= PGin1(0) or (PGin1(1) and PGin2(0));	--Gi:k + Pi:k * Gk-1:j

end BEH;
