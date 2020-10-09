library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.myTypes.all; -- libreria WORK user-defined

entity CARRY_GENERATOR is
	generic( NBIT: integer;
			 NBIT_PER_BLOCK : integer);
	port( A: in std_logic_vector(NBIT-1 downto 0);
			B: in std_logic_vector(NBIT-1 downto 0);
			Cin: std_logic;
		    Co: out std_logic_vector((NBIT/NBIT_PER_BLOCK)-1 downto 0)
		);
end entity CARRY_GENERATOR;

architecture STRUCT of CARRY_GENERATOR is

	component PG is
		port( PGin1, PGin2: in std_logic_vector(1 downto 0);
					 PGout: out std_logic_vector(1 downto 0)
			);
	end component PG;

	component G is
		port( PGin: in std_logic_vector(1 downto 0);
			   Gin: in std_logic;
			  Gout: out std_logic
			);
	end component G;

	component PGnet is
		port( a,b: in std_logic;
			   pg: out std_logic_vector(1 downto 0)
			);
	end component PGnet;

	component BUF1 is
		port(I: in std_logic;
			 O: out std_logic);
	end component BUF1;

	component BUF is
		generic(NBIT: integer);
		port(I: in std_logic_vector(NBIT-1 downto 0);
		 	 O: out std_logic_vector(NBIT-1 downto 0));
	end component BUF;

	constant NUM_CARRY: integer := integer(ceil(log2(real(NBIT/NBIT_PER_BLOCK))));
	constant INIT_CYCLE: integer := integer(ceil(log2(real(NBIT_PER_BLOCK))));

	type row is array(NBIT-1 downto 0) of std_logic_vector(1 downto 0);
    type fitrow is array(NBIT/NBIT_PER_BLOCK-1 downto 0) of std_logic_vector(1 downto 0);
	type matrix is array(INIT_CYCLE downto 0) of row;
	type fitmatrix is array(NUM_CARRY downto 0) of fitrow;

	signal mx: matrix;
	signal fm: fitmatrix;
	signal pg_G: std_logic_vector(1 downto 0);
begin


PGnetwork:	for i in 0 to NBIT-1 generate
			i0:	if( i = 0 ) generate
					PGnet_i0: PGnet port map(A(i), B(i), pg_G);
					Gnet_i0: G port map(pg_G, Cin, mx(0)(i)(0));
				end generate;
			in0:if( i /= 0 ) generate
					PGnet_i: PGnet port map(A(i), B(i), mx(0)(i));
				end generate;
			end generate;
--init part
exter:	for k in 1 to INIT_CYCLE generate
firstrow:	for i in 0 to NBIT/(2**k)-1 generate
				--utilizzo una prima matrice
				z0:if i=0 and k/=INIT_CYCLE generate
				  		G_mx0: G port map(PGin => mx(k-1)(2*i+1),Gin => mx(k-1)(2*i)(0),Gout => mx(k)(i)(0));
					 end generate;
			  noz0:if i /= 0 and k/=INIT_CYCLE generate
						PG_mx0: PG port map(PGin1 => mx(k-1)(2*i+1),PGin2 => mx(k-1)(2*i),PGout => mx(k)(i));
					end generate;
				--inizializzo seconda matrice
				z:if i=0 and k=INIT_CYCLE generate
				  		G_fm0: G port map(PGin => mx(k-1)(2*i+1),Gin => mx(k-1)(2*i)(0),Gout => fm(0)(i)(0));
					 end generate;
			  noz:if i /= 0 and k=INIT_CYCLE generate
						PG_fm0: PG port map(PGin1 => mx(k-1)(2*i+1),PGin2 => mx(k-1)(2*i),PGout => fm(0)(i));
					end generate;
			end generate;
		end generate;

--carry computation
c_ex:		for i in 1 to NUM_CARRY generate
cycle1:			for j in 0 to NBIT/NBIT_PER_BLOCK-1 generate
					r: if (j rem 2**i) < 2**i/2 generate
						  bb: BUF generic map(2) port map(I => fm(i-1)(j),O => fm(i)(j));
						end generate;
					r1d0: if (j rem 2**i >= 2**i/2) and (j < 2**i) generate
						gg:	G port map(PGin => fm(i-1)(j), Gin => fm(i-1)((2**(i-1))-1)(0),Gout => fm(i)(j)(0));
						  end generate;
					r1d1: if (j rem 2**i >= 2**i/2) and (j >= 2**i) generate
						pgpg: PG port map(PGin1 => fm(i-1)(j),PGin2 => fm(i-1)(j-(j rem ((2**i)/2)) -1),PGout =>  fm(i)(j));
						  end generate;
				end generate;
			end generate;

deliver_out: for i in 0 to NBIT/NBIT_PER_BLOCK-1 generate

				uscita: BUF1 port map(fm(NUM_CARRY)(i)(0), Co(i));
			 end generate;


end STRUCT;
