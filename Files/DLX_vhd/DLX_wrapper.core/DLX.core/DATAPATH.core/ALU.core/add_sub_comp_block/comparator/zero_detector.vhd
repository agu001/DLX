library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity zero_detector is
	generic (NBIT:	integer);
	port 	(A:	in std_logic_vector(NBIT-1 downto 0);
			 Z:	out std_logic);
end;

architecture beh of zero_detector is

	component comparator_generic is
		generic (NBIT: integer);
		port ( A, B: in std_logic_vector(NBIT-1 downto 0);
				  Z: out std_logic
				);
	end component comparator_generic;

	signal data_zero: std_logic_vector(NBIT-1 downto 0);

begin

	data_zero <= (others => '0');
	compare_to_zero: comparator_generic generic map(NBIT) port map(A, data_zero, Z);
	--Z <= '1' when unsigned(A) = 0 else
	--	 '0';
end beh;
