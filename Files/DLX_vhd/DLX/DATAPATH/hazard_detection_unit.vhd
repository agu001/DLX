library IEEE;
use IEEE.std_logic_1164.all;
use WORK.myTypes.all;

entity HAZARD_DETECTION_UNIT is
	port ( RS1_DEC, RS2_DEC, RD_EX: in std_logic_vector(4 downto 0);
		   MEMRD_EX, STALL: in std_logic;
		   PC_EN, IR_EN, MUX_SEL: out std_logic
		 );
end entity HAZARD_DETECTION_UNIT;

architecture Beh of HAZARD_DETECTION_UNIT is
begin
	process(RS1_DEC, RS2_DEC, RD_EX, MEMRD_EX, STALL)
	begin
		if ( STALL = '1' ) then
			PC_EN <= '1';
			IR_EN <= '1';
			MUX_SEL <= '1';
		elsif ( MEMRD_EX = '1' and (RS1_DEC = RD_EX or RS2_DEC = RD_EX) ) then
			PC_EN <= '0';
			IR_EN <= '0';
			MUX_SEL <= '1';
		else
			PC_EN <= '1';
			IR_EN <= '1';
			MUX_SEL <= '0';
		end if;
	end process;
end Beh;
