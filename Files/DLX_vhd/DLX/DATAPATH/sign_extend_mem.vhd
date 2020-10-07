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
	sign24 <= X"000000" when (DataIn(31) = '0') else
			  X"FFFFFF";
	sign16 <= X"0000" when (DataIn(31) = '0') else
			  X"FFFF";
	--sign8 <=  X"00" when (DataIn() = '0') else
	--		  X"FF";
	temp_v <= MSIZE1 & MSIZE0;
	numbytes <= to_integer(unsigned(temp_v));


	DataOut <= 	zero24 & DataIn(31 downto 24) when numbytes = 1 and se_ctrl = '0' else
				zero16 & DataIn(31 downto 16) when numbytes = 2 and se_ctrl = '0' else
				sign24 & DataIn(31 downto 24) when numbytes = 1 and se_ctrl = '1' else
				sign16 & DataIn(31 downto 16) when numbytes = 2 and se_ctrl = '1' else
				DataIn;
end Beh;
