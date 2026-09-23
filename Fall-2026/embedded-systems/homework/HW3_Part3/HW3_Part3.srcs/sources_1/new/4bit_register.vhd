----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 05:49:21 PM
-- Design Name: 
-- Module Name: 4bit_register - Behavioral
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

entity simple_register is 
    generic (n: integer := 4);
    port ( i : in std_logic_vector (n-1 downto 0);
           clock, clear, preset : in std_logic;
           q : out std_logic_vector (n-1 downto 0));
end simple_register;

architecture arch_simple_register of simple_register is
begin
    process (preset, clear, clock) begin
        if preset = '0' then
            q <= (others => '1');
        elsif clear = '0' then
            q <= (others => '0');
        elsif (clock'event and clock = '1') then
            q <= i;
        end if;
    end process;
end arch_simple_register;
