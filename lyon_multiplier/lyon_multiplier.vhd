LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY lyon_multiplier IS
    GENERIC (
        multiplicator : INTEGER
    );
    PORT (
        clk          : IN std_logic;
        rst          : IN std_logic;
        ce           : IN std_logic;
        ctrl         : IN STD_LOGIC;
        data_in      : IN std_logic;
        product_out  : OUT STD_LOGIC
    );
END lyon_multiplier;

ARCHITECTURE Behavioral OF lyon_multiplier IS

    COMPONENT partial_product IS
        PORT (
            clk       : IN std_logic;
            rst       : IN std_logic;
            ce        : IN std_logic;
            ctrl      : IN STD_LOGIC;
            data1_in  : IN std_logic;
            data2_in  : IN STD_LOGIC;
            data3_in  : IN std_logic;
            pp_out    : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT partial_product_last IS
        PORT (
            clk       : IN std_logic;
            rst       : IN std_logic;
            ce        : IN std_logic;
            ctrl      : IN STD_LOGIC;
            data1_in  : IN std_logic;
            data2_in  : IN STD_LOGIC;
            data3_in  : IN std_logic;
            pp_out    : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL data_in_delay : std_logic_vector(15 DOWNTO 0);
    SIGNAL ctrl_delay : std_logic_vector(14 DOWNTO 0);

    SIGNAL pp : std_logic_vector(15 DOWNTO 0);

    --- multiplicator in std_logic_vector
    SIGNAL mul_vec : std_logic_vector(15 DOWNTO 0);

BEGIN
    mul_vec<=std_logic_vector(to_signed(multiplicator, 16));
    data_in_delay(0) <= data_in;
    --- buffer for data_in
    PROCESS (clk, rst, ce)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                data_in_delay(15 DOWNTO 1) <= (OTHERS => '0');
            ELSIF ce = '1' THEN
                data_in_delay(15 DOWNTO 1) <= data_in_delay(14 DOWNTO 0);
            END IF;
        END IF;
    END PROCESS;

    ctrl_delay(0) <= ctrl;
    --- buffer for ctrl
    PROCESS (clk, rst, ce, ctrl)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                ctrl_delay(14 DOWNTO 1) <= (OTHERS => '0');
            ELSIF ce = '1' THEN
                ctrl_delay(14 DOWNTO 1) <= ctrl_delay(13 DOWNTO 0);
            END IF;
        END IF;
    END PROCESS;

    pp(0) <= mul_vec(0) AND data_in;

    GEN_PP : 
    FOR I IN 0 TO 13 GENERATE
        PPX : partial_product
        PORT MAP(
            clk       => clk, 
            rst       => rst, 
            ce        => ce, 
            data1_in  => pp(I), 
            data2_in  => data_in_delay(I + 1), 
            data3_in  => mul_vec(I + 1), 
            ctrl      => ctrl_delay(I), 
            pp_out    => pp(I + 1)
        );
    END GENERATE;

    PP_LAST : partial_product_last
    PORT MAP(
        clk       => clk, 
        rst       => rst, 
        ce        => ce, 
        data1_in  => pp(14), 
        data2_in  => data_in_delay(15), 
        data3_in  => mul_vec(15), 
        ctrl      => ctrl_delay(14), 
        pp_out    => pp(15)
    );

    --- output
    PROCESS (clk, rst, ce)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                product_out <= '0';
            ELSIF ce = '1' THEN
                product_out <= pp(15);
            END IF;
        END IF;
    END PROCESS;

END Behavioral;
