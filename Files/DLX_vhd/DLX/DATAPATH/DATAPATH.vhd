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

	component NPC_LOGIC is
		generic( NBIT:integer := BUS_WIDTH );
		port( BJ_ADDR, NPC_BRANCH, NPC, BTB_ADDRESS: in std_logic_vector(NBIT-1 downto 0);
			  ISJUMP, B_TAKEN, P_WRONG, B_PREDICT: in std_logic;
			  PC_ADDRESS: out std_logic_vector(NBIT-1 downto 0)
			);
	end component NPC_LOGIC;

	component branch_result is
		port( isbranch, zero_result, isbeqz: in std_logic;
			  branch_taken: out std_logic
			);
	end component branch_result;

	component OR2 is
		port(	A, B: 	in std_logic;
				C:		out std_logic
			);
	end component OR2;

	component XOR2 is
		port(	A, B: 	in std_logic;
				C:		out std_logic
			);
	end component XOR2;

	--*****SIGNALS*****

	signal CW_active: std_logic_vector(CW_SIZE-1 downto 0);
	signal RFOUT1, RFOUT2, MEM_ALU_SEL_WB, DATA_WRITE_WB_to_RF, DATA_WRITE_to_FU, A_OUT, B_OUT, S2_OUT, ALU_OUT_EX, ALU_OUT_MEM, ALU_OUT_WB: std_logic_vector(BUS_WIDTH-1 downto 0);
	signal PC_OUT, NPC, IR_DEC, IMM32, IMM32_OUT, REL_ADDR, PC_IN, PC_IN_1, BJ_ADDR, NPC_DEC, NPC_EX, NPC_MEM, NPC_WB, mux_to_PC_2_to_1, mux_to_ir: std_logic_vector(BUS_WIDTH-1 downto 0);
	signal IN1_OUT, MUX_FW1_OUT, MUX_FW2_OUT, FU_OUT_S1, FU_OUT_S2, MEMORY_OUT, MEMORY_OUT_WB, DATA_WRITE_TO_MEM: std_logic_vector(BUS_WIDTH-1 downto 0);

	signal RF1, RF2, EN_DEC, S1, S2, EN_EX, EN_WB, ISJUMP, ISBRANCH, ISBEQZ, RM, WM, EN_MEM, S3, WF1, SE_CTRL, SE_CTRL_EX, I0_R1_SEL, JAL_SEL, MSIZE1, MSIZE0, SE_CTRL2, ISJR: std_logic;
	signal branch_taken, branch_taken1, FLUSH, FU_CTRL1, FU_CTRL2, HDU_PC_EN, HDU_IR_EN, HDU_MUX_SEL, JAL_MEM, JAL_WB, WF1_to_FU, ZERO_RESULT: std_logic;

	signal RS1, RS2, RD_EX, RD_MEM, RD_WB, RD_to_FU, RS1_EX, RS2_EX: std_logic_vector(4 downto 0);
	signal RD_RTYPE_DEC, RD_ITYPE_DEC, RD_SEL_EX: std_logic_vector(4 downto 0);

	signal aluCTRL: ALU_OP_type;
	signal aluCTRLint: integer;
	signal aluCTRLbits1, aluCTRLbits2: std_logic_vector(4 downto 0);

	signal CW_EX, CW_EX_1: std_logic_vector(CW_EX_SIZE-1 downto 0);
	signal CW_MEM: std_logic_vector(CW_MEM_SIZE-1 downto 0);
	signal CW_WB: std_logic_vector(CW_WB_SIZE-1 downto 0);

	signal IMM26: std_logic_vector(25 downto 0);

	--BTB signal
	signal BIT_PREDICTION, prediction_wrong,BIT_PRED_DEC, BIT_PRED_EXE: std_logic;
	signal BTB_ADDRESS, IR_IN: std_logic_vector(BUS_WIDTH-1 downto 0);

begin
	--RF1, RF2,	EN_DEC, I0_R1_SEL, JAL_SEL, ISJR, SE_CTRL, S2, EN_EX, ISJUMP, ISBRANCH,	BEQZ, RM, WM, MSIZE1, MSIZE0, SE_CTRL2,	EN_MEM,	S3,	WF1, EN_WB
	--***********  CONTROL SIGNALS  ***********
	-- FETCH STAGE

	--DECODE STAGE
			RF1 <= CW_active(CW_SIZE-1);
			RF2 <= CW_active(CW_SIZE-2);
			EN_DEC <= CW_active(CW_SIZE-3) or WF1;
			SE_CTRL <= CW_active(CW_SIZE-7);
			aluCTRLbits1 <= std_logic_vector(to_unsigned(aluCTRLint, aluCTRLbits1'length));
			aluCTRLint <= ALU_OP_type'POS(aluCTRL_from_CU);
			aluCTRL <= ALU_OP_type'VAL(to_integer(unsigned(aluCTRLbits2)));
	--EXECUTE STAGE
			I0_R1_SEL  <= CW_EX(CW_EX_SIZE-1);
			JAL_SEL  <= CW_EX(CW_EX_SIZE-2);
			ISJR <= CW_EX(CW_EX_SIZE-3);
			S2 <= CW_EX(CW_EX_SIZE-5);
			EN_EX <= CW_EX(CW_EX_SIZE-6);
			ISJUMP <= CW_EX(CW_EX_SIZE-7);
			ISBRANCH <= CW_EX(CW_EX_SIZE-8);
			ISBEQZ <= CW_EX(CW_EX_SIZE-9);
	--MEMORY STAGE
			RM <= CW_MEM(CW_MEM_SIZE-1);
		 	WM <= CW_MEM(CW_MEM_SIZE-2);
		 	MSIZE1 <= CW_MEM(CW_MEM_SIZE-3);
		 	MSIZE0 <= CW_MEM(CW_MEM_SIZE-4);
		 	SE_CTRL2 <= CW_MEM(CW_MEM_SIZE-5);
			EN_MEM <= CW_MEM(CW_MEM_SIZE-6);
	--WRITEBACK STAGE
			S3 <= CW_WB(CW_WB_SIZE-1);
			WF1 <= CW_WB(CW_WB_SIZE-2);
			EN_WB <= CW_WB(CW_WB_SIZE-3);
	--****************************************

	--***********     PIPELINE     ***********
	--FETCH
			--Computed new PC
			npc_sel: NPC_LOGIC port map(BJ_ADDR, NPC_EX, NPC, BTB_ADDRESS, ISJUMP, branch_taken, prediction_wrong, BIT_PREDICTION, PC_IN);
			PC_reg: Register_generic port map(PC_IN, Clk, Rst, HDU_PC_EN, PC_OUT);
			iram_addr <= PC_OUT;
			--Branch Target Buffer
			branch_predict: BTB port map(PC_OUT, NPC_MEM, BJ_ADDR, ISBRANCH, branch_taken, Clk, Rst, BIT_PREDICTION, BTB_ADDRESS);
			--Compute NPC given a defined PC
			adder_NPC: P4_adder generic map (BUS_WIDTH) port map(PC_OUT, X"00000004", '0',  NPC, open);
			--In case of loading a NOP instruction
			mux_ir_fetch: MUX21_GENERIC generic map(BUS_WIDTH) port map (NOP_instruction, iram_in, FLUSH, IR_IN);

			--pipeline registers
			IR_reg: Register_generic port map(IR_IN, Clk, Rst, HDU_IR_EN, IR_DEC);
			NPC_reg1: Register_generic port map(NPC, Clk, Rst, '1', NPC_DEC);
			prediction_FETCH: fd port map(BIT_PREDICTION, Clk, Rst, '1', BIT_PRED_DEC);

	--DECODE
			OPCODE_to_CU <= IR_DEC(BUS_WIDTH-1 downto BUS_WIDTH-6);
			FUNC_to_CU <= IR_DEC(10 downto 0);
			RS1 <= IR_DEC(25 downto 21);
			RS2 <= IR_DEC(20 downto 16);
			RD_rtype: Register_generic generic map(5) port map (IR_DEC(15 downto 11), Clk, Rst, EN_DEC, RD_RTYPE_DEC);
			RD_itype: Register_generic generic map(5) port map (IR_DEC(20 downto 16), Clk, Rst, EN_DEC, RD_ITYPE_DEC);
			IMM26 <= IR_DEC(25 downto 0);
			--For stalling due to RAW hazard
			hdu: HAZARD_DETECTION_UNIT port map(RS1, RS2, RS2_EX, CW_EX(8), HDU_PC_EN, HDU_IR_EN, HDU_MUX_SEL);
			mux_cw_hdu: MUX21_GENERIC generic map(CW_SIZE) port map (ZERO_CW_SIZE, CW_from_CU, HDU_MUX_SEL, CW_active);
			--Register file
			RF: register_file port map (Clk, Rst, EN_DEC, '1', '1', WF1, RD_WB, RS1, RS2, DATA_WRITE_WB_to_RF, RFOUT1, RFOUT2);

			A: Register_generic port map (RFOUT1, Clk, Rst, EN_DEC, A_OUT);
			B: Register_generic port map (RFOUT2, Clk, Rst, EN_DEC, B_OUT);
			imm_sign_ext: immediate_ext port map(SE_CTRL, CW_active(CW_SIZE-5), IMM26, IMM32);
			--Flush new EX stage
			mux_CW_EX: MUX21_GENERIC generic map(CW_EX_SIZE) port map (ZERO_CW_EX_SIZE, CW_active(CW_EX_SIZE-1 downto 0), FLUSH, CW_EX_1);

			--pipeline registers
			EX_M_WB_cw_reg: Register_generic generic map(CW_EX_SIZE) port map(CW_EX_1, Clk, Rst, '1', CW_EX);

			rs1_r: Register_generic generic map(5) port map(RS1, Clk, Rst, EN_DEC, RS1_EX);
			rs2_r: Register_generic generic map(5) port map(RS2, Clk, Rst, EN_DEC, RS2_EX);
			IMM32_reg: Register_generic port map (IMM32, Clk, Rst, EN_DEC, IMM32_OUT);
			aluCTRL_reg: Register_generic generic map(aluCTRLbits1'length) port map(aluCTRLbits1, Clk, Rst, EN_DEC, aluCTRLbits2 );
			NPC_reg2: Register_generic port map(NPC_DEC, Clk, Rst, EN_DEC, NPC_EX);
			SE_CTRL_EXE: fd port map(SE_CTRL, Clk, Rst, EN_DEC, SE_CTRL_EX);
			prediction_DEC: fd port map(BIT_PRED_DEC, Clk, Rst, EN_DEC, BIT_PRED_EXE);

	--EXECUTE
			FU: FORWARDING_UNIT
			          port map (RS1_EX, RS2_EX, RD_MEM, RD_WB, RD_to_FU, ALU_OUT_MEM, DATA_WRITE_WB_to_RF, DATA_WRITE_to_FU, CW_MEM(0), WF1, WF1_to_FU, FU_OUT_S1, FU_OUT_S2, FU_CTRL1, FU_CTRL2, Clk, Rst);

			adder_REL_ADDR: P4_adder generic map (BUS_WIDTH) port map(NPC_EX, IMM32_OUT, '0', REL_ADDR, open);
			addr_to_jump: MUX21_GENERIC port map(MUX_FW1_OUT, REL_ADDR, ISJR, BJ_ADDR);
			op1_is_zero: zero_detector port map(MUX_FW1_OUT, ZERO_RESULT);

			--BRANCH LOGIC
			branch_evaluation: branch_result port map(ISBRANCH, ZERO_RESULT, ISBEQZ, branch_taken);


			--BTB CHECKING
			xor_logic: XOR2 port map(branch_taken, BIT_PRED_EXE, prediction_wrong);
			or_logic: OR2 port map(prediction_wrong, ISJUMP, FLUSH);

			mux_fw1: MUX21_GENERIC port map ( FU_OUT_S1, A_OUT, FU_CTRL1, MUX_FW1_OUT);
			mux_fw2: MUX21_GENERIC port map ( FU_OUT_S2, B_OUT, FU_CTRL2, MUX_FW2_OUT);
			mux_s2: MUX21_GENERIC port map (MUX_FW2_OUT, IMM32_OUT, S2, S2_OUT);

			alu_block: ALU port map (MUX_FW1_OUT, S2_OUT, SE_CTRL_EX, aluCTRL, ALU_OUT_EX);

			RD_type_mux: MUX21_GENERIC generic map(5) port map (RD_RTYPE_DEC, RD_ITYPE_DEC, I0_R1_SEL, RD_SEL_EX);
			mux_jal:  MUX21_GENERIC generic map(5) port map (RD31, RD_SEL_EX, JAL_SEL, RD_EX);

			--pipeline registers
			M_WB_cw_reg: Register_generic generic map(CW_MEM_SIZE) port map(CW_EX(CW_MEM_SIZE-1 downto 0), Clk, Rst, '1', CW_MEM);

			alu_reg1: Register_generic port map (ALU_OUT_EX, Clk, Rst, EN_EX, ALU_OUT_MEM);
			me: Register_generic port map (MUX_FW2_OUT, Clk, Rst, EN_EX, DATA_WRITE_TO_MEM);
			RD_reg1: Register_generic generic map(5) port map (RD_EX, Clk, Rst, EN_EX, RD_MEM);
			JAL_SEL_fd1: fd port map(JAL_SEL, Clk, Rst, EN_EX, JAL_MEM);
			NPC_reg3: Register_generic port map(NPC_EX, Clk, Rst, EN_EX, NPC_MEM);

	--MEMORY
			dram_en <= EN_MEM;
			dram_rd <= RM;
			dram_wr <= WM;
			dram_addr <= ALU_OUT_MEM;
			dram_size <= MSIZE1 & MSIZE0;
			dram_data_out <= DATA_WRITE_TO_MEM;

			--sign extension
			dram_sign_ext: dmemory_ext port map(SE_CTRL2, MSIZE1, MSIZE0, dram_data_in, MEMORY_OUT);

			--pipeline registers
			WB_cw_reg: Register_generic generic map(CW_WB_SIZE) port map(CW_MEM(CW_WB_SIZE-1 downto 0), Clk, Rst, '1', CW_WB);

			mem_reg: Register_generic port map (MEMORY_OUT, Clk, Rst, EN_MEM, MEMORY_OUT_WB);
			alu_reg2: Register_generic port map (ALU_OUT_MEM, Clk, Rst, EN_MEM, ALU_OUT_WB);
			RD_reg2: Register_generic generic map(5) port map (RD_MEM, Clk, Rst, EN_MEM, RD_WB);
			JAL_SEL_fd2: fd port map(JAL_MEM, Clk, Rst, EN_MEM, JAL_WB);
			NPC_reg4: Register_generic port map(NPC_MEM, Clk, Rst, EN_MEM, NPC_WB);

	--WRITEBACK
			mux_s3_1: MUX21_GENERIC port map (MEMORY_OUT_WB, ALU_OUT_WB, S3, MEM_ALU_SEL_WB);
			mux_s3_2: MUX21_GENERIC port map (NPC_WB, MEM_ALU_SEL_WB, JAL_WB, DATA_WRITE_WB_to_RF);

			--pipeline registers
			WF1_WB_reg: fd port map(WF1, Clk, Rst, EN_WB, WF1_to_FU);
			RD_reg3: Register_generic generic map(5) port map (RD_WB, Clk, Rst, EN_WB, RD_to_FU);
			WB_OUT_REG: Register_generic port map (DATA_WRITE_WB_to_RF, Clk, Rst, EN_WB, DATA_WRITE_to_FU);

end Struct;
