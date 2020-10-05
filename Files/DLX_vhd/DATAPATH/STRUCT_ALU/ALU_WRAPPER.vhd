library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.alu_type.all;

	entity ALU is
		generic (N : integer := 32);
		port (	DATA1, DATA2: IN std_logic_vector(N-1 downto 0);
				SE_ctrl_in: in std_logic;
				TYPE_OP: in ALU_TYPE_OP;
				OUTALU: OUT std_logic_vector(N-1 downto 0));
	end ALU;

architecture Struct of ALU is

	component ALU_controller is
		port (	TYPE_OP: in ALU_TYPE_OP;
				SE_ctrl: in std_logic;
				conf, ctrl_mux_out: out std_logic_vector(1 downto 0);
				comparator_ctrl, logic_op: out std_logic_vector(2 downto 0);
				ctrl_16, adder_comp_sel, SUB: out std_logic);
	end component ALU_controller;

	component ALU_IN is
		port (	conf, ctrl_mux_out: in std_logic_vector(1 downto 0);
				comparator_ctrl, logic_op: in std_logic_vector(2 downto 0);
				ctrl_16, adder_comp_sel, SUB: in std_logic;
				DATA1, DATA2: IN std_logic_vector(N-1 downto 0);
				OUTALU: OUT std_logic_vector(N-1 downto 0));
	end component ALU_IN;

	signal conf_s, ctrl_mux_out_s: std_logic_vector(1 downto 0);
	signal comparator_ctrl, logic_op_s: std_logic_vector(2 downto 0);
	signal ctrl_16, adder_comp_sel_s, SUB: std_logic;

begin

	ALU_controller_instance: ALU_controller port map(TYPE_OP, SE_ctrl_in, conf_s, ctrl_mux_out_s, comparator_ctrl, logic_op_s, ctrl_16, adder_comp_sel_s, SUB);
	ALU: ALU_IN port map(conf_s, ctrl_mux_out_s, comparator_ctrl, logic_op_s, ctrl_16, adder_comp_sel_s, SUB, DATA1, DATA2, OUTALU);

end Struct;
