LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY lyon_multiplier IS
    GENERIC (
        ctrl_start : INTEGER := 0
    );
    PORT (
        clk            : IN std_logic;
        rst            : IN std_logic;
        ce             : IN std_logic;
        bypass         : IN std_logic;
        mul1           : IN std_logic;
        ctrl_delay     : IN std_logic_vector(15 DOWNTO 0);
        data_in        : IN std_logic;
        multiplicator  : IN std_logic_vector(15 DOWNTO 0);
        product_out    : OUT STD_LOGIC
    );
END lyon_multiplier;

ARCHITECTURE Behavioral OF lyon_multiplier IS

    COMPONENT partial_product IS
        GENERIC (
            ctrl_start     : INTEGER
        );
        PORT (
            clk         : IN std_logic;
            rst         : IN std_logic;
            ce          : IN std_logic;
            ctrl_delay  : IN std_logic_vector(15 DOWNTO 0);
            data1_in    : IN std_logic;
            data2_in    : IN STD_LOGIC;
            data3_in    : IN std_logic;
            pp_out      : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT partial_product_last IS
        GENERIC (
            ctrl_start  : INTEGER
        );
        PORT (
            clk         : IN std_logic;
            rst         : IN std_logic;
            ce          : IN std_logic;
            ctrl_delay  : IN std_logic_vector(15 DOWNTO 0);
            data1_in    : IN std_logic;
            data2_in    : IN STD_LOGIC;
            data3_in    : IN std_logic;
            pp_out      : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Dff_regN_Nout IS
        GENERIC (N : INTEGER);
        PORT (
            D    : IN STD_LOGIC;
            clk  : IN STD_LOGIC;
            Q    : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            QN   : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Dff_reg1 IS
        PORT (
            D    : IN STD_LOGIC;
            clk  : IN STD_LOGIC;
            Q    : OUT STD_LOGIC;
            QN   : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT mux_in2 IS
        PORT (
            sel       : IN STD_LOGIC;

            data1_in  : IN STD_LOGIC;
            data2_in  : IN std_logic;
            data_out  : OUT std_logic
        );
    END COMPONENT;

    COMPONENT shifter IS
        PORT (
            clk       : IN STD_LOGIC;
            rst       : IN STD_LOGIC;
            ce        : IN STD_LOGIC;
            ctrl      : IN STD_LOGIC;
            data_in   : IN std_logic;
            data_out  : OUT std_logic
        );
    END COMPONENT;
    
    SIGNAL data_in_delay : std_logic_vector(15 DOWNTO 0);
    SIGNAL ndata_in_delay : std_logic_vector(15 DOWNTO 1);

    SIGNAL pp : std_logic_vector(15 DOWNTO 0);

    SIGNAL output_sel, ctrl_shifter : STD_LOGIC;
    SIGNAL data_output : STD_LOGIC;
BEGIN
    data_in_delay(0) <= data_in;
    --- buffer for data_in
    UDFF15 : Dff_regN_Nout
    GENERIC MAP(
        N => 15
    )
    PORT MAP(
        D           => data_in, 
        clk         => clk, 
        Q           => data_in_delay(15 DOWNTO 1), 
        QN          => ndata_in_delay(15 DOWNTO 1)
    );

    pp(0) <= multiplicator(0) AND data_in;

    GEN_PP : 
    FOR I IN 0 TO 13 GENERATE
        PPX : partial_product
        GENERIC MAP(
            ctrl_start  => (I + ctrl_start) MOD 16
        )
        PORT MAP(
            clk         => clk, 
            rst         => rst, 
            ce          => ce, 
            data1_in    => pp(I), 
            data2_in    => data_in_delay(I + 1), 
            data3_in    => multiplicator(I + 1), 
            ctrl_delay  => ctrl_delay, 
            pp_out      => pp(I + 1)
        );
    END GENERATE;

    PP_LAST : partial_product_last
    GENERIC MAP(
        ctrl_start  => (14 + ctrl_start) MOD 16
    )
    PORT MAP(
        clk         => clk, 
        rst         => rst, 
        ce          => ce, 
        data1_in    => pp(14), 
        data2_in    => ndata_in_delay(15), 
        data3_in    => multiplicator(15), 
        ctrl_delay  => ctrl_delay, 
        pp_out      => pp(15)
    );

    output_sel <= bypass and mul1;
    UMUX : mux_in2
    PORT MAP(
        sel       => output_sel, 
        data1_in  => pp(15), 
        data2_in  => data_in_delay(15), 
        data_out  => data_output
    );

    --- output
    ctrl_shifter <= ctrl_delay((15 + ctrl_start) MOD 16) and (not mul1) and bypass;
    USHIFTER_OUT : shifter
    PORT MAP(
        clk       => clk, 
        rst       => rst, 
        ce        => ce, 
        ctrl      => ctrl_shifter, 
        data_in   => data_output, 
        data_out  => product_out
    );

END Behavioral;
