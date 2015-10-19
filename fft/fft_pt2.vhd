----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 15:10:51 10/09/2015
-- Design Name:
-- Module Name: fft_pt2 - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY fft_pt2 IS
    PORT (
        clk            : IN STD_LOGIC;
        rst            : IN STD_LOGIC;
        ce             : IN STD_LOGIC;
        ctrl           : IN STD_LOGIC;

        data_0_re_in   : IN STD_LOGIC;
        data_0_im_in   : IN STD_LOGIC;
        data_1_re_in   : IN STD_LOGIC;
        data_1_im_in   : IN STD_LOGIC;

        data_0_re_out  : OUT STD_LOGIC;
        data_0_im_out  : OUT STD_LOGIC;
        data_1_re_out  : OUT STD_LOGIC;
        data_1_im_out  : OUT STD_LOGIC
    );
END fft_pt2;

ARCHITECTURE Behavioral OF fft_pt2 IS

    COMPONENT adder_bit1 IS
        PORT (
            d1_in    : IN STD_LOGIC;
            d2_in    : IN STD_LOGIC;
            c_in     : IN STD_LOGIC;
            sum_out  : OUT STD_LOGIC;
            c_out    : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Dff_preload_reg1 IS
        PORT (
            D        : IN STD_LOGIC;
            clk      : IN STD_LOGIC;
            rst      : IN STD_LOGIC;
            ce       : IN STD_LOGIC;
            preload  : IN STD_LOGIC;
            Q        : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Dff_preload_reg1_init_1 IS
        PORT (
            D        : IN STD_LOGIC;
            clk      : IN STD_LOGIC;
            rst      : IN STD_LOGIC;
            ce       : IN STD_LOGIC;
            preload  : IN STD_LOGIC;
            Q        : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL c : std_logic_vector(3 DOWNTO 0);
    SIGNAL c_buff : std_logic_vector(3 DOWNTO 0);

    SIGNAL not_data_1_re_in : STD_LOGIC;
    SIGNAL not_data_1_im_in : STD_LOGIC;

    SIGNAL data_0_re_out_buff : STD_LOGIC;
    SIGNAL data_0_im_out_buff : STD_LOGIC;
    SIGNAL data_1_re_out_buff : STD_LOGIC;
    SIGNAL data_1_im_out_buff : STD_LOGIC;

BEGIN
    PROCESS (clk, rst, ce)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF rst = '0' THEN
                data_0_re_out <= '0';
                data_0_im_out <= '0';
                data_1_re_out <= '0';
                data_1_im_out <= '0';
            ELSIF ce = '1' THEN
                data_0_re_out <= data_0_re_out_buff;
                data_0_im_out <= data_0_im_out_buff;
                data_1_re_out <= data_1_re_out_buff;
                data_1_im_out <= data_1_im_out_buff;
            END IF;
        END IF;
    END PROCESS;

    --- Re(X[0])=Re(x[0])+Re(x[1])
    C_BUFF0_RE : Dff_preload_reg1
    PORT MAP(
        D        => c(0), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff(0)
    );

    ADDER0_RE : adder_bit1
    PORT MAP(
        d1_in    => data_0_re_in, 
        d2_in    => data_1_re_in, 
        c_in     => c_buff(0), 
        sum_out  => data_0_re_out_buff, 
        c_out    => c(0)
    );

    --- Im(X[0])=Im(x[0])+Im(x[1])
    C_BUFF0_IM : Dff_preload_reg1
    PORT MAP(
        D        => c(1), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff(1)
    );

    ADDER0_IM : adder_bit1
    PORT MAP(
        d1_in    => data_0_im_in, 
        d2_in    => data_1_im_in, 
        c_in     => c_buff(1), 
        sum_out  => data_0_im_out_buff, 
        c_out    => c(1)
    );

    --- Re(X[1])=Re(x[0])-Re(x[1])
    C_BUFF1_RE : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(2), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff(2)
    );

    not_data_1_re_in <= NOT data_1_re_in;

    ADDER1_RE : adder_bit1
    PORT MAP(
        d1_in    => data_0_re_in, 
        d2_in    => not_data_1_re_in, 
        c_in     => c_buff(2), 
        sum_out  => data_1_re_out_buff, 
        c_out    => c(2)
    );

    --- Im(X[1])=Im(x[0])-Im(x[1])
    C_BUFF1_IM : Dff_preload_reg1_init_1
    PORT MAP(
        D        => c(3), 
        clk      => clk, 
        rst      => rst, 
        ce       => ce, 
        preload  => ctrl, 
        Q        => c_buff(3)
    );

    not_data_1_im_in <= NOT data_1_im_in;

    ADDER1_IM : adder_bit1
    PORT MAP(
        d1_in    => data_0_im_in, 
        d2_in    => not_data_1_im_in, 
        c_in     => c_buff(3), 
        sum_out  => data_1_im_out_buff, 
        c_out    => c(3)
    );
END Behavioral;

