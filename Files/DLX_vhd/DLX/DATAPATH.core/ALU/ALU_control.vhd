library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.alu_package.all;
use work.myTypes.all;

entity ALU_control is
	port (  ALU_OP: in ALU_OP_type;
			SE_ctrl: in std_logic;
			conf, ctrl_mux_out: out std_logic_vector(1 downto 0);
			comparator_ctrl, logic_op: out std_logic_vector(2 downto 0);
			adder_comp_sel, SUB, shift_16: out std_logic);
end ALU_control;

architecture BEHAVIOR of ALU_control is

	signal l_r: std_logic;

begin

	conf <= SE_ctrl & l_r;

	P_ALU: process (ALU_OP)
	-- complete all the requested functions
	begin
		l_r <= '0';	-- 1 shift left, 0 shift right
		shift_16 <= '0'; --used for lhi instruction
		ctrl_mux_out <= "00"; --used for selecting the alu output
		comparator_ctrl <= "000"; --used for selecting the desired bit computed by the comparator
		logic_op <= "000"; --001 for AND, 111 for OR, 110 for XOR
		adder_comp_sel <= '0'; --1 adder output, 0 comparator output
		SUB <= '0';--1 used to compute sub operation, 0 for addition
		case ALU_OP is
			when alu_DEFAULT	=>
			when alu_ADD | alu_ADDU	=>
				adder_comp_sel <= '1';
				SUB <= '0';
				ctrl_mux_out <= "01";
			when alu_SUB | alu_SUBU	=>
				adder_comp_sel <= '1';
				SUB <= '1';
				ctrl_mux_out <= "01";
			when alu_MULT	=>
				ctrl_mux_out <= "11";
			when alu_AND	=>
				ctrl_mux_out <= "10";
				logic_op <= "001";
			when alu_OR	=>
				ctrl_mux_out <= "10";
				logic_op <= "111";
			when alu_XOR	=>
				ctrl_mux_out <= "10";
				logic_op <= "110";
			when alu_SGE | alu_SGEU	=>
				comparator_ctrl <= "101";
				adder_comp_sel <= '0';
				SUB <= '1';
				ctrl_mux_out <= "01";
			when alu_SLE | alu_SLEU	=>
				comparator_ctrl <= "011";
				adder_comp_sel <= '0';
				SUB <= '1';
				ctrl_mux_out <= "01";
			when alu_SGT | alu_SGTU	=>
				comparator_ctrl <= "100";
				adder_comp_sel <= '0';
				SUB <= '1';
				ctrl_mux_out <= "01";
			when alu_SLT | alu_SLTU	=>
				comparator_ctrl <= "010";
				adder_comp_sel <= '0';
				SUB <= '1';
				ctrl_mux_out <= "01";
			when alu_SEQ	=>
				comparator_ctrl <= "000";
				adder_comp_sel <= '0';
				SUB <= '1';
				ctrl_mux_out <= "01";
			when alu_SNE	=>
				comparator_ctrl <= "001";
				adder_comp_sel <= '0';
				SUB <= '1';
				ctrl_mux_out <= "01";
			when alu_SLL	=>
				l_r <= '1';
				ctrl_mux_out <= "00";
			when alu_LHI	=>
				l_r <= '1';
				shift_16 <= '1';
				ctrl_mux_out <= "00";
			when alu_SRA | alu_SRL	=>
				l_r <= '0';
				ctrl_mux_out <= "00";
		end case;
	end process P_ALU;

end BEHAVIOR;
