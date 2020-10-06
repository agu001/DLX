library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use WORK.constants.all; -- libreria WORK user-defined

entity T2_SHIFTER is
    port(   dataIn: in std_logic_vector(32-1 downto 0);
            shift: in std_logic_vector(4 downto 0);
            conf:   in std_logic_vector(1 downto 0);
            dataOut: out std_logic_vector(32-1 downto 0) );
end;

architecture struct of T2_SHIFTER is

    component mux21_generic is
		generic(NBIT: integer;
		    	DELAY_MUX: time := tp_mux);
        port(   in_1, in_0: in std_logic_vector(NBIT-1 downto 0);
                sel: in std_logic;
                y: out std_logic_vector(NBIT-1 downto 0)
        );
    end component;

    component mux41_generic is
        generic(NBIT: integer);
        port(   in_0, in_1, in_2, in_3: in std_logic_vector(NBIT-1 downto 0);
                sel: in std_logic_vector(1 downto 0);
                y: out std_logic_vector(NBIT-1 downto 0)
        );
    end component;

    component mux81_generic is
        generic(NBIT: integer);
        port(   in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7: in std_logic_vector(NBIT-1 downto 0);
                sel: in std_logic_vector(2 downto 0);
                y: out std_logic_vector(NBIT-1 downto 0)
        );
    end component;

    type SH_BY8_MASKS is array (0 to 3) of std_logic_vector(32+7-1 downto 0);
    signal M, ML, MR: SH_BY8_MASKS;

    type SH_BY1_MASKS is array (0 to 7) of std_logic_vector(32-1 downto 0);
    signal S: SH_BY1_MASKS;

    signal SH_BY8_BUF: std_logic_vector(32+7-1 downto 0);
    signal zeros7, msbs7: std_logic_vector(6 downto 0);
    signal zeros8, msbs8: std_logic_vector(7 downto 0);
    signal msbs_at_1, sel_1s: std_logic;
    signal sel_2s: std_logic_vector(1 downto 0);
    signal sel_3s_r, sel_3s_l, sel_3s: std_logic_vector(2 downto 0);
begin

    msbs_at_1 <= conf(1) and datain(31);            -- (1) 0 -> logic ; 1 -> arithmetic
    sel_1s <= conf(0);                              -- (0) 0 -> right ; 1 -> left
    sel_2s <= shift(4 downto 3);
    sel_3s_r <= shift(2 downto 0);                  --in case of shift right
    sel_3s_l <= not shift(2 downto 0);              --in case of shift left (negated bits)

    zeros7 <= (others => '0');
    zeros8 <= (others => '0');
    msbs8_mux: mux21_generic generic map (8, tp_mux) port map (X"FF", zeros8, msbs_at_1, msbs8);
    msbs7 <= msbs8(6 downto 0);

    --FIRST STAGE--
    MR(0) <= msbs7 & dataIn;
    ML(0) <= dataIn & zeros7;

    --SECOND STAGE--
    sh_by8_generate:
    for i in 0 to 3 generate
        sh_by8_mux_MX: mux21_generic generic map (32+7, tp_mux) port map (ML(i), MR(i), sel_1s, M(i));
        innerIf: if (i /= 3) generate
            MR(i+1) <= msbs8 & M(i)(32+7-1 downto 8);
            ML(i+1) <= M(i)(32-2 downto 0) & zeros8;
        end generate innerIf;
    end generate sh_by8_generate;

    stage2_mux: mux41_generic generic map (32+7) port map (M(0), M(1), M(2), M(3), sel_2s, SH_BY8_BUF);

    --THIRD STAGE--
    sh_by1_generate:
    for i in 0 to 7 generate
        S(i) <= SH_BY8_BUF((i+31) downto i);
    end generate sh_by1_generate;

    stage3_sel_3s_mux: mux21_generic generic map (3, tp_mux) port map (sel_3s_l, sel_3s_r, sel_1s, sel_3s);
    stage3_mux: mux81_generic generic map (32) port map (S(0), S(1), S(2), S(3), S(4), S(5), S(6), S(7), sel_3s, dataOut);

end struct;
