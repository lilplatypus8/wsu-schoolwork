----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/04/2026 02:07:26 PM
-- Design Name: 
-- Module Name: priority_encoder - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity priority_encoder is
    Port (
        input: in std_logic_vector(15 downto 0);
        output: out std_logic_vector(3 downto 0);
        valid: out std_logic;
        even_valid: out std_logic;
        odd_valid: out std_logic
    );
end priority_encoder;

architecture Behavioral of priority_encoder is

    signal even_inputs: std_logic_vector(7 downto 0);
    signal odd_inputs: std_logic_vector(7 downto 0);
    
begin

    even_inputs <= input(14) & input(12) & input(10) & input(8)
                       & input(6) & input(4) & input(2) & input(0);
                       
    odd_inputs <= input(15) & input(13) & input(11) & input(9)
                      & input(7) & input(5) & input(3) & input(1);

    process(even_inputs, odd_inputs)
    begin
    
        -- Set defaults for output
        valid <= '0';
        output <= "0000";
        even_valid <= '0';
        odd_valid <= '0';

        -- H-block logic
        -- Check for even input value
        if even_inputs /= "00000000" then
            -- Even-input priority encoder logic
            even_valid <= '1';
            valid <= '1';
            
            for i in 7 downto 0 loop
                -- Assign even input value to output if found
                if even_inputs(i) = '1' then
                    output <= std_logic_vector(to_unsigned(i*2, 4));
                    exit;
                end if;
            end loop; 
        -- Check for odd input value if no even inputs  
        elsif odd_inputs /= "00000000" then
            -- Odd-input priority encoder logic
            odd_valid <= '1';
            valid <= '1';
            
            for i in 7 downto 0 loop
                -- Assign even input value to output if found
                if odd_inputs(i) = '1' then
                    output <= std_logic_vector(to_unsigned(i*2 + 1, 4));
                    exit;
                end if;
            end loop; 
        end if;
    end process;

end Behavioral;
