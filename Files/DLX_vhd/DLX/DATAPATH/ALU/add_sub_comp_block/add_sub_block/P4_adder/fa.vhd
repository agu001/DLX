library ieee;
use ieee.std_logic_1164.all;
use WORK.myTypes.all;

entity FA is
	Port (	A:	In	std_logic;
			B:	In	std_logic;
			Ci:	In	std_logic;
			S:	Out	std_logic;
			Co:	Out	std_logic);
end FA;

architecture BEHAVIORAL of FA is

begin

  S <= A xor B xor Ci after FASDELAY;
  Co <= (A and B) or (B and Ci) or (A and Ci) after FACDELAY;

end BEHAVIORAL;
