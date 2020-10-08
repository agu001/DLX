library IEEE;
use IEEE.std_logic_1164.all;

entity FD is
	Port (	D:	In	std_logic;
			CK:	In	std_logic;
			RESET:	In	std_logic;
			EN: in std_logic;
			Q:	Out	std_logic);
end FD;


architecture PIPPO of FD is -- flip flop D with Asyncronous reset

begin
	PSYNCH: process(CK,RESET)
	begin
	    if RESET='1' then -- active high reset
	      Q <= '0';
	    elsif CK'event and CK='1' then -- positive edge triggered:
	    	if (EN='1') then
	      		Q <= D; -- input is written on output
	      	end if;
	    end if;
	end process;

end PIPPO;


