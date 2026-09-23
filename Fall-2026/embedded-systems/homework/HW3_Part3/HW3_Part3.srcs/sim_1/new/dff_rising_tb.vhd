----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 05:45:20 PM
-- Design Name: 
-- Module Name: dff_rising_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dff_rising_tb is
end dff_rising_tb;

architecture sim of dff_rising_tb is
    signal d_tb   : std_logic := '0';
    signal clk_tb : std_logic := '0';
    signal q_tb   : std_logic;
begin

    uut : entity work.dff_rising
        port map (
            d   => d_tb,
            clk => clk_tb,
            q   => q_tb
        );

    -- Generate six clock cycles, each 10 ns long.
    clock_process : process
    begin
        for i in 1 to 6 loop
            clk_tb <= '0';
            wait for 5 ns;
            clk_tb <= '1';
            wait for 5 ns;
        end loop;

        clk_tb <= '0';
        wait;
    end process;

    stimulus : process
    begin
        -- First rising edge occurs at 5 ns.
        wait for 6 ns;
        assert q_tb = '0'
            report "Failed to capture 0"
            severity error;

        d_tb <= '1';

        -- Falling edge at 10 ns must not update Q.
        wait for 5 ns;
        assert q_tb = '0'
            report "Q changed between rising edges"
            severity error;

        -- Rising edge at 15 ns captures 1.
        wait for 5 ns;
        assert q_tb = '1'
            report "Failed to capture 1"
            severity error;

        d_tb <= '0';

        wait for 5 ns;
        assert q_tb = '1'
            report "Q failed to hold 1"
            severity error;

        -- Rising edge at 25 ns captures 0.
        wait for 5 ns;
        assert q_tb = '0'
            report "Failed to capture the new 0"
            severity error;

        report "DFF test complete" severity note;
        wait;
    end process;

end sim;
