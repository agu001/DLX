library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity mux21 is
	Port (in_1, in_0:	In	std_logic;
		  sel:	In	std_logic;
		  y:	Out	std_logic);
end mux21;

architecture df of mux21 is
begin

	y <= in_1 when( sel = '1' ) else
		 in_0 when( sel = '0' ) else
		 'U';

end df;

