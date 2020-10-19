library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux81_generic is
    generic (NBIT: integer);
	port ( in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7: in std_logic_vector(NBIT-1 downto 0);
		   sel: in std_logic_vector(2 downto 0);
		   y: out std_logic_vector(NBIT-1 downto 0)
		 );
end mux81_generic;

architecture df of mux81_generic is

	component mux41_generic is
		generic (NBIT: integer);
		port ( in_0, in_1, in_2, in_3: in std_logic_vector(NBIT-1 downto 0);
			   sel: in std_logic_vector(1 downto 0);
			   y: out std_logic_vector(NBIT-1 downto 0)
			 );
	end component mux41_generic;

	component MUX21_GENERIC is
		generic ( NBIT: integer );
		Port (	in_1, in_0:	In	std_logic_vector(NBIT-1 downto 0);
				sel:	In	std_logic;
				y:	Out	std_logic_vector(NBIT-1 downto 0));
	end component MUX21_GENERIC;

	signal mux41_out0, mux41_out1: std_logic_vector(NBIT-1 downto 0);

begin

	mux41_comb1: mux41_generic generic map(NBIT) port map(in_0, in_1, in_2, in_3, sel(1 downto 0), mux41_out0);
	mux41_comb2: mux41_generic generic map(NBIT) port map(in_4, in_5, in_6, in_7, sel(1 downto 0), mux41_out1);
	mux21_comb: MUX21_GENERIC generic map(NBIT) port map(mux41_out1, mux41_out0, sel(2), y);

end df;
