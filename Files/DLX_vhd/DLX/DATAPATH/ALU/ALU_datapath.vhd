library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.alu_package.all;

	entity ALU_datapath is
		port (	conf, ctrl_mux_out: in std_logic_vector(1 downto 0);
				comparator_ctrl, logic_op: in std_logic_vector(2 downto 0);
				ctrl_16, adder_comp_sel, SUB, shift_16: in std_logic;
				DATA1, DATA2: IN std_logic_vector(NBIT-1 downto 0);
				OUTALU: OUT std_logic_vector(NBIT-1 downto 0));
	end ALU_datapath;

architecture Struct of ALU_datapath is

		component T2_shifter is
			port ( 	dataIN: in std_logic_vector(31 downto 0);
					shift: in std_logic_vector(4 downto 0);
					conf: in std_logic_vector(1 downto 0);
					dataOUT: out std_logic_vector(31 downto 0)
				 );
		end component T2_shifter;

		component ADD_SUB_COMP_BLOCK is
				generic (NBIT:	integer :=	32);
				port (  	A :		in	std_logic_vector(NBIT-1 downto 0);
							B :		in	std_logic_vector(NBIT-1 downto 0);
							SUB, SIGN:	in	std_logic;
							RES :	out	std_logic_vector(NBIT-1 downto 0);
							Cout, e, ne, lt, le, gt, ge:	out	std_logic);
		end component;

		component logic_unit is
		  	port(	logic_op: IN std_logic_vector(2 downto 0);
		  			ctrl_16: IN std_logic;					--0->32, 1->16
					DATA1, DATA2: IN std_logic_vector(NBIT-1 downto 0);
					Y: OUT std_logic_vector(NBIT-1 downto 0));
		end component logic_unit;

		component boothmul is
			generic (numBit: integer := 32);
			port ( 	  A_mp : in std_logic_vector(numBit-1 downto 0);
					  B_mp : in std_logic_vector(numBit-1 downto 0);
					  Y_mp : out std_logic_vector(2*numBit-1 downto 0) );
		end component;

		component mux21_generic is
			generic(NBIT: integer);
			Port (in_1, in_0:	In	std_logic_vector(NBIT-1 downto 0);
				  sel:	In	std_logic;
				  y:	Out	std_logic_vector(NBIT-1 downto 0));
		end component mux21_generic;


		component mux41_generic is
			generic (NBIT: integer);
			port ( in_0, in_1, in_2, in_3: in std_logic_vector(NBIT-1 downto 0);
				   sel: in std_logic_vector(1 downto 0);
				   y: out std_logic_vector(NBIT-1 downto 0)
				 );
		end component mux41_generic;

		component mux61 is
			Port (in_0, in_1, in_2, in_3, in_4, in_5:	In	std_logic;
				  sel:	In	std_logic_vector(2 downto 0);
				  y:	Out	std_logic);
		end component mux61;

		signal shifter_out, adder_out, logic_out, zeros32, adder_comp_out, comparator_out32, DATA_s: std_logic_vector(NBIT-1 downto 0);
		signal mult_out: std_logic_vector(2*NBIT-1 downto 0);
		signal zeros31: std_logic_vector(NBIT-2 downto 0);
		signal shift_s: std_logic_vector(4 downto 0);
		signal Cout, e, ne, lt, le, gt, ge, comparator_out1: std_logic;

begin
										--Need to add CS for each component!
		zeros31 <= (others => '0');

		--shifter
		num_to_shift: mux21_generic generic map(5) port map("10000", DATA2(4 downto 0), shift_16, shift_s);
		data_to_shift: mux21_generic generic map(NBIT) port map(DATA2, DATA1, shift_16, DATA_s);
		SHIFTER: T2_shifter port map(DATA_s, shift_s, conf, shifter_out);

		--adder, subtractor, comparator
		ADD_SUB_COMP: ADD_SUB_COMP_BLOCK port map(DATA1, DATA2, SUB, conf(1), adder_out, Cout, e, ne, lt, le, gt, ge);
  		comparator_out: mux61 port map(e, ne, lt, le, gt, ge, comparator_ctrl, comparator_out1);
  		comparator_out32 <= zeros31 & comparator_out1;
		add_comp_slct: mux21_generic generic map(NBIT) port map(adder_out, comparator_out32, adder_comp_sel, adder_comp_out);

		--logic
		logic: logic_unit port map (logic_op, ctrl_16, DATA1, DATA2, logic_out);

		--multiplier
		MULT: boothmul port map(DATA1, DATA2, mult_out);

		--to output
  		mux_output: mux41_generic generic map(32) port map(shifter_out, adder_comp_out, logic_out, mult_out(NBIT-1 downto 0), ctrl_mux_out, OUTALU);


end Struct;


