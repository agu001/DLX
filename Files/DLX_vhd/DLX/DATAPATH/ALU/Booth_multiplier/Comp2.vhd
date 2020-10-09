library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.myTypes.all;

entity Comp_2 is
	generic ( NBIT: integer );
	port ( I: in std_logic_vector(NBIT-1 downto 0);
		   O: out std_logic_vector(NBIT-1 downto 0) );
end entity Comp_2;

architecture struct of Comp_2 is
	component IV is
		Port (	A:	In	std_logic;
			    Y:	Out	std_logic);
	end component IV;

	component P4_ADDER is
				generic ( NBIT : integer );
				port (
					A :		in	std_logic_vector(NBIT-1 downto 0);
					B :		in	std_logic_vector(NBIT-1 downto 0);
					Cin :	in	std_logic;
					S :		out	std_logic_vector(NBIT-1 downto 0);
					Cout :	out	std_logic);
	end component P4_ADDER;

	signal zeros, IV2ADD: std_logic_vector(NBIT-1 downto 0);

begin

	zeros <= (others=>'0');

ivblock: for j in 0 to (NBIT-1) generate
			 ivs: IV port map ( I(j), IV2ADD(j) );
		 end generate ivblock;

add:	P4_ADDER generic map (NBIT) port map ( IV2ADD, zeros, '1', O, open);

end struct;
