library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;

entity comparator_generic is
	generic (NBIT: integer);
	port ( A, B: in std_logic_vector(NBIT-1 downto 0);
		      Z: out std_logic
			);
end entity comparator_generic;

architecture Struct of comparator_generic is

	component XOR2 is
			port(	A, B: 	in std_logic;
					C:		out std_logic
				);
	end component XOR2;

	component OR2 is
			port(	A, B: 	in std_logic;
					C:		out std_logic
				);
	end component OR2;

	component IV is
		Port (	A:	In	std_logic;
				Y:	Out	std_logic);
	end component;

	signal xor_out: std_logic_vector(NBIT-1 downto 0);
	constant NUM_LEVEL: integer := integer(ceil(log2(real(NBIT))));
	type matrix is array(NUM_LEVEL-1 downto 0) of std_logic_vector(NBIT-1 downto 0);
	signal mx: matrix := (others => (others => '0'));
begin
	--funziona solo su multipli di 2, per ora
	xor_chain: for i in 0 to NBIT-1 generate
			   	xor_gen: XOR2 port map(A(i), B(i), xor_out(i));
			   end generate;

	or_gen:		for j in 0 to NUM_LEVEL-1 generate
					inner:  for i in 0 to ((NBIT/(2*(j+1)))-1) generate
								C_s_xor:if ( j = 0) generate
											or_s_xor_j_i: OR2 port map(xor_out(2*i), xor_out(2*i+1), mx(0)(i));
										end generate;
								Cmux: 	if ( j /= 0) generate
											or_mux_j_i: OR2 port map(mx(j-1)(2*i), mx(j-1)(2*i+1), mx(j)(i));
										end generate;
							end generate;
				end generate;

	iv_comp: IV port map(mx(NUM_LEVEL-1)(0), Z);

end Struct;
