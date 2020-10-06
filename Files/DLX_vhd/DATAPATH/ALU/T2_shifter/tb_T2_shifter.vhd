library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity TB is
end TB;

architecture TestBench of TB is

    component T2_SHIFTER is
        port(   dataIn: in std_logic_vector(32-1 downto 0);
            shift: in std_logic_vector(4 downto 0);
            conf:   in std_logic_vector(1 downto 0);
            dataOut: out std_logic_vector(32-1 downto 0) );
    end component;

  signal dataIN: std_logic_vector(31 downto 0);
  signal shift: std_logic_vector(4 downto 0);
  signal conf: std_logic_vector(1 downto 0);
  signal dataOUT: std_logic_vector(31 downto 0);

begin

  dut: T2_shifter port map (DataIN, shift, conf, dataOUT);

  --conf
  -- (1) 0 -> logic ; 1 -> arithmetic
  -- (0) 0 -> right ; 1 -> left
  process
  begin
  ---------------------------------
    dataIN <= X"00000001";
    shift <= "00000";
    conf <= "01";
    wait for 1 ns;
    dataIN <= X"00000001";
    shift <= "00111";
    conf <= "01";
    wait for 1 ns;
    dataIN <= X"00000001";
    shift <= "01000";
    conf <= "01";
    wait for 1 ns;
    dataIN <= X"00000001";
    shift <= "11111";
    conf <= "01";
    wait for 1 ns;
    --------------------------------------------------
    dataIN <= X"80000000";
    shift <= "00000";
    conf <= "00";
    wait for 1 ns;
    dataIN <= X"80000000";
    shift <= "00111";
    conf <= "00";
    wait for 1 ns;
    dataIN <= X"80000000";
    shift <= "01000";
    conf <= "00";
    wait for 1 ns;
    dataIN <= X"80000000";
    shift <= "11111";
    conf <= "00";
    wait for 1 ns;
    ---------------------------------------------
    dataIN <= X"FFFFFFFF";
    shift <= "00000";
    conf <= "00";
    wait for 1 ns;
    dataIN <= X"FFFFFFFF";
    shift <= "00111";
    conf <= "00";
    wait for 1 ns;
    dataIN <= X"FFFFFFFF";
    shift <= "01000";
    conf <= "00";
    wait for 1 ns;
    dataIN <= X"FFFFFFFF";
    shift <= "11111";
    conf <= "00";
    wait for 1 ns;
    ---------------------------------------------
    dataIN <= X"FFFFFFFF";
    shift <= "00000";
    conf <= "01";
    wait for 1 ns;
    dataIN <= X"FFFFFFFF";
    shift <= "00111";
    conf <= "01";
    wait for 1 ns;
    dataIN <= X"FFFFFFFF";
    shift <= "01000";
    conf <= "01";
    wait for 1 ns;
    dataIN <= X"FFFFFFFF";
    shift <= "11111";
    conf <= "01";
    wait for 1 ns;
    ---------------------------------------------
    conf <= "11";
    wait for 1 ns;
    shift <= "01111";
    wait for 1 ns;
    dataIN <= X"0F000000";
    conf <= "00";
    shift <= "11111";
    wait for 1 ns;
    dataIN <= X"0F000000";
    conf <= "00";
    shift <= "00111";
    wait for 1 ns;
    dataIN <= X"0F000000";
    conf <= "10";
    shift <= "00111";
    wait for 1 ns;
    dataIN <= X"80000000";
    conf <= "00";
    shift <= "11111";
    wait for 1 ns;
    dataIN <= X"80000000";
    conf <= "00";
    shift <= "10001";
    wait for 1 ns;
    dataIN <= X"80000000";
    conf <= "10";
    shift <= "11111";
    wait for 1 ns;
    dataIN <= X"80000000";
    conf <= "10";
    shift <= "00110";

    wait;
  end process;
end TestBench;
