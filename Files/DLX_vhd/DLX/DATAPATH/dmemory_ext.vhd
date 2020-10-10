library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_package.all;
use WORK.myTypes.all;

entity dmemory_ext is
	port ( 	    SE_CTRL, MSIZE1, MSIZE0: in std_logic; 	--extend signed if SE_CTRL is 1
				DataIn: in std_logic_vector(BUS_WIDTH-1 downto 0);
			   	Dataout: out std_logic_vector(BUS_WIDTH-1 downto 0));
end entity;

architecture Beh of dmemory_ext is

	signal zero24, sign24: std_logic_vector(23 downto 0);
	signal zero16, sign16: std_logic_vector(15 downto 0);

	signal MSIZE: std_logic_vector(1 downto 0);
	signal int_MSIZE: integer;

begin

	zero24 <= X"000000";
	zero16 <= X"0000";

	sign24 <= X"000000" when (DataIn(BUS_WIDTH-1) = '0') else
			  X"FFFFFF";

	sign16 <= X"0000" when (DataIn(BUS_WIDTH-1) = '0') else
			  X"FFFF";

	MSIZE <= MSIZE1 & MSIZE0;
	int_MSIZE <= to_integer(unsigned(MSIZE));

	DataOut <= 	zero24 & DataIn(BUS_WIDTH-1 downto 24) when int_MSIZE = 1 and se_ctrl = '0' else
				zero16 & DataIn(BUS_WIDTH-1 downto 16) when int_MSIZE = 2 and se_ctrl = '0' else
				sign24 & DataIn(BUS_WIDTH-1 downto 24) when int_MSIZE = 1 and se_ctrl = '1' else
				sign16 & DataIn(BUS_WIDTH-1 downto 16) when int_MSIZE = 2 and se_ctrl = '1' else
				DataIn;
end Beh;
