----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 03:50:30 PM
-- Design Name: 
-- Module Name: adder16 - Behavioral
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

entity adder16 is port (
    a : in std_logic_vector(15 downto 0);
    b : in std_logic_vector(15 downto 0);
    cin : in std_logic;
    s : out std_logic_vector(15 downto 0);
    cout: out std_logic
);
end adder16;

architecture Behavioral of adder16 is
signal c : bit_vector (15 downto 0);
begin
    adder_stages : for i in 0 to 15 generate
        begin
            first : if i=0 generate
        begin
            cell : entity work.full_adder
                port map(a(i), b(i), cin, s(i), c(i));
        end generate first;
        
        other_stages : if i/=0 generate
        begin
            cell : entity work.full_adder
                port map(a(i), b(i), c(i-1), s(i), c(i));
        end generate other_stages;
    end generate adder_stages;
    
    cout <= c(15);

end architecture Behavioral;
