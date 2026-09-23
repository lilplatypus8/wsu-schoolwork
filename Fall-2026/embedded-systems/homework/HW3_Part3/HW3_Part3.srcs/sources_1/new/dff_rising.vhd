----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 05:42:35 PM
-- Design Name: 
-- Module Name: dff_rising - Behavioral
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

entity dff_rising is port (
    d, clk: in std_logic;
    q : out std_logic
);
end dff_rising;

architecture arch_dff_rising of dff_rising is
begin
    process (clk) begin
        if (rising_edge(clk)) then
            q <= d;
        end if;
    end process;
end arch_dff_rising;