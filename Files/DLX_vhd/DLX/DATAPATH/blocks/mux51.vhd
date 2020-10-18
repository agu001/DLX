library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.myTypes.all;

entity mux51 is
	generic (NBIT: integer );
	port  (
			sel_s: in std_logic_vector(2 downto 0);
		  	in_0: in std_logic_vector(NBIT-1 downto 0);
			in_1: in std_logic_vector(NBIT-1 downto 0);
			in_2: in std_logic_vector(NBIT-1 downto 0);
			in_3: in std_logic_vector(NBIT-1 downto 0);
			in_4: in std_logic_vector(NBIT-1 downto 0);
			out_s:out std_logic_vector(NBIT-1 downto 0)
		);
end entity;

architecture beh of mux51 is

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

	signal mux41_out0: std_logic_vector(NBIT-1 downto 0);

BEGIN

	mux41_comb1: mux41_generic generic map(NBIT) port map(in_0, in_1, in_2, in_3, sel_s(1 downto 0), mux41_out0);
	mux21_comb: MUX21_GENERIC generic map(NBIT) port map(in_4, mux41_out0, sel_s(2), out_s);

	--process(sel_s, in_0, in_1, in_2, in_3, in_4)
	--begin
	--	case sel_s is
	--		when "000"  => out_s <= in_0; --  0
	--		when "001"  => out_s <= in_1; --  A
	--		when "010"  => out_s <= in_2; -- -A
	--		when "011"  => out_s <= in_3;  -- 2A
	--		when "100"  => out_s <= in_4; -- -2A
	--		when others => out_s <= (others=> '0');
	--	end case;
	--end process;
end architecture beh;

