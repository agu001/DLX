library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity tb_comparator is
end;

architecture test2 of tb_comparator is
	component ADD_SUB_BLOCK is
		generic (NBIT:	integer :=	32);
		port (
					A :		in	std_logic_vector(NBIT-1 downto 0);
					B :		in	std_logic_vector(NBIT-1 downto 0);
					SUB :	in	std_logic;
					RES :	out	std_logic_vector(NBIT-1 downto 0);
					Cout :	out	std_logic);
	end component;

	component comparator is
		generic (NBIT: integer:= 32);
		port	(	A, B, SUM:	in std_logic_vector(NBIT-1 downto 0);
					S, Cout:	in std_logic;
					e, lt, le, gt, ge:	out std_logic		--equal, less than, less or equal, greater than, greater or equal
				);
	end component;

	signal A,B,RES :std_logic_vector(32-1 downto 0);
	signal S, SUB, Cout :std_logic;

begin
	dut: comparator generic map (32) port map(A, B, RES, S, Cout);
	dut2: ADD_SUB_BLOCK generic map(32) port map(A, B, SUB, RES, Cout);

	process
	begin
		-------UNSIGNED TESTING------
		SUB <= '1';
		S <= '0';
		A <= std_logic_vector(to_unsigned(8, 32));
		B <= std_logic_vector(to_unsigned(8, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_unsigned(8, 32));
		B <= std_logic_vector(to_unsigned(7, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_unsigned(7, 32));
		B <= std_logic_vector(to_unsigned(8, 32));
		wait for 10 ns;
		A <= X"FFFFFFFF";
		B <= X"FFFFFFFF";
		wait for 10 ns;
		A <= X"80000000";
		B <= X"00000001";
		wait for 10 ns;
		A <= X"7FFFFFFF";
		B <= X"80000000";
		wait for 10 ns;
		A <= X"FFFFFFFF";
		B <= X"80000000";
		wait for 10 ns;
		A <= X"7FFFFFFF";
		B <= X"FFFFFFFF";
		-------SIGNED TESTING------
		S <= '1';
		SUB <= '1';
		A <= std_logic_vector(to_unsigned(8, 32));
		B <= std_logic_vector(to_unsigned(8, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_unsigned(8, 32));
		B <= std_logic_vector(to_unsigned(7, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_unsigned(7, 32));
		B <= std_logic_vector(to_unsigned(8, 32));
		wait for 10 ns;
		A <= X"FFFFFFFF";
		B <= X"FFFFFFFF";
		wait for 10 ns;
		A <= X"80000000";
		B <= X"00000001";
		wait for 10 ns;
		A <= X"7FFFFFFF";
		B <= X"80000000";
		wait for 10 ns;
		A <= X"FFFFFFFF";
		B <= X"80000000";
		wait for 10 ns;
		A <= X"7FFFFFFF";
		B <= X"FFFFFFFF";
		------------------------------------
		wait for 10 ns;
		A <= std_logic_vector(to_signed(-3, 32));
		B <= std_logic_vector(to_signed(-4, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_signed(-3, 32));
		B <= std_logic_vector(to_signed(-3, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_signed(-3, 32));
		B <= std_logic_vector(to_signed(-2, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_signed(-3, 32));
		B <= std_logic_vector(to_signed(1, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_signed(-3, 32));
		B <= std_logic_vector(to_signed(50, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_signed(3, 32));
		B <= std_logic_vector(to_signed(-4, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_signed(3, 32));
		B <= std_logic_vector(to_signed(-1, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_signed(3, 32));
		B <= std_logic_vector(to_signed(2, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_signed(3, 32));
		B <= std_logic_vector(to_signed(4, 32));
		wait for 10 ns;
		A <= std_logic_vector(to_signed(3, 32));
		B <= std_logic_vector(to_signed(50, 32));

		wait;
	end process;
end test2;
