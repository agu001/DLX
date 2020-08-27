library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_type.all;

entity DATAPATH is
	generic ( CONTROL: natural := 15;
			  D_SIZE: natural := 32;
			  IRAM_DEPTH: natural := 8;
			  I_SIZE: natural := 32;
			  DRAM_DEPTH: natural := 32
			);
	port (	controls: in std_logic_vector(CONTROL-1 downto 0);
			--DRAM
			dram_out: out std_logic_vector(D_SIZE-1 downto 0);
			dram_addr: out std_logic_vector(DRAM_DEPTH-1 downto 0);
			dram_in: in std_logic_vector(D_SIZE- 1 downto 0);
			RD_MEM, WR_MEM, EN_MEM: out std_logic;
			--IRAM
			--iram_out: out std_logic_vector(I_SIZE-1 downto 0);
			iram_addr: out std_logic_vector(I_SIZE-1 downto 0);
			iram_in: in std_logic_vector(I_SIZE-1 downto 0);
			--INP1, INP2: in std_logic_vector(D_SIZE-1 downto 0);
			--RS1, RS2, RD: in std_logic_vector(4 downto 0);			
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
	 port ( CLK: 		IN std_logic;
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
	  generic (N : integer := D_SIZE);
	  port 	 ( FUNC: IN TYPE_OP;
		       DATA1, DATA2: IN std_logic_vector(N-1 downto 0);
		       OUTALU: OUT std_logic_vector(N-1 downto 0));
	end component ALU;

	component adder is
		port (A, B: in std_logic_vector(31 downto 0);
				 X: out std_logic_vector(31 downto 0)
			 );
	end component adder;
	
	component sign_ext is
		port ( DataIn: in std_logic_vector(15 downto 0);
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
				Q:	Out	std_logic);
	end component FD;

	--signal INP1, INP2: std_logic_vector(D_SIZE-1 downto 0);
	--signal RS1, RS2, RD: std_logic_vector(4 downto 0);
	--REGISTER_FILE
	signal RFOUT1, RFOUT2, S3_OUT, A_OUT, B_OUT, S1_OUT, S2_OUT, ALU_OP_OUT, ALU_OUT_REG, MEMORY_OUT, ME_OUT, OUT_REG_OUT, INP1_R_OUT, INP2_R_OUT: std_logic_vector(D_SIZE-1 downto 0);
	signal IN1_OUT, IMM32_OUT: std_logic_vector(D_SIZE-1 downto 0);
	signal RF1, RF2, EN1, S1, S2, ALU1, ALU2, EN2, RM, WM, EN3, S3, WF1, EN4: std_logic;
	signal RD1_OUT, RD2_OUT, RS1_R_OUT, RS2_R_OUT: std_logic_vector(4 downto 0);
	signal FUNC_OP: std_logic_vector(1 downto 0);
	signal type_alu: TYPE_OP;
	signal CWregEX: std_logic_vector(11 downto 0);
	signal CWregMW: std_logic_vector(7 downto 0); 
	signal RD_R_OUT: std_logic_vector(4 downto 0);
	signal PC_OUT, NPC, IR_R_OUT, SIGN_EXT_OUT, IMM32_SHIFTED, RELATIVE_ADDRESS, PC_IN, ADDRESS_TO_JUMP, NPC_REG1_OUT, NPC_REG2_OUT, NPC_REG3_OUT, mux_to_PC_2_to_1: std_logic_vector(31 downto 0);
	signal INP1: std_logic_vector(D_SIZE-1 downto 0);
	signal INP2: std_logic_vector(15 downto 0);	
	signal RS1, RS2, RD: std_logic_vector(4 downto 0); 
	signal CWregWR, CWregWR_temp: std_logic_vector(1 downto 0);
	signal RD_RTYPE_OUT, RD_ITYPE_OUT: std_logic_vector(4 downto 0);
	signal ISJUMP, ISBRANCH, ISBEQZ, ZERO_RESULT, PCSrc, ZERO_REG_OUT, branch_taken: std_logic;
	--signal CWregID: std_logic_vector(12 downto 0);
	
begin
	--INP1 <= X"0000" & IR_R_OUT(15 downto 0);
	INP2 <= IR_R_OUT(15 downto 0);	
    RS1 <= IR_R_OUT(15 downto 11);
	RS2 <= IR_R_OUT(25 downto 21);
	--RD <= IR_R_OUT(20 downto 16);
	--ISJUMP,	RF1,	RF2,	EN1,	S2, 	ALU1,	ALU2,	EN2,	ISBRANCH,	ISBEQZ,	RM,	WM,	EN3,	S3,	WF1
	--*******************
	--control signals
	-- FETCH STAGE          
	 
	--DECODE STAGE            
	RF1 <= controls(CONTROL-1);            
	RF2 <= controls(CONTROL-2);            
	EN1 <= controls(CONTROL-3) or EN4; 
	--EXECUTE STAGE
	S2 <= CWregEX(11);
	ALU1 <= CWregEX(10);
	ALU2 <= CWregEX(9);
	EN2 <= CWregEX(8);
	FUNC_OP <= ALU2 & ALU1;
	--MEMORY STAGE
	ISJUMP <= CWregMW(7); 
	ISBRANCH <= CWregMW(6);
	ISBEQZ <= CWregMW(5);
	RM <= CWregMW(4);  
 	WM <= CWregMW(3); 
	EN3 <= CWregMW(2);  
	S3 <= CWregMW(1);
	--WRITEBACK STAGE
	WF1 <= CWregWR(1);
	EN4 <= CWregWR(0);
	--**********************	
--	control signals
--	-- FIRST PIPE STAGE OUTPUTS             
--	RF1 <= controls(CONTROL-1);              
--	RF2 <= controls(CONTROL-2);            
--	EN1 <= controls(CONTROL-3) or EN4; 
--	-- SECOND PIPE STAGE OUTPUTS 
--	--CWregEX <= controls(9 downto 0);
--	S1 <= CWregEX(9);
--	S2 <= CWregEX(8);
--	ALU1 <= CWregEX(7);
--	ALU2 <= CWregEX(6);
--	EN2 <= CWregEX(5);
--	FUNC_OP <= ALU2 & ALU1;
--	-- THIRD PIPE STAGE OUTPUTS
--	--CWregMW <= controls(4 downto 0);
--	RM <= CWregMW(4);  
--	WM <= CWregMW(3);  
--	EN3 <= CWregMW(2);  
--	S3 <= CWregMW(1);   

--	--FOURTH PIPE STAGE OUTPUT
--	WF1 <= CWregWR(1);
--	EN4 <= CWregWR(0);



	--STAGE FETCH
	--***********************

	--S1  <= controls(CONTROL-4);              
	--S2  <= controls(CONTROL-5);     
	--EN2 <= controls(CONTROL-8);         
	--ALU1 <= controls(CONTROL-6);             
	--ALU2 <= controls(CONTROL-7);
	--FUNC_OP <= ALU2 & ALU1;
	type_alu <= ADD when (FUNC_OP = "00") else
				SUB when (FUNC_OP = "01") else
				BITAND when (FUNC_OP = "10") else
				BITOR;

	
	mux_to_PC: MUX21_GENERIC port map(ADDRESS_TO_JUMP, mux_to_PC_2_to_1, ISJUMP, PC_IN);
	iram_addr <= PC_OUT;
	adder_PC: adder port map(PC_OUT, X"00000001", NPC);
	NPC_reg1: Register_generic port map(NPC, Clk, Rst, '1', NPC_REG1_OUT);
	PC_reg: Register_generic port map(PC_IN, Clk, Rst, '1', PC_OUT);
	IR_reg: Register_generic port map(iram_in, Clk, Rst, '1',IR_R_OUT);
	--STAGE DECODE
	--reg_stage_1: Register_generic generic map(13) port map(controls(12 downto 0), Clk, Rst, '1', CWregID);
	--inp1_r: Register_generic port map(INP1, Clk, Rst, '1', INP1_R_OUT);
	--inp2_r: Register_generic port map(INP1, Clk, Rst, '1', INP2_R_OUT);
	--rs1_r: Register_generic generic map(5) port map(RS1, Clk, Rst, '1', RS1_R_OUT);
	--rs2_r: Register_generic generic map(5) port map(RS2, Clk, Rst, '1', RS2_R_OUT);
	NPC_reg2: Register_generic port map(NPC_REG1_OUT, Clk, Rst, EN1, NPC_REG2_OUT);
	RF: register_file port map (Clk, Rst, EN1, '1', '1', WF1, RD2_OUT, RS1, RS2, Out_reg_OUT, RFOUT1, RFOUT2);
	--in1: Register_generic port map (INP1, Clk, Rst, '1', IN1_OUT);
	imm16_to_extend: sign_ext port map(INP2, SIGN_EXT_OUT);
	imm32_extended: Register_generic port map (SIGN_EXT_OUT, Clk, Rst, EN1, IMM32_OUT);
	A: Register_generic port map (RFOUT1, Clk, Rst, EN1, A_OUT);	
	B: Register_generic port map (RFOUT2, Clk, Rst, EN1, B_OUT);
	--rd_reg: Register_generic generic map(5) port map(RD, Clk, Rst, '1', RD_R_OUT);
	rd_rtype: Register_generic generic map(5) port map (IR_R_OUT(20 downto 16), Clk, Rst, EN1, RD_RTYPE_OUT);
	rd_itype: Register_generic generic map(5) port map (IR_R_OUT(15 downto 11), Clk, Rst, EN1, RD_ITYPE_OUT);
	--STAGE EXECUTE
		reg_stage_2: Register_generic generic map(12) port map(controls(11 downto 0), Clk, Rst, '1', CWregEX);
		
		IMM32_SHIFTED <= "0000" & IMM32_OUT(25 downto 0) & "00";
		adder_NPC: adder port map(NPC_REG2_OUT, IMM32_SHIFTED, RELATIVE_ADDRESS);
		compare: comparator port map(A_OUT, ZERO_RESULT);
		
		mux_s_rd: MUX21_GENERIC generic map(5) port map (RD_RTYPE_OUT, RD_ITYPE_OUT, '1', RD1_OUT);	
		mux_s2: MUX21_GENERIC port map (B_OUT, IMM32_OUT, S2, S2_OUT);
		alu_op: ALU port map (type_alu, A_OUT, S2_OUT, ALU_OP_OUT);
	
		--pipeline registers
		zero_reg: fd port map(ZERO_RESULT, Clk, Rst, ZERO_REG_OUT);			
		address_jump_branch: Register_generic port map(RELATIVE_ADDRESS, Clk, Rst, '1', ADDRESS_TO_JUMP);
		NPC_reg3: Register_generic port map(NPC_REG2_OUT, Clk, Rst, '1', NPC_REG3_OUT);
		alu_out_reg1: Register_generic port map (ALU_OP_OUT, Clk, Rst, EN2, ALU_OUT_REG);
		me: Register_generic port map (B_OUT, Clk, Rst, EN2, ME_OUT);
		rd2: Register_generic generic map(5) port map (RD1_OUT, Clk, Rst, EN2, RD2_OUT);
	--STAGE MEMORY
	branch_taken <= (ISBRANCH and ZERO_REG_OUT) when ( ISBEQZ = '1') else
				 	(ISBRANCH and (not ZERO_REG_OUT));
 
	mux_to_PC_2: MUX21_GENERIC port map(ADDRESS_TO_JUMP, NPC, branch_taken, mux_to_PC_2_to_1);
	
	reg_stage_3: Register_generic generic map(8) port map(CWregEX(7 downto 0), Clk, Rst, '1', CWregMW);
	RD_MEM <= RM;
	WR_MEM <= WM;
	EN_MEM <= EN3;
	dram_out <= ME_OUT;
	dram_addr <= ALU_OUT_REG;
	MEMORY_OUT <= dram_in;
	mux_s3: MUX21_GENERIC port map (MEMORY_OUT, ALU_OUT_REG, S3, S3_OUT);
	--STAGE WB
	CWregWR_temp <= CWregMW(0)&'1';
	reg_stage_4: Register_generic generic map(2) port map(CWregWR_temp, Clk, Rst, '1', CWregWR);
	Out_reg: Register_generic port map (S3_OUT, Clk, Rst, '1', Out_reg_OUT);
	
end Struct;
