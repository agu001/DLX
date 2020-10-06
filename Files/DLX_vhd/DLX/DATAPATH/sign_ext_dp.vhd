library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_type.all;

entity sign_ext_dp is
	port ( 	    SE_CTRL, ISJUMP: in std_logic; 	--extend signed if SE_CTRL is 1
				DataIn: in std_logic_vector(25 downto 0);
			   	Dataout: out std_logic_vector(31 downto 0)
			 );
end entity;

architecture Beh of sign_ext_dp is
begin

	process(SE_CTRL, ISJUMP, DataIn)
	begin
		if (ISJUMP = '1') then
			if ((DataIn(25) = '0') or SE_CTRL = '0') then
				DataOut <= ("000000" & DataIn) after 0.3 ns;
			else
				DataOut <= ("111111" & DataIn) after 0.3 ns;
			end if;
		else
			if ((DataIn(15) = '0') or SE_CTRL = '0') then
				DataOut <= (X"0000" & DataIn(15 downto 0)) after 0.3 ns;
			else
				DataOut <= (X"FFFF" & DataIn(15 downto 0)) after 0.3 ns;
			end if;
		end if;
	end process;
end Beh;
