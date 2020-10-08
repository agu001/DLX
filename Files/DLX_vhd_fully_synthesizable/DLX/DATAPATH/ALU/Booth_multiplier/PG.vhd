library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PG is
	port( PGin1, PGin2: in std_logic_vector(1 downto 0);
			     PGout: out std_logic_vector(1 downto 0)
		);
end entity PG;

architecture BEH of PG is
begin

	PGout(1) <= PGin1(1) and PGin2(1);
	PGout(0) <= PGin1(0) or (PGin1(1) and PGin2(0));	--Gi:k + Pi:k * Gk-1:j

end BEH;
