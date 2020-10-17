library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_package.all;
use WORK.myTypes.all;

entity FORWARDING_UNIT is
	port ( 	    RS1, RS2, RD_EX, RD_MEM, RD_WB:IN std_logic_vector(4 downto 0);
				F_ALU_EX, F_ALU_MEM, F_ALU_WB: IN std_logic_vector(BUS_WIDTH-1 downto 0);
				WF_EX, WF_MEM, WF_WB: in std_logic;
				F_OUT_S1, F_OUT_S2: OUT std_logic_vector(BUS_WIDTH-1 downto 0);
				MUX1_SEL, MUX2_SEL: OUT std_logic;
				CLK, RST: IN std_logic
			 );
end FORWARDING_UNIT;

architecture beh of FORWARDING_UNIT is

begin


	F_OUT_S1 <=	F_ALU_EX 	WHEN ((RS1 = RD_EX) and WF_EX='1') ELSE
				F_ALU_MEM  	WHEN ((RS1 = RD_MEM) and WF_MEM='1') ELSE
				F_ALU_WB  	WHEN ((RS1 = RD_WB) and WF_WB='1');

	F_OUT_S2 <=	F_ALU_EX 	WHEN ((RS2 = RD_EX) and WF_EX='1') ELSE
				F_ALU_MEM  	WHEN ((RS2 = RD_MEM) and WF_MEM='1') ELSE
				F_ALU_WB  	WHEN ((RS2 = RD_WB) and WF_WB='1');

	MUX1_SEL <= '1' WHEN ((RS1 = RD_EX and WF_EX='1') OR (RS1 = RD_MEM and WF_MEM='1') OR (RS1 = RD_WB and WF_WB='1')) ELSE
				'0';

	MUX2_SEL <= '1' WHEN ((RS2 = RD_EX and WF_EX='1') OR (RS2 = RD_MEM and WF_MEM='1') OR (RS2 = RD_WB and WF_WB='1')) ELSE
				'0';
end beh;
