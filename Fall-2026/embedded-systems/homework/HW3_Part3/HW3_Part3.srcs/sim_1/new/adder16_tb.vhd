----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 04:16:41 PM
-- Design Name: 
-- Module Name: adder16_tb - Behavioral
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder16_tb is
end adder16_tb;

architecture sim of adder16_tb is
    signal a_tb, b_tb : std_logic_vector(15 downto 0)
        := (others => '0');
    signal cin_tb  : std_logic := '0';
    signal s_tb    : std_logic_vector(15 downto 0);
    signal cout_tb : std_logic;
begin

    uut : entity work.adder16
        port map (
            a    => a_tb,
            b    => b_tb,
            cin  => cin_tb,
            s    => s_tb,
            cout => cout_tb
        );

    stimulus : process
        procedure check_sum (
            constant av : natural;
            constant bv : natural;
            constant cv : natural
        ) is
            variable expected : unsigned(16 downto 0);
        begin
            a_tb <= std_logic_vector(to_unsigned(av, 16));
            b_tb <= std_logic_vector(to_unsigned(bv, 16));

            if cv = 0 then
                cin_tb <= '0';
            else
                cin_tb <= '1';
            end if;

            wait for 10 ns;

            expected := to_unsigned(av + bv + cv, 17);

            assert s_tb = std_logic_vector(expected(15 downto 0))
                   and cout_tb = expected(16)
                report "FAILED: a=" & integer'image(av) &
                       ", b=" & integer'image(bv) &
                       ", cin=" & integer'image(cv)
                severity error;
        end procedure;
    begin
        check_sum(0,     0,     0); -- Zero
        check_sum(0,     0,     1); -- Carry-in only
        check_sum(5,     3,     0); -- Simple addition
        check_sum(5,     3,     1); -- Addition with carry-in

        -- Exercise progressively longer carry chains.
        for n in 1 to 16 loop
            check_sum(2**n - 1, 1, 0);
        end loop;

        check_sum(65535, 0,     1); -- Carry-in through all stages
        check_sum(43690, 21845, 0); -- Alternating bit patterns
        check_sum(65535, 65535, 0); -- Two maximum inputs
        check_sum(65535, 65535, 1); -- Maximum possible result

        report "Completed all 24 adder tests." severity note;
        wait;
    end process;

end sim;
