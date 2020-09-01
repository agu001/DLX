library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use WORK.alu_type.all;

entity ALU is
  generic (N : integer := 32);
  port 	 ( TYPE_OP: IN ALU_TYPE_OP;
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
P_ALU: process (TYPE_OP, DATA1, DATA2, INTD2)
  -- complete all the requested functions

  begin
	case TYPE_OP is
		when alu_DEFAULT	=>
		when alu_ADD	=>
			OUTALU <= DATA1+DATA2 after 1 ns;
		when alu_SUB	=>
			OUTALU <= DATA1-DATA2 after 1 ns;
		when alu_AND16	=>
			OUTALU <= DATA1(31 downto 16)&(DATA1(15 downto 0) and DATA2(15 downto 0)) after 1 ns; -- bitwise operations
		when alu_AND32	=>
			OUTALU <= DATA1 and DATA2 after 1 ns; -- bitwise operations
		when alu_OR16	=>
			OUTALU <= DATA1(31 downto 16)&(DATA1(15 downto 0) or DATA2(15 downto 0)) after 1 ns; -- bitwise operations
		when alu_OR32	=>
			OUTALU <= DATA1 OR DATA2 after 1 ns;
		when alu_SGE	=>
			OUTALU(31 downto 1) <= (others => '0');
			if (signed(DATA1) >= signed(DATA2)) then
				OUTALU(0) <= '1' after 1 ns;
			else
				OUTALU(0) <= '0' after 1 ns;
			end if;
		when alu_SLE	=>
			OUTALU(31 downto 1) <= (others => '0');
			if (signed(DATA1) <= signed(DATA2)) then
				OUTALU(0) <= '1' after 1 ns;
			else
				OUTALU(0) <= '0' after 1 ns;
			end if;
		when alu_SLL	=>
			OUTALU <= std_logic_vector((signed(DATA1)) srl intd2) after 1 ns;
		when alu_SNE	=>
			OUTALU(31 downto 1) <= (others => '0');
			if (signed(DATA1) /= signed(DATA2)) then
				OUTALU(0) <= '1' after 1 ns;
			else
				OUTALU(0) <= '0' after 1 ns;
			end if;
		when alu_SRL	=>
			OUTALU <= std_logic_vector((signed(DATA1)) srl intd2) after 1 ns;
		when alu_XOR16	=>
			OUTALU <= DATA1(31 downto 16)&(DATA1(15 downto 0) xor DATA2(15 downto 0)) after 1 ns; -- bitwise operations
		when alu_XOR32	=>
			OUTALU <= DATA1 XOR DATA2 after 1 ns;
	end case;









--    --case FUNC is
--	when ADD 	=> OUTALU <= DATA1+DATA2 after 1 ns;
--	when SUB 	=> OUTALU <= DATA1-DATA2 after 1 ns;
--	--when MULT 	=> OUTALU <= DATA1(N/2-1 downto 0)*DATA2(N/2-1 downto 0);
--	when BITAND 	=> OUTALU <= DATA1 and DATA2 after 1 ns; -- bitwise operations
--	when BITOR 	=> OUTALU <= DATA1 OR DATA2 after 1 ns;
--	when BITXOR 	=> OUTALU <= DATA1 XOR DATA2;
--	--when FUNCLSL 	=> OUTALU <= std_logic_vector(signed(DATA1) SLL intd2);
--		--OUTALU <= DATA1(N-1-intd2 downto 0)&zero(N-1 downto N-intd2); -- logical shift left, HELP: use the concatenation operator &
--	--when FUNCLSR 	=> OUTALU <= std_logic_vector(signed(DATA1) SRL intd2);
--					--OUTALU <= zero(intd2-1 downto 0)&DATA1(N-1 downto intd2); -- logical shift right
--	--when FUNCRL 	=> OUTALU <= std_logic_vector(signed(DATA1) ROL rd2);
--					--OUTALU <= DATA1(N-1-intd2 downto 0)&DATA1(N-1 downto N-intd2); -- rotate left
--	--when FUNCRR 	=> OUTALU <= std_logic_vector(signed(DATA1) ROR rd2);
--					--OUTALU <= DATA1(intd2-1 downto 0)&DATA1(N-1 downto intd2); -- rotate right
--	when others => OUTALU <= (others => '0');
--    end case;
  end process P_ALU;

end BEHAVIOR;

configuration CFG_ALU_BEHAVIORAL of ALU is
  for BEHAVIOR
  end for;
end CFG_ALU_BEHAVIORAL;
