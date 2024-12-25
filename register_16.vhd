library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity sixteen_bit_register is
generic(n:integer :=16);
    Port ( 
        clk     : in STD_LOGIC;                     
        reset   : in STD_LOGIC;                     
        enable  : in STD_LOGIC;                     
        data_in : in STD_LOGIC_VECTOR(n-1 downto 0); 
        data_out: out STD_LOGIC_VECTOR(n-1 downto 0) 
    );
end sixteen_bit_register;

architecture Behavioral of sixteen_bit_register is
begin
    process(clk, reset)  -- Add reset to the sensitivity list for asynchronous reset
    begin
        if reset = '1' then
            data_out <= (others => '0');  -- Reset immediately when reset is high
        elsif rising_edge(clk) then
            if enable = '1' then
                data_out <= data_in;  -- Load data if enable is high on clock edge
            end if;
        end if;
    end process;
end Behavioral;
