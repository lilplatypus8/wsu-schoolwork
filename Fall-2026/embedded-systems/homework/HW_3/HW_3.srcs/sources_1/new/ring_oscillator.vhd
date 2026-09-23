----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2026 07:53:24 PM
-- Design Name: 
-- Module Name: ring_oscillator - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity ring_oscillator is

port (
    Enable: in std_logic;
    Output: out
std_logic);
end ring_oscillator;

architecture Behavioral of ring_oscillator is
    signal s0, s1, s2: std_logic;
begin

LUT1_inst : LUT2
generic map (INIT => X"7")
port map (
    O => S0, 
    I0 => Enable,
    I1 => s2
);

LUT2_inst : LUT1
generic map (INIT => "01")
port map (
    O => S1,
    I0 => s0
);

LUT3_inst : LUT1
generic map (INIT => "01")
port map (
    O => S2,
    I0 => s1
);

Output <= S2;

end Behavioral;
