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
begin

	Gout <= PGin(0) or (PGin(1) and Gin); --Gi:k + Pi:k * Gk-1:j

end BEH;
