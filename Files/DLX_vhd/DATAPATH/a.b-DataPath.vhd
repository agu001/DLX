library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_type.all;
use work.myTypes.all;

entity DATAPATH is
	generic ( D_SIZE: natural := 32;
			  IRAM_DEPTH: natural := 8;
			  I_SIZE: natural := 32;
			  DRAM_DEPTH: natural := 32
			);
	port (	--CU
			CW_from_CU: in std_logic_vector(CW_SIZE-1 downto 0);
			aluCTRL_from_CU: in alu_type_op;
			--DRAM
			dram_addr: out std_logic_vector(DRAM_DEPTH-1 downto 0);
			dram_data_out: out std_logic_vector(D_SIZE-1 downto 0);
			dram_data_in: in std_logic_vector(D_SIZE- 1 downto 0);
			dram_rd, dram_wr, dram_en: out std_logic;
			--IRAM
			iram_addr: out std_logic_vector(I_SIZE-1 downto 0);
			iram_in: in std_logic_vector(I_SIZE-1 downto 0);
			OPCODE_to_CU 		: out  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
			FUNC_to_CU   		: out  std_logic_vector(FUNC_SIZE - 1 downto 0);
			Clk, Rst: in std_logic
		  );
end DATAPATH;

architecture Struct of DATAPATH is
	component Register_generic is
		generic(NBIT:integer := D_SIZE);
		Port (	D:	In	std_logic_vector(NBIT-1 downto 0);
				CK:	In	std_logic;
				RESET:	In	std_logic;
				EN: in std_logic;
				Q:	Out	std_logic_vector(NBIT-1 downto 0));
	end component;

	component register_file is
		generic (DATABIT: natural := D_SIZE;
			  	ADDBIT: natural := 5);
		port	(CLK: 		IN std_logic;
				 RESET: 	IN std_logic;
				 ENABLE: 	IN std_logic;
				 RD1: 		IN std_logic;
				 RD2: 		IN std_logic;
				 WR: 		IN std_logic;
				 ADD_WR: 	IN std_logic_vector(ADDBIT-1 downto 0);
				 ADD_RD1: 	IN std_logic_vector(ADDBIT-1 downto 0);
				 ADD_RD2: 	IN std_logic_vector(ADDBIT-1 downto 0);
				 DATAIN: 	IN std_logic_vector(DATABIT-1 downto 0);
				 OUT1: 		OUT std_logic_vector(DATABIT-1 downto 0);
				 OUT2: 		OUT std_logic_vector(DATABIT-1 downto 0));
	end component register_file;

	component MUX21_GENERIC is
		generic(NBIT: integer := D_SIZE;
			   DELAY_MUX: time := 0.2 ns);
		Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
			B:	In	std_logic_vector(NBIT-1 downto 0);
			SEL:	In	std_logic;
			Y:	Out	std_logic_vector(NBIT-1 downto 0));
	end component MUX21_GENERIC;

	component ALU is
		generic (N : integer := 32);
		port	(	TYPE_OP: IN ALU_TYPE_OP;
					DATA1, DATA2: IN std_logic_vector(N-1 downto 0);
					OUTALU: OUT std_logic_vector(N-1 downto 0));
	end component ALU;

	component adder is
		port (A, B: in std_logic_vector(31 downto 0);
				 X: out std_logic_vector(31 downto 0)
			 );
	end component adder;

	component sign_ext is
		port ( 	SE_CTRL, ISJUMP: in std_logic;
				DataIn: in std_logic_vector(25 downto 0);
			   	Dataout: out std_logic_vector(31 downto 0)
			 );
	end component;

	component comparator is
		generic ( SIZE: natural := 32 );
		port ( R1: in std_logic_vector(SIZE-1 downto 0);
			ISZERO: out std_logic );
	end component comparator;

	component FD is
		Port (	D:	In	std_logic;
				CK:	In	std_logic;
				RESET:	In	std_logic;
				EN: in std_logic;
				Q:	Out	std_logic);
	end component FD;

	component FORWARDING_UNIT is
		port ( 	RS1, RS2, RD_EX, RD_MEM, RD_WB:IN std_logic_vector(4 downto 0);
				F_ALU_EX, F_ALU_MEM, F_ALU_WB: IN std_logic_vector(31 downto 0);
				WF_EX, WF_MEM, WF_WB: in std_logic;
				F_OUT_S1, F_OUT_S2: OUT std_logic_vector(31 downto 0);
				MUX1_SEL, MUX2_SEL: OUT std_logic;
				CLK, RST: IN std_logic
			 );
	end component;

	component HAZARD_DETECTION_UNIT is
		port ( RS1_DEC, RS2_DEC, RD_EX: in std_logic_vector(4 downto 0);
			   MEMRD_EX: in std_logic;
			   PC_EN, IR_EN, MUX_SEL: out std_logic
			 );
	end component HAZARD_DETECTION_UNIT;

	--*****SIGNALS*****

	--TO DECLARE:	OUT_REG_OUT
	signal CW_active: std_logic_vector(CW_SIZE-1 downto 0);
	signal RFOUT1, RFOUT2, S3_1_OUT, S3_2_OUT, S3_2_WB_OUT, A_OUT, B_OUT, S2_OUT, ALU_OUT, ALU_OUT_REG1, ALU_OUT_REG2, MEMORY_OUT, MEMORY_OUT_REG1, ME_OUT: std_logic_vector(D_SIZE-1 downto 0);
	signal PC_OUT, NPC, IR_R_OUT, IMM32, IMM32_OUT, REL_ADDR, PC_IN, REL_ADDR_OUT, NPC_REG1_OUT, NPC_REG2_OUT, NPC_REG3_OUT, NPC_REG4_OUT, mux_to_PC_2_to_1, mux_to_ir: std_logic_vector(D_SIZE-1 downto 0);
	signal IN1_OUT, MUX_FW1_OUT, MUX_FW2_OUT, FU_OUT_S1, FU_OUT_S2: std_logic_vector(D_SIZE-1 downto 0);

	signal RF1, RF2, EN1, S1, S2, EN2, ISJUMP, ISBRANCH, ISBEQZ, RM, WM, EN3, S3, WF1, SE_CTRL, I0_R1_SEL, JAL_SEL: std_logic;
	signal ZERO_RESULT, ZERO_REG_OUT: std_logic;
	signal branch_taken, branch_taken1, FU_CTRL1, FU_CTRL2, HDU_PC_EN, HDU_IR_EN, HDU_MUX_SEL, JAL_SEL_OUT1, JAL_SEL_OUT2, WF_WB_REG_OUT: std_logic;

	signal RS1, RS2, RD, RD_OUT_REG1, RD_OUT_REG2, RD_OUT_REG3, RS1_R_OUT, RS2_R_OUT: std_logic_vector(4 downto 0);
	signal RD_RTYPE_OUT, RD_ITYPE_OUT, RD_type_mux_OUT: std_logic_vector(4 downto 0);

	signal aluCTRL: ALU_TYPE_OP;
	signal aluCTRLint: integer;
	signal aluCTRLbits1, aluCTRLbits2: std_logic_vector(3 downto 0);

	signal CWregEX: std_logic_vector(12 downto 0);
	signal CWregMW: std_logic_vector(7 downto 0);
	signal CWregWR: std_logic_vector(1 downto 0);

	signal IMM26: std_logic_vector(25 downto 0);

begin

	--***********  CONTROL SIGNALS  ***********
	-- FETCH STAGE

	--DECODE STAGE
			RF1 <= CW_active(CW_SIZE-1);
			RF2 <= CW_active(CW_SIZE-2);
			EN1 <= CW_active(CW_SIZE-3) or WF1;
			aluCTRLbits1 <= std_logic_vector(to_unsigned(aluCTRLint, aluCTRLbits1'length));
			aluCTRLint <= ALU_TYPE_OP'POS(aluCTRL_from_CU);
			aluCTRL <= ALU_TYPE_OP'VAL(to_integer(unsigned(aluCTRLbits2)));
	--EXECUTE STAGE
			I0_R1_SEL  <= CWregEX(12);
			JAL_SEL  <= CWregEX(11);
			--SE_CTRL <= CWregEX(10);
			SE_CTRL <= CW_active(CW_SIZE-6);
			S2 <= CWregEX(9);
			EN2 <= CWregEX(8);
	--MEMORY STAGE
			ISJUMP <= CWregMW(7);
			ISBRANCH <= CWregMW(6);
			ISBEQZ <= CWregMW(5);
			RM <= CWregMW(4);
		 	WM <= CWregMW(3);
			EN3 <= CWregMW(2);
	--WRITEBACK STAGE
			S3 <= CWregWR(1);
			WF1 <= CWregWR(0);
	--****************************************

	--***********     PIPELINE     ***********
	--FETCH
			mux_to_PC: MUX21_GENERIC port map(REL_ADDR_OUT, mux_to_PC_2_to_1, ISJUMP, PC_IN);
			PC_reg: Register_generic port map(PC_IN, Clk, Rst, HDU_PC_EN, PC_OUT);
			iram_addr <= PC_OUT;

			adder_PC: adder port map(PC_OUT, X"00000004", NPC);
			NPC_reg1: Register_generic port map(NPC, Clk, Rst, '1', NPC_REG1_OUT);

			ir_mux_nop_iram: MUX21_GENERIC generic map(32) port map (X"54000000", iram_in, branch_taken1, mux_to_IR);

			IR_reg: Register_generic port map(mux_to_IR, Clk, Rst, HDU_IR_EN, IR_R_OUT);

	--DECODE
			OPCODE_to_CU <= IR_R_OUT(I_SIZE-1 downto I_SIZE-6);
			FUNC_to_CU <= IR_R_OUT(10 downto 0);

			RS1 <= IR_R_OUT(25 downto 21);
			RS2 <= IR_R_OUT(20 downto 16);
			RD_rtype: Register_generic generic map(5) port map (IR_R_OUT(15 downto 11), Clk, Rst, EN1, RD_RTYPE_OUT);
			RD_itype: Register_generic generic map(5) port map (IR_R_OUT(20 downto 16), Clk, Rst, EN1, RD_ITYPE_OUT);
			IMM26 <= IR_R_OUT(25 downto 0);

			hdu: HAZARD_DETECTION_UNIT port map(RS1, RS2, RS2_R_OUT, CWregEX(4), HDU_PC_EN, HDU_IR_EN, HDU_MUX_SEL);
			mux_control: MUX21_GENERIC generic map(CW_SIZE) port map (X"0000", CW_from_CU, HDU_MUX_SEL, CW_active);

			rs1_r: Register_generic generic map(5) port map(RS1, Clk, Rst, '1', RS1_R_OUT);
			rs2_r: Register_generic generic map(5) port map(RS2, Clk, Rst, '1', RS2_R_OUT);

			RF: register_file port map (Clk, Rst, EN1, '1', '1', WF1, RD_OUT_REG2, RS1, RS2, S3_2_OUT, RFOUT1, RFOUT2);

			A: Register_generic port map (RFOUT1, Clk, Rst, EN1, A_OUT);
			B: Register_generic port map (RFOUT2, Clk, Rst, EN1, B_OUT);

			sext: sign_ext port map(SE_CTRL, CW_active(CW_SIZE-5), IMM26, IMM32);

			--pipeline registers
			EX_M_WB_reg: Register_generic generic map(13) port map(CW_active(12 downto 0), Clk, branch_taken1, '1', CWregEX);
			IMM32_reg: Register_generic port map (IMM32, Clk, Rst, EN1, IMM32_OUT);
			aluCTRL_reg: Register_generic generic map(aluCTRLbits1'length) port map(aluCTRLbits1, Clk, branch_taken, '1',aluCTRLbits2 );
			NPC_reg2: Register_generic port map(NPC_REG1_OUT, Clk, Rst, EN1, NPC_REG2_OUT);

	--EXECUTE
			FU: FORWARDING_UNIT port map (RS1_R_OUT, RS2_R_OUT, RD_OUT_REG1, RD_OUT_REG2, RD_OUT_REG3, ALU_OUT_REG1, S3_2_OUT, S3_2_WB_OUT, CWregMW(0), WF1, WF_WB_REG_OUT, FU_OUT_S1, FU_OUT_S2, FU_CTRL1, FU_CTRL2, Clk, Rst);

			adder_NPC: adder port map(NPC_REG2_OUT, IMM32_OUT, REL_ADDR);
			compare: comparator port map(MUX_FW1_OUT, ZERO_RESULT);

			mux_fw1: MUX21_GENERIC port map ( FU_OUT_S1, A_OUT, FU_CTRL1, MUX_FW1_OUT);

			mux_fw2: MUX21_GENERIC port map ( FU_OUT_S2, B_OUT, FU_CTRL2, MUX_FW2_OUT);
			mux_s2: MUX21_GENERIC port map (MUX_FW2_OUT, IMM32_OUT, S2, S2_OUT);

			alu_op: ALU port map (aluCTRL, MUX_FW1_OUT, S2_OUT, ALU_OUT);

			RD_type_mux: MUX21_GENERIC generic map(5) port map (RD_RTYPE_OUT, RD_ITYPE_OUT, I0_R1_SEL, RD_type_mux_OUT);
			mux_jal:  MUX21_GENERIC generic map(5) port map ("11111", RD_type_mux_OUT, JAL_SEL, RD);

			--pipeline registers
			M_WB_reg: Register_generic generic map(8) port map(CWregEX(7 downto 0), Clk, Rst, '1', CWregMW);
			zero_reg: fd port map(ZERO_RESULT, Clk, Rst, '1', ZERO_REG_OUT);
			REL_ADDR_reg: Register_generic port map(REL_ADDR, Clk, Rst, '1', REL_ADDR_OUT);
			alu_reg1: Register_generic port map (ALU_OUT, Clk, Rst, EN2, ALU_OUT_REG1);
			me: Register_generic port map (MUX_FW2_OUT, Clk, Rst, EN2, ME_OUT);
			RD_reg1: Register_generic generic map(5) port map (RD, Clk, Rst, EN2, RD_OUT_REG1);
			JAL_SEL_fd1: fd port map(JAL_SEL, Clk, Rst, '1', JAL_SEL_OUT1);
			NPC_reg3: Register_generic port map(NPC_REG2_OUT, Clk, Rst, '1', NPC_REG3_OUT);

	--MEMORY
			branch_taken <= (ISBRANCH and ZERO_REG_OUT) when ( ISBEQZ = '1') else
						 	(ISBRANCH and (not ZERO_REG_OUT)) when ( ISBEQZ = '0') else
						 	'0';
			branch_taken1 <= branch_taken or Rst or ISJUMP;

			mux_to_PC_2: MUX21_GENERIC port map(REL_ADDR_OUT, NPC, branch_taken, mux_to_PC_2_to_1);

			dram_en <= EN3;
			dram_rd <= RM;
			dram_wr <= WM;
			dram_addr <= ALU_OUT_REG1;
			dram_data_out <= ME_OUT;
			MEMORY_OUT <= dram_data_in;

			--pipeline registers
			WB_reg: Register_generic generic map(2) port map(CWregMW(1 downto 0), Clk, Rst, '1', CWregWR);
			mem_reg: Register_generic port map (MEMORY_OUT, Clk, Rst, EN3, MEMORY_OUT_REG1);
			alu_reg2: Register_generic port map (ALU_OUT_REG1, Clk, Rst, EN3, ALU_OUT_REG2);
			RD_reg2: Register_generic generic map(5) port map (RD_OUT_REG1, Clk, Rst, EN3, RD_OUT_REG2);
			JAL_SEL_fd2: fd port map(JAL_SEL_OUT1, Clk, Rst, '1', JAL_SEL_OUT2);
			NPC_reg4: Register_generic port map(NPC_REG3_OUT, Clk, Rst, '1', NPC_REG4_OUT);

	--WRITEBACK
			mux_s3_1: MUX21_GENERIC port map (MEMORY_OUT_REG1, ALU_OUT_REG2, S3, S3_1_OUT);
			mux_s3_2: MUX21_GENERIC port map (NPC_REG4_OUT, S3_1_OUT, JAL_SEL_OUT2, S3_2_OUT);

			--pipeline registers
			WF_WB_REG: fd port map(WF1, Clk, Rst, '1', WF_WB_REG_OUT);
			RD_reg3: Register_generic generic map(5) port map (RD_OUT_REG2, Clk, Rst, '1', RD_OUT_REG3);
			WB_OUT_REG: Register_generic port map (S3_2_OUT, Clk, Rst, '1', S3_2_WB_OUT);

end Struct;
