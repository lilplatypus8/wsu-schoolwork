----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/07/2026 01:40:20 PM
-- Design Name: 
-- Module Name: priority_encoder_tb - Behavioral
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

entity priority_encoder_tb is
end priority_encoder_tb;

architecture sim of priority_encoder_tb is
    signal input_tb: std_logic_vector(15 downto 0);
    signal output_tb: std_logic_vector(3 downto 0);
    signal valid_tb: std_logic;
    signal even_valid_tb: std_logic;
    signal odd_valid_tb: std_logic;
begin

    UUT: entity work.Priority_Encoder(Behavioral)
        port map (
            input => input_tb,
            output => output_tb,
            valid => valid_tb,
            even_valid => even_valid_tb,
            odd_valid => odd_valid_tb
        );
    
    process
    begin
    
        -- Below are the expected even/odd selections and outputs
    
        -- One even
        -- Selection: Even 
        -- Output: 2
        input_tb <= "0000000000000100";
        wait for 10 ns;
        
        -- Multiple evens
        -- Selection: Even 
        -- Output: 8
        input_tb <= "0000000100010100";
        wait for 10 ns;
        
        -- One odd
        -- Selection: Odd 
        -- Output: 1
        input_tb <= "0000000000000010";
        wait for 10 ns;
        
        -- Multiple odds
        -- Selection: Odd 
        -- Output: 7
        input_tb <= "0000000010001010";
        wait for 10 ns;
        
        -- Evens and odds
        -- Selection: Even 
        -- Output: C
        input_tb <= "0001001010011000";
        wait for 10 ns;
        
        -- All inputs
        -- Selection: Even 
        -- Output: E
        input_tb <= "1111111111111111";
        wait for 10 ns;
        
        -- No inputs
        -- Selection: None 
        -- Output: 0
        input_tb <= "0000000000000000";
        wait for 10 ns;
        
        wait;
    
    end process;

end sim;
