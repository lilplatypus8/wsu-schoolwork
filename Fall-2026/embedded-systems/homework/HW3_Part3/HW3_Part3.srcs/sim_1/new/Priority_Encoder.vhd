----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 02:56:22 PM
-- Design Name: 
-- Module Name: Priority_Encoder - Behavioral
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

entity Priority_Encoder is port (
    d : in std_logic_vector (3 downto 0);
    f : out std_logic_vector (1 downto 0);
    z : out std_logic);
end Priority_Encoder;

architecture sample of Priority_Encoder is
begin
    f <= "11" when d(3) = '1' else
         "10" when d(2) = '1' else
         "01" when d(1) = '1' else
         "00";
    z <= '0' when d = "0000" else '1';

end sample;
