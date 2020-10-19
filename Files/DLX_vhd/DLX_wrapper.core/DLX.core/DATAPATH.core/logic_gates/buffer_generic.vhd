library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity buffer_generic is
	generic(NBIT: integer);
	port(I: in std_logic_vector(NBIT-1 downto 0);
		 O: out std_logic_vector(NBIT-1 downto 0));
end buffer_generic;

architecture BEH of buffer_generic is

	component buffer1 is
			port(I: in std_logic;
		 		 O: out std_logic);
	end component buffer1;

	signal I_s, O_s: std_logic_vector(NBIT-1 downto 0);

begin
	I_s <= I;
	buff_gen: 	for i in 0 to NBIT-1 generate
					b1_gen: buffer1 port map(I_s(i), O_s(i));
				end generate;
	O <= O_s;
end BEH;
