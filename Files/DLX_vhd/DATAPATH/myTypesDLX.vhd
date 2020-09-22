library ieee;
use ieee.std_logic_1164.all;

package myTypes is
	constant MICROCODE_MEM_DEPTH: integer := 64;
	constant MICROCODE_MEM_SIZE: integer := 15;
	constant CW_SIZE: integer := 16;
	-- Control unit input sizes
	constant OP_CODE_SIZE : integer :=  6;                                              -- OPCODE field size
	constant FUNC_SIZE    : integer :=  11;                                             -- FUNC field size

	-- R-Type instruction -> FUNC field
	constant funcADD : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100000";    -- ADD RS1,RS2,RD
	constant funcSUB : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100010";    -- SUB RS1,RS2,RD
	constant funcAND : std_logic_vector(FUNC_SIZE - 1 downto 0) := "00000100100";
	constant funcOR : std_logic_vector(FUNC_SIZE - 1 downto 0) := "00000100101";
	constant funcSGE : std_logic_vector(FUNC_SIZE - 1 downto 0) :=   "00000101101";
	constant funcSLE : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101100";
	constant funcSLL : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000100";		--CHANGED MSB!!!!!!!!!!!!!!!!!
	constant funcSNE : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101001";
	constant funcSRL : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000110";
	constant funcXOR : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100110";

	--constant DEFAULT : std_logic_vector(3 downto 0) :=  "0000";
	constant DEFAULT_OP : std_logic_vector(FUNC_SIZE-1 downto 0) :=  "00000000000";

	-- R-Type instruction -> OPCODE field
	constant RTYPE : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000000";          -- for ADD, SUB, AND, OR register-to-register operation

	-- I-Type instruction -> OPCODE field
	constant ADDI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "001000";
	constant ANDI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "001100";
	constant LW : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "100011";
	constant ORI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "001101";
	constant SGEI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "011101";
	constant SLEI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "011100";
	constant SLLI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010100";
	constant SNEI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011001";
	constant SRLI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010110";
	constant SUBI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001010";
	constant SW : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "101011";
	constant XORI : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001110";
	-- J-Type instruction -> OPCODE field
	constant J : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "000010";
	constant JAL : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "000011";
	-- Branch instructions
	constant BEQZ : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "000100";
	constant BNEZ : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "000101";

	constant NOP : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "010101";

	--ALU OPERATION
end myTypes;

