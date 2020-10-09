library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity TB_ADD_SUB_COMP_BLOCK is
end TB_ADD_SUB_COMP_BLOCK;

architecture TEST of TB_ADD_SUB_COMP_BLOCK is

	-- P4 component declaration
	component ADD_SUB_COMP_BLOCK is
		generic ( NBIT:	integer);
		port (	A :		in	std_logic_vector(NBIT-1 downto 0);
				B :		in	std_logic_vector(NBIT-1 downto 0);
				SUB, SIGN :	in	std_logic;
				RES :	out	std_logic_vector(NBIT-1 downto 0);
				Cout, e, ne, lt, le, gt, ge:	out	std_logic);
	end component;

	signal DATA1,DATA2,RES :std_logic_vector(BUS_WIDTH-1 downto 0);
	signal SUB, Cout, e, ne, lt, le, gt, ge, SE_ctrl_in :std_logic;

begin
	dut: ADD_SUB_COMP_BLOCK generic map(BUS_WIDTH) port map(DATA1, DATA2, SUB, SE_ctrl_in, RES, Cout, e, ne, lt, le, gt, ge);

	process
	begin
		--COMPARATOR OP
		SUB <= '1';
		--TRUE
		DATA1 <= X"00000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		--TYPE_OP <= alu_SNE;
		wait for 1 ns;
		DATA1 <= X"00000003";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		--TYPE_OP <= alu_SEQ;
		wait for 1 ns;
		DATA1 <= X"70000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		--TYPE_OP <= alu_SGE;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		--TYPE_OP <= alu_SGEU;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		--TYPE_OP <= alu_SLE;
		wait for 1 ns;
		DATA1 <= X"00000001";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		--TYPE_OP <= alu_SLEU;
		wait for 1 ns;
		DATA1 <= X"80000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		--TYPE_OP <= alu_SGT;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		--TYPE_OP <= alu_SGTU;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		--TYPE_OP <= alu_SLT;
		wait for 1 ns;
		DATA1 <= X"00000001";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		--TYPE_OP <= alu_SLTU;
		wait for 1 ns;
		--FALSE
		DATA1 <= X"00000003";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		--TYPE_OP <= alu_SNE;
		wait for 1 ns;
		DATA1 <= X"00000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		--TYPE_OP <= alu_SEQ;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		--TYPE_OP <= alu_SGE;
		wait for 1 ns;
		DATA1 <= X"00000002";
		DATA2 <= X"F0000000";
		SE_ctrl_in <= '0';
		--TYPE_OP <= alu_SGEU;
		wait for 1 ns;
		DATA1 <= X"70000000";
		DATA2 <= X"F0000003";
		SE_ctrl_in <= '1';
		--TYPE_OP <= alu_SLE;
		wait for 1 ns;
		DATA1 <= X"00000004";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		--TYPE_OP <= alu_SLEU;
		wait for 1 ns;
		DATA1 <= X"00000003";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		--TYPE_OP <= alu_SGT;
		wait for 1 ns;
		DATA1 <= X"00000003";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		--TYPE_OP <= alu_SGTU;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"F0000000";
		SE_ctrl_in <= '1';
		--TYPE_OP <= alu_SLT;
		wait for 1 ns;
		DATA1 <= X"00000003";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		--TYPE_OP <= alu_SLTU;
		wait;
	end process;

end TEST;

