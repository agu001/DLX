library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_type.all;

entity DATAPATH is
	generic ( CONTROL: natural := 13;
			  D_SIZE: natural := 32;
			  IRAM_DEPTH: natural := 8;
			  I_SIZE: natural := 32;
			  DRAM_DEPTH: natural := 12; 
			);
	port (	controls: in std_logic_vector(CONTROL_WIDTH-1 downto 0);
			--DRAM
			dram_out: out std_logic_vector(D_SIZE- downto 0);
			dram_addr: out std_logic_vector(DRAM_DEPTH-1 downto 0);
			dram_in: in std_logic_vector(D_SIZE- downto 0);
			--IRAM
			iram_out: out std_logic_vector(I_SIZE- downto 0);
			iram_addr: out std_logic_vector(IRAM_DEPTH-1 downto 0);
			iram_in: in std_logic_vector(I_SIZE- downto 0);
			INP1, INP2: in std_logic_vector(D_SIZE-1 downto 0);
			RS1, RS2, RD: in std_logic_vector(4 downto 0);			
			Clk, Rst: in std_logic;
		  );
end DATAPATH;

architecture Struct of DATAPATH is
	component Register_generic is
		generic(NBIT:integer := D_SIZE);
		Port (	D:	In	std_logic_vector(NBIT-1 downto 0); 
				CK:	In	std_logic;
				RESET:	In	std_logic;
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
			   DELAY_MUX: time := tp_mux);
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
	signal RFOUT1, RFOUT2, MUX3_OUT: std_logic_vector(D_SIZE-1 downto 0);
	
begin
	
	RF: register_file port map(Clk, Rst, '1', controls(control-1), controls(control-2), controls(control-3), RD2_OUT, RS1, RS2, MUX3_OUT, RFOUT1, RFOUT2);
	IN1: Register_generic port map();

end Struct
