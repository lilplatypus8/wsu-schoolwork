----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2026 08:22:30 PM
-- Design Name: 
-- Module Name: ring_oscillator_delayed - Behavioral
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

architecture delayed_sim of ring_oscillator is
    signal s0, s1, s2 : std_logic;
begin

    -- Model each gate as taking 1 ns to respond.
    s0 <= not (Enable and s2) after 1 ns;
    s1 <= not s0 after 1 ns;
    s2 <= not s1 after 1 ns;

    Output <= s2;

end delayed_sim;
