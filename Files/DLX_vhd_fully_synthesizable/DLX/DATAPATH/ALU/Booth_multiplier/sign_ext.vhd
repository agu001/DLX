library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity sign_ext is
	generic ( NBIT: integer := 32);
	port ( I: in std_logic_vector(NBIT-1 downto 0);
		   O: out std_logic_vector(2*NBIT-1 downto 0) );
end sign_ext;

architecture struct of sign_ext is

	component mux21_generic is
		generic(NBIT: integer);
        port(   a, b: in std_logic_vector(NBIT-1 downto 0);
                sel: in std_logic;
                y: out std_logic_vector(NBIT-1 downto 0)
        );
    end component;

	signal zeros, ones : std_logic_vector(NBIT-1 downto 0);
begin
	zeros <= (others => '0');
	ones <= (others => '1');
	mx: MUX21_GENERIC generic map(NBIT) port map ( ones, zeros, I(NBIT-1), O(2*NBIT-1 downto NBIT));
	O(NBIT-1 downto 0) <= I;
end struct;
