library IEEE;
use IEEE.std_logic_1164.all; 
use work.myTypes.all;

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
				dram_in: in std_logic_vector(D_SIZE-1 downto 0);
				RD_MEM, WR_MEM, EN_MEM: out std_logic;
				--IRAM
				--iram_out: out std_logic_vector(I_SIZE-1 downto 0);
				iram_addr: out std_logic_vector(IRAM_DEPTH-1 downto 0);
				iram_in: in std_logic_vector(I_SIZE-1 downto 0);
				--INP1, INP2: in std_logic_vector(D_SIZE-1 downto 0);
				--RS1, RS2, RD: in std_logic_vector(4 downto 0);			
				Clk, Rst: in std_logic
			  );
	end component DATAPATH;
	component cu is	
	generic (
    	MICROCODE_MEM_SIZE :     integer := 16  -- Microcode Memory Size
		);     
		port (
				-- FETCH STAGE OUTPUTS
				
				-- DECODE STAGE OUTPUTS 
				RF1    : out std_logic;               -- enables the read port 1 of the register file
				RF2    : out std_logic;               -- enables the read port 2 of the register file

				EN1    : out std_logic;               -- enables the register file and the pipeline registers
				--EXECUTE STAGE OUTPUTS
				--S1 previous position
								
				S2 	    : out std_logic;               -- input selection of the second multiplexer
				ALU1   : out std_logic;               -- alu control bit
				ALU2   : out std_logic;               -- alu control bit
				EN2    : out std_logic;               -- enables the pipe registers
				-- MEMORY STAGE OUTPUTS
				ISJUMP	:out std_logic;				  --NEW!!
				ISBRANCH	: out std_logic;          -- originally S1	NEW!!			
				ISBEQZ   : out std_logic;				  --selects 		NEW!!
				RM     : out std_logic;               -- enables the read-out of the memory
				WM     : out std_logic;               -- enables the write-in of the memory
				EN3    : out std_logic;               -- enables the memory and the pipeline registers
				S3     : out std_logic;               -- input selection of the multiplexer
				-- WRITEBACK STAGE OUTPUTS
				WF1    : out std_logic;               -- enables the write port of the register file
				

				-- INPUTS
				OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
				FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0);              
				Clk : in std_logic;
				Rst : in std_logic);                -- Active Low
    end component;

	signal ISJUMP,	RF1,	RF2,	EN1,	S2, 	ALU1,	ALU2,	EN2,	ISBRANCH,	ISBEQZ,	RM,	WM,	EN3,	S3,	WF1: std_logic;	
	signal controls_s: std_logic_vector(14 downto 0);
	signal INP1_S, INP2_S: std_logic_vector(31 downto 0);
	--signal RD_MEM, WR_MEM, EN_MEM: std_logic;
	
begin
	
	--INP1_S <= X"0000" & iram_in(15 downto 0);
	--INP2_S <= X"0000" & iram_in(15 downto 0);
	controls_s <= RF1 & RF2 & EN1 & S2 & ALU1 & ALU2 & EN2 & ISJUMP & ISBRANCH & ISBEQZ & RM & WM & EN3 & S3 & WF1;
	--controls_s <= RF1 & RF2 & EN1 & S1 & S2 & ALU1 & ALU2 & EN2 & RM & WM & EN3 & S3 & WF1;
--								RF1,	RF2,	EN1,	S2, 	ALU1,	ALU2,	EN2, ISJUMP,	ISBRANCH,	ISBEQZ,	RM,	WM,	EN3,	S3,	WF1
	CONTROL_UNIT: cu port map (RF1,	RF2,	EN1,	S2, 	ALU1,	ALU2,	EN2, ISJUMP,	ISBRANCH,	ISBEQZ,	RM,	WM,	EN3,	S3,	WF1, iram_in(I_SIZE-1 downto I_SIZE-6), iram_in(10 downto 0), Clk, Rst);	
	--CONTROL_UNIT: cu port map (RF1, RF2, WF1, EN1, S1, S2, ALU1, ALU2, EN2, RM, WM, EN3, S3, iram_in(I_SIZE-1 downto I_SIZE-6), iram_in(10 downto 0), Clk, Rst);

	DATA_PATH: DATAPATH port map 
						(controls_s, dram_out, dram_addr, dram_in, RD_MEM, WR_MEM, EN_MEM, iram_addr, iram_in, Clk, Rst);
	
end Struct;
