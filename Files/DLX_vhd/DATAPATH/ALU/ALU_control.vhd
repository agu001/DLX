library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.alu_package.all;

entity ALU_control is
	port (  ALU_OP: in ALU_OP_type;
			SE_ctrl: in std_logic;
			conf, ctrl_mux_out: out std_logic_vector(1 downto 0);
			comparator_ctrl, logic_op: out std_logic_vector(2 downto 0);
			ctrl_16, adder_comp_sel, SUB: out std_logic);
end ALU_control;

architecture BEHAVIOR of ALU_control is

	signal l_r: std_logic;

begin

	conf <= SE_ctrl & l_r;

	P_ALU: process (ALU_OP)
	-- complete all the requested functions
	begin
		l_r <= '0';
		ctrl_mux_out <= "00";
		comparator_ctrl <= "000";
		logic_op <= "100"; --logic_op(2) -> AND, logic_op(1) -> OR, logic_op(0) -> XOR
		ctrl_16 <= '0';
		adder_comp_sel <= '0';
		SUB <= '0';
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
			when alu_AND16	=>
				ctrl_16 <= '1';
				ctrl_mux_out <= "10";
				logic_op <= "100";
			when alu_AND32	=>
				ctrl_16 <= '0';
				ctrl_mux_out <= "10";
				logic_op <= "100";
			when alu_OR16	=>
				ctrl_16 <= '1';
				ctrl_mux_out <= "10";
				logic_op <= "010";
			when alu_OR32	=>
				ctrl_16 <= '0';
				ctrl_mux_out <= "10";
				logic_op <= "010";
			when alu_XOR16	=>
				ctrl_16 <= '1';
				ctrl_mux_out <= "10";
				logic_op <= "001";
			when alu_XOR32	=>
				ctrl_16 <= '0';
				ctrl_mux_out <= "10";
				logic_op <= "001";
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
			when alu_SLL 	=>
				l_r <= '1';
				ctrl_mux_out <= "00";
			when alu_SRA | alu_SRL	=>
				l_r <= '0';
				ctrl_mux_out <= "00";
		end case;
	end process P_ALU;

end BEHAVIOR;
