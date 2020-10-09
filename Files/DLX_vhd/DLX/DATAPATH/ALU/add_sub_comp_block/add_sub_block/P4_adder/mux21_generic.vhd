library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity MUX21_GENERIC is
	generic ( NBIT: integer );
	Port (	in_1, in_0:	In	std_logic_vector(NBIT-1 downto 0);
			sel:	In	std_logic;
			y:	Out	std_logic_vector(NBIT-1 downto 0));
end MUX21_GENERIC;

architecture MUX21_GEN_STRUCTURAL of MUX21_GENERIC is

	component ND2
		Port (	A:	In	std_logic;
				B:	In	std_logic;
				Y:	Out	std_logic);
	end component;

	component IV
		Port (	A:	In	std_logic;
				Y:	Out	std_logic);
	end component;

	signal y1, y2: std_logic_vector(NBIT-1 downto 0);
	signal sb: std_logic;

begin
	--the select signal is complemented
	UIV : IV Port Map ( sel, sb);
	--for each bit for our inputs data, the for-generate statement replicates the architecture of a
	--simple one-bit mux21 using three nand gates
	C1:for i in 0 to NBIT-1 generate
	     UND1 : ND2 Port Map ( in_1(i), sel, y1(i));
	     UND2 : ND2 Port Map ( in_0(i), sb, y2(i));
	     UND3 : ND2 Port Map ( y1(i), y2(i), y(i));
	   end generate;

end MUX21_GEN_STRUCTURAL;
