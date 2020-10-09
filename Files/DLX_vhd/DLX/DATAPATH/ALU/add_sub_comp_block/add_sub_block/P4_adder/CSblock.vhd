library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.myTypes.all;

entity CSblock is
	generic(NBIT: integer );
	Port( A,B: in std_logic_vector(NBIT-1 downto 0);
		  Cin: in std_logic;
		  S: out std_logic_vector(NBIT-1 downto 0)
		);
end entity CSblock;

architecture STRUCTURAL of CSblock is
	component RCA is
	generic (NBIT :  integer;
			 DRCAS : Time := 0 ns;
	         DRCAC : Time := 0 ns);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
			B:	In	std_logic_vector(NBIT-1 downto 0);
			Ci:	In	std_logic;
			S:	Out	std_logic_vector(NBIT-1 downto 0));
	end component RCA;

	component MUX21_GENERIC is
	generic(NBIT: integer;
		   DELAY_MUX: time := tp_mux);
	Port (	in_1, in_0:	In	std_logic_vector(NBIT-1 downto 0);
			sel:	In	std_logic;
			y:	Out	std_logic_vector(NBIT-1 downto 0));
	end component MUX21_GENERIC;

	signal RCA1toMUX, RCA2toMUX: std_logic_vector(NBIT-1 downto 0);

begin

	RCA1: RCA generic map(NBIT, DRCAS, DRCAC) port map(A, B, '0', RCA1toMUX);
	RCA2: RCA generic map(NBIT, DRCAS, DRCAC) port map(A, B, '1', RCA2toMUX);
   MUX21: MUX21_GENERIC generic map(NBIT, tp_mux) port map (RCA2toMUX, RCA1toMUX, Cin, S);

end architecture;
