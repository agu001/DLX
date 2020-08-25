library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.all;

entity adder is
	port (A, B: in std_logic_vector(31 downto 0);
		     X: out std_logic_vector(31 downto 0)
		 );
end adder;

architecture Beh of adder is
begin
	X <= std_logic_vector( unsigned(A) + signed(B) );
end Beh;
