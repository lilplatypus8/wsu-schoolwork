----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2026 08:05:24 PM
-- Design Name: 
-- Module Name: ring_oscillator_tb - Behavioral
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

entity ring_oscillator_tb is
end ring_oscillator_tb;

architecture sim of ring_oscillator_tb is
    signal enable_tb : std_logic := '0';
    signal output_tb : std_logic;
begin

    -- Connect the circuit being tested.
    uut : entity work.ring_oscillator(delayed_sim)
        port map (
            Enable => enable_tb,
            Output => output_tb
        );

    stimulus : process
    begin
        -- Start disabled so the circuit can settle.
        enable_tb <= '0';
        wait for 20 ns;

        -- Enable oscillation.
        enable_tb <= '1';
        wait for 100 ns;

        -- Disable again.
        enable_tb <= '0';
        wait for 20 ns;

        report "Test sequence complete" severity note;
        wait;
    end process;

end sim;
