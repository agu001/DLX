library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_package.all;
use WORK.myTypes.all;

entity immediate_ext is
	port ( 	    SE_CTRL, ISJUMP: in std_logic;					--extend signed if SE_CTRL is 1
				DataIn: in std_logic_vector(25 downto 0);		--immediate is 26 bits for jump instructions
			   	Dataout: out std_logic_vector(BUS_WIDTH-1 downto 0)
			 );
end entity immediate_ext;

architecture Beh of immediate_ext is
begin

	process(SE_CTRL, ISJUMP, DataIn)
	begin
		if (ISJUMP = '1') then
			if ((DataIn(25) = '0') or SE_CTRL = '0') then
				DataOut <= ("000000" & DataIn) after SEDELAY;
			else
				DataOut <= ("111111" & DataIn) after SEDELAY;
			end if;
		else
			if ((DataIn(15) = '0') or SE_CTRL = '0') then
				DataOut <= (X"0000" & DataIn(15 downto 0)) after SEDELAY;
			else
				DataOut <= (X"FFFF" & DataIn(15 downto 0)) after SEDELAY;
			end if;
		end if;
	end process;
end Beh;
