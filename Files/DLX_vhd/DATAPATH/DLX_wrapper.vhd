library IEEE;
use IEEE.std_logic_1164.all; 
use work.myTypes.all;

entity DLX_wrapper is
	generic ( I_SIZE: natural := 32 );
	port (  IR: in std_logic_vector(I_SIZE-1 downto 0);
			Clk, Rst: in std_logic
		 );
end DLX_wrapper;

architecture Struct of DLX_wrapper is

	component DRAM is
		generic (	n: natural := 32; 
					p: natural := 256;
					k: natural := 32;
					Td: time := 0.5 ns
				);
		port ( X: in std_logic_vector(n-1 downto 0);
			   A: in std_logic_vector(k-1 downto 0);
			   Z: out std_logic_vector(n-1 downto 0);
			   Rst, RM, WM, Clk, En: std_logic
	  		 );
	end component DRAM;

	component IRAM is
	  generic (
		RAM_DEPTH : integer := 48;
		I_SIZE : integer := 32);
	  port (
		Rst  : in  std_logic;
		Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
		Dout : out std_logic_vector(I_SIZE - 1 downto 0)
		);

	end component IRAM;

	component DLX is
		generic ( I_SIZE: natural := 32 );
		port ( 	IR: in std_logic_vector(I_SIZE-1 downto 0);
		 		dram_out: out std_logic_vector(I_SIZE-1 downto 0);
				dram_addr: out std_logic_vector(31 downto 0);
				dram_in: in std_logic_vector(I_SIZE-1 downto 0);
				RD_MEM, WR_MEM, EN_MEM: out std_logic;			
				--iram_out: out std_logic_vector(I_SIZE-1 downto 0);
				iram_addr: out std_logic_vector(7 downto 0);
				iram_in: in std_logic_vector(I_SIZE-1 downto 0);
			   	Clk, Rst: in std_logic
			 );
	end component DLX;
	
	signal dram_out, dram_addr, dram_in: std_logic_vector(31 downto 0);
	signal RD_MEM, WR_MEM, EN_MEM: std_logic;
	signal iram_addr: std_logic_vector(7 downto 0);
    signal iram_in: std_logic_vector(I_SIZE-1 downto 0);

begin
	CPU: DLX port map (IR, dram_out, dram_addr, dram_in, RD_MEM, WR_MEM, EN_MEM, iram_addr, iram_in, Clk, Rst);
	Memory: DRAM port map (dram_out, dram_addr, dram_in, Rst, RD_MEM, WR_MEM, Clk, EN_MEM);	
	--IMemory: IRAM port map (Rst, iram_addr, iram_in);
end Struct;
