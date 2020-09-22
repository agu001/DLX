library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.myTypes.all;
use WORK.alu_type.all;

	entity CONTROL_UNIT is
		port (
				-- FETCH STAGE OUTPUTS

				-- DECODE STAGE OUTPUTS
				RF1    		: out std_logic;               -- enables the read port 1 of the register file
				RF2    		: out std_logic;               -- enables the read port 2 of the register file
				EN1    		: out std_logic;               -- enables the register file and the pipeline registers

				--EXECUTE STAGE OUTPUTS
				I0_R1_SEL	: out std_logic;               --selection bit of RD multiplexer			NEW!!
				JAL_SEL		: out std_logic;               --selection bit of RD/R31 multiplexer		NEW!!
				S2 	    	: out std_logic;               --selection bit of second alu input multiplexer
				SE_CTRL		: out std_logic;
				ALU_CTRL	: out ALU_TYPE_OP;
				EN2  	  	: out std_logic;               -- enables the pipe registers

				-- MEMORY STAGE OUTPUTS
				ISJUMP		: out std_logic;			   --
				ISBRANCH	: out std_logic;			   --
				ISBEQZ   	: out std_logic;			   --
				RM     		: out std_logic;               -- enables the read-out of the memory
				WM     		: out std_logic;               -- enables the write-in of the memory
				EN3    		: out std_logic;               -- enables the memory and the pipeline registers
				S3     		: out std_logic;               -- input selection of the multiplexer

				-- WRITEBACK STAGE OUTPUTS
				WF1    		: out std_logic;               -- enables the write port of the register file

				-- INPUTS
				OPCODE 		: in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
				FUNC   		: in  std_logic_vector(FUNC_SIZE - 1 downto 0);
				Clk 		: in std_logic;
				Rst 		: in std_logic);
    end entity;

architecture beh of CONTROL_UNIT is
	type mem_array is array (integer range 0 to MICROCODE_MEM_DEPTH - 1) of std_logic_vector(MICROCODE_MEM_SIZE - 1 downto 0);
  							--RF1,	RF2,	EN1,	I0_R1_SEL,	JAL_SEL,	nextSE_CTRL,	S2,		EN2,	ISJUMP,	ISBRANCH,	BEQZ,	RM,	WM,	EN3,	S3,	WF1
							--0,	1,  	2,		3,			4,			5,				6,		7,		8,		9,			10,		11,	12,	13, 	14,	15
	signal cw_mem : mem_array := (  "111101100000101",--RTYPE	0
									"000000000000000",
									"101000110000000",--J		2
									"101010110000101",--JAL		3
									"101000101100100",--BEQZ	4
									"101000101000100",--BNEZ	5
									"000000000000000",
									"000000000000000",
									"101000100000101",--ADDI	8
									"000000000000000",
									"101000100000101",--SUBI	10
									"000000000000000",
									"101000100000101",--ANDI	12
									"101000100000101",--ORI		13
									"101000100000101",--XORI	14
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"101000100000101",--SLLI	20
									"001000100000100",--NOP		21
									"101000100000101",--SRLI	22
									"000000000000000",
									"000000000000000",
									"101000100000101",--SNEI	25
									"000000000000000",
									"000000000000000",
									"101000100000101",--SLEI	28
									"101000100000101",--SGEI	29
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"101000100010111",--LW		35
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"111000100001100",--SW		43
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000"
									);

	signal cw_from_mem: std_logic_vector(MICROCODE_MEM_SIZE-1 downto 0);
	signal outCW: std_logic_vector(CW_SIZE-1 downto 0);

  	signal nextALU_CTRL : ALU_TYPE_OP;
  	signal nextSE_CTRL : std_logic;

begin
		--RF1,	RF2,	EN1,	I0_R1_SEL,	JAL_SEL,	nextSE_CTRL,	S2,		EN2,	ISJUMP,	ISBRANCH,	BEQZ,	RM,	WM,	EN3,	S3,	WF1
		--0,	1,  	2,		3,			4,			5,			6,		7,		8,		9,			10,		11,	12,	13, 	14,	15

	  	cw_from_mem <= cw_mem( to_integer( unsigned(OPCODE) ) ) when (OPCODE /= "100000" ) else
			  "000000000000000";
		-- FETCH STAGE OUTPUTS

		-- DECODE STAGE OUTPUTS
		RF1    		<= outCW(CW_SIZE -1);
		RF2    		<= outCW(CW_SIZE -2);
		EN1    		<= outCW(CW_SIZE -3);
		--EXECUTE STAGE OUTPUTS
		I0_R1_SEL	<= outCW(CW_SIZE -4);
		JAL_SEL		<= outCW(CW_SIZE -5);
		SE_CTRL		<= outCW(CW_SIZE -6);
		S2			<= outCW(CW_SIZE -7);
		EN2    		<= outCW(CW_SIZE -8);
		-- MEMORY STAGE OUTPUTS
		ISJUMP		<= outCW(CW_SIZE -9);
		ISBRANCH	<= outCW(CW_SIZE -10);
		ISBEQZ   	<= outCW(CW_SIZE -11);
		RM     		<= outCW(CW_SIZE -12);
		WM     		<= outCW(CW_SIZE -13);
		EN3    		<= outCW(CW_SIZE -14);
		S3     		<= outCW(CW_SIZE -15);
		-- WRITEBACK STAGE OUTPUTS
		WF1    		<= outCW(CW_SIZE -16);

		-- process to pipeline control words
		CW_PIPE: process (Clk, Rst)
			begin  -- process Clk
				if Rst = '1' then                   -- asynchronous reset (active low)
					outCW <= (others => '0');
					ALU_CTRL <= alu_DEFAULT;
				elsif Clk'event and Clk = '0' then  -- falling clock edge
					outCW <= cw_from_mem(MICROCODE_MEM_SIZE-1 downto MICROCODE_MEM_SIZE-5) & nextSE_CTRL & cw_from_mem(MICROCODE_MEM_SIZE-6 downto 0);
					ALU_CTRL <= nextALU_CTRL;
				end if;
		end process CW_PIPE;

		ALU_SE_CTRL : process (OPCODE, FUNC)
		begin  -- process ALU_OP_CODE_P
		case OPCODE is
			--ALU_OP_SIZE <= '0';				--0if 32bit operation, 16bit otherwise
			when RTYPE =>
				CASE FUNC IS
					when funcADD =>
							nextALU_CTRL <= alu_ADD;
							nextSE_CTRL <= '1';
					when funcSUB =>
							nextALU_CTRL <= alu_SUB;
							nextSE_CTRL <= '1';
					when funcAND =>
							nextALU_CTRL <= alu_AND32;
							nextSE_CTRL <= '0';
					when funcOR  =>
							nextALU_CTRL <= alu_OR32;
							nextSE_CTRL <= '0';
					when funcSGE =>
							nextALU_CTRL <= alu_SGE;
							nextSE_CTRL <= '1';
					when funcSLE =>
							nextALU_CTRL <= alu_SLE;
							nextSE_CTRL <= '1';
					when funcSLL =>
							nextALU_CTRL <= alu_SLL;
							nextSE_CTRL <= '0';
					when funcSNE =>
							nextALU_CTRL <= alu_SNE;
							nextSE_CTRL <= '1';
					when funcSRL =>
							nextALU_CTRL <= alu_SRL;
							nextSE_CTRL <= '0';
					when funcXOR =>
							nextALU_CTRL <= alu_XOR32;
							nextSE_CTRL <= '0';
					when others => nextALU_CTRL <= alu_DEFAULT;
				END CASE;
			when ADDI | LW | SW | J | JAL | BNEZ | BEQZ =>
				nextALU_CTRL <= alu_ADD;
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
			when SLLI =>
				nextALU_CTRL <= alu_SLL;
				nextSE_CTRL <= '0';
			when SNEI =>
				nextALU_CTRL <= alu_SNE;
				nextSE_CTRL <= '1';
			when SRLI =>
				nextALU_CTRL <= alu_SRL;
				nextSE_CTRL <= '0';
			when SUBI =>
				nextALU_CTRL <= alu_SUB;
				nextSE_CTRL <= '1';
			when XORI =>
				nextALU_CTRL <= alu_XOR16;
				nextSE_CTRL <= '0';
			when others =>
				nextALU_CTRL <= alu_DEFAULT;
				nextSE_CTRL <= '0';
		 end case;
		end process;



end architecture;
