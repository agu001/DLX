library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity iram_test is
end iram_test;

architecture test of iram_test is

	component IRAM is
	  generic (
		RAM_DEPTH : integer := 48;
		I_SIZE : integer := 32);
	  port (
		Rst  : in  std_logic;
		Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
		Dout : out std_logic_vector(I_SIZE - 1 downto 0)
		);

	end component IRAM;

	signal Rst: std_logic;
	signal Addr, Dout: std_logic_vector(31 downto 0);

begin

	dut: IRAM port map(Rst, Addr, Dout);

	Rst <= '1', '0' after 1 ns;

	CONTROL: process
        begin

		Addr <= X"00000000";
		wait for 1.5 ns;
		Addr <= X"00000001";
		wait for 1.5 ns;
		Addr <= X"00000004";
        wait;
        end process;

end test;
