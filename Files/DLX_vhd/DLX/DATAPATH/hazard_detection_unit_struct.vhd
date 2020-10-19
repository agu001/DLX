library IEEE;
use IEEE.std_logic_1164.all;
use WORK.myTypes.all;

entity HAZARD_DETECTION_UNIT is
	port ( RS1_DEC, RS2_DEC, RD_EX: in std_logic_vector(4 downto 0);
		   MEMRD_EX: in std_logic;
		   PC_EN, IR_EN, MUX_SEL: out std_logic
		 );
end entity HAZARD_DETECTION_UNIT;

architecture Beh of HAZARD_DETECTION_UNIT is

	component comparator_generic is
		generic (NBIT: integer);
		port ( A, B: in std_logic_vector(NBIT-1 downto 0);
				  Z: out std_logic
				);
	end component comparator_generic;

	component ND3 is
		Port (	A, B, C: In	std_logic;
			Y:	Out	std_logic);
	end component ND3;

	component AND2 is
			port(	A, B: 	in std_logic;
					C:		out std_logic
				);
	end component AND2;

	component IV is
		Port (	A:	In	std_logic;
			Y:	Out	std_logic);
	end component IV;

	signal compare1_out, compare2_out, and_out, nd_out, iv_out, iv_n_out: std_logic;
	signal tempRS1, tempRS2, tempRD: std_logic_vector(7 downto 0);

begin

	tempRS1 <= "000" & RS1_DEC;
	tempRS2 <= "000" & RS2_DEC;
	tempRD <= "000" & RD_EX;
	compare_RS1: comparator_generic generic map(8) port map(tempRS1, tempRD, compare1_out);
	compare_RS2: comparator_generic generic map(8) port map(tempRS2, tempRD, compare2_out);
	and_mem: AND2 port map(MEMRD_EX, '1', and_out);


	nand_logic: ND3 port map(and_out, compare1_out, compare2_out, nd_out);
	iv_result: IV port map(nd_out, iv_out);

	result_neg: IV port map(iv_out, iv_n_out);

	MUX_SEL <= iv_out;
	PC_EN <= iv_n_out;
	IR_EN <= iv_n_out;

end Beh;
