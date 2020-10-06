library ieee;
use ieee.std_logic_1164.all;
package alu_package is

	type ALU_OP_type is (	alu_DEFAULT, alu_ADD, alu_SUB, alu_AND16, alu_AND32,
							alu_OR16, alu_OR32, alu_SGE, alu_SLE, alu_SLEU,
							alu_SLL, alu_SNE, alu_SEQ, alu_SRL, alu_XOR16,
							alu_XOR32, alu_ADDU, alu_SGEU, alu_SGTU, alu_SGT,
							alu_SLT, alu_SLTU, alu_SRA, alu_SUBU, alu_MULT, alu_LHI);

	constant NBIT: integer:= 32;
	constant DEFAULT : std_logic_vector(3 downto 0) :=  "0000";

end alu_package;
