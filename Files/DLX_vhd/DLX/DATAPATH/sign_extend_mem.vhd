library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_package.all;

entity sign_ext_mem is
	port ( 	    SE_CTRL, MSIZE1, MSIZE0: in std_logic; 	--extend signed if SE_CTRL is 1
				DataIn: in std_logic_vector(31 downto 0);
			   	Dataout: out std_logic_vector(31 downto 0)
			 );
end entity;

architecture Beh of sign_ext_mem is
	signal zero24, sign24: std_logic_vector(23 downto 0);
	signal zero16, sign16: std_logic_vector(15 downto 0);
	signal zero8, sign8: std_logic_vector(7 downto 0);
	signal numbytes: integer;
	signal temp_v: std_logic_vector(1 downto 0);
begin

	zero24 <= X"000000";
	zero16 <= X"0000";
	zero8 <= X"00";
	sign24 <= X"000000" when (DataIn(23) = '0') else
			  X"FFFFFF";
	sign16 <= X"0000" when (DataIn(15) = '0') else
			  X"FFFF";
	sign8 <=  X"00" when (DataIn(7) = '0') else
			  X"FF";
	temp_v <= MSIZE1 & MSIZE0;
	numbytes <= to_integer(unsigned(temp_v));

	process(SE_CTRL, DataIn)
	begin
		if (numbytes /= 0) then
			case SE_CTRL is
				when '0' =>
					if (numbytes = 1 ) then
						DataOut <= zero24 & DataIn(7 downto 0);
					elsif (numbytes = 2 ) then
						DataOut <= zero16 & DataIn(15 downto 0);
					else
						DataOut <= DataIn;
					end if;
				when '1' =>
					if (numbytes = 1 ) then
						DataOut <= sign24 & DataIn(7 downto 0);
					elsif (numbytes = 2 ) then
						DataOut <= sign16 & DataIn(15 downto 0);
					else
						DataOut <= DataIn;
					end if;
				when others => DataOut <= zero24 & zero8;
			end case;
		end if;
	end process;
end Beh;
