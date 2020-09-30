library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity TB_ADD_SUB_BLOCK is
end TB_ADD_SUB_BLOCK;

architecture TEST of TB_ADD_SUB_BLOCK is

	-- P4 component declaration
	component ADD_SUB_BLOCK is
		generic (
					NBIT:	integer :=	32);
		port (
					A :		in	std_logic_vector(NBIT-1 downto 0);
					B :		in	std_logic_vector(NBIT-1 downto 0);
					SUB :	in	std_logic;
					RES :	out	std_logic_vector(NBIT-1 downto 0);
					Cout :	out	std_logic);
	end component;

	signal A,B,RES :std_logic_vector(NBIT-1 downto 0);
	signal SUB, Cout :std_logic;

begin
	dut: ADD_SUB_BLOCK generic map(NBIT) port map(A, B, SUB, RES, Cout);

	process
	begin
		SUB <= '0';
		A <= X"0000123F";
		B <= X"00000FD1";
		wait for 10 ns;
		SUB <= '1';
		wait for 10 ns;
		SUB <= '0';			--expected Cout = '1'
		A <= X"FFFFFFFF";
		B <= X"00000001";
		wait for 10 ns;
		SUB <= '1';
		wait for 10 ns;
		SUB <= '0';
		A <= X"00000005";
		B <= X"FFFFFFFC";
		wait for 10 ns;
		SUB <= '1';
		wait;
	end process;

end TEST;

