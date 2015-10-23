LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test_dff_preload_reg1 IS
END test_dff_preload_reg1;

ARCHITECTURE behavior OF test_dff_preload_reg1 IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT Dff_preload_reg1
        PORT (
            D        : IN std_logic;
            clk      : IN std_logic;
            ce       : IN std_logic;
            rst      : IN std_logic;
            preload  : IN std_logic;
            Q        : OUT std_logic
        );
    END COMPONENT;
 

    --Inputs
    SIGNAL D : std_logic := '0';
    SIGNAL clk : std_logic := '0';
    SIGNAL ce : std_logic := '0';
    SIGNAL rst : std_logic := '0';
    SIGNAL preload : std_logic := '0';

    --Outputs
    SIGNAL Q : std_logic;

    -- Clock period definitions
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : Dff_preload_reg1
    PORT MAP(
        D        => D, 
        clk      => clk, 
        ce       => ce, 
        rst      => rst, 
        preload  => preload, 
        Q        => Q
    );

    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;
    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- hold reset state for 100 ns.
        rst <= '0';
        WAIT FOR 95 ns; 
        rst <= '1';
        WAIT FOR clk_period * 10;
        ce <= '1';
        D <= '1';
        WAIT FOR clk_period * 2;
        D <= '0';
        preload <= '1';
        WAIT FOR clk_period;
        D <= '1';
        preload <= '0';
        -- insert stimulus here

        WAIT;
    END PROCESS;

    END;
