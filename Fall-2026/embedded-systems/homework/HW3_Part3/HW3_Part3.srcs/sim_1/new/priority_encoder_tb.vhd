----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 03:07:14 PM
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Priority_Encoder_tb is
end Priority_Encoder_tb;

architecture sim of Priority_Encoder_tb is
    signal d_tb : std_logic_vector(3 downto 0) := "0000";
    signal f_tb : std_logic_vector(1 downto 0);
    signal z_tb : std_logic;
begin

    uut : entity work.Priority_Encoder(sample)
        port map (
            d => d_tb,
            f => f_tb,
            z => z_tb
        );

    stimulus : process
    begin
        -- Apply every four-bit input, holding each for 10 ns.
        for i in 0 to 15 loop
            d_tb <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns;
        end loop;

        report "All 16 input combinations tested";
        wait;
    end process;

end sim;