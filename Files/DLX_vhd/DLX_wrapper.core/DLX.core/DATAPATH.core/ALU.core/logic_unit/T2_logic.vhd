library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use WORK.myTypes.all;

entity T2_logic is
	generic (NBIT: integer);
  	port(	logic_op: IN std_logic_vector(2 downto 0);
			DATA1, DATA2: IN std_logic_vector(NBIT-1 downto 0);
			Y: OUT std_logic_vector(NBIT-1 downto 0));
end T2_logic;

architecture Struct of T2_logic is

	component T2_logic_block is
		port ( S: in std_logic_vector(2 downto 0);
			   R1, R2: in std_logic;
			   O: out std_logic
			 );
	end component T2_logic_block;

begin

	T2_blocks: 	for i in 0 to NBIT-1 generate

					createT2block: T2_logic_block port map(logic_op, DATA1(i), DATA2(i), Y(i));

				end generate;

end Struct;
