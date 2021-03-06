LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY shifter IS
    PORT (
        clk       : IN STD_LOGIC;
        rst       : IN STD_LOGIC;
        ce        : IN STD_LOGIC;
        ctrl      : IN STD_LOGIC;

        data_in   : IN std_logic;

        data_out  : OUT std_logic
    );
END shifter;

ARCHITECTURE Behavioral OF shifter IS

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

    SIGNAL data_in_delay : std_logic;
BEGIN
    --- buffer for data_in
    UDFF : Dff_reg1
    PORT MAP(
        D    => data_in, 
        clk  => clk, 
        Q    => data_in_delay
    );

    UMUX : mux_in2
    PORT MAP(
        sel       => ctrl, 
        data1_in  => data_in, 
        data2_in  => data_in_delay, 
        data_out  => data_out
    );

END Behavioral;

