library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.myTypes.all;

entity NPC_LOGIC is
	generic( NBIT:integer := BUS_WIDTH );
	port( BJ_ADDR, NPC_BRANCH, NPC, BTB_ADDRESS: in std_logic_vector(NBIT-1 downto 0);
		  ISJUMP, B_TAKEN, P_WRONG, B_PREDICT: in std_logic;
		  PC_ADDRESS: out std_logic_vector(NBIT-1 downto 0)
		);
end NPC_LOGIC;

architecture DataFlow of NPC_LOGIC is

	component mux21_generic is
		generic (	NBIT: integer := BUS_WIDTH);
		Port (	in_1, in_0:	In	std_logic_vector(NBIT-1 downto 0);
				sel:	In	std_logic;
				y:	Out	std_logic_vector(NBIT-1 downto 0));
	end component mux21_generic;

begin

		PC_ADDRESS <= 	BJ_ADDR 	when( ( P_WRONG='1' and B_TAKEN='1' ) or ISJUMP='1') else
						NPC_BRANCH 	when( P_WRONG='1' and B_TAKEN='0' ) else
						BTB_ADDRESS	when( B_PREDICT='1' and P_WRONG='0' ) else
						NPC;

end DataFlow;
