library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.alu_package.all;
use work.myTypes.all;

entity branch_result is
	port( isbranch, zero_result, isbeqz: in std_logic;
		  branch_taken: out std_logic
		);
end branch_result;

architecture Struct of branch_result is

	component OR2 is
			port(	A, B: 	in std_logic;
					C:		out std_logic
				);
	end component OR2;

	component AND2 is
			port(	A, B: 	in std_logic;
					C:		out std_logic
				);
	end component AND2;

	component IV is
		Port (	A:	In	std_logic;
			Y:	Out	std_logic);
	end component IV;

	signal and1_1_out, and1_2_out, and2_1_out, and2_2_out, zero_res_n, isbeqz_n: std_logic;

begin

	isbeqz_neg: IV port map(isbeqz, isbeqz_n);
	zero_res_neg: IV port map(zero_result, zero_res_n);
	and1_1: AND2 port map(isbranch, zero_result, and1_1_out);
	and2_1: AND2 port map(isbranch, zero_res_n, and2_1_out);
	and1_2: AND2 port map(and1_1_out, isbeqz, and1_2_out);
	and2_2: AND2 port map(and2_1_out, isbeqz_n, and2_2_out);
	or1: OR2 port map(and1_2_out, and2_2_out, branch_taken);

end Struct;
