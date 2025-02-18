library ieee;
use ieee.std_logic_1164.all;

package myTypes is
	constant I_SIZE: integer:= 32;
	constant MICROCODE_MEM_DEPTH: integer := 64;
	constant MICROCODE_MEM_SIZE: integer := 20;
	constant CW_SIZE: integer := 21;
	-- Control unit input sizes
	constant OP_CODE_SIZE : integer :=  6;                                              -- OPCODE field size
	constant FUNC_SIZE    : integer :=  11;                                             -- FUNC field size

	-- R-Type instruction -> FUNC field
	constant funcADD : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100000";    -- ADD RS1,RS2,RD
	constant funcSUB : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100010";    -- SUB RS1,RS2,RD
	constant funcSUBU : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100011";
	constant funcAND : std_logic_vector(FUNC_SIZE - 1 downto 0) := "00000100100";
	constant funcOR : std_logic_vector(FUNC_SIZE - 1 downto 0) := "00000100101";
	constant funcSGE : std_logic_vector(FUNC_SIZE - 1 downto 0) :=   "00000101101";
	constant funcSGEU : std_logic_vector(FUNC_SIZE - 1 downto 0) :=   "00000111101";
	constant funcSLE : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101100";
	constant funcSLEU : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000111100";
	constant funcSLT : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101010";
	constant funcSLTU : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000111010";
	constant funcSLL : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000100";
	constant funcSNE : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101001";
	constant funcSEQ : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101000";
	constant funcSRL : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000110";
	constant funcSRA : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000111";
	constant funcSGT : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101011";
	constant funcSGTU : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000111011";
	constant funcXOR : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100110";
	constant funcADDU : std_logic_vector(FUNC_SIZE - 1 downto 0) := "00000100001";
	constant funcMULT : std_logic_vector(FUNC_SIZE - 1 downto 0) := "00000001110";

	--constant DEFAULT : std_logic_vector(3 downto 0) :=  "0000";
	constant DEFAULT_OP : std_logic_vector(FUNC_SIZE-1 downto 0) :=  "00000000000";

	-- R-Type instruction -> OPCODE field
	constant RTYPE : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000000";          -- for ADD, SUB, AND, OR register-to-register operation

	-- I-Type instruction -> OPCODE field
	constant ADDI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "001000";
	constant ANDI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "001100";
	constant LW : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "100011";
	constant LH : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "100001";
	constant LB : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "100000";
	constant LBU : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "100100";
	constant ORI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "001101";
	constant LHI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "001111";
	constant LHU : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "100101";
	constant SGEI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "011101";
	constant SGTI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "011011";
	constant SGTUI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "111011";
	constant SGEUI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "111101";
	constant SLEI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "011100";
	constant SLEUI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "111100";
	constant SLTI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "011010";
	constant SLTUI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "111010";
	constant SLLI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010100";
	constant SEQI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011000";
	constant SNEI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011001";
	constant SRLI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010110";
	constant SRAI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010111";
	constant SUBI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001010";
	constant SUBUI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001011";
	constant SW : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "101011";
	constant SH : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "101001";
	constant SB : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "101000";
	constant XORI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001110";
	constant ADDUI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001001";
	-- J-Type instruction -> OPCODE field
	constant J : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "000010";
	constant JAL : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "000011";
	constant JALR : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "010011";
	constant JR : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "010010";
	-- Branch instructions
	constant BEQZ : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "000100";
	constant BNEZ : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "000101";

	constant NOP : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "010101";

	--ALU OPERATION
end myTypes;

