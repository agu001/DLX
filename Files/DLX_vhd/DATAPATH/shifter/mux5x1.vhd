library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux5x1 is
	port ( INPUT1, INPUT2, INPUT3, INPUT4, INPUT5: in std_logic;
		   SEL: in std_logic_vector(2 downto 0);
		   OUTPUT: out std_logic
		 );
end mux5x1;

architecture Dataflow of mux5x1 is
begin
	OUTPUT <= INPUT1 when( SEL = "000" ) else
			  INPUT2 when( SEL = "001" ) else
			  INPUT3 when( SEL = "010") else
			  INPUT4 when( SEL = "011") else
			  INPUT5 when( SEL = "100") else
			  (others => 'U');
end Dataflow;
