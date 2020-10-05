library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use WORK.alu_type.all;

entity ALU is
  generic (N : integer := 32);
  port 	 ( conf, ctrl_mux_out: in std_logic_vector(1 downto 0);
  		   comparator_slct: in std_logic_vector(2 downto 0);
  		   ctrl_16_32, adder_comp_sel, Cin: in std_logic;
           DATA1, DATA2: IN std_logic_vector(N-1 downto 0);
           OUTALU: OUT std_logic_vector(N-1 downto 0));
end ALU;

architecture Struct of ALU is

		component T2shifter is
			port ( 	dataIN: in std_logic_vector(31 downto 0);
					shift: in std_logic_vector(4 downto 0);
					conf: in std_logic_vector(1 downto 0);
					dataOUT: out std_logic_vector(31 downto 0)
				 );
		end component T2shifter;

		component ADD_SUB_BLOCK is
				generic (NBIT:	integer :=	32);
				port (  	A :		in	std_logic_vector(NBIT-1 downto 0);
							B :		in	std_logic_vector(NBIT-1 downto 0);
							SUB, SIGN:	in	std_logic;
							RES :	out	std_logic_vector(NBIT-1 downto 0);
							Cout, e, lt, le, gt, ge:	out	std_logic);
		end component;

		component boothmul is
			generic (numBit: integer := 32);
			port ( --  input
					  A_mp : in std_logic_vector(numBit-1 downto 0);
					  B_mp : in std_logic_vector(numBit-1 downto 0);
					  -- output
					  Y_mp : out std_logic_vector(2*numBit-1 downto 0) );
		end component;

		component mux5x1 is
			port ( INPUT1, INPUT2, INPUT3, INPUT4, INPUT5: in std_logic;
				   SEL: in std_logic_vector(2 downto 0);
				   OUTPUT: out std_logic
				 );
		end component mux5x1;

		component mux4x1 is
			generic (BITS: integer := 40);
			port ( INPUT1, INPUT2, INPUT3, INPUT4: in std_logic_vector(BITS-1 downto 0);
				   SEL: in std_logic_vector(1 downto 0);
				   OUTPUT: out std_logic_vector(BITS-1 downto 0)
				 );
		end component mux4x1;

		component MUX21_GENERIC is
				generic(NBIT: integer := 32);
				Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
						B:	In	std_logic_vector(NBIT-1 downto 0);
						SEL:	In	std_logic;
						Y:	Out	std_logic_vector(NBIT-1 downto 0));
		end component MUX21_GENERIC;

		signal shifter_out, adder_out, mult_out, logic_out, zeros32, adder_comp_out: std_logic_vector(N-1 downto 0);
		signal zeros31: std_logic_vector(N-2 downto 0);
		signal Cout, e, lt, le, gt, ge, comp_mux_out: std_logic;

begin
		--Need to add CS for each component!

		--shifter
		SHIFTER: T2shifter port map(DATA1, DATA2(4 downto 0), conf, shifter_out);
		--adder
		ADDER: ADD_SUB_BLOCK port map(DATA1, DATA2, Cin, conf(1), adder_out, Cout, e, lt, le, gt, ge);
  comp_signal: mux5x1 port map(e, lt, le, gt, ge, comparator_slct, comp_mux_out);
  		zeros31 <= (others => '0');
  		zeros32 <= zeros31 & comp_mux_out;
add_comp_slct: MUX21_GENERIC port map(adder_out, zeros32, adder_comp_sel, adder_comp_out);
		--logic
		logic_out <= (others => '0');
		--mult
		MULT: boothmul port map(DATA1, DATA2, mult_out);


  mux_output: mux4x1 generic map(32) port map(shifter_out, adder_comp_out, logic_out, mult_out, ctrl_mux_out, OUTALU);


end Struct;


