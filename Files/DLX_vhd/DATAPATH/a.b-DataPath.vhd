library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_type.all;

entity DATAPATH is
	generic ( CONTROL: natural := 13;
			  D_SIZE: natural := 32;
			  IRAM_DEPTH: natural := 8;
			  I_SIZE: natural := 32;
			  DRAM_DEPTH: natural := 12
			);
	port (	controls: in std_logic_vector(CONTROL-1 downto 0);
			--DRAM
			dram_out: out std_logic_vector(D_SIZE-1 downto 0);
			dram_addr: out std_logic_vector(DRAM_DEPTH-1 downto 0);
			dram_in: in std_logic_vector(D_SIZE- 1 downto 0);
			--IRAM
			iram_out: out std_logic_vector(I_SIZE-1 downto 0);
			iram_addr: out std_logic_vector(IRAM_DEPTH-1 downto 0);
			iram_in: in std_logic_vector(I_SIZE-1 downto 0);
			INP1, INP2: in std_logic_vector(D_SIZE-1 downto 0);
			RS1, RS2, RD: in std_logic_vector(4 downto 0);			
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
	
	--signal INP1, INP2: std_logic_vector(D_SIZE-1 downto 0);
	--signal RS1, RS2, RD: std_logic_vector(4 downto 0);
	--REGISTER_FILE
	signal RFOUT1, RFOUT2, S3_OUT, IN1_OUT, A_OUT, B_OUT, IN2_OUT, S1_OUT, S2_OUT, ALU_OP_OUT, ALU_OUT_REG, MEMORY_OUT, ME_OUT, OUT_REG_OUT: std_logic_vector(D_SIZE-1 downto 0);
	signal RF1, RF2, EN1, S1, S2, ALU1, ALU2, EN2, RM, WM, EN3, S3, WF1: std_logic;
	signal RD1_OUT, RD2_OUT: std_logic_vector(4 downto 0);
	signal FUNC_OP: std_logic_vector(1 downto 0);
	signal type_alu: TYPE_OP;
	
begin

	--control signals
	-- FIRST PIPE STAGE OUTPUTS             
	RF1 <= controls(CONTROL-1);              
	RF2 <= controls(CONTROL-2);            
	EN1 <= controls(CONTROL-3); 
	-- SECOND PIPE STAGE OUTPUTS              
	S1  <= controls(CONTROL-4);              
	S2  <= controls(CONTROL-5);     
	EN2 <= controls(CONTROL-8);         
	ALU1 <= controls(CONTROL-6);             
	ALU2 <= controls(CONTROL-7);
	FUNC_OP <= ALU2 & ALU1;
	type_alu <= ADD when (FUNC_OP = "00") else
				SUB when (FUNC_OP = "00") else
				BITAND when (FUNC_OP = "00") else
				BITOR;

	-- THIRD PIPE STAGE OUTPUTS          
	RM  <= controls(CONTROL-9);             
	WM  <= controls(CONTROL-10); 
	EN3 <= controls(CONTROL-11);              
	S3  <= controls(CONTROL-12);  
	WF1 <= controls(CONTROL-13); 
	--STAGE 1
	RF: register_file port map (Clk, Rst, '1', RF1, RF2, EN1, RD2_OUT, RS1, RS2, S3_OUT, RFOUT1, RFOUT2);
	in1: Register_generic port map (INP1, Clk, Rst, EN1, IN1_OUT);
	in2: Register_generic port map (INP2, Clk, Rst, EN1, IN2_OUT);
	A: Register_generic port map (RFOUT1, Clk, Rst, EN1, A_OUT);
	B: Register_generic port map (RFOUT2, Clk, Rst, EN1, B_OUT);
	rd1: Register_generic port map (RD, Clk, Rst, EN1, RD1_OUT);
	--STAGE 2	
	mux_s1: MUX21_GENERIC port map (IN1_OUT, A_OUT, S1, S1_OUT);
	mux_s2: MUX21_GENERIC port map (B_OUT, IN2_OUT, S2, S2_OUT);
	alu_op: ALU port map (type_alu, S1_OUT, S2_OUT, ALU_OP_OUT);
	alu_out_reg1: Register_generic port map (ALU_OP_OUT, Clk, Rst, EN2, ALU_OUT_REG);
	me: Register_generic port map (B_OUT, Clk, Rst, EN2, ME_OUT);
	rd2: Register_generic port map (RD1_OUT, Clk, Rst, EN2, RD2_OUT);
	--STAGE 3
	dram_out <= ME_OUT;
	dram_addr <= ALU_OUT_REG;
	MEMORY_OUT <= dram_in;
	mux_s3: MUX21_GENERIC port map (MEMORY_OUT, ALU_OUT_REG, S3, S3_OUT);
	Out_reg: Register_generic port map (S3_OUT, Clk, Rst, EN3, Out_reg_OUT);
	
end Struct;
