library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.all;

entity register_file is
 generic (DATABIT: natural := 64;
		  ADDBIT: natural := 5);
 port ( CLK: 		IN std_logic;
         RESET: 	IN std_logic;
	 ENABLE: 	IN std_logic;
	 RD1: 		IN std_logic;
	 RD2: 		IN std_logic;
	 WR: 		IN std_logic;
	 ADD_WR: 	IN std_logic_vector(ADDBIT-1 downto 0);
	 ADD_RD1: 	IN std_logic_vector(ADDBIT-1 downto 0);
	 ADD_RD2: 	IN std_logic_vector(ADDBIT-1 downto 0);
	 DATAIN: 	IN std_logic_vector(DATABIT-1 downto 0);
     OUT1: 		OUT std_logic_vector(DATABIT-1 downto 0);
	 OUT2: 		OUT std_logic_vector(DATABIT-1 downto 0));
end register_file;

architecture BEH of register_file is

	type REG_ARRAY is array(0 to 2**ADDBIT-1) of std_logic_vector(DATABIT-1 downto 0);
	signal REGISTERS : REG_ARRAY;

begin

	process(CLK, RESET)
	begin

		if(CLK = '0' AND CLK'event) then
			if(RESET ='1') then
				REGISTERS <= (others => ( others =>'0')) after 0.2 ns;
				REGISTERS(5) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
				REGISTERS(2) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
				REGISTERS(3) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
				REGISTERS(10) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
				REGISTERS(9) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
				REGISTERS(7) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
				REGISTERS(8) <= std_logic_vector(to_unsigned(16, DATABIT)) after 0.2 ns;
				REGISTERS(12) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
				REGISTERS(15) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
				REGISTERS(20) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
				REGISTERS(30) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
				REGISTERS(13) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
				REGISTERS(14) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
				REGISTERS(18) <= std_logic_vector(to_unsigned(10, DATABIT)) after 0.2 ns;
			elsif( ENABLE = '1') then
				if (WR = '1' and ADD_WR /="00000") then
					REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN after 0.2 ns;
				end if;
			end if;
		end if;
	end process;

	OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1))) after 0.2 ns when(RD1 = '1' and ENABLE = '1');
	OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2))) after 0.2 ns when(RD2 = '1' and ENABLE = '1');

end BEH;

----


configuration CFG_RF_BEH of register_file is
  for BEH
  end for;
end configuration;
