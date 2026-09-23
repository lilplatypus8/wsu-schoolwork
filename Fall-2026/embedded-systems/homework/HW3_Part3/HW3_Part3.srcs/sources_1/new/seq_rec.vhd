----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 09:38:08 PM
-- Design Name: 
-- Module Name: seq_rec - Behavioral
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

entity seq_rec is port (
    CLK, RESET, X: in std_logic;
    Z: out std_logic);
end seq_rec;

architecture process_3 of seq_rec is
    type state_type is (A, B, C, D);
    signal state, next_state: state_type;
begin

state_register: process (CLK, RESET)
begin
    if(RESET = '1') then
        state <= A;
    elsif (CLK'event and CLK = '1') then
        state <= next_state;
    end if;
end process;

output_function: process (X, state)
begin
    case state is
    when A => Z <= '0';
    when B => Z <= '0';
    when C => Z <= '0';
    when D =>
        if X = '1' then
            Z <= '1';
        else
            Z <= '0';
        end if;
    end case;
end process;

next_state_function: process (X, state)
begin
    case state is
    when A =>
        if X = '1' then
            next_state <= B;
        else
            next_state <= A;
        end if;        
    when B =>
        if X = '1' then
            next_state <= C;
        else
            next_state <= A;
        end if;        
    when C =>
        if X = '1' then
            next_state <= C;
        else
            next_state <= D;
        end if;        
    when D =>
        if X = '1' then
            next_state <= B;
        else
            next_state <= A;
        end if;
    end case;
end process;    

end process_3;
