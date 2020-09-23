library ieee;
use ieee.std_logic_1164.all;
package alu_type is
	type ALU_TYPE_OP is (alu_DEFAULT, alu_ADD, alu_SUB, alu_AND16, alu_AND32, alu_OR16, alu_OR32, alu_SGE, alu_SLE, alu_SLL, alu_SNE, alu_SEQ, alu_SRL, alu_XOR16, alu_XOR32);
	constant DEFAULT : std_logic_vector(3 downto 0) :=  "0000";
end alu_type;
