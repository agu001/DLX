library IEEE;
use IEEE.std_logic_1164.all;

entity Register_generic is
	generic(NBIT:integer := 32);
	Port (	D:	In	std_logic_vector(NBIT-1 downto 0);
			CK:	In	std_logic;
			RESET:	In	std_logic;
			EN: in std_logic;
			Q:	Out	std_logic_vector(NBIT-1 downto 0));
end entity;

architecture STRUCTURAL_2 of Register_generic is
	    component FD is
		Port (	D:	In	std_logic;
				CK:	In	std_logic;
				RESET:	In	std_logic;
				EN: in std_logic;
				Q:	Out	std_logic);
	end component FD;

begin

	G2: for i in 0 to NBIT-1 generate
			ffd2: FD port map (D(i), CK, RESET, EN, Q(i));
		end generate;

end architecture;




