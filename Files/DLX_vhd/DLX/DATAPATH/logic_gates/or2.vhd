library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.myTypes.all;

entity OR2 is
		port(	A, B: 	in std_logic;
				C:		out std_logic
			);
end entity;

architecture df of OR2 is
	component ND2 is
		Port (	A:	In	std_logic;
				B:	In	std_logic;
				Y:	Out	std_logic);
	end component;

	component IV is
		Port (	A:	In	std_logic;
				Y:	Out	std_logic);
	end component;

	signal A_n, B_n: std_logic;
begin
	iva: IV port map (A, A_n);
	ivb: IV port map (B, B_n);
	nd: ND2 port map (A_n, B_n, C);
end architecture;
