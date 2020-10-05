library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity MULTIPLIER_tb is
end MULTIPLIER_tb;


architecture TEST of MULTIPLIER_tb is

	-- MUL component declaration
	component boothmul is
		generic (numBit: integer := 32);
		port (
				  --  input	 
				  A_mp : in std_logic_vector(numBit-1 downto 0);
				  B_mp : in std_logic_vector(numBit-1 downto 0);

				  -- output
				  Y_mp : out std_logic_vector(2*numBit-1 downto 0) );
	end component;

  --constant numBit : integer := 32;    -- :=8  --:=16    

  --  input	 
  signal A_mp_i : std_logic_vector(numBit-1 downto 0);
  signal B_mp_i : std_logic_vector(numBit-1 downto 0);

  -- output
  signal Y_mp_i : std_logic_vector(2*numBit-1 downto 0);

begin

-- MUL instantiation
--
--
	dut: boothmul generic map(numBit) port map(A_mp_i, B_mp_i, Y_mp_i);

-- PROCESS FOR TESTING TEST - COMLETE CYCLE ---------
  test: process
  begin

    A_mp_i <= X"800000FA";
	B_mp_i <= x"0000000A";
    wait for 10 ns;
    A_mp_i <= X"0000001A";
	B_mp_i <= x"FFFFFFAA";
    wait for 10 ns;
    A_mp_i <= X"FFFFFFFF";
	B_mp_i <= x"FFFFFFFA";
    wait;          
  end process test;


end TEST;
