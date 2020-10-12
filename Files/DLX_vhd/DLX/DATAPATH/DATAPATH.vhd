library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_package.all;
use work.myTypes.all;

entity DATAPATH is
	port (	--CU
			CW_from_CU: in std_logic_vector(CW_SIZE-1 downto 0);
			aluCTRL_from_CU: in ALU_OP_type;
			--DRAM
			dram_addr: out std_logic_vector(BUS_WIDTH-1 downto 0);
			dram_size: out std_logic_vector(1 downto 0);
			dram_data_out: out std_logic_vector(BUS_WIDTH-1 downto 0);
			dram_data_in: in std_logic_vector(BUS_WIDTH- 1 downto 0);
			dram_rd, dram_wr, dram_en: out std_logic;
			--IRAM
			iram_addr: out std_logic_vector(BUS_WIDTH-1 downto 0);
			iram_in: in std_logic_vector(BUS_WIDTH-1 downto 0);
			OPCODE_to_CU 		: out  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
			FUNC_to_CU   		: out  std_logic_vector(FUNC_SIZE - 1 downto 0);
			Clk, Rst: in std_logic
		  );
end DATAPATH;

architecture Struct of DATAPATH is
	component register_generic is
		generic(NBIT:integer := BUS_WIDTH);
		Port (	D:	In	std_logic_vector(NBIT-1 downto 0);
				CK:	In	std_logic;
				RESET:	In	std_logic;
				EN: in std_logic;
				Q:	Out	std_logic_vector(NBIT-1 downto 0));
	end component;

	component register_file is
		generic (DATABIT: natural := BUS_WIDTH;
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

	component mux21_generic is
		generic (	NBIT: integer := BUS_WIDTH);
		Port (	in_1, in_0:	In	std_logic_vector(NBIT-1 downto 0);
				sel:	In	std_logic;
				y:	Out	std_logic_vector(NBIT-1 downto 0));
	end component mux21_generic;

	component ALU is
		port (	DATA1, DATA2: IN std_logic_vector(BUS_WIDTH-1 downto 0);
				SE_ctrl_in: in std_logic;
				ALU_OP: in ALU_OP_type;
				OUTALU: OUT std_logic_vector(BUS_WIDTH-1 downto 0));
	end component ALU;

	component P4_adder is
		generic ( NBIT : integer);
		port (
			A :		in	std_logic_vector(NBIT-1 downto 0);
			B :		in	std_logic_vector(NBIT-1 downto 0);
			Cin :	in	std_logic;
			S :		out	std_logic_vector(NBIT-1 downto 0);
			Cout :	out	std_logic);
	end component P4_adder;


	component immediate_ext is
		port ( 	SE_CTRL, ISJUMP: in std_logic;
				DataIn: in std_logic_vector(25 downto 0);
			   	Dataout: out std_logic_vector(BUS_WIDTH-1 downto 0)
			 );
	end component immediate_ext;

	component zero_detector is
		generic ( NBIT:	integer:= BUS_WIDTH );
		port (	A:	in std_logic_vector(NBIT-1 downto 0);
				Z:	out std_logic);
	end component zero_detector;

	component FD is
		Port (	D:	In	std_logic;
				CK:	In	std_logic;
				RESET:	In	std_logic;
				EN: in std_logic;
				Q:	Out	std_logic);
	end component FD;

	component FORWARDING_UNIT is
		port ( 	RS1, RS2, RD_EX, RD_MEM, RD_WB:IN std_logic_vector(4 downto 0);
				F_ALU_EX, F_ALU_MEM, F_ALU_WB: IN std_logic_vector(BUS_WIDTH-1 downto 0);
				WF_EX, WF_MEM, WF_WB: in std_logic;
				F_OUT_S1, F_OUT_S2: OUT std_logic_vector(BUS_WIDTH-1 downto 0);
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


	component dmemory_ext is
		port ( 	    SE_CTRL, MSIZE1, MSIZE0: in std_logic; 	--extend signed if SE_CTRL is 1
					DataIn: in std_logic_vector(BUS_WIDTH-1 downto 0);
				   	Dataout: out std_logic_vector(BUS_WIDTH-1 downto 0)
				 );
	end component;

	component BTB is
			port (	PC_from_fetch, PC_from_exe, target_to_save: in std_logic_vector(BUS_WIDTH-1 downto 0);
					ISBRANCH, branch_was_taken, clk, rst: in std_logic;
					predict_taken: out std_logic;
					target_out: out std_logic_vector(BUS_WIDTH-1 downto 0)
				);
	end component BTB;

	--*****SIGNALS*****

	--TO DECLARE:	OUT_REG_OUT
	signal CW_active: std_logic_vector(CW_SIZE-1 downto 0);
	signal RFOUT1, RFOUT2, S3_1_OUT, S3_2_OUT, S3_2_WB_OUT, A_OUT, B_OUT, S2_OUT, ALU_OUT, ALU_OUT_REG1, ALU_OUT_REG2, MEMORY_OUT, MEMORY_OUT_REG1, ME_OUT: std_logic_vector(BUS_WIDTH-1 downto 0);
	signal PC_OUT, NPC, IR_R_OUT, IMM32, IMM32_OUT, REL_ADDR, PC_IN, PC_IN_1, BJ_ADDR, NPC_REG1_OUT, NPC_REG2_OUT, NPC_REG3_OUT, NPC_REG4_OUT, mux_to_PC_2_to_1, mux_to_ir: std_logic_vector(BUS_WIDTH-1 downto 0);
 	-----------------BJ_ADDR_OUT
	signal IN1_OUT, MUX_FW1_OUT, MUX_FW2_OUT, FU_OUT_S1, FU_OUT_S2: std_logic_vector(BUS_WIDTH-1 downto 0);

	signal RF1, RF2, EN_DE, S1, S2, EN_EM, EN_W, ISJUMP, ISBRANCH, ISBEQZ, RM, WM, EN_MW, S3, WF1, SE_CTRL, SE_CTRL1, I0_R1_SEL, JAL_SEL, MSIZE1, MSIZE0, SE_CTRL2, ISJR: std_logic;
	signal ZERO_RESULT: std_logic;
	-----------signal ZERO_REG_OUT: std_logic;
	signal branch_taken, branch_taken1, branch_taken2, FU_CTRL1, FU_CTRL2, HDU_PC_EN, HDU_IR_EN, HDU_MUX_SEL, JAL_SEL_OUT1, JAL_SEL_OUT2, WF1_WB_REG_OUT: std_logic;

	signal RS1, RS2, RD, RD_OUT_REG1, RD_OUT_REG2, RD_OUT_REG3, RS1_R_OUT, RS2_R_OUT: std_logic_vector(4 downto 0);
	signal RD_RTYPE_OUT, RD_ITYPE_OUT, RD_type_mux_OUT: std_logic_vector(4 downto 0);

	signal aluCTRL: ALU_OP_type;
	signal aluCTRLint: integer;
	signal aluCTRLbits1, aluCTRLbits2: std_logic_vector(4 downto 0);

	constant CW_EX_SIZE: natural := 18;
	constant CW_M_SIZE: natural := 9;
	constant CW_WR_SIZE: natural := 3;
	signal CWregEX: std_logic_vector(CW_EX_SIZE-1 downto 0);
	signal CWregMW: std_logic_vector(CW_M_SIZE-1 downto 0);
	signal CWregWR: std_logic_vector(CW_WR_SIZE-1 downto 0);

	signal IMM26: std_logic_vector(25 downto 0);

	--BTB signal
	signal prediction_table, prediction_wrong,PREDICTION_OUT_REG1, PREDICTION_OUT_REG2: std_logic;
	signal target_table: std_logic_vector(BUS_WIDTH-1 downto 0);


begin
	--RF1,	RF2,	EN_DEC,	   I0_R1_SEL,	JAL_SEL, ISJR, SE_CTRL,		S2,		EN_EX,	ISJUMP,	ISBRANCH,	BEQZ,	RM,	WM,	MSIZE1,	MSIZE0,	SE_CTRL2,	EN_MEM,	S3,	WF1, EN_WB
	--***********  CONTROL SIGNALS  ***********
	-- FETCH STAGE

	--DECODE STAGE
			RF1 <= CW_active(CW_SIZE-1);
			RF2 <= CW_active(CW_SIZE-2);
			EN_DE <= CW_active(CW_SIZE-3) or WF1;
			SE_CTRL <= CW_active(CW_SIZE-7);
			aluCTRLbits1 <= std_logic_vector(to_unsigned(aluCTRLint, aluCTRLbits1'length));
			aluCTRLint <= ALU_OP_type'POS(aluCTRL_from_CU);
			aluCTRL <= ALU_OP_type'VAL(to_integer(unsigned(aluCTRLbits2)));
	--EXECUTE STAGE
			I0_R1_SEL  <= CWregEX(CW_EX_SIZE-1);
			JAL_SEL  <= CWregEX(CW_EX_SIZE-2);
			ISJR <= CWregEX(CW_EX_SIZE-3);
			--SE_CTRL <= CWregEX(10);
			----------------SE_CTRL <= CW_active(CW_SIZE-7);
			S2 <= CWregEX(CW_EX_SIZE-5);
			EN_EM <= CWregEX(CW_EX_SIZE-6);
			ISJUMP <= CWregEX(CW_EX_SIZE-7);
			ISBRANCH <= CWregEX(CW_EX_SIZE-8);
			ISBEQZ <= CWregEX(CW_EX_SIZE-9);
	--MEMORY STAGE
			RM <= CWregMW(CW_M_SIZE-1);
		 	WM <= CWregMW(CW_M_SIZE-2);
		 	MSIZE1 <= CWregMW(CW_M_SIZE-3);
		 	MSIZE0 <= CWregMW(CW_M_SIZE-4);
		 	SE_CTRL2 <= CWregMW(CW_M_SIZE-5);
			EN_MW <= CWregMW(CW_M_SIZE-6);
	--WRITEBACK STAGE
			S3 <= CWregWR(CW_WR_SIZE-1);
			WF1 <= CWregWR(CW_WR_SIZE-2);
			EN_W <= CWregWR(CW_WR_SIZE-3);
	--****************************************

	--***********     PIPELINE     ***********
	--FETCH
			mux_to_PC: MUX21_GENERIC port map(BJ_ADDR, mux_to_PC_2_to_1, ISJUMP, PC_IN);

			--PC_IN <= target_table when (prediction_table = '1' and prediction_wrong = '0') else
			--		 PC_IN_1;

			PC_reg: Register_generic port map(PC_IN, Clk, Rst, HDU_PC_EN, PC_OUT);

			iram_addr <= PC_OUT;

			--BTB
			branch_predict: BTB port map(PC_out, NPC_REG3_OUT, BJ_ADDR, ISBRANCH, branch_taken, Clk, Rst, prediction_table, target_table);
			--BTB

			adder_NPC: P4_adder generic map (BUS_WIDTH) port map(PC_OUT, X"00000004", '0',  NPC, open);
			NPC_reg1: Register_generic port map(NPC, Clk, Rst, '1', NPC_REG1_OUT);

			IR_reg: Register_generic port map(iram_in, Clk, Rst, HDU_IR_EN, IR_R_OUT);
			prediction_FETCH: fd port map(prediction_table, Clk, Rst, '1', PREDICTION_OUT_REG1);
	--DECODE
			OPCODE_to_CU <= IR_R_OUT(BUS_WIDTH-1 downto BUS_WIDTH-6);
			FUNC_to_CU <= IR_R_OUT(10 downto 0);

			RS1 <= IR_R_OUT(25 downto 21);
			RS2 <= IR_R_OUT(20 downto 16);
			RD_rtype: Register_generic generic map(5) port map (IR_R_OUT(15 downto 11), Clk, Rst, EN_DE, RD_RTYPE_OUT);
			RD_itype: Register_generic generic map(5) port map (IR_R_OUT(20 downto 16), Clk, Rst, EN_DE, RD_ITYPE_OUT);
			IMM26 <= IR_R_OUT(25 downto 0);

			hdu: HAZARD_DETECTION_UNIT port map(RS1, RS2, RS2_R_OUT, CWregEX(8), HDU_PC_EN, HDU_IR_EN, HDU_MUX_SEL);
			mux_cw_hdu: MUX21_GENERIC generic map(CW_SIZE) port map ("000000000000000000000", CW_from_CU, HDU_MUX_SEL, CW_active);

			RF: register_file port map (Clk, Rst, EN_DE, '1', '1', WF1, RD_OUT_REG2, RS1, RS2, S3_2_OUT, RFOUT1, RFOUT2);

			A: Register_generic port map (RFOUT1, Clk, Rst, EN_DE, A_OUT);
			B: Register_generic port map (RFOUT2, Clk, Rst, EN_DE, B_OUT);

			imm_sign_ext: immediate_ext port map(SE_CTRL, CW_active(CW_SIZE-5), IMM26, IMM32);

			--pipeline registers
			EX_M_WB_cw_reg: Register_generic generic map(CW_EX_SIZE) port map(CW_active(CW_EX_SIZE-1 downto 0), Clk, branch_taken1, '1', CWregEX);
			rs1_r: Register_generic generic map(5) port map(RS1, Clk, Rst, '1', RS1_R_OUT);
			rs2_r: Register_generic generic map(5) port map(RS2, Clk, Rst, '1', RS2_R_OUT);
			IMM32_reg: Register_generic port map (IMM32, Clk, Rst, EN_DE, IMM32_OUT);
			aluCTRL_reg: Register_generic generic map(aluCTRLbits1'length) port map(aluCTRLbits1, Clk, branch_taken, EN_DE, aluCTRLbits2 );
			NPC_reg2: Register_generic port map(NPC_REG1_OUT, Clk, Rst, EN_DE, NPC_REG2_OUT);
			SE_CTRL_EX: fd port map(SE_CTRL, Clk, Rst, EN_DE, SE_CTRL1);
			prediction_DEC: fd port map(PREDICTION_OUT_REG1, Clk, Rst, '1', PREDICTION_OUT_REG2);

	--EXECUTE
			FU: FORWARDING_UNIT port map (RS1_R_OUT, RS2_R_OUT, RD_OUT_REG1, RD_OUT_REG2, RD_OUT_REG3, ALU_OUT_REG1, S3_2_OUT, S3_2_WB_OUT, CWregMW(0), WF1, WF1_WB_reg_OUT, FU_OUT_S1, FU_OUT_S2, FU_CTRL1, FU_CTRL2, Clk, Rst);

			adder_REL_ADDR: P4_adder generic map (BUS_WIDTH) port map(NPC_REG2_OUT, IMM32_OUT, '0', REL_ADDR, open);
			addr_to_jump: MUX21_GENERIC port map(MUX_FW1_OUT, REL_ADDR, ISJR, BJ_ADDR);
			op1_is_zero: zero_detector port map(MUX_FW1_OUT, ZERO_RESULT);

			--BRANCH LOGIC
			branch_taken <= (ISBRANCH and ZERO_RESULT) when ( ISBEQZ = '1') else
						 	(ISBRANCH and (not ZERO_RESULT)) when ( ISBEQZ = '0') else
						 	'0';
			branch_taken2 <= branch_taken or Rst or ISJUMP;

			mux_to_PC_2: MUX21_GENERIC port map(BJ_ADDR, NPC, branch_taken, mux_to_PC_2_to_1);
			--BRANCH LOGIC

			--BTB CHECKING
			prediction_wrong <= branch_taken xor PREDICTION_OUT_REG2;

			--mux_to_PC_2_to_1 <= BJ_ADDR when (prediction_wrong='1' and branch_taken='1') else
			--					NPC_REG2_OUT when (prediction_wrong='1' and branch_taken='0') else
			--					NPC;
			--BTB CHECKING

			mux_fw1: MUX21_GENERIC port map ( FU_OUT_S1, A_OUT, FU_CTRL1, MUX_FW1_OUT);

			mux_fw2: MUX21_GENERIC port map ( FU_OUT_S2, B_OUT, FU_CTRL2, MUX_FW2_OUT);
			mux_s2: MUX21_GENERIC port map (MUX_FW2_OUT, IMM32_OUT, S2, S2_OUT);

			alu_block: ALU port map (MUX_FW1_OUT, S2_OUT, SE_CTRL1, aluCTRL, ALU_OUT);

			RD_type_mux: MUX21_GENERIC generic map(5) port map (RD_RTYPE_OUT, RD_ITYPE_OUT, I0_R1_SEL, RD_type_mux_OUT);
			mux_jal:  MUX21_GENERIC generic map(5) port map ("11111", RD_type_mux_OUT, JAL_SEL, RD);

			--pipeline registers
			M_WB_cw_reg: Register_generic generic map(CW_M_SIZE) port map(CWregEX(CW_M_SIZE-1 downto 0), Clk, Rst, '1', CWregMW);
			---------------zero_fd: fd port map(ZERO_RESULT, Clk, Rst, EN_EM, ZERO_REG_OUT);
			-----------------BJ_ADDR_reg: Register_generic port map(BJ_ADDR, Clk, Rst, EN_EM, BJ_ADDR_OUT);
			alu_reg1: Register_generic port map (ALU_OUT, Clk, Rst, EN_EM, ALU_OUT_REG1);
			me: Register_generic port map (MUX_FW2_OUT, Clk, Rst, EN_EM, ME_OUT);
			RD_reg1: Register_generic generic map(5) port map (RD, Clk, Rst, EN_EM, RD_OUT_REG1);
			JAL_SEL_fd1: fd port map(JAL_SEL, Clk, Rst, EN_EM, JAL_SEL_OUT1);
			NPC_reg3: Register_generic port map(NPC_REG2_OUT, Clk, Rst, EN_EM, NPC_REG3_OUT);

			Rst_with_branch_taken2: fd port map(branch_taken2, Clk, Rst,'1', branch_taken1);

	--MEMORY

			dram_en <= EN_MW;
			dram_rd <= RM;
			dram_wr <= WM;
			dram_addr <= ALU_OUT_REG1;
			dram_size <= MSIZE1 & MSIZE0;
			dram_data_out <= ME_OUT;

			--sign extension
			dram_sign_ext: dmemory_ext port map(SE_CTRL2, MSIZE1, MSIZE0, dram_data_in, MEMORY_OUT);

			--pipeline registers
			WB_cw_reg: Register_generic generic map(CW_WR_SIZE) port map(CWregMW(CW_WR_SIZE-1 downto 0), Clk, Rst, EN_MW, CWregWR);
			mem_reg: Register_generic port map (MEMORY_OUT, Clk, Rst, EN_MW, MEMORY_OUT_REG1);
			alu_reg2: Register_generic port map (ALU_OUT_REG1, Clk, Rst, EN_MW, ALU_OUT_REG2);
			RD_reg2: Register_generic generic map(5) port map (RD_OUT_REG1, Clk, Rst, EN_MW, RD_OUT_REG2);
			JAL_SEL_fd2: fd port map(JAL_SEL_OUT1, Clk, Rst, EN_MW, JAL_SEL_OUT2);
			NPC_reg4: Register_generic port map(NPC_REG3_OUT, Clk, Rst, EN_MW, NPC_REG4_OUT);

	--WRITEBACK
			mux_s3_1: MUX21_GENERIC port map (MEMORY_OUT_REG1, ALU_OUT_REG2, S3, S3_1_OUT);
			mux_s3_2: MUX21_GENERIC port map (NPC_REG4_OUT, S3_1_OUT, JAL_SEL_OUT2, S3_2_OUT);

			--pipeline registers
			WF1_WB_reg: fd port map(WF1, Clk, Rst, EN_W, WF1_WB_reg_OUT);
			RD_reg3: Register_generic generic map(5) port map (RD_OUT_REG2, Clk, Rst, EN_W, RD_OUT_REG3);
			WB_OUT_REG: Register_generic port map (S3_2_OUT, Clk, Rst, EN_W, S3_2_WB_OUT);

end Struct;
