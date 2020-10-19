library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity mux61 is
	Port (in_0, in_1, in_2, in_3, in_4, in_5:	In	std_logic;
		  sel:	In	std_logic_vector(2 downto 0);
		  y:	Out	std_logic);
end mux61;

architecture struct of mux61 is

		component mux21 is
			Port (in_1, in_0:	In	std_logic;
				  sel:	In	std_logic;
				  y:	Out	std_logic);
		end component mux21;

	signal mux1_out, mux2_out, mux3_out, mux4_out: std_logic;
begin

		mux1: mux21 port map(in_1, in_0, sel(0), mux1_out);
		mux2: mux21 port map(in_3, in_2, sel(0), mux2_out);
		mux3: mux21 port map(in_5, in_4, sel(0), mux3_out);
		mux4: mux21 port map(mux2_out, mux1_out, sel(1), mux4_out);
		mux5: mux21 port map(mux3_out, mux4_out, sel(2), y);			--if sel(2) is '1', sel(1) is a don't care

end struct;

