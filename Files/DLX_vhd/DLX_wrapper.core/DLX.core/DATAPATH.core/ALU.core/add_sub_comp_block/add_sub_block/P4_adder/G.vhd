library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity G is
	port( PGin: in std_logic_vector(1 downto 0);
	       Gin: in std_logic;
		  Gout: out std_logic
		);
end entity G;

architecture BEH of G is

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

	signal and_out: std_logic;

begin

	and_logic: AND2 port map(PGin(1), Gin, and_out);
	or_logic: OR2 port map(PGin(0), and_out, Gout);

	--Gout <= PGin(0) or (PGin(1) and Gin); --Gi:k + Pi:k * Gk-1:j

end BEH;
