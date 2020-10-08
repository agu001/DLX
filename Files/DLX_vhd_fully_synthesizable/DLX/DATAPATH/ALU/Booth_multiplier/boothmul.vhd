library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity boothmul is
	generic (numBit: integer := 32);
	port (
			  --  input
			  A_mp : in std_logic_vector(numBit-1 downto 0);
			  B_mp : in std_logic_vector(numBit-1 downto 0);

			  -- output
			  Y_mp : out std_logic_vector(2*numBit-1 downto 0) );
end entity;

architecture struct of boothmul is

	component P4_ADDER is
			generic (
				NBIT :		integer := 64);
			port (
				A :		in	std_logic_vector(NBIT-1 downto 0);
				B :		in	std_logic_vector(NBIT-1 downto 0);
				Cin :	in	std_logic;
				S :		out	std_logic_vector(NBIT-1 downto 0);
				Cout :	out	std_logic);
	end component P4_ADDER;

	component mux21_generic is
		generic(NBIT: integer);
        port(   a, b: in std_logic_vector(NBIT-1 downto 0);
                sel: in std_logic;
                y: out std_logic_vector(NBIT-1 downto 0)
        );
    end component;

	component mux51 is
		generic (numB: integer := 64);
		port  (
				sel_s: in std_logic_vector(2 downto 0);
			  	in_0: in std_logic_vector(numB-1 downto 0);
				in_1: in std_logic_vector(numB-1 downto 0);
				in_2: in std_logic_vector(numB-1 downto 0);
				in_3: in std_logic_vector(numB-1 downto 0);
				in_4: in std_logic_vector(numB-1 downto 0);
				out_s:out std_logic_vector(numB-1 downto 0)
			);
	end component;

	component sign_ext is
		generic ( NBIT: integer := 32);
		port ( I: in std_logic_vector(NBIT-1 downto 0);
			   O: out std_logic_vector(2*NBIT-1 downto 0) );
	end component sign_ext;

	component Comp_2 is
		generic ( numBit: integer := 64 );
		port ( I: in std_logic_vector(numBit-1 downto 0);
			   O: out std_logic_vector(numBit-1 downto 0) );
	end component Comp_2;

	component encoder33 is
		port (in_s:in std_logic_vector(2 downto 0);
				out_s: out std_logic_vector(2 downto 0));
	end component;

	constant LEN: integer := 2*numBit;
	type enc2mux is array(numBit/2-1 downto 0) of std_logic_vector(2 downto 0);
	type mux_out is array(numBit/2-1 downto 0) of std_logic_vector(LEN-1 downto 0);
	type sum_out is array(numBit/2-1 downto 0) of std_logic_vector(LEN-1 downto 0);
	type shift_A is array(numBit-1 downto 0) of std_logic_vector(LEN-1 downto 0);
	signal enc2mux_s: enc2mux;
	signal mux_out_s: mux_out;
	signal sum_out_s: sum_out;
	signal Bbar_s, B_muxout: std_logic_vector(numBit-1 downto 0);
	signal Pbar_s: std_logic_vector(LEN - 1 downto 0);
	--signal zero: std_logic_vector(numBit-1 downto 0) := (others => '0');
	--signal one: std_logic_vector(numBit-1 downto 0) := (others => '1');
	signal A_s, Abar_s: shift_A;
	signal B_init: std_logic_vector(2 downto 0);
	signal sel_result: std_logic;
begin


	--sel_result <= A_mp(numBit-1) XOR B_mp(numBit-1);

	s_e: sign_ext generic map(numBit) port map(A_mp, A_s(0));
	--A_s(0) <= zero(numBit-1 downto 0) & A_mp; --segnale A su 64 bit

	C2: Comp_2 generic map (LEN) port map(A_s(0), Abar_s(0)); --complemento a due di A

	comp_B: Comp_2 generic map(numBit) port map(B_mp, Bbar_s);
	mux_enc: MUX21_GENERIC generic map(numBit) port map(Bbar_s, B_mp, B_mp(numBit-1), B_muxout);

	B_init <= B_muxout(1 downto 0)&'0';
	encoder: encoder33 port map(B_init, enc2mux_s(0)); --primo encoder

	A_s(1) <= A_s(0)(LEN-2 downto 0)&'0';
	Abar_s(1) <= Abar_s(0)(LEN-2 downto 0)&'0';
	MUX_1: mux51 generic map (LEN) port map( enc2mux_s(0),
						   (others=>'0') ,
						   A_s(0),
						   Abar_s(0),
						   A_s(1),
						   Abar_s(1),
						   mux_out_s(0) );



	create: for i in 1 to numBit/2-1 generate

				encoder_i: encoder33 port map( B_muxout(2*i+1 downto 2*i-1), enc2mux_s(i));
				A_s(2*i) <= A_s(2*i-1)(LEN-2 downto 0)&'0';
				Abar_s(2*i) <= Abar_s(2*i-1)(LEN-2 downto 0)&'0';
				A_s(2*i+1) <= A_s(2*i)(LEN-2 downto 0)&'0';
				Abar_s(2*i+1) <= Abar_s(2*i)(LEN-2 downto 0)&'0';

				MUX_1: mux51 generic map(LEN) port map( 	enc2mux_s(i), (others=>'0') ,
						   				A_s(2*i),
						   				Abar_s(2*i),
						   				A_s(2*i+1),
						   				Abar_s(2*i+1),
						   				mux_out_s(i) );

				first_sum: 	if( i = 1) generate
								sum_i_f: P4_ADDER generic map(LEN) port map(mux_out_s(i), mux_out_s(i-1), '0', sum_out_s(1), open);
							end generate;
				gen_sum:	if( i /= 1 and i /= numBit/2-1) generate
								sum_i_g: P4_ADDER generic map(LEN) port map(mux_out_s(i), sum_out_s(i-1), '0', sum_out_s(i), open);
							end generate;
				gen_sum_end:if( i = numBit/2-1) generate
								sum_i_end: P4_ADDER generic map(LEN) port map(mux_out_s(i), sum_out_s(i-1), '0', sum_out_s(i), open);
								comp_P: Comp_2 generic map(LEN) port map(sum_out_s(i), Pbar_s);
								mux_enc: MUX21_GENERIC generic map(LEN) port map(Pbar_s, sum_out_s(i), B_mp(numBit-1), Y_mp);
							end generate;

			end generate;


end architecture struct;
