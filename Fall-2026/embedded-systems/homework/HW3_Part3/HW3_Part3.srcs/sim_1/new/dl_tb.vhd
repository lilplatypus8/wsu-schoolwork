----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 05:04:44 PM
-- Design Name: 
-- Module Name: dl_tb - Behavioral
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

entity dl_tb is
end dl_tb;

architecture sim of dl_tb is
    signal d_tb  : std_logic := '0';
    signal en_tb : std_logic := '0';
    signal q_tb  : std_logic;
begin

    uut : entity work.dl
        port map (
            d  => d_tb,
            clk => en_tb,
            q  => q_tb
        );

    stimulus : process
    begin
        -- Open the latch and establish a known value.
        en_tb <= '1';
        d_tb  <= '0';
        wait for 10 ns;

        assert q_tb = '0'
            report "Latch failed to pass 0"
            severity error;

        -- While enabled, Q should follow D.
        d_tb <= '1';
        wait for 10 ns;

        assert q_tb = '1'
            report "Latch failed to pass 1"
            severity error;

        -- Close the latch.
        en_tb <= '0';
        wait for 5 ns;

        d_tb <= '0';
        wait for 10 ns;

        assert q_tb = '1'
            report "Latch failed to hold 1 while disabled"
            severity error;

        -- Reopen: Q should now follow D back to 0.
        en_tb <= '1';
        wait for 10 ns;

        assert q_tb = '0'
            report "Latch failed to update when enabled"
            severity error;

        report "Latch test complete" severity note;
        wait;
    end process;

end sim;
