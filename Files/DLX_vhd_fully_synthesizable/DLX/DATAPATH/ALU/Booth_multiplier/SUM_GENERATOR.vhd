library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all; -- libreria WORK user-defined

entity SUM_GENERATOR is
		generic (
			NBIT_PER_BLOCK: integer := 4;
			NBLOCKS:	integer := 8);
		port (
			A:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			B:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			Ci:	in	std_logic_vector(NBLOCKS-1 downto 0);
			S:	out	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0));
end entity SUM_GENERATOR;

architecture STRUCTURAL of SUM_GENERATOR is
	component CSblock is
		generic(NBIT: integer := numBit );
		Port( A,B: in std_logic_vector(NBIT-1 downto 0);
			  Cin: in std_logic;
			  S: out std_logic_vector(NBIT-1 downto 0)
			);
    end component CSblock;
begin
	
	G1: for i in 0 to NBLOCKS-1 generate
	  CS_i:  CSblock generic map(NBIT_PER_BLOCK)
				     port map(A(NBIT_PER_BLOCK*(i+1)-1 downto NBIT_PER_BLOCK*i),
					  	      B(NBIT_PER_BLOCK*(i+1)-1 downto NBIT_PER_BLOCK*i),
						      Ci(i),
						      S(NBIT_PER_BLOCK*(i+1)-1 downto NBIT_PER_BLOCK*i) );
	    end generate;
end STRUCTURAL;

configuration CFG_SUM_GENERATOR OF SUM_GENERATOR is
	for STRUCTURAL
		for all : CSblock
			use configuration work.cfg_CSblock;
		end for;
	end for;	
end configuration;
