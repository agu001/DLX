library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.alu_package.all;
use WORK.myTypes.all;

entity TB is
end TB;

architecture TestBench of TB is

		component ALU is
			port (	DATA1, DATA2: IN std_logic_vector(BUS_WIDTH-1 downto 0);
					SE_ctrl_in: in std_logic;
					ALU_OP: in ALU_OP_type;
					OUTALU: OUT std_logic_vector(BUS_WIDTH-1 downto 0));
		end component ALU;

		signal DATA1, DATA2: std_logic_vector(BUS_WIDTH-1 downto 0);
		signal SE_ctrl_in: std_logic;
	    signal ALU_OP: ALU_OP_type;
		signal OUTALU: std_logic_vector(BUS_WIDTH-1 downto 0);

begin

	DUT: ALU port map(DATA1, DATA2, SE_ctrl_in, ALU_OP, OUTALU);

	process
	begin
		--ADD, SUB
		DATA1 <= X"FFFFFFFF";
		DATA2 <= X"00000001";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_ADD;
		wait for 1 ns;
		DATA2 <= X"FFFFFFFF";
		DATA1 <= X"00000001";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SUB;
		wait for 1 ns;
		DATA1 <= X"FFFFFFFF";
		DATA2 <= X"00000001";
		SE_ctrl_in <= '0';
		ALU_OP <= alu_SUBU;
		wait for 1 ns;
		--MULT
		DATA1 <= X"0000000F";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_MULT;
		wait for 1 ns;
		DATA1 <= X"0000000F";
		DATA2 <= X"FFFFFF00";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_MULT;
		wait for 1 ns;
		--ALL SHIFT OP
		DATA1 <= X"0000000F";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		ALU_OP <= alu_SLL;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SRA;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		ALU_OP <= alu_SRL;
		wait for 1 ns;
		--COMPARATOR OP
		--TRUE
		DATA1 <= X"00000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SNE;
		wait for 1 ns;
		DATA1 <= X"00000003";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SEQ;
		wait for 1 ns;
		DATA1 <= X"70000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SGE;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		ALU_OP <= alu_SGEU;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SLE;
		wait for 1 ns;
		DATA1 <= X"00000001";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		ALU_OP <= alu_SLEU;
		wait for 1 ns;
		DATA1 <= X"80000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SGT;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		ALU_OP <= alu_SGTU;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SLT;
		wait for 1 ns;
		DATA1 <= X"00000001";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		ALU_OP <= alu_SLTU;
		wait for 1 ns;
		--FALSE
		DATA1 <= X"00000003";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SNE;
		wait for 1 ns;
		DATA1 <= X"00000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SEQ;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SGE;
		wait for 1 ns;
		DATA1 <= X"00000002";
		DATA2 <= X"F0000000";
		SE_ctrl_in <= '0';
		ALU_OP <= alu_SGEU;
		wait for 1 ns;
		DATA1 <= X"70000000";
		DATA2 <= X"F0000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SLE;
		wait for 1 ns;
		DATA1 <= X"00000004";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		ALU_OP <= alu_SLEU;
		wait for 1 ns;
		DATA1 <= X"00000003";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SGT;
		wait for 1 ns;
		DATA1 <= X"00000003";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		ALU_OP <= alu_SGTU;
		wait for 1 ns;
		DATA1 <= X"F0000000";
		DATA2 <= X"F0000000";
		SE_ctrl_in <= '1';
		ALU_OP <= alu_SLT;
		wait for 1 ns;
		DATA1 <= X"00000003";
		DATA2 <= X"00000003";
		SE_ctrl_in <= '0';
		ALU_OP <= alu_SLTU;
		wait for 1 ns;
		DATA1 <= X"F0F0F0F0";
		DATA2 <= X"F00FF00F";
		SE_ctrl_in <= '0';
		--32
		ALU_OP <= alu_XOR;--xor
		wait for 1 ns;
		ALU_OP <= alu_OR;--or
		wait for 1 ns;
		ALU_OP <= alu_AND;--and
		wait for 1 ns;
		wait;
	end process;

end TestBench;
