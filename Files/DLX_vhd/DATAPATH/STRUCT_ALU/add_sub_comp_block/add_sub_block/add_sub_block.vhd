library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ADD_SUB_BLOCK is
		generic (
					NBIT:	integer :=	32);
		port (
					A :		in	std_logic_vector(NBIT-1 downto 0);
					B :		in	std_logic_vector(NBIT-1 downto 0);
					SUB:	in	std_logic;
					RES :	out	std_logic_vector(NBIT-1 downto 0);
					Cout, e, ne, lt, le, gt, ge:	out std_logic);
end entity;

architecture arch of ADD_SUB_BLOCK is
		component P4_ADDER is
				generic (
					NBIT :		integer := 32);
				port (
					A :		in	std_logic_vector(NBIT-1 downto 0);
					B :		in	std_logic_vector(NBIT-1 downto 0);
					Cin :	in	std_logic;
					S :		out	std_logic_vector(NBIT-1 downto 0);
					Cout :	out	std_logic);
		end component P4_ADDER;

		component xor2_block is
				port(	A, B: 	in std_logic;
						C:		out std_logic
					);
		end component;

		signal B_1: std_logic_vector(NBIT-1 downto 0);
begin
	GEN_XOR:
	for i in 0 to NBIT-1 generate
		xor2x: xor2_block port map(B(i), SUB, B_1(i));
	end generate GEN_XOR;

	ADDER: P4_ADDER generic map (NBIT) port map ( A, B_1, SUB, RES, Cout);

end architecture;
