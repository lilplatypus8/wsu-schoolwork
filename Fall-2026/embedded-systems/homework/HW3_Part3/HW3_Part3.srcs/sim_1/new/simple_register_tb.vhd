----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 05:55:51 PM
-- Design Name: 
-- Module Name: simple_register_tb - Behavioral
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

entity simple_register_tb is
end simple_register_tb;

architecture sim of simple_register_tb is
    constant n : positive := 4;

    signal i_tb      : std_logic_vector(n-1 downto 0) := "0000";
    signal q_tb      : std_logic_vector(n-1 downto 0);
    signal clock_tb  : std_logic := '0';
    signal clear_tb  : std_logic := '1';
    signal preset_tb : std_logic := '1';
begin

    uut : entity work.simple_register
        generic map (
            n => n
        )
        port map (
            i      => i_tb,
            clock  => clock_tb,
            clear  => clear_tb,
            preset => preset_tb,
            q      => q_tb
        );

    -- Rising edges at 5, 15, 25, ... ns.
    clock_process : process
    begin
        for k in 1 to 8 loop
            clock_tb <= '0';
            wait for 5 ns;
            clock_tb <= '1';
            wait for 5 ns;
        end loop;
        clock_tb <= '0';
        wait;
    end process;

    stimulus : process
    begin
        -- Assert clear before any rising edge.
        wait for 2 ns;
        clear_tb <= '0';
        wait for 1 ns;

        assert q_tb = "0000"
            report "Asynchronous clear failed"
            severity error;

        clear_tb <= '1';
        i_tb <= "1010";
        wait for 3 ns;                    -- 6 ns

        assert q_tb = "1010"
            report "Failed to capture input at 5 ns"
            severity error;

        i_tb <= "0101";
        wait for 5 ns;                    -- 11 ns

        assert q_tb = "1010"
            report "Register changed between rising edges"
            severity error;

        wait for 5 ns;                    -- 16 ns

        assert q_tb = "0101"
            report "Failed to capture input at 15 ns"
            severity error;

        -- Preset must work without a clock edge.
        wait for 1 ns;                    -- 17 ns
        preset_tb <= '0';
        wait for 1 ns;

        assert q_tb = "1111"
            report "Asynchronous preset failed"
            severity error;

        -- Both asserted: preset has priority.
        clear_tb <= '0';
        wait for 1 ns;                    -- 19 ns

        assert q_tb = "1111"
            report "Preset priority failed"
            severity error;

        -- Release preset, leaving clear asserted.
        preset_tb <= '1';
        wait for 1 ns;                    -- 20 ns

        assert q_tb = "0000"
            report "Clear failed after releasing preset"
            severity error;

        -- Clear must override input at a rising edge.
        i_tb <= "1111";
        wait for 6 ns;                    -- 26 ns

        assert q_tb = "0000"
            report "Clear failed to override clocked data"
            severity error;

        -- Release clear: wait until the next rising edge.
        clear_tb <= '1';
        i_tb <= "1100";
        wait for 5 ns;                    -- 31 ns

        assert q_tb = "0000"
            report "Output changed before next rising edge"
            severity error;

        wait for 5 ns;                    -- 36 ns

        assert q_tb = "1100"
            report "Normal capture failed after clear release"
            severity error;

        -- Preset must also override a rising clock edge.
        preset_tb <= '0';
        i_tb <= "0000";
        wait for 10 ns;                   -- 46 ns

        assert q_tb = "1111"
            report "Preset failed to override clocked data"
            severity error;

        preset_tb <= '1';
        wait for 10 ns;                   -- 56 ns

        assert q_tb = "0000"
            report "Normal capture failed after preset release"
            severity error;

        report "Register test complete" severity note;
        wait;
    end process;

end sim;
