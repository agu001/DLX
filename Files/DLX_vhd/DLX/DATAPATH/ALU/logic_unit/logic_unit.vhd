library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.alu_package.all;

entity logic_unit is
  	port(	logic_op: IN std_logic_vector(2 downto 0);
  			ctrl_16: IN std_logic;					--0->32, 1->16
			DATA1, DATA2: IN std_logic_vector(NBIT-1 downto 0);
			Y: OUT std_logic_vector(NBIT-1 downto 0));
end logic_unit;

architecture struct of logic_unit is

	component xor2_generic is
		generic(NBIT: integer);
		port(	A, B: 	in std_logic_vector(NBIT-1 downto 0);
				C:		out std_logic_vector(NBIT-1 downto 0));
	end component;

	component and2_generic is
		generic(NBIT: integer);
		port(	A, B: 	in std_logic_vector(NBIT-1 downto 0);
				C:		out std_logic_vector(NBIT-1 downto 0));
	end component;

	component or2_generic is
		generic(NBIT: integer);
		port(	A, B: 	in std_logic_vector(NBIT-1 downto 0);
				C:		out std_logic_vector(NBIT-1 downto 0));
	end component;

	component mux21_generic is
		generic(NBIT: integer);
		Port (in_1, in_0:	In	std_logic_vector(NBIT-1 downto 0);
			  sel:	In	std_logic;
			  y:	Out	std_logic_vector(NBIT-1 downto 0));
	end component mux21_generic;

	signal OR_OUT, AND_OUT, XOR_OUT, MUX1_OUT, MUX2_OUT: std_logic_vector(NBIT-1 downto 0);

begin
	xor_block: xor2_generic generic map (NBIT) port map (DATA1, DATA2, XOR_OUT);--001
	or_block: or2_generic generic map (NBIT) port map (DATA1, DATA2, OR_OUT);--010
	and_block: and2_generic generic map (NBIT) port map (DATA1, DATA2, AND_OUT);--100

	mux1: mux21_generic generic map(NBIT) port map (XOR_OUT, OR_OUT, logic_op(0), MUX1_OUT);
	mux2: mux21_generic generic map(NBIT) port map (AND_OUT, MUX1_OUT, logic_op(2), MUX2_OUT);

	mux3: mux21_generic generic map(NBIT/2) port map (DATA1(NBIT-1 downto NBIT/2), MUX2_OUT(NBIT-1 downto NBIT/2), ctrl_16, Y(NBIT-1 downto NBIT/2));
	Y(NBIT/2-1 downto 0) <= MUX2_OUT(NBIT/2-1 downto 0);

end struct;
