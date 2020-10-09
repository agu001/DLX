library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use WORK.myTypes.all;

entity DRAM is
		generic (	DEPTH: natural;
					NBIT: natural;
					Td: time := 0.5 ns
				);
		port ( A: in std_logic_vector(NBIT-1 downto 0);
			   size: in std_logic_vector(1 downto 0);	--"01" if byte, "10" if half, "11" if word
			   X: in std_logic_vector(NBIT-1 downto 0);
			   Z: out std_logic_vector(NBIT-1 downto 0);
			   Rst, RM, WM, Clk, En: in std_logic
	  		 );
end DRAM;

architecture Beh of DRAM is

	subtype WordT is std_logic_vector(7 downto 0);
	type StorageT is array(0 to DEPTH-1) of WordT;
	signal Memory: StorageT;
	signal int_A: integer;

begin

	int_A <= to_integer(unsigned(A));
	WrProc: process(Clk)
			begin
				if (Clk'event and Clk='0') then
					if (Rst = '1') then
							Memory <= (others => (others => '0'));
							Memory(41) <= X"EE";
							Memory(42) <= X"EE";
							Memory(43) <= X"EE";
							Memory(44) <= X"EE";
							Memory(45) <= X"EE";
							Memory(46) <= X"EE";
							Memory(47) <= X"EE";
							Memory(48) <= X"EE";
							Memory(49) <= X"EE";
							Memory(50) <= X"EE";
							Memory(51) <= X"EE";
							Memory(52) <= X"EE";
					elsif (En = '1' and (int_A >= 0 and int_A <=DEPTH ) ) then
						if (WM = '1') then

							case size is
								when "01"	=>
									Memory(int_A) <= X(7 downto 0) after Td;
								when "10"	=>

									Memory(to_integer(unsigned(A))) <= X(15 downto 8) after Td;
									Memory(to_integer(unsigned(A)+1)) <= X(7 downto 0) after Td;
								when "11"	=>
									Memory(to_integer(unsigned(A))) <= X(BUS_WIDTH-1 downto 24) after Td;
									Memory(to_integer(unsigned(A)+1)) <= X(23 downto 16) after Td;
									Memory(to_integer(unsigned(A)+2)) <= X(15 downto 8) after Td;
									Memory(to_integer(unsigned(A)+3)) <= X(7 downto 0) after Td;

								when others =>
							end case;
						elsif (RM = '1') then
							Z <= Memory(int_A) & Memory(to_integer(unsigned(A)+1)) & Memory(to_integer(unsigned(A)+2)) & Memory(to_integer(unsigned(A)+3)) after Td;
						end if;
					end if;
				end if;
			end process;

end Beh;
