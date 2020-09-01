library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity DRAM is
	generic (	n: natural := 16;
				p: natural := 256;
				k: natural := 8;
				Td: time := 0.5 ns
			);
	port ( X: in std_logic_vector(n-1 downto 0);
		   A: in std_logic_vector(k-1 downto 0);
		   Z: out std_logic_vector(n-1 downto 0);
		   Rst, RM, WM, Clk, En: in std_logic
  		 );
end DRAM;

architecture Beh of DRAM is

	subtype WordT is std_logic_vector(n-1 downto 0);
	type StorageT is array(0 to p-1) of WordT;
	signal Memory: StorageT;

begin

	WrProc: process(Clk)
			begin
				if (Clk'event and Clk='0') then
					if (Rst = '1') then
							Memory <= (others => (others => '0'));
					elsif (En = '1') then
						if (WM = '1') then
							Memory(to_integer(unsigned(A))) <= X after Td;
						elsif (RM = '1') then
							Z <= Memory(to_integer(unsigned(A))) after Td;
						end if;
					end if;
				end if;
			end process;

--	RdProc: process(RM, A, Memory)
--			begin
--				if (RM = '1' and En = '1') then
--					Z <= Memory(to_integer(unsigned(A))) after Td;
--				end if;
--			end process;

end Beh;
