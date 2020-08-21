library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.myTypes.all;

entity cu_test is
end cu_test;

architecture TEST of cu_test is

	component DLX is
		generic ( I_SIZE: natural := 32 );
		port ( IR: in std_logic_vector(I_SIZE-1 downto 0);
			   Clk, Rst: in std_logic
			 );
	end component DLX;

    signal Clk: std_logic := '1';
    signal Rst: std_logic := '1';

    signal IR: std_logic_vector(31 downto 0); 

begin

        -- instance of DLX
		dut: DLX port map (IR, Clk, Rst);

        Clk <= not Clk after 1 ns;
		Rst <= '1', '0' after 3 ns;


        CONTROL: process
        begin

        wait for 3.5 ns;  ----- be careful! the wait statement is ok in test
                        ----- benches, but do not use it in normal processes!
		--wait until Clk='0' and Clk'event;
        IR <= X"00221800";
		wait for 1 ns;		
		--wait until Clk='0' and Clk'event;		
		IR <= X"04050080";

        wait;
        end process;

end TEST;
