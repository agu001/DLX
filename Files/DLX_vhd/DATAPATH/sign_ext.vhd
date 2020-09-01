library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_type.all;

entity sign_ext is
	port ( 	SE_CTRL: in std_logic;					--extend as unsigned if 1
			DataIn: in std_logic_vector(15 downto 0);
		   Dataout: out std_logic_vector(31 downto 0)
		 );
end entity;

architecture Beh of sign_ext is
begin

	DataOut <= (X"0000" & DataIn) after 0.3 ns when ((DataIn(15) = '0') OR SE_CTRL = '0') else
			   (X"FFFF" & DataIn) after 0.3 ns;
end Beh;
