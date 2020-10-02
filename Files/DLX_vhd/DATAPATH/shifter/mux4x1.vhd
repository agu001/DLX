library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux4x1 is
	port ( INPUT1, INPUT2, INPUT3, INPUT4: in std_logic_vector(39 downto 0);
		   SEL: in std_logic_vector(1 downto 0);
		   OUTPUT: out std_logic_vector(39 downto 0)
		 );
end mux4x1;

architecture Dataflow of mux4x1 is
begin
	OUTPUT <= INPUT1 when( SEL = "00" ) else
			  INPUT2 when( SEL = "01" ) else
			  INPUT3 when( SEL = "10") else
			  INPUT4 when( SEL = "11") else
			  (others => '0');
end Dataflow;
