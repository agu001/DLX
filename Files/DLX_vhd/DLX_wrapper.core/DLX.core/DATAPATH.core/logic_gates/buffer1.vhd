library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity buffer1 is
	port(I: in std_logic;
		 O: out std_logic);
end buffer1;

architecture BEH of buffer1 is

	component IV is
		Port (	A:	In	std_logic;
			Y:	Out	std_logic);
	end component IV;

	signal iv_out: std_logic;

begin

	iv1_logic: IV port map(I, iv_out);
	iv2_logic: IV port map(iv_out, O);

	--O <= I;
end BEH;
