library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.myTypes.all;
use WORK.alu_package.all;

	entity CONTROL_UNIT is
		port (	-- FETCH STAGE OUTPUTS

				-- DECODE STAGE OUTPUTS
				RF1    		: out std_logic;               -- enables the read port 1 of the register file
				RF2    		: out std_logic;               -- enables the read port 2 of the register file
				EN_DE    		: out std_logic;               -- enables the register file and the pipeline registers

				--EXECUTE STAGE OUTPUTS
				I0_R1_SEL	: out std_logic;               --selection bit of RD multiplexer			NEW!!
				JAL_SEL		: out std_logic;               --selection bit of RD/R31 multiplexer		NEW!!
				ISJR		: out std_logic;
				S2 	    	: out std_logic;               --selection bit of second alu input multiplexer
				SE_CTRL		: out std_logic;
				ALU_CTRL	: out ALU_OP_type;
				EN_EM  	  	: out std_logic;               -- enables the pipe registers

				-- MEMORY STAGE OUTPUTS
				ISJUMP		: out std_logic;			   --
				ISBRANCH	: out std_logic;			   --
				ISBEQZ   	: out std_logic;			   --
				RM     		: out std_logic;               -- enables the read-out of the memory
				WM     		: out std_logic;               -- enables the write-in of the memory
				MSIZE1		: out std_logic;
				MSIZE0		: out std_logic;
				SE_CTRL2	: out std_logic;
				EN_MW  		: out std_logic;               -- enables the memory and the pipeline registers

				-- WRITEBACK STAGE OUTPUTS
				S3     		: out std_logic; 				-- input selection of the multiplexer
				WF1    		: out std_logic;               -- enables the write port of the register file
				EN_W		: out std_logic;
				-- INPUTS
				OPCODE 		: in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
				FUNC   		: in  std_logic_vector(FUNC_SIZE - 1 downto 0);
				Clk 		: in std_logic;
				Rst 		: in std_logic);
    end entity;

architecture beh of CONTROL_UNIT is
	type mem_array is array (integer range 0 to MICROCODE_MEM_DEPTH - 1) of std_logic_vector(MICROCODE_MEM_SIZE - 1 downto 0);
  							--RF1,	RF2,	EN_DEC,	I0_R1_SEL,	JAL_SEL, ISJR,	S2,		EN_EX,	ISJUMP,	ISBRANCH,	BEQZ,	RM,	WM,	MSIZE1,	MSIZE0,	SE_CTRL2,	EN_MEM,	S3,	WF1, EN_WB
							--0,	1,  	2,		3,			4,	      5,	6,		7,		8,		9,			10,		11,	12,	13, 	14,		15,			16,		17,	 18,	19
	signal cw_mem : mem_array := (  "11110011000000001011",--RTYPE	0
									"00000000000000000000",
									"10100001100000001001",--J		2
									"10101001100000001011",--JAL		3
									"10100001011000001000",--BEQZ	4
									"10100001010000001000",--BNEZ	5
									"00000000000000000000",
									"00000000000000000000",
									"10100001000000001011",--ADDI	8
									"10100001000000001011",--ADDUI	9
									"10100001000000001011",--SUBI	10
									"10100001000000001011",--SUBUI	11
									"10100001000000001011",--ANDI	12
									"10100001000000001011",--ORI	13
									"10100001000000001011",--XORI	14
									"10100001000000001011",--LHI	15
									"00000000000000000000",
									"00000000000000000000",
									"10100101100000000001",--JR		18
									"10101101100000001011",--JALR	19
									"10100001000000001011",--SLLI	20
									"00100001000000001001",--NOP	21
									"10100001000000001011",--SRLI	22
									"10100001000000001011",--SRAI	23
									"10100001000000001011",--SEQI	24
									"10100001000000001011",--SNEI	25
									"10100001000000001011",--SLTI	26
									"10100001000000001011",--SGTI	27
									"10100001000000001011",--SLEI	28
									"10100001000000001011",--SGEI	29
									"00000000000000000000",
									"00000000000000000000",
									"10100001000100101111",--LB		32
									"00000000000000000000",
									"00000000000000000000",
									"10100001000101101111",--LW		35
									"10100001000100111111",--LBU	36
									"10100001000101011111",--LHU	37
									"00000000000000000000",
									"00000000000000000000",
									"11100001000010101001",--SB		40
									"00000000000000000000",
									"00000000000000000000",
									"11100001000011101001",--SW		43
									"00000000000000000000",
									"00000000000000000000",
									"00000000000000000000",
									"00000000000000000000",
									"00000000000000000000",
									"00000000000000000000",
									"00000000000000000000",
									"00000000000000000000",
									"00000000000000000000",
									"00000000000000000000",
									"00000000000000000000",
									"00000000000000000000",
									"00000000000000000000",
									"00000000000000000000",
									"10100001000000001011",--SLTUI	58
									"10100001000000001011",--SGTUI	59
									"10100001000000001011",--SLEUI	60
									"10100001000000001011",--SGEUI	61
									"00000000000000000000",
									"00000000000000000000"
									);

	signal cw_from_mem: std_logic_vector(MICROCODE_MEM_SIZE-1 downto 0);
	signal outCW: std_logic_vector(CW_SIZE-1 downto 0);

  	signal nextALU_CTRL : ALU_OP_type;
  	signal nextSE_CTRL : std_logic;

begin
		--RF1,	RF2,	EN_DEC,	I0_R1_SEL,	JAL_SEL, ISJR,	SE_CTRL, S2,	EN_EX,	ISJUMP,	ISBRANCH,	BEQZ,	RM,	WM,	MSIZE1,	MSIZE0,	SE_CTRL2,	EN_MEM,	S3,	WF1, EN_WB
		--0,	1,  	2,		3,			4,	      5,			 6,		7,		8,		9,			10,		11,	12,	13, 	14,		15,			16,		17,	 18,	19

	  	cw_from_mem <= cw_mem( to_integer( unsigned(OPCODE) ) );
		-- FETCH STAGE OUTPUTS

		-- DECODE STAGE OUTPUTS
		RF1    		<= outCW(CW_SIZE -1);
		RF2    		<= outCW(CW_SIZE -2);
		EN_DE    		<= outCW(CW_SIZE -3);
		--EXECUTE STAGE OUTPUTS
		I0_R1_SEL	<= outCW(CW_SIZE -4);
		JAL_SEL		<= outCW(CW_SIZE -5);
		ISJR		<= outCW(CW_SIZE -6);
		SE_CTRL		<= outCW(CW_SIZE -7);
		S2			<= outCW(CW_SIZE -8);
		EN_EM  		<= outCW(CW_SIZE -9);
		-- MEMORY STAGE OUTPUTS
		ISJUMP		<= outCW(CW_SIZE -10);
		ISBRANCH	<= outCW(CW_SIZE -11);
		ISBEQZ   	<= outCW(CW_SIZE -12);
		RM     		<= outCW(CW_SIZE -13);
		WM     		<= outCW(CW_SIZE -14);
		MSIZE1		<= outCW(CW_SIZE -15);
		MSIZE0		<= outCW(CW_SIZE -16);
		SE_CTRL2	<= outCW(CW_SIZE -17);
		EN_MW  		<= outCW(CW_SIZE -18);
		-- WRITEBACK STAGE OUTPUTS
		S3     		<= outCW(CW_SIZE -19);
		WF1    		<= outCW(CW_SIZE -20);
		EN_W		<= outCW(CW_SIZE -21);
		-- process to pipeline control words
		CW_PIPE: process (Clk, Rst)
			begin  -- process Clk
				if Rst = '1' then                   -- asynchronous reset (active low)
					outCW <= (others => '0');
					ALU_CTRL <= alu_DEFAULT;
				elsif Clk'event and Clk = '0' then  -- falling clock edge
					outCW <= cw_from_mem(MICROCODE_MEM_SIZE-1 downto MICROCODE_MEM_SIZE-6) & nextSE_CTRL & cw_from_mem(MICROCODE_MEM_SIZE-7 downto 0);
					ALU_CTRL <= nextALU_CTRL;
				end if;
		end process CW_PIPE;

		ALU_SE_CTRL : process (OPCODE, FUNC)
		begin  -- process ALU_OP_CODE_P
		case OPCODE is
			--ALU_OP_SIZE <= '0';				--0if 32bit operation, 16bit otherwise
			when RTYPE =>
				CASE FUNC IS
					--SE_CTRL NOT NEEDED
					when funcADD =>
							nextALU_CTRL <= alu_ADD;
							nextSE_CTRL <= '1';
					when funcADDU =>
							nextALU_CTRL <= alu_ADDU;
							nextSE_CTRL <= '0';
					when funcSUB =>
							nextALU_CTRL <= alu_SUB;
							nextSE_CTRL <= '1';
					when funcSUBU =>
							nextALU_CTRL <= alu_SUBU;
							nextSE_CTRL <= '0';
					when funcAND =>
							nextALU_CTRL <= alu_AND32;
							nextSE_CTRL <= '0';
					when funcOR  =>
							nextALU_CTRL <= alu_OR32;
							nextSE_CTRL <= '0';
					when funcSGE =>
							nextALU_CTRL <= alu_SGE;
							nextSE_CTRL <= '1';
					when funcSGEU =>
							nextALU_CTRL <= alu_SGEU;
							nextSE_CTRL <= '0';
					when funcSGTU =>
							nextALU_CTRL <= alu_SGTU;
							nextSE_CTRL <= '0';
					when funcSGT =>
							nextALU_CTRL <= alu_SGT;
							nextSE_CTRL <= '1';
					when funcSLTU =>
							nextALU_CTRL <= alu_SLTU;
							nextSE_CTRL <= '0';
					when funcSLT =>
							nextALU_CTRL <= alu_SLT;
							nextSE_CTRL <= '1';
					when funcSLE =>
							nextALU_CTRL <= alu_SLE;
							nextSE_CTRL <= '1';
					when funcSLEU =>
							nextALU_CTRL <= alu_SLEU;
							nextSE_CTRL <= '0';
					when funcSLL =>
							nextALU_CTRL <= alu_SLL;
							nextSE_CTRL <= '0';
					when funcSRA =>
							nextALU_CTRL <= alu_SRA;
							nextSE_CTRL <= '1';
					when funcSNE =>
							nextALU_CTRL <= alu_SNE;
							nextSE_CTRL <= '1';
					when funcSEQ =>
							nextALU_CTRL <= alu_SEQ;
							nextSE_CTRL <= '1';
					when funcSRL =>
							nextALU_CTRL <= alu_SRL;
							nextSE_CTRL <= '0';
					when funcXOR =>
							nextALU_CTRL <= alu_XOR32;
							nextSE_CTRL <= '0';
					when funcMULT =>
							nextALU_CTRL <= alu_MULT;
							nextSE_CTRL <= '1';
					when others => nextALU_CTRL <= alu_DEFAULT;
				END CASE;
			when ADDI | LW | SW | J | JAL | BNEZ | BEQZ =>
				nextALU_CTRL <= alu_ADD;
				nextSE_CTRL <= '1';
			when ADDUI =>
				nextALU_CTRL <= alu_ADDU;
				nextSE_CTRL <= '1';
			when ANDI =>
				nextALU_CTRL <= alu_AND16;
				nextSE_CTRL <= '0';
				--ALU_OP_SIZE <= '1';
			when ORI =>
				nextALU_CTRL <= alu_OR16;
				nextSE_CTRL <= '0';
				--ALU_OP_SIZE <= '1';
			when SGEI =>
				nextALU_CTRL <= alu_SGE;
				nextSE_CTRL <= '1';
			when SLEI =>
				nextALU_CTRL <= alu_SLE;
				nextSE_CTRL <= '1';
			when SGEUI =>
				nextALU_CTRL <= alu_SGEU;
				nextSE_CTRL <= '0';
			when SGTI =>
				nextALU_CTRL <= alu_SGT;
				nextSE_CTRL <= '1';
			when SLEUI =>
				nextALU_CTRL <= alu_SLEU;
				nextSE_CTRL <= '0';
			when SGTUI =>
				nextALU_CTRL <= alu_SGTU;
				nextSE_CTRL <= '0';
			when SLTUI =>
				nextALU_CTRL <= alu_SLTU;
				nextSE_CTRL <= '0';
			when SLTI =>
				nextALU_CTRL <= alu_SLT;
				nextSE_CTRL <= '1';
			when SLLI =>
				nextALU_CTRL <= alu_SLL;
				nextSE_CTRL <= '0';
			when SNEI =>
				nextALU_CTRL <= alu_SNE;
				nextSE_CTRL <= '1';
			when SEQI =>
				nextALU_CTRL <= alu_SEQ;
				nextSE_CTRL <= '1';
			when SRLI =>
				nextALU_CTRL <= alu_SRL;
				nextSE_CTRL <= '0';
			when SUBI =>
				nextALU_CTRL <= alu_SUB;
				nextSE_CTRL <= '1';
			when SUBUI =>
				nextALU_CTRL <= alu_SUBU;
				nextSE_CTRL <= '0';
			when SRAI =>
				nextALU_CTRL <= alu_SRA;
				nextSE_CTRL <= '0';
			when XORI =>
				nextALU_CTRL <= alu_XOR16;
				nextSE_CTRL <= '0';
			when LHI =>
				nextALU_CTRL <= alu_LHI;
				nextSE_CTRL <= '0';
			when others =>
				nextALU_CTRL <= alu_ADD;  -- default operation of store and load instructions
				nextSE_CTRL <= '1';
		 end case;
		end process;


end architecture;
