library IEEE;
use IEEE.std_logic_1164.all;
use work.myTypes.all;
use WORK.alu_type.all;

entity DLX is
	generic ( I_SIZE: natural := 32 );
	port ( 	--IR: in std_logic_vector(I_SIZE-1 downto 0);
	 		dram_out: out std_logic_vector(I_SIZE-1 downto 0);
			dram_addr: out std_logic_vector(31 downto 0);
			dram_in: in std_logic_vector(I_SIZE-1 downto 0);
			RD_MEM, WR_MEM, EN_MEM: out std_logic;
			--iram_out: out std_logic_vector(I_SIZE-1 downto 0);
			iram_addr: out std_logic_vector(I_SIZE-1 downto 0);
			iram_in: in std_logic_vector(I_SIZE-1 downto 0);
		   	Clk, Rst: in std_logic
		 );
end DLX;

architecture Struct of DLX is

	component DATAPATH is
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
				iram_addr: out std_logic_vector(IRAM_DEPTH-1 downto 0);
				iram_in: in std_logic_vector(I_SIZE-1 downto 0);
				OPCODE_to_CU 		: out  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
				FUNC_to_CU   		: out  std_logic_vector(FUNC_SIZE - 1 downto 0);
				Clk, Rst: in std_logic
			  );
	end component DATAPATH;
	component CONTROL_UNIT is
		port (	-- FETCH STAGE OUTPUTS

				-- DECODE STAGE OUTPUTS
				RF1    		: out std_logic;               -- enables the read port 1 of the register file
				RF2    		: out std_logic;               -- enables the read port 2 of the register file
				EN_DE    		: out std_logic;               -- enables the register file and the pipeline registers

				--EXECUTE STAGE OUTPUTS
				I0_R1_SEL	: out std_logic;               --selection bit of RD multiplexer			NEW!!
				JAL_SEL		: out std_logic;               --selection bit of RD/R31 multiplexer		NEW!!
				ISJR		: out std_logic;
				S2 	    	: out std_logic;               --selection bit of second alu input multiplexer
				SE_CTRL		: out std_logic;
				ALU_CTRL	: out ALU_TYPE_OP;
				EN_EM  	  	: out std_logic;               -- enables the pipe registers

				-- MEMORY STAGE OUTPUTS
				ISJUMP		: out std_logic;			   --
				ISBRANCH	: out std_logic;			   --
				ISBEQZ   	: out std_logic;			   --
				RM     		: out std_logic;               -- enables the read-out of the memory
				WM     		: out std_logic;               -- enables the write-in of the memory
				MSIZE1		: out std_logic;
				MSIZE0		: out std_logic;
				SE_CTRL2	: out std_logic;
				EN_MW  		: out std_logic;               -- enables the memory and the pipeline registers
				               -- input selection of the multiplexer

				-- WRITEBACK STAGE OUTPUTS
				S3     		: out std_logic;
				WF1    		: out std_logic;               -- enables the write port of the register file
				EN_W		: out std_logic;
				-- INPUTS
				OPCODE 		: in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
				FUNC   		: in  std_logic_vector(FUNC_SIZE - 1 downto 0);
				Clk 		: in std_logic;
				Rst 		: in std_logic);
    end component;

	signal RF1,	RF2, EN_DE,	I0_R1_SEL, JAL_SEL, ISJR, S2, EN_EM, ISJUMP, ISBRANCH, ISBEQZ, RM, WM, MSIZE1, MSIZE0, SE_CTRL2, SE_CTRL, EN_MW, S3, WF1, EN_W: std_logic;
	signal controls_s: std_logic_vector(CW_SIZE-1 downto 0);
	signal INP1_S, INP2_S: std_logic_vector(31 downto 0);
	signal ALU_CTRL: ALU_TYPE_OP;
	signal OPCODE_to_CU: std_logic_vector(OP_CODE_SIZE - 1 downto 0);
	signal FUNC_to_CU: std_logic_vector(FUNC_SIZE - 1 downto 0);

	--signal RD_MEM, WR_MEM, EN_MEM: std_logic;

begin
	--RF1,	RF2,	EN_DE,	I0_R1_SEL,	JAL_SEL, ISJR,		S2,		EN_EM,	ISJUMP,	ISBRANCH,	BEQZ,	RM,	WM,	MSIZE1,	MSIZE0,	SE_CTRL2,	EN_MW,	S3,	WF1, EN_W
	--0,	1,  	2,		3,			4,	      5,		6,		7,		8,		9,			10,		11,	12,	13, 	14,		15,			16,		17,	 18,	19
	controls_s <= RF1 & RF2 & EN_DE & I0_R1_SEL & JAL_SEL & ISJR & SE_CTRL & S2 & EN_EM & ISJUMP & ISBRANCH & ISBEQZ & RM & WM & MSIZE1 & MSIZE0 & SE_CTRL2 & EN_MW & S3 & WF1 & EN_W;

	CU: CONTROL_UNIT port map (RF1,	RF2, EN_DE, I0_R1_SEL, JAL_SEL, ISJR, S2, SE_CTRL, ALU_CTRL, EN_EM, ISJUMP, ISBRANCH, ISBEQZ, RM, WM, MSIZE1, MSIZE0, SE_CTRL2, EN_MW, S3, WF1, EN_W, OPCODE_to_CU, FUNC_to_CU, Clk, Rst);

	DP: DATAPATH port map (controls_s, ALU_CTRL, dram_addr, dram_out, dram_in, RD_MEM, WR_MEM, EN_MEM, iram_addr, iram_in, OPCODE_to_CU, FUNC_to_CU, Clk, Rst);

end Struct;
