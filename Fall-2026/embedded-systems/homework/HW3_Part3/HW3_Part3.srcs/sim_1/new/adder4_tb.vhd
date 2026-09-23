----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 03:17:25 PM
-- Design Name: 
-- Module Name: adder4_tb - Behavioral
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

entity adder4_tb is
end adder4_tb;

architecture sim of adder4_tb is
    signal a_tb, b_tb : std_logic_vector(3 downto 0) := "0000";
    signal cin_tb    : std_logic := '0';
    signal s_tb      : std_logic_vector(3 downto 0);
    signal cout_tb   : std_logic;
begin

    uut : entity work.adder4
        port map (
            a    => a_tb,
            b    => b_tb,
            cin  => cin_tb,
            s    => s_tb,
            cout => cout_tb
        );

    stimulus : process
        variable expected : unsigned(4 downto 0);
    begin
        -- Test every combination of a, b, and carry-in.
        for a_value in 0 to 15 loop
            for b_value in 0 to 15 loop
                for carry_value in 0 to 1 loop

                    a_tb <= std_logic_vector(to_unsigned(a_value, 4));
                    b_tb <= std_logic_vector(to_unsigned(b_value, 4));

                    if carry_value = 0 then
                        cin_tb <= '0';
                    else
                        cin_tb <= '1';
                    end if;

                    wait for 10 ns;

                    expected := to_unsigned(
                        a_value + b_value + carry_value, 5
                    );

                    assert (cout_tb = expected(4)) and
                           (s_tb = std_logic_vector(expected(3 downto 0)))
                        report "Incorrect result: a=" &
                               integer'image(a_value) &
                               ", b=" & integer'image(b_value) &
                               ", cin=" & integer'image(carry_value)
                        severity error;

                end loop;
            end loop;
        end loop;

        report "Finished checking all 512 input combinations."
            severity note;
        wait;
    end process;

end sim;