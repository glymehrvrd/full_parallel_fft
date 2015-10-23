LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fft_pt2048 IS
    PORT (
        clk       : IN STD_LOGIC;
        rst       : IN STD_LOGIC;
        ce        : IN STD_LOGIC;
        data_in   : IN STD_LOGIC;
        data_out  : OUT STD_LOGIC
    );
END fft_pt2048;

ARCHITECTURE Behavioral OF fft_pt2048 IS

BEGIN
END Behavioral;

