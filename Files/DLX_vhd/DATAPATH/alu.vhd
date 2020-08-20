library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use WORK.alu_type.all;

entity ALU is
  generic (N : integer := 32);
  port 	 ( FUNC: IN TYPE_OP;
           DATA1, DATA2: IN std_logic_vector(N-1 downto 0);
           OUTALU: OUT std_logic_vector(N-1 downto 0));
end ALU;

architecture BEHAVIOR of ALU is
	signal zero: std_logic_vector(N-1 downto 0);
	signal intd2, rd2: integer;
begin
	intd2 <= to_integer(unsigned(DATA2));
	rd2 <= to_integer(unsigned(DATA2)) rem N;
	zero <= (others => '0');
P_ALU: process (FUNC, DATA1, DATA2, INTD2)
  -- complete all the requested functions

  begin
    case FUNC is
	when ADD 	=> OUTALU <= DATA1+DATA2; 
	when SUB 	=> OUTALU <= DATA1-DATA2;
	--when MULT 	=> OUTALU <= DATA1(N/2-1 downto 0)*DATA2(N/2-1 downto 0);
	when BITAND 	=> OUTALU <= DATA1 and DATA2; -- bitwise operations
	when BITOR 	=> OUTALU <= DATA1 OR DATA2;
	--when BITXOR 	=> OUTALU <= DATA1 XOR DATA2;
	--when FUNCLSL 	=> OUTALU <= std_logic_vector(signed(DATA1) SLL intd2);
		--OUTALU <= DATA1(N-1-intd2 downto 0)&zero(N-1 downto N-intd2); -- logical shift left, HELP: use the concatenation operator &  
	--when FUNCLSR 	=> OUTALU <= std_logic_vector(signed(DATA1) SRL intd2);
					--OUTALU <= zero(intd2-1 downto 0)&DATA1(N-1 downto intd2); -- logical shift right
	--when FUNCRL 	=> OUTALU <= std_logic_vector(signed(DATA1) ROL rd2);
					--OUTALU <= DATA1(N-1-intd2 downto 0)&DATA1(N-1 downto N-intd2); -- rotate left
	--when FUNCRR 	=> OUTALU <= std_logic_vector(signed(DATA1) ROR rd2);
					--OUTALU <= DATA1(intd2-1 downto 0)&DATA1(N-1 downto intd2); -- rotate right
	when others => OUTALU <= (others => '0');
    end case; 
  end process P_ALU;

end BEHAVIOR;

configuration CFG_ALU_BEHAVIORAL of ALU is
  for BEHAVIOR
  end for;
end CFG_ALU_BEHAVIORAL;
