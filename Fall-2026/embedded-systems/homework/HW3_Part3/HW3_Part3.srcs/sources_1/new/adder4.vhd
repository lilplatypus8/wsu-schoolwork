----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 03:12:51 PM
-- Design Name: 
-- Module Name: adder4 - Behavioral
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
--use IEEE.STD_LOGIC_arith.ALL;
--use IEEE.STD_LOGIC_signed.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder4 is port (
    cin : in std_logic;
    a, b : in std_logic_vector(3 downto 0);
    s : out std_logic_vector(3 downto 0);
    cout : out std_logic);
end adder4;

architecture example of adder4 is
signal sum : std_logic_vector(4 downto 0);
begin
    sum <= std_logic_vector(
        resize(unsigned(a), 5) +
        resize(unsigned(b), 5) +
        unsigned'("0000" & cin)
    );
    s <= sum(3 downto 0);
    cout <= sum(4);
end example;
