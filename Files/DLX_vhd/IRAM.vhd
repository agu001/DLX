library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;


-- Instruction memory for DLX
-- Memory filled by a process which reads from a file
-- file name is "test.asm.mem"
entity IRAM is
  generic ( DEPTH : integer;
    		NBIT : integer);
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(NBIT - 1 downto 0);
    Dout : out std_logic_vector(NBIT - 1 downto 0)
    );

end IRAM;

architecture IRam_Bhe of IRAM is

  type RAMtype is array (0 to DEPTH - 1) of integer;-- std_logic_vector(NBIT - 1 downto 0);

  signal IRAM_mem : RAMtype;
  signal AddrShifted, Dout_temp: std_logic_vector(NBIT-1 downto 0);

begin  -- IRam_Bhe

	AddrShifted <= "00" & Addr(NBIT-1 downto 2);
	Dout_temp <= conv_std_logic_vector(IRAM_mem(conv_integer(unsigned(AddrShifted))),NBIT);
	Dout <= Dout_temp when (Dout_temp /= X"80000000") else
			X"54000000";
  -- purpose: This process is in charge of filling the Instruction RAM with the firmware
  -- type   : combinational
  -- inputs : Rst
  -- outputs: IRAM_mem
  FILL_MEM_P: process (Rst)
    file mem_fp: text;
    variable file_line : line;
    variable index : integer := 0;
    variable tmp_data_u : std_logic_vector(NBIT-1 downto 0);
  begin  -- process FILL_MEM_P
    if (Rst = '0') then
      file_open(mem_fp,"./asm_example/JUMP_BRANCH_ISSUE.asm.mem",READ_MODE);
      while (not endfile(mem_fp)) loop
        readline(mem_fp,file_line);
        hread(file_line,tmp_data_u);
        IRAM_mem(index) <= conv_integer(unsigned(tmp_data_u));
        index := index + 1;
      end loop;
    end if;
  end process FILL_MEM_P;

--	RdProc: process(Addr, IRAM_mem)
--			variable index: integer := 0;
--			begin
--				if (Rst = '0') then
--					index := conv_integer(unsigned(Addr));
--					Dout <= IRAM_mem(index) after 0.3 ns;
--				end if;
--			end process;

end IRam_Bhe;
