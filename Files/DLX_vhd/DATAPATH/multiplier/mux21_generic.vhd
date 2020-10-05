library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use WORK.constants.all; -- libreria WORK user-defined

entity MUX21_GENERIC is
	generic(NBIT: integer := numBit;
		   DELAY_MUX: time := tp_mux);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(NBIT-1 downto 0));
end MUX21_GENERIC;


architecture MUX21_GEN_BEHAVIORAL of MUX21_GENERIC is

begin
	process(SEL)
	begin
	  if( SEL = '0') then
	    Y <= B;-- after DELAY_MUX;
	  else
	    Y<= A;-- after DELAY_MUX;
	  end if;
	end process;
		 --il processo è implicito

end MUX21_GEN_BEHAVIORAL;


architecture MUX21_GEN_STRUCTURAL of MUX21_GENERIC is

	signal Y1: std_logic_vector(NBIT-1 downto 0);
	signal Y2: std_logic_vector(NBIT-1 downto 0);
	signal SB: std_logic;

	component ND2
	
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		Y:	Out	std_logic);
	end component;
	
	component IV
	
	Port (	A:	In	std_logic;
		Y:	Out	std_logic);
	end component;

begin
	--the select signal is complemented
	UIV : IV Port Map ( SEL, SB);
	--for each bit for our inputs data, the for-generate statement replicates the architecture of a 
	--simple one-bit mux21 using three nand gates
	C1:for i in 0 to NBIT-1 generate
	     UND1 : ND2 Port Map ( A(i), SEL, Y1(i));
	     UND2 : ND2 Port Map ( B(i), SB, Y2(i));
	     UND3 : ND2 Port Map ( Y1(i), Y2(i), Y(i));
	   end generate;

end MUX21_GEN_STRUCTURAL;


configuration CFG_MUX21_GEN_BEHAVIORAL of MUX21_GENERIC is
	for MUX21_GEN_BEHAVIORAL
	end for;
end CFG_MUX21_GEN_BEHAVIORAL;

configuration CFG_MUX21_GEN_STRUCTURAL of MUX21_GENERIC is
	for MUX21_GEN_STRUCTURAL
		for all : IV
			use configuration WORK.CFG_IV_BEHAVIORAL;
		end for;
		for all : ND2
			use configuration WORK.CFG_ND2_ARCH2;
		end for;
	end for;
end CFG_MUX21_GEN_STRUCTURAL;
