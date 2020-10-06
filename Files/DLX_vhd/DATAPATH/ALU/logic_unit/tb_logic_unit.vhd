library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use work.constants.all;

entity TB is
end TB;

architecture TestBench of TB is

	component logic_unit is
	  	port(	logic_op: IN std_logic_vector(2 downto 0);
	  			ctrl_16: IN std_logic;					--0->32, 1->16
				DATA1, DATA2: IN std_logic_vector(NBIT-1 downto 0);
				Y: OUT std_logic_vector(NBIT-1 downto 0));
	end component logic_unit;

  signal DATA1, DATA2: std_logic_vector(31 downto 0);
  signal logic_op: std_logic_vector(2 downto 0);
  signal ctrl_16: std_logic;
  signal Y: std_logic_vector(31 downto 0);

begin

  dut: logic_unit port map (logic_op, ctrl_16, DATA1, DATA2, Y);


  process
  begin
  ---------------------------------
	DATA1 <= X"F0F0F0F0";
	DATA2 <= X"F00FF00F";
	ctrl_16 <= '0';			--32
    logic_op <= "001";--xor
    wait for 10 ns;
    logic_op <= "010";--or
    wait for 10 ns;
    logic_op <= "100";--and
    wait for 10 ns;			--16
    ctrl_16 <= '1';
    logic_op <= "001";--xor
    wait for 10 ns;
    logic_op <= "010";--or
    wait for 10 ns;
    logic_op <= "100";--and
    wait for 10 ns;

    ctrl_16 <= '0';
    DATA2 <= X"FFFFFFFF";
    logic_op <= "001";--xor
    wait for 10 ns;
    logic_op <= "010";--or
    wait for 10 ns;
    logic_op <= "100";--and
    wait for 10 ns;
    ctrl_16 <= '1';
    logic_op <= "001";--xor
    wait for 10 ns;
    logic_op <= "010";--or
    wait for 10 ns;
    logic_op <= "100";--and
    wait for 10 ns;

    ctrl_16 <= '0';
    DATA2 <= X"00000000";
    logic_op <= "001";--xor
    wait for 10 ns;
    logic_op <= "010";--or
    wait for 10 ns;
    logic_op <= "100";--and
    wait for 10 ns;
    ctrl_16 <= '1';
    logic_op <= "001";--xor
    wait for 10 ns;
    logic_op <= "010";--or
    wait for 10 ns;
    logic_op <= "100";--and
    wait for 10 ns;

    wait;
  end process;
end TestBench;
