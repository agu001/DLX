library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.myTypes.all;

	entity BTB is
		port (	PC_from_fetch, PC_from_exe, target_to_save: in std_logic_vector(BUS_WIDTH-1 downto 0);
				ISBRANCH, branch_was_taken, clk, rst: in std_logic;
				predict_taken: out std_logic;
				target_out: out std_logic_vector(BUS_WIDTH-1 downto 0)
			);
	end BTB;

architecture beh of BTB is

	constant BIT_ADDRESS_BTB: integer := 5;
	type rf_target is array(0 to 2**BIT_ADDRESS_BTB-1) of std_logic_vector(BUS_WIDTH-1 downto 0);
	--type rf_pc is array(0 to 2**BIT_ADDRESS_BTB-1) of std_logic_vector(BUS_WIDTH-3 downto 0);
	type rf_pred is array(0 to 2**BIT_ADDRESS_BTB-1) of std_logic_vector(1 downto 0);
	--type rf_pred is array(0 to 2**BIT_ADDRESS_BTB-1) of std_logic;


	--signal pc_mem: rf_pc;
	signal target_mem: rf_target;
	signal predict_mem: rf_pred;
	signal dirty_bit: std_logic_vector(0 to 2**BIT_ADDRESS_BTB-1);
	signal INDEX_FETCH, INDEX_EXE: integer;

	--signal prediction_temp: std_logic;

begin

	INDEX_FETCH <= to_integer(unsigned(PC_from_fetch(BIT_ADDRESS_BTB-1 downto 2)));
	INDEX_EXE <= to_integer(unsigned(PC_from_exe(BIT_ADDRESS_BTB-1 downto 2)));


	fetch_stage:
	process(rst, clk)
	begin
		if (rst = '1') then
			predict_taken <= '0';
			target_out <= (others => 'Z');
		elsif (clk = '0' and clk'event) then
			if ( dirty_bit(INDEX_FETCH) = '1' ) then
				if (predict_mem(INDEX_FETCH) = "00" or predict_mem(INDEX_FETCH) = "01") then
					predict_taken <= '0';
				else
					predict_taken <= '1';
				end if;
				target_out <= target_mem(INDEX_FETCH);
			else
				predict_taken <= '0';
			end if;
		end if;
	end process;

	execute_stage:
	process(rst, clk)
		variable predict: integer;
	begin
		if(rst = '1') then
			target_mem <= (others => (others => 'Z'));
			predict_mem <= (others => (others => 'Z'));
			dirty_bit <= (others => '0');
		elsif (clk = '0' and clk'event) then
			if (ISBRANCH = '1') then
				if ( target_mem(INDEX_EXE) /= target_to_save or dirty_bit(INDEX_EXE) = '0') then
					target_mem(INDEX_EXE) <= target_to_save;
					predict_mem(INDEX_EXE) <= "00";
					dirty_bit(INDEX_EXE) <= '1';
				end if;
				predict := to_integer(unsigned(predict_mem(INDEX_EXE)));
				if ( branch_was_taken = '1' and predict/= 3 ) then
					predict_mem(INDEX_EXE) <= std_logic_vector(to_unsigned(predict+1, 2));
				end if;
				if ( branch_was_taken = '0' and predict/= 0 ) then
					predict_mem(INDEX_EXE) <= std_logic_vector(to_unsigned(predict-1, 2));
				end if;
			end if;
		end if;
	end process;

end beh;
