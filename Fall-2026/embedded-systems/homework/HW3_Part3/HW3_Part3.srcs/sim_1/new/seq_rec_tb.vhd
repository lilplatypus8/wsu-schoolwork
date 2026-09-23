----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 09:46:07 PM
-- Design Name: 
-- Module Name: sec_req_tb - Behavioral
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

entity seq_rec_tb is
end seq_rec_tb;

architecture sim of seq_rec_tb is
   signal CLK_tb : std_logic := '0';
   signal RESET_tb : std_logic := '0';
   signal X_tb : std_logic := '0';
   signal Z_tb : std_logic;
begin

    uut : entity work.seq_rec
        port map (
            CLK => CLK_tb,
            RESET => RESET_tb,
            X => X_tb,
            Z => Z_tb
        );

    -- Clock period: 10 ns. Stops after 1000 ns.
    clock_process : process
    begin
        for i in 1 to 100 loop
            CLK_tb <= '0';
            wait for 5 ns;
            CLK_tb <= '1';
            wait for 5 ns;
        end loop;

        CLK_tb <= '0';
        wait;
    end process;

    stimulus : process
    begin
        wait for 10 ns;
        
        X_tb <= '1';
        wait for 10 ns;
        
        X_tb <= '1';
        wait for 10 ns;
        
        X_tb <= '0';
        wait for 10 ns;
        
        X_tb <= '1';
        wait for 10 ns;
        
        X_tb <= '1';
        wait for 10 ns;
        
        X_tb <= '0';
        wait for 10 ns;
        
        X_tb <= '1';
        wait for 10 ns;
        
        RESET_tb <= '1';
        wait for 10 ns;
        
        RESET_tb <= '0';
        wait for 10 ns;
        
        X_tb <= '0';
        wait for 10 ns;
        
        X_tb <= '0';
        wait for 10 ns;        
        
        X_tb <= '1';
        wait for 10 ns;
        
        wait;
        
    end process;

end sim;