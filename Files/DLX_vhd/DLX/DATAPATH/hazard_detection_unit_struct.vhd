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

	component ADD_SUB_COMP_BLOCK is
			generic (	NBIT:	integer);
			port (	A:	in	std_logic_vector(NBIT-1 downto 0);
					B:	in	std_logic_vector(NBIT-1 downto 0);
					SUB, SIGN:	in	std_logic;
					RES :	out	std_logic_vector(NBIT-1 downto 0);
					Cout, e, ne, lt, le, gt, ge: out std_logic);
	end component ADD_SUB_COMP_BLOCK;

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
	compare_RS1: ADD_SUB_COMP_BLOCK generic map(8) port map(tempRS1, tempRD, '1', '0', open, open, compare1_out, open, open, open, open, open);
	compare_RS2: ADD_SUB_COMP_BLOCK generic map(8) port map(tempRS2, tempRD, '1', '0', open, open, compare2_out, open, open, open, open, open);
	and_mem: AND2 port map(MEMRD_EX, '1', and_out);


	nand_logic: ND3 port map(and_out, compare1_out, compare2_out, nd_out);
	iv_result: IV port map(nd_out, iv_out);

	result_neg: IV port map(iv_out, iv_n_out);

	MUX_SEL <= iv_out;
	PC_EN <= iv_n_out;
	IR_EN <= iv_n_out;


	--process(RS1_DEC, RS2_DEC, RD_EX, MEMRD_EX)
	--begin
	--	if ( MEMRD_EX = '1' and (RS1_DEC = RD_EX or RS2_DEC = RD_EX) ) then
	--		PC_EN <= '0';
	---		IR_EN <= '0';
	--		MUX_SEL <= '1';
	--	else
	---		PC_EN <= '1';
	--		IR_EN <= '1';
	--		MUX_SEL <= '0';
	--	end if;
	--end process;
end Beh;
