library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
use work.myTypes.all;

	entity cu is
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
    end entity;

architecture beh of cu is
	type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  							--RF1,	RF2,	EN1,	S2,		EN2,	ISJUMP,	ISBRANCH,	BEQZ,	RM,	WM,	EN3,	S3,	WF1
							--0,	1,  	2,		3,		4,		5,		6,			7,		8,	9,	10,		11,	12
	signal cw_mem : mem_array := (  "1111100000001", --RTYPE
		                            "0111100000001", --ADDI1
		                            "0111100000001", --SUBI1
		                            "0111100000001", --ANDI1
		                            "0111101000001", --ORI1, S1 1 -> 0, BNEZ simulation
		                            "1010100000001", --ADDI2
		                            "1010100000001", --SUBI2
		                            "1010110000001", --ANDI2 JUMP OPERATION
		                            "1010101100001", --ORI2, S1 0 -> 1, BEQZ simulation
									"1010100000001", --MOV R2 <= R1, INP2 = 0
									"0010100000001", --S_REG1 INP2 = 0
									"0010100000001", --S_REG2 INP1 = 0
									"1110100001100", --S_MEM2
									"0110100010111", --L_MEM1 we save in R2 MEM[R[2]+inp1]
		                            "1010100010111", --L_MEM2
									"0000000000000");--NOP 

	subtype aluOp is std_logic_vector(1 downto 0);

	signal cw, cw1: std_logic_vector(CW_SIZE-1 downto 0);

	signal aluOpcode_i: aluOp := DEFAULT; -- ALUOP defined in package
  	signal aluOpcode1: aluOp := DEFAULT;
  	signal aluOpcode2: aluOp := DEFAULT;

begin
		--RF1,	RF2,	EN1,	S2,		EN2,	ISJUMP,	ISBRANCH,	BEQZ,	RM,	WM,	EN3,	S3,	WF1
		--0,	1,  	2,		3,		4,		5,		6,			7,		8,	9,	10,		11,	12
		
	  	cw <= cw_mem( to_integer( unsigned(OPCODE) ) ) when (OPCODE /= "100000" ) else
			  "0000000000000";
		-- FETCH STAGE OUTPUTS
		
		-- DECODE STAGE OUTPUTS 
		RF1    	<= cw1(CW_SIZE -1);
		RF2    	<= cw1(CW_SIZE -2);
		EN1    	<= cw1(CW_SIZE -3);
		--EXECUTE STAGE OUTPUTS
		S2		<= cw1(CW_SIZE -4);
		--ALU1   	<= cw1(CW_SIZE -6);
		--ALU2   	<= cw1(CW_SIZE -7);
		EN2    	<= cw1(CW_SIZE -5);
		-- MEMORY STAGE OUTPUTS
		ISJUMP	<= cw1(CW_SIZE -6);
		ISBRANCH	<= cw1(CW_SIZE -7);		
		ISBEQZ   	<= cw1(CW_SIZE -8);
		RM     	<= cw1(CW_SIZE -9);
		WM     	<= cw1(CW_SIZE -10);
		EN3    	<= cw1(CW_SIZE -11);
		S3     	<= cw1(CW_SIZE -12);
		-- WRITEBACK STAGE OUTPUTS
		WF1    	<= cw1(CW_SIZE -13);

--	  -- FIRST PIPE STAGE OUTPUTS             
--      RF1 <= cw1(CW_SIZE -1);              
--      RF2 <= cw1(CW_SIZE -2);            
--      EN1 <= cw1(CW_SIZE -3); 
--      -- SECOND PIPE STAGE OUTPUTS              
--      S1  <= cw1(CW_SIZE -4);              
--      S2  <= cw1(CW_SIZE -5);     
--	  	EN2 <= cw1(CW_SIZE -8);         
--      --ALU1 <= cw2(CW_SIZE -6);             
--      --ALU2 <= cw2(CW_SIZE -7);               
--      -- THIRD PIPE STAGE OUTPUTS          
--      RM  <= cw1(CW_SIZE -9);             
--      WM  <= cw1(CW_SIZE -10); 
--      EN3 <= cw1(CW_SIZE -11);              
--      S3  <= cw1(CW_SIZE -12);  
--		WF1 <= cw1(CW_SIZE -13); 

	-- process to pipeline control words
	  CW_PIPE: process (Clk, Rst)
	  begin  -- process Clk
		if Rst = '1' then                   -- asynchronous reset (active low)
		  cw1 <= (others => '0');
		  aluOpcode1 <= DEFAULT;
		  aluOpcode2 <= DEFAULT;

		elsif Clk'event and Clk = '1' then  -- rising clock edge
		  cw1 <= cw;										--here the cw is passed from cw to cw1 to cw2 to cw3, in order to assign the signals with the correct timing
		  aluOpcode1 <= aluOpcode_i;						--here che aluOpcode_i, whose value is set in ALU_OP_CODE_P process, is passed in aluOpcode1, 
		end if;
	  end process CW_PIPE; 

	ALU1 <= aluOpcode1(0);
	ALU2 <= aluOpcode1(1);

   ALU_OP_CODE_P : process (OPCODE, FUNC)
   begin  -- process ALU_OP_CODE_P
	case to_integer(unsigned(OPCODE)) is
		when 0 =>												--when the OPCODE is 0 the instruction is R_type
			case to_integer(unsigned(FUNC)) is				--case of R type requires analysis of FUNC
				when 0 => aluOpcode_i <= opADD(1 downto 0); 	--here we decide what signals to send the ALU
				when 1 => aluOpcode_i <= opSUB(1 downto 0);
				when 2 => aluOpcode_i <= opAND(1 downto 0);
				when 3 => aluOpcode_i <= opOR(1 downto 0); 
				when others => aluOpcode_i <= DEFAULT;
			end case;
		when 1 | 5 | 9 | 10 | 11 | 12 | 13 | 14 | 15 => aluOpcode_i <= opADD(1 downto 0); --for I_type instructions the opcode is sufficient to decide what signals to send to the ALU
		when 2 | 6 => aluOpcode_i <= opSUB(1 downto 0); 
		when 3 | 7 => aluOpcode_i <= opAND(1 downto 0);
		when 4 | 8 => aluOpcode_i <= opOR(1 downto 0);
		when others => aluOpcode_i <= DEFAULT;
	 end case;
	end process ALU_OP_CODE_P;


end architecture;
