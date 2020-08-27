library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_type.all;

entity sign_ext is
	port ( DataIn: in std_logic_vector(15 downto 0);
		   Dataout: out std_logic_vector(31 downto 0)
		 );
end entity;

architecture Beh of sign_ext is
begin
	DataOut <= X"0000" & DataIn when (DataIn(15) = '0') else
			   X"FFFF" & DataIn;
end Beh;
