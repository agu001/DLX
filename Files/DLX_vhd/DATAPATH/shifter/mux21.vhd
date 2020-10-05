library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity MUX21 is
	generic(NBIT: integer := 32);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(NBIT-1 downto 0));
end MUX21;


architecture MUX21_GEN of MUX21 is
begin

	Y <= A when( SEL = '1' ) else
		 B when( SEL = '0' ) else
		 (others => 'U');

end MUX21_GEN;

