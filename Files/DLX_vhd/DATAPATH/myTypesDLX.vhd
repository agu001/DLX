library ieee;
use ieee.std_logic_1164.all;

package myTypes is
	constant CW_SIZE: integer := 13;
	-- Control unit input sizes
	constant OP_CODE_SIZE : integer :=  6;                                              -- OPCODE field size
	constant FUNC_SIZE    : integer :=  6;                                             -- FUNC field size

	-- R-Type instruction -> FUNC field
	constant opADD : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "000100";    -- ADD RS1,RS2,RD
	constant opSUB : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "100010";    -- SUB RS1,RS2,RD
	constant opAND : std_logic_vector(FUNC_SIZE - 1 downto 0) := "100100";
	constant opOR : std_logic_vector(FUNC_SIZE - 1 downto 0) := "100101";
	constant opSGE : std_logic_vector(FUNC_SIZE - 1 downto 0) :=   "101101";
	constant opSLE : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "101100";
	constant opSLL : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "000100";
	constant opSNE : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "101001";
	constant opSRL : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "000110";
	constant opXOR : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "100110";

	constant DEFAULT : std_logic_vector(1 downto 0) :=  "00";
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
end myTypes;

