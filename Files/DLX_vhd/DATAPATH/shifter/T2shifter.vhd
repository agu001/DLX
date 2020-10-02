library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity T2shifter is
	port ( 	dataIN: in std_logic_vector(31 downto 0);
			shift: in std_logic_vector(4 downto 0);
			conf: in std_logic_vector(1 downto 0);
			dataOUT: out std_logic_vector(31 downto 0)
		 );
end entity T2shifter;

architecture Struct of T2shifter is

	component mux3x1 is
		port ( INPUT1, INPUT2, INPUT3: in std_logic_vector(39 downto 0);
			   SEL: in std_logic_vector(1 downto 0);
			   OUTPUT: out std_logic_vector(39 downto 0)
			 );
	end component mux3x1;

	component mux4x1 is
		port ( INPUT1, INPUT2, INPUT3, INPUT4: in std_logic_vector(39 downto 0);
			   SEL: in std_logic_vector(1 downto 0);
			   OUTPUT: out std_logic_vector(39 downto 0)
			 );
	end component mux4x1;

	component mux8x1 is
		port ( INPUT1, INPUT2, INPUT3, INPUT4, INPUT5, INPUT6, INPUT7, INPUT8: in std_logic_vector(31 downto 0);
			   SEL: in std_logic_vector(2 downto 0);
			   OUTPUT: out std_logic_vector(31 downto 0)
			 );
	end component mux8x1;

	component MUX21_GENERIC is
		generic(NBIT: integer := 32);
		Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
				B:	In	std_logic_vector(NBIT-1 downto 0);
				SEL:	In	std_logic;
				Y:	Out	std_logic_vector(NBIT-1 downto 0));
	end component MUX21_GENERIC;

	signal IN1_LR, IN1_AR, IN1_LAL, IN2_LR, IN2_AR, IN2_LAL, IN3_LR, IN3_AR, IN3_LAL, IN4_LR, IN4_AR, IN4_LAL: std_logic_vector(39 downto 0);
	signal ext_sign_in1, zero_in1: std_logic_vector(7 downto 0);
	signal ext_sign_in2, zero_in2: std_logic_vector(15 downto 0);
	signal ext_sign_in3, zero_in3: std_logic_vector(23 downto 0);
	signal ext_sign_in4, zero_in4: std_logic_vector(31 downto 0);

	signal MUX1_OUT_IN1, MUX1_OUT_IN2, MUX1_OUT_IN3, MUX1_OUT_IN4, MASK_OUT: std_logic_vector(39 downto 0);

	signal MUX2_OUT_IN1, MUX2_OUT_IN2, MUX2_OUT_IN3, MUX2_OUT_IN4, MUX2_OUT_IN5, MUX2_OUT_IN6, MUX2_OUT_IN7, MUX2_OUT_IN8: std_logic_vector(31 downto 0);

begin

	zero_in1 <= (others => '0');
	zero_in2 <= (others => '0');
	zero_in3 <= (others => '0');
	zero_in4 <= (others => '0');

	ext_sign_in1 <= ( others => dataIN(31) );
	ext_sign_in2 <= ( others => dataIN(31) );
	ext_sign_in3 <= ( others => dataIN(31) );
	ext_sign_in4 <= ( others => dataIN(31) );

	--MASK0
	IN1_LR <= zero_in1 & dataIN;
	IN1_AR <= ext_sign_in1 & dataIN;
	IN1_LAL <= dataIN & zero_in1;
	--MASK8
	IN2_LR <= zero_in2 & dataIN(31 downto 8);
	IN2_AR <= ext_sign_in2 & dataIN(31 downto 8);
	IN2_LAL <= dataIN(23 downto 0) & zero_in2;
	--MASK16
	IN3_LR <= zero_in3 & dataIN(31 downto 16);
	IN3_AR <= ext_sign_in3 & dataIN(31 downto 16);
	IN3_LAL <= dataIN(15 downto 0) & zero_in3;
	--MASK24
	IN4_LR <= zero_in4 & dataIN(31 downto 24);
	IN4_AR <= ext_sign_in4 & dataIN(31 downto 24);
	IN4_LAL <= dataIN(7 downto 0) & zero_in4;

	MUX_INPUT1: mux3x1 port map(IN1_LR, IN1_AR, IN1_LAL, conf, MUX1_OUT_IN1);
	MUX_INPUT2: mux3x1 port map(IN2_LR, IN2_AR, IN2_LAL, conf, MUX1_OUT_IN2);
	MUX_INPUT3: mux3x1 port map(IN3_LR, IN3_AR, IN3_LAL, conf, MUX1_OUT_IN3);
	MUX_INPUT4: mux3x1 port map(IN4_LR, IN4_AR, IN4_LAL, conf, MUX1_OUT_IN4);

	--second level
	MUX_L2: mux4x1 port map(MUX1_OUT_IN1, MUX1_OUT_IN2, MUX1_OUT_IN3, MUX1_OUT_IN4, shift(4 downto 3), MASK_OUT);

	--third level 1 left 0 right
	MUX_A: MUX21_GENERIC port map(MASK_OUT(32 downto 1), MASK_OUT(38 downto 7), conf(0), MUX2_OUT_IN1);
	MUX_B: MUX21_GENERIC port map(MASK_OUT(33 downto 2), MASK_OUT(37 downto 6), conf(0), MUX2_OUT_IN2);
	MUX_C: MUX21_GENERIC port map(MASK_OUT(34 downto 3), MASK_OUT(36 downto 5), conf(0), MUX2_OUT_IN3);
	MUX_D: MUX21_GENERIC port map(MASK_OUT(35 downto 4), MASK_OUT(35 downto 4), conf(0), MUX2_OUT_IN4);
	MUX_E: MUX21_GENERIC port map(MASK_OUT(36 downto 5), MASK_OUT(34 downto 3), conf(0), MUX2_OUT_IN5);
	MUX_F: MUX21_GENERIC port map(MASK_OUT(37 downto 6), MASK_OUT(33 downto 2), conf(0), MUX2_OUT_IN6);
	MUX_G: MUX21_GENERIC port map(MASK_OUT(38 downto 7), MASK_OUT(32 downto 1), conf(0), MUX2_OUT_IN7);
	MUX_X: MUX21_GENERIC port map(MASK_OUT(39 downto 8), MASK_OUT(31 downto 0), conf(0), MUX2_OUT_IN8);

	MUX_L3: mux8x1 port map(MUX2_OUT_IN8, MUX2_OUT_IN7, MUX2_OUT_IN6, MUX2_OUT_IN5, MUX2_OUT_IN4, MUX2_OUT_IN3, MUX2_OUT_IN2, MUX2_OUT_IN1, shift(2 downto 0), dataOUT);




end Struct;
