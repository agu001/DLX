library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity mux21 is
	Port (in_1, in_0:	In	std_logic;
		  sel:	In	std_logic;
		  y:	Out	std_logic);
end mux21;

architecture df of mux21 is

	component ND2 is
		Port (	A:	In	std_logic;
				B:	In	std_logic;
				Y:	Out	std_logic);
	end component;

	component IV is
		Port (	A:	In	std_logic;
				Y:	Out	std_logic);
	end component;

	--signal y1, y2: std_logic_vector(NBIT-1 downto 0);
	signal sb, y1, y2: std_logic;

begin

	UIV : IV Port Map ( sel, sb);
	UND1 : ND2 Port Map ( in_1, sel, y1);
	UND2 : ND2 Port Map ( in_0, sb, y2);
	UND3 : ND2 Port Map ( y1, y2, y);

	--y <= in_1 when( sel = '1' ) else
	--	 in_0 when( sel = '0' ) else
	--	 'U';

end df;

