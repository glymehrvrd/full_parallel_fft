LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY partial_product IS
    PORT (
        clk       : IN std_logic;
        rst       : IN std_logic;
        ce        : IN std_logic;
        ctrl      : IN STD_LOGIC;
        data1_in  : IN std_logic;
        data2_in  : IN STD_LOGIC;
        data3_in  : IN std_logic;
        pp_out    : OUT STD_LOGIC --- partial product
    );
END partial_product;

ARCHITECTURE Behavioral OF partial_product IS

    COMPONENT adder_bit1 IS
        PORT (
            data1_in  : IN STD_LOGIC;
            data2_in  : IN STD_LOGIC;
            c_in      : IN STD_LOGIC;
            sum_out   : OUT STD_LOGIC;
            c_out     : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Dff_reg1 IS
        PORT (
            D    : IN STD_LOGIC;
            clk  : IN STD_LOGIC;
            rst  : IN STD_LOGIC;
            ce   : IN STD_LOGIC;
            Q    : OUT STD_LOGIC
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

    SIGNAL ctrl_delay1 : std_logic;

    SIGNAL data1_in_delay1 : std_logic;

    SIGNAL adder_in1 : std_logic;
    SIGNAL adder_in2 : std_logic;

    SIGNAL adder_c_in : std_logic;
    SIGNAL c_out : std_logic;
    SIGNAL c_buff : std_logic;

BEGIN
    BUFF_CTRL : Dff_reg1
    PORT MAP(
        D    => ctrl, 
        clk  => clk, 
        rst  => rst, 
        ce   => ce, 
        Q    => ctrl_delay1
    );

    BUFF_DIN1 : Dff_reg1
    PORT MAP(
        D    => data1_in, 
        clk  => clk, 
        rst  => rst, 
        ce   => ce, 
        Q    => data1_in_delay1
    );

    MUX_DIN1 : mux_in2
    PORT MAP(
        sel       => ctrl, 
        data1_in  => data1_in, 
        data2_in  => data1_in_delay1, 
        data_out  => adder_in1
    );

    adder_in2 <= data2_in AND data3_in;

    BUFF_C : Dff_reg1
    PORT MAP(
        D    => c_out, 
        clk  => clk, 
        rst  => rst, 
        ce   => ce, 
        Q    => c_buff
    );

    MUX_ADDER_C_IN : mux_in2
    PORT MAP(
        sel       => ctrl_delay1, 
        data1_in  => c_buff, 
        data2_in  => '0', 
        data_out  => adder_c_in
    );

    ADDER : adder_bit1
    PORT MAP(
        data1_in  => adder_in1, 
        data2_in  => adder_in2, 
        c_in      => adder_c_in, 
        sum_out   => pp_out, 
        c_out     => c_out
    );

END Behavioral;

