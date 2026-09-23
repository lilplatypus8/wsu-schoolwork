----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 04:51:53 PM
-- Design Name: 
-- Module Name: dff_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dff_tb is
end dff_tb;

architecture sim of dff_tb is
    signal d_tb   : std_logic := '0';
    signal clk_tb : std_logic := '0';
    signal q_tb   : std_logic;
begin

    uut : entity work.dff
        port map (
            d   => d_tb,
            clk => clk_tb,
            q   => q_tb
        );

    -- Clock period: 10 ns. Stops after 60 ns.
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
        wait for 6 ns;
        assert q_tb = '0'
            report "DFF failed to capture 0 at 5 ns"
            severity error;

        d_tb <= '1';
        wait for 5 ns;  -- Time: 11 ns, after falling edge
        assert q_tb = '0'
            report "DFF changed without a rising edge"
            severity error;

        wait for 5 ns;  -- Time: 16 ns
        assert q_tb = '1'
            report "DFF failed to capture 1 at 15 ns"
            severity error;

        d_tb <= '0';
        wait for 5 ns;  -- Time: 21 ns
        assert q_tb = '1'
            report "DFF failed to hold its value"
            severity error;

        wait for 5 ns;  -- Time: 26 ns
        assert q_tb = '0'
            report "DFF failed to capture 0 at 25 ns"
            severity error;

        report "DFF test complete" severity note;
        wait;
    end process;

end sim;
